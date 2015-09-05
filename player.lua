class "Player" {
	world = {};
	physics = {};
}

function Player:__init(world)
	self.world = world
	
	self.image = love.graphics.newImage("gfx/human.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
	
  self.physics.body = love.physics.newBody(world, 225, 175, "dynamic")
  --self.physics.shape = love.physics.newCircleShape(32)
  self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 3)
	self.physics.fixture:setRestitution(0.3)	
  
end

function Player:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Player:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Player:update(dt)
	self.physics.body:applyForce(2000, 0)
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