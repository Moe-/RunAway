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
	
	self.ground = {}
  self.ground.body = love.physics.newBody(self.world, 0, 250/2)
  self.ground.shape = love.physics.newRectangleShape(0, 250, 10000000, 50)
  self.ground.fixture = love.physics.newFixture(self.ground.body, self.ground.shape)
	
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
	
	print(#self.sausages)
	for i,v in pairs(self.sausages) do
		v:update(dt)
	end
	
	local posx, posy = self.player:getPosition()
	self.offsetx = posx - self.width/2
	
	local dposx, dposy = self.player:getPosition()
	
	if dposx >= posx then
		self.lost = false
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
		love.graphics.print("Lost", 50, 50)
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