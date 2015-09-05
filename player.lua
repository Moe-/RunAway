class "Player" {
	sausages = 5;
}

function Player:__init(world, x, y)
	self.world = world
	
	self.image = love.graphics.newImage("gfx/human.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
	
	self.physics = {}
  self.physics.body = love.physics.newBody(world, x, y, "dynamic")
  --self.physics.shape = love.physics.newCircleShape(32)
  self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 3)
	self.physics.body:setUserData(self)
	self.physics.fixture:setUserData(self)
  
	self.physics.fixture:setRestitution(0.3)
	
end

function Player:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Player:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Player:update(dt)
	self.physics.body:applyForce(500, 0)
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
		self.physics.body:applyLinearImpulse(400, 12000)
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
