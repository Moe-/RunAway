class "Player" {
	sausages = 5;
	boost = 0;
	timer = 0;
	frame = 0;
	jumping = false;
}

function Player:__init(world, x, y)
	self.world = world
	
	self.image = love.graphics.newImage("gfx/ButcherRunAnimation.png")
	self.image:setWrap("repeat", "repeat")
	self.width = self.image:getWidth() / 14
	self.height = self.image:getHeight()
	self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.image:getWidth(), self.image:getHeight())
	
	self.image2 = love.graphics.newImage("gfx/ButcherJumpAnimation.png")
	self.image2:setWrap("repeat", "repeat")
	self.width2 = self.image2:getWidth() / 10
	self.height2 = self.image2:getHeight()
	self.quad2 = love.graphics.newQuad(0, 0, self.width2, self.height2, self.image2:getWidth(), self.image2:getHeight())

	
	self.physics = {}
  self.physics.body = love.physics.newBody(world, x, y, "dynamic")
  --self.physics.shape = love.physics.newCircleShape(32)
  self.physics.shape = love.physics.newRectangleShape(0, 0, self.width * 0.5, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 3)
	self.physics.body:setUserData(self)
	self.physics.body:setFixedRotation(true)
	self.physics.fixture:setUserData(self)

	self.physics.fixture:setRestitution(0.3)
	
	self.particleEat = Particle:new(0, 0, 255, 128, 128, 2)
	self.particleEat:stop()
end

function Player:draw(offsetx, offsety)
	if self.jumping then
		self.frame = math.min(math.floor(self.timer), 9)
		self.quad2:setViewport(self.width2 * self.frame, 0, self.width2, self.height2)
		love.graphics.draw(self.image2, self.quad2, self.physics.body:getX() - self.width2/2 - offsetx, self.physics.body:getY() - self.height2/2 - offsety)
	else
		self.frame = math.floor(self.timer) % 14
		self.quad:setViewport(self.width * self.frame, 0, self.width, self.height)
		love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
	end
	self.particleEat:drawAt(self.physics.body:getX() - offsetx, self.physics.body:getY() - offsety)
end

function Player:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Player:update(dt)
	x, y = self.physics.body:getLinearVelocity()
	
	if self.jumping then
		self.timer = self.timer + 10 * dt
	else
		if x > 0 then
			self.timer = self.timer + (math.max(2, x) * 0.05) * dt
		elseif x < 0 then
			self.timer = self.timer + (math.min(-2, x) * 0.05) * dt
		end
	end
	
	self.boost = self.boost - dt
	local factor = 1
	if self.boost >= 0 then
		factor = 1.5
	end
	self.physics.body:applyForce(1000 * math.pow(0.9, self.sausages) * factor, 0)
	
	self.particleEat:update(dt)
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
		self.physics.body:applyLinearImpulse(0, 12000)
		
		self.timer = 0
		
		self.jumping = true
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
		self.particleEat:reset()
	end
end
