class "Sign" {
	obsType = 0;
}

function Sign:__init(world, x, y)
	self.world = world
	
	local r = math.random(1, 5)
	local ox, oy
	if r == 1 then
		ox = 0
		oy = 0
	elseif r == 2 then
		ox = 1
		oy = 0
	elseif r == 3 then
		ox = 0
		oy = 1
	elseif r == 4 then
		ox = 1
		oy = 1
	else
		ox = 0
		oy = 2
	end
	self.obsType = r + 3
  
	self.image = love.graphics.newImage("gfx/hanging_signs.png")
	self.image:setWrap("repeat", "repeat")
	self.width = self.image:getWidth() / 2
  self.height = self.image:getHeight() / 3
	
  self.quad = love.graphics.newQuad(ox * self.width, oy * self.height, self.width, self.height, self.image:getDimensions())
  
	
	self.physics = {}
	self.physics.body = love.physics.newBody(world, x, y - self.height/2, "static")
  --self.physics.shape = love.physics.newCircleShape(16)
	self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 4)
	self.physics.body:setUserData(self)
	self.physics.body:setFixedRotation(true)
	self.physics.fixture:setUserData(self)
	self.physics.fixture:setFriction(0.0)
	
	self.physics.fixture:setRestitution(0.3)

end

function Sign:getObstacleType()
	return self.obsType
end

function Sign:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Sign:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Sign:update(dt)

end

function Sign:getSize()
  return self.width, self.height
end

function Sign:getWidth()
  return self.width
end

function Sign:getHeight()
  return self.height
end

function Sign:getType()
	return "Obstacle"
end

function Sign:destroy()
	self.physics.body:destroy()
	self.physics.fixture:destroy()
end
