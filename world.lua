require('background')
require('dog')
require('player')
require('sausage')
require('sausageitem')
require('obstacle')

class "World" {
  width = 0;
  height = 0;
  offsetx = 0;
  offsety = 0;
	timePassed = 0;
	lost = false;
	
	numberSausages = 10;
	numberObstacles = 10;
	dogReturns = false;
}

function World:__init(width, height)
	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  self.world = love.physics.newWorld(0, 9.81*64, true)
	self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	self.ground = {}
  self.ground.body = love.physics.newBody(self.world, 0, 300/2)
  self.ground.shape = love.physics.newRectangleShape(0, 300, 10000000, 50)
  self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)
	self.ground.fixture:setFriction(0.0)
	self.ground.body:setFixedRotation(true)
	
	self.sausages = {}
	self.sausageItems = {}
	self.obstacles = {}
	
	self.width = width
	self.height = height
  self.background = Background:new(width, height)
	self.player = Player:new(self.world, 300, 150)
	self.dog = Dog:new(self.world, 50, 150)
	
	self.music = love.audio.newSource('sfx/fast_paced.ogg', 'static')
	self.music:setLooping(true)
	self.music:play()
end

function World:update(dt)
	self.world:update(dt)
	
	self.background:update(dt)
	self.player:update(dt)
	
	
	for i,v in pairs(self.sausages) do
		v:update(dt)
	end
	
	local posx, posy = self.player:getPosition()
	self.offsetx = posx - self.width/2
	
	local dposx, dposy = self.dog:getPosition()
	
	if dposx >= posx then
		self.dog:update(dt, self.obstacles, true)
		self.dogReturns = true
	else
		self.dog:update(dt, self.obstacles, false)
		self.dogReturns = false
	end
	
	-- sausages update and respawn
	for i, v in pairs(self.sausageItems) do
		v:update(dt)
		local sposx, sposy = v:getPosition()
		if getDistance(posx, posy, sposx, sposy) > 5000 then
			self.sausageItems[i] = nil
		end
	end
	
	while self.numberSausages > #self.sausageItems do
		table.insert(self.sausageItems, SausageItem:new(self.world, posx + 500 + math.random(4500), math.random(50, 400)))
	end
	
	-- obstacles update and respawn
	for i, v in pairs(self.obstacles) do
		v:update(dt)
		local sposx, sposy = v:getPosition()
		if getDistance(posx, posy, sposx, sposy) > 5000 then
			self.obstacles[i] = nil
		end
	end
	
	while self.numberObstacles > #self.obstacles do
		table.insert(self.obstacles, Obstacle:new(self.world, posx + 500 + math.random(4500), 425))
	end
	
	if self.lost == false then
		self.timePassed = self.timePassed + dt
	end
end

function World:draw()
	self.background:draw(self.offsetx, self.offsety)
	self.player:draw(self.offsetx, self.offsety)
	self.dog:draw(self.offsetx, self.offsety, self.dogReturns)
	
	for i,v in pairs(self.sausages) do
		v:draw(self.offsetx, self.offsety)
	end
	
	for i, v in pairs(self.sausageItems) do
		v:draw(self.offsetx, self.offsety)
	end
	
	for i, v in pairs(self.obstacles) do
		v:draw(self.offsetx, self.offsety)
	end
	
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print("You survived " .. math.ceil(0.5 + 1000 * self.timePassed) / 1000 .. " seconds", 50, self.height - 50, 0, 0.75)
	love.graphics.setColor(255, 255, 255, 255)
	
	if self.lost then
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print("Lost", 50, 50, 0, 5)
		love.graphics.setColor(255, 255, 255, 255)
	end
	
	if math.floor(love.timer.getTime()) % 2 == 0 then
		love.graphics.setColor(255, 0, 0, 127)
		love.graphics.circle("fill", 656, 54, 16)
		love.graphics.setColor(255, 255, 255, 127)
		love.graphics.print("REC", 680, 32)
	end
end

function World:keyPressed(key)
	if key == 'w' then
		self.player:jump()
	end
	if key == 's' then
		self.player:sausageDrop(self.world, self.sausages)
	end
	if key == 'e' then
		self.player:eatSausage()
	end
end

function World:keyReleased()
	
end

function World:dogEatsSausage(dog, sausage)
	for i,v in pairs(self.sausages) do
		if v == sausage then
			self.sausages[i] = nil
			dog:eatSausage(sausage)
			sausage:destroy()
			break
		end
	end
end

function World:dogEatsPlayer(dog, player)
	self.lost = true
end

function World:playerGetsSausage(player, sausageItem)
	for i,v in pairs(self.sausageItems) do
		if v == sausageItem then
			self.sausageItems[i] = nil
			player:takeSausage(sausageItem)
			sausageItem:destroy()
			break
		end
	end
end

function beginContact(a, b, coll)
	aUser = a:getUserData()
	bUser = b:getUserData()
	if aUser ~= nil and bUser ~= nil then
		if aUser:getType() == "Sausage" and bUser:getType() == "Dog" then
			gWorld:dogEatsSausage(bUser, aUser)
		elseif bUser:getType() == "Sausage" and aUser:getType() == "Dog" then
			gWorld:dogEatsSausage(aUser, bUser)
		elseif aUser:getType() == "Player" and bUser:getType() == "Dog" then
			gWorld:dogEatsPlayer(bUser, aUser)
		elseif bUser:getType() == "Player" and aUser:getType() == "Dog" then
			gWorld:dogEatsPlayer(aUser, bUser)
		elseif aUser:getType() == "Player" and bUser:getType() == "SausageItem" then
			gWorld:playerGetsSausage(aUser, bUser)
		elseif bUser:getType() == "Player" and aUser:getType() == "SausageItem" then
			gWorld:playerGetsSausage(bUser, aUser)
		end
	end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
 
end