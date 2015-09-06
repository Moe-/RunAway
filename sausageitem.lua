class "SausageItem" {

}

function SausageItem:__init(world, x, y)
	self.world = world
	
	print(x, y)
  self.image = love.graphics.newImage("gfx/werf_wurst2.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
	
	self.physics = {}
	self.physics.body = love.physics.newBody(world, x, y, "static")
  --self.physics.shape = love.physics.newCircleShape(16)
	self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 2)
	self.physics.body:setUserData(self)
	self.physics.body:setMass(0.0)
	self.physics.body:setFixedRotation(true)
	self.physics.fixture:setUserData(self)
	self.physics.fixture:setSensor(true)
	
	self.physics.fixture:setRestitution(0.3)

end

function SausageItem:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function SausageItem:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function SausageItem:update(dt)

end

function SausageItem:getSize()
  return self.width, self.height
end

function SausageItem:getWidth()
  return self.width
end

function SausageItem:getHeight()
  return self.height
end

function SausageItem:getType()
	return "SausageItem"
end

function SausageItem:destroy()
	self.physics.body:destroy()
	self.physics.fixture:destroy()
end