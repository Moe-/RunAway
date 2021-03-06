class "Obstacle" {
	obsType = 0;
}

function Obstacle:__init(world, x, y)
	self.world = world
	
	local r = math.random(1, 3)
	if r == 1 then
		self.image = love.graphics.newImage("gfx/shelf.png")
	elseif r == 2 then
		self.image = love.graphics.newImage("gfx/shelf2.png")
	elseif r == 3 then
		self.image = love.graphics.newImage("gfx/shelf3.png")
	else
		self.image = love.graphics.newImage("gfx/box.png")
	end
	self.obsType = r
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
	
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

function Obstacle:getObstacleType()
	return self.obsType
end

function Obstacle:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
end

function Obstacle:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Obstacle:update(dt)

end

function Obstacle:getSize()
  return self.width, self.height
end

function Obstacle:getWidth()
  return self.width
end

function Obstacle:getHeight()
  return self.height
end

function Obstacle:getType()
	return "Obstacle"
end

function Obstacle:destroy()
	self.physics.body:destroy()
	self.physics.fixture:destroy()
end
