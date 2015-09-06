class "Player" {
	sausages = 5;
	boost = 0;
	timer = 0;
	frame = 0;
}

function Player:__init(world, x, y)
	self.world = world
	
	self.image = love.graphics.newImage("gfx/ButcherRunAnimation.png")
  self.image:setWrap("repeat", "repeat")
	self.width = self.image:getWidth() / 14
	self.height = self.image:getHeight()
	self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.image:getWidth(), self.image:getHeight())
	
	self.physics = {}
  self.physics.body = love.physics.newBody(world, x, y, "dynamic")
  --self.physics.shape = love.physics.newCircleShape(32)
  self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 3)
	self.physics.body:setUserData(self)
	self.physics.body:setFixedRotation(true)
	self.physics.fixture:setUserData(self)

	self.physics.fixture:setRestitution(0.3)
	
end

function Player:draw(offsetx, offsety)
	self.frame = math.floor(self.timer) % 14
	self.quad:setViewport(self.width * self.frame, 0, self.width, self.height)
	love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Player:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Player:update(dt)
	x, y = self.physics.body:getLinearVelocity()
	self.timer = self.timer + (x * 0.05) * dt
	self.boost = self.boost - dt
	local factor = 1
	if self.boost >= 0 then
		factor = 1.5
	end
	self.physics.body:applyForce(2000 * math.pow(0.9, self.sausages) * factor, 0)
end

function Player:getSize()
  return self.width, self.height
end

function Player:getWidth()
  return self.width
end

function Player:getHeight()
  return self.height
end

function Player:jump()
	if #self.physics.body:getContactList() > 0 then
		self.physics.body:applyLinearImpulse(0, 25000)
	end
end

function Player:sausageDrop(world, sausages)
	if self.sausages > 0 then
		table.insert(sausages, Sausage:new(world, self.physics.body:getX() - self.width, self.physics.body:getY()))
		self.sausages = self.sausages - 1
	end
end

function Player:getType()
	return "Player"
end

function Player:takeSausage(sausageItem)
	self.sausages = self.sausages + 1
end

function Player:destroy()
	self.physics.body:destroy()
	self.physics.fixture:destroy()
end

function Player:eatSausage()
	if self.sausages > 0 then
		self.physics.body:applyForce(-500 * math.pow(0.9, self.sausages), 0)
		self.sausages = self.sausages - 1
		self.boost = 5.0
	end
end
