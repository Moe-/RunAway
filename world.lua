require('background')
require('dog')
require('player')
require('sausage')

class "World" {
  width = 0;
  height = 0;
  offsetx = 0;
  offsety = 0;
	lost = false;
}

function World:__init(width, height)
	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  self.world = love.physics.newWorld(0, 9.81*64, true)
	self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	self.ground = {}
  self.ground.body = love.physics.newBody(self.world, 0, 250/2)
  self.ground.shape = love.physics.newRectangleShape(0, 250, 10000000, 50)
  self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)
	self.ground.fixture:setFriction(0.0)
	
	self.sausages = {}
	
	self.width = width
	self.height = height
  self.background = Background:new(width, height)
	self.player = Player:new(self.world, 300, 150)
	self.dog = Dog:new(self.world, 50, 150)
end

function World:update(dt)
	self.world:update(dt)
	
	self.background:update(dt)
	self.player:update(dt)
	self.dog:update(dt)
	
	for i,v in pairs(self.sausages) do
		v:update(dt)
	end
	
	local posx, posy = self.player:getPosition()
	self.offsetx = posx - self.width/2
	
	local dposx, dposy = self.player:getPosition()
	
	if dposx >= posx then
		-- dog overtakes human - what to do?
	end
	
	
	--self.offsety = posy - 3*self.height/4
end

function World:draw()
	self.background:draw(self.offsetx, self.offsety)
	self.player:draw(self.offsetx, self.offsety)
	self.dog:draw(self.offsetx, self.offsety)
	
	for i,v in pairs(self.sausages) do
		v:draw(self.offsetx, self.offsety)
	end
	
	if self.lost then
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print("Lost", 50, 50, 0, 5)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function World:keyPressed(key)
	if key == 'w' then
		self.player:jump()
	end
	
	if key == 's' then
		self.player:sausageDrop(self.world, self.sausages)
	end
end

function World:keyReleased()
	
end

function World:dogEatsSausage(dog, sausage)
	for i,v in pairs(self.sausages) do
		if v == sausage then
			self.sausages[i] = nil
			dog:eatSausage(sausage)
			break
		end
	end
end

function World:dogEatsPlayer(dog, player)
	self.lost = true
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
		end
	end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
 
end