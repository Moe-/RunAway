class "Dog" {
	nextJump = 0.0;
	timer = 0;
	frame = 0;
	barkNext = 0;
}

function Dog:__init(world, x, y)
	self.world = world
	
  self.image = love.graphics.newImage("gfx/DogRunAnimation.png")
  self.image:setWrap("repeat", "repeat")
  self.width = self.image:getWidth() / 8
  self.height = self.image:getHeight()
  self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.image:getWidth(), self.image:getHeight())
	
	self.physics = {}
	self.physics.body = love.physics.newBody(world, x, y, "dynamic")
  --self.physics.shape = love.physics.newCircleShape(16)
	self.physics.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 2)
	self.physics.body:setUserData(self)
	self.physics.body:setFixedRotation(true)
	self.physics.fixture:setUserData(self)
	
	self.physics.fixture:setRestitution(0.3)
	
	self.strength = 1
	
	self.bite = love.audio.newSource('sfx/dog_bite_01.wav', 'static')
	self.bark = {
		love.audio.newSource('sfx/dog_bark_01.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_02.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_03.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_04.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_05.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_06.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_07.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_08.wav', 'static'),
		love.audio.newSource('sfx/dog_bark_09.wav', 'static')
	}
	
	self.particleEat = Particle:new(0, 0, 255, 128, 192, 2)
	self.particleEat:stop()
end

function Dog:draw(offsetx, offsety, flip)
	self.frame = math.floor(self.timer) % 8
	self.quad:setViewport(self.width * self.frame, 0, self.width, self.height)
	if flip then
		love.graphics.draw(self.image, self.quad, self.physics.body:getX() + self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety, 0, -1, 1)
	else
		love.graphics.draw(self.image, self.quad, self.physics.body:getX() - self.width/2 - offsetx, self.physics.body:getY() - self.height/2 - offsety)
	end
	self.particleEat:drawAt(self.physics.body:getX() + 3 * self.width/8 - offsetx, self.physics.body:getY() - self.height/4 - offsety)
end

function Dog:getPosition()
	return self.physics.body:getX(), self.physics.body:getY()
end

function Dog:update(dt, obstacles, wait, distanceToPlayer)
	self.timer = self.timer + (x * 0.05) * dt

	if not wait then
		self.physics.body:applyForce(gDogSpeedBase * math.pow(gDogSpeedFactorBase, self.strength - 1), 0)
	else
		self.physics.body:applyForce(-gDogSpeedBase * math.pow(gDogSpeedFactorBase, self.strength - 1), 0)
	end
	
	self.nextJump = self.nextJump - dt
	if self.nextJump <= 0 then
		local posx, posy = self:getPosition()
		for i,v in pairs(obstacles) do
			local oposx, oposy = v:getPosition()
			if getDistance(posx, posy, oposx, oposy) < 500 and ((not wait and posx < oposx) or (wait and posx > oposx)) then
				self.physics.body:applyLinearImpulse(0, 6000)
				self.nextJump = 2.0
				break
			end
		end
	end
	
	self.barkNext = self.barkNext - dt
	if self.barkNext < 0 then
		if distanceToPlayer < 300 then
			self.barkNext = math.random() * 1.0
		else
			self.barkNext = math.random() * 5.0
		end
		local id = math.random(1, #self.bark)
		self.bark[id]:rewind()
		self.bark[id]:play()
	end
	self.particleEat:update(dt)
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

function Dog:eatSausage(sausage)
	self.physics.body:applyForce(-1250 * math.pow(1.2, self.strength), 0)
	self.strength = self.strength + 1
	self.particleEat:reset()
end

function Dog:destroy()
	self.physics.body:destroy()
	self.physics.fixture:destroy()
end

function Dog:bitePlayer(player)
	self.bite:rewind()
	self.bite:play()
end