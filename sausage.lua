class "Sausage" {

}

function Sausage:__init(world, x, y)
	self.world = world
	
  self.image = love.graphics.newImage("gfx/sausage.png")
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
	self.physics.body:setFixedRotation(true)
	self.physics.body:setMass(0.0)
	self.physics.fixture:setUserData(self)
	
	self.physics.fixture:setRestitution(0.3)

end

function Sausage:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Sausage:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Sausage:update(dt)

end

function Sausage:getSize()
  return self.width, self.height
end

function Sausage:getWidth()
  return self.width
end

function Sausage:getHeight()
  return self.height
end

function Sausage:getType()
	return "Sausage"
end

function Sausage:destroy()
	self.physics.body:destroy()
	self.physics.fixture:destroy()
end
