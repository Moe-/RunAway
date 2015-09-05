class "Dog" {
	world = {};
	physics = {};
}

function Dog:__init(world)
	self.world = world
	
  self.image = love.graphics.newImage("gfx/dog.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
	
	self.physics.body = love.physics.newBody(world, 0, 0, "dynamic")
  --self.physics.shape = love.physics.newCircleShape(16)
	self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 2)
	self.physics.fixture:setRestitution(0.3)
	
end

function Dog:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Dog:update(dt)
	self.physics.body:applyForce(2000, 0)
end

function Dog:getSize()
  return self.width, self.height
end

function Dog:getWidth()
  return self.width
end

function Dog:getHeight()
  return self.height
end