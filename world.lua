require('background')
require('foreground')
require('dog')
require('player')
require('sausage')
require('sausageitem')
require('obstacle')
require('particle')

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
	title = nil;
}

function World:__init(width, height)
	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  self.world = love.physics.newWorld(0, 9.81*64, true)
	self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	self.ground = {}
  self.ground.body = love.physics.newBody(self.world, 0, 300/2)
  self.ground.shape = love.physics.newRectangleShape(0, 400, 10000000, 50)
  self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)
	self.ground.fixture:setFriction(0.0)
	self.ground.body:setFixedRotation(true)
	
	self.sausages = {}
	self.sausageItems = {}
	self.obstacles = {}
	
	self.width = width
	self.height = height
  self.background = Background:new(width, height)
  self.foreground = Foreground:new(width, height)
	self.player = Player:new(self.world, 300, 150)
	self.dog = Dog:new(self.world, 50, 150)
	
	self.title = love.graphics.newImage("gfx/record.png");
	
	self.atmosphere = love.audio.newSource('sfx/atmo_loop_supermarket.wav', 'static')
	self.atmosphere:setLooping(true)
	self.atmosphere:play()
end

function World:update(dt)
	self.world:update(dt)
	
	self.background:update(dt)
	self.foreground:update(dt)
	self.player:update(dt)
	
	for i,v in pairs(self.sausages) do
		v:update(dt)
	end
	
	local posx, posy = self.player:getPosition()
	self.offsetx = posx + (self.player.physics.body:getLinearVelocity() * 0.2) - self.width/2
	
	local dposx, dposy = self.dog:getPosition()
	local dogToPlayerDistance = getDistance(posx, posy, dposx, dposy)
	if dposx >= posx then
		self.dog:update(dt, self.obstacles, true, dogToPlayerDistance)
		self.dogReturns = true
	else
		self.dog:update(dt, self.obstacles, false, dogToPlayerDistance)
		self.dogReturns = false
	end
	self.player:dogBites(dt, dogToPlayerDistance)
	
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
		table.insert(self.obstacles, Obstacle:new(self.world, posx + 500 + math.random(4500), 525))
	end
	
	if self.lost == false then
		self.timePassed = self.timePassed + dt
	end
end

function World:draw()
	if self.lost then
		--love.postshader.addEffect("bloom")
	end
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
	
	self.foreground:draw(self.offsetx, self.offsety)
end
	
function World:draw2()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.title, 0, 548, 0, 2, 2)
	love.graphics.setColor(0, 0, 0, 127)
	love.graphics.print("You ran " .. math.floor(self.offsetx * 0.01 + 1) .. "m", 52, self.height - 48, 0, 0.75)
	love.graphics.setColor(0, 255, 0, 191)
	love.graphics.print("You ran " .. math.floor(self.offsetx * 0.01 + 1) .. "m", 50, self.height - 50, 0, 0.75)

	love.graphics.setFont(FONT_SAUSAGE)
	love.graphics.setColor(0, 0, 0, 127)
	love.graphics.print(self.player.sausages, 702, 502, 0, 2, 2)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(self.player.sausages, 700, 500, 0, 2, 2)
	love.graphics.setFont(FONT_MENU)
	
	if self.lost then
		love.graphics.setColor(0, 0, 0, 127)
		love.graphics.printf("You Lost!", 2, 242, 800, "center")
		
		local f = 7
		local r = 127 + math.sin((love.timer.getTime() * 0.25) * 5 * f + 90) * 127
		local g = 127 + math.sin((love.timer.getTime() * 0.25) * 5 * f + 180) * 127
		local b = 127 + math.sin((love.timer.getTime() * 0.25) * 5 * f + 270) * 127
		
		love.graphics.setColor(r, g, b, 191)
		love.graphics.printf("You Lost!", 0, 240, 800, "center")
		love.graphics.setColor(255, 255, 255, 255)
	end
	
	if math.floor(love.timer.getTime()) % 2 == 0 then
		love.graphics.setColor(0, 0, 0, 127)
		love.graphics.circle("fill", 657, 55, 16)
		love.graphics.setColor(255, 0, 0, 127)
		love.graphics.circle("fill", 656, 54, 16)
		love.graphics.setColor(0, 0, 0, 127)
		love.graphics.print("REC", 682, 34)
		love.graphics.setColor(255, 255, 255, 127)
		love.graphics.print("REC", 680, 32)
	end
end

function World:keyPressed(key)
	if key == 'w' then
		self.player:jump()
	end
	if key == 's' or key == ' ' then
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
	if not self.lost then
		dog:bitePlayer(player)
		player:die()
	end
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

function World:playerHitsObstacle(player, obstacle)
	player:hitObstacle(obstacle)
end

function World:clearAll()
	self.world:destroy()
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
		elseif aUser:getType() == "Player" and bUser:getType() == "Obstacle" then
			gWorld:playerHitsObstacle(aUser, bUser)
		elseif bUser:getType() == "Player" and aUser:getType() == "Obstacle" then
			gWorld:playerHitsObstacle(bUser, aUser)
		end
	end
	
	if (aUser ~= nil and aUser:getType() == "Player") or (bUser ~= nil and bUser:getType() == "Player") then
		gWorld.player.jumping = false
	end
end
 
function endContact(a, b, coll)
 
end
 
function preSolve(a, b, coll)
 
end
 
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
 
end