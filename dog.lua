class "Dog" {
}

function Dog:__init(world, x, y)
	self.world = world
	
  self.image = love.graphics.newImage("gfx/dog.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
	
	self.physics = {}
	self.physics.body = love.physics.newBody(world, x, y, "dynamic")
  --self.physics.shape = love.physics.newCircleShape(16)
	self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 2)
	self.physics.body:setUserData(self)
	self.physics.fixture:setUserData(self)
	
	self.physics.fixture:setRestitution(0.3)
	
end

function Dog:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Dog:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Dog:update(dt)
	self.physics.body:applyForce(1000, 0)
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

function Dog:getType()
	return "Dog"
end
