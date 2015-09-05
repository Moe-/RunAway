require('background')
require('dog')
require('player')

class "World" {
  width = 0;
  height = 0;
  offsetx = 0;
  offsety = 0;
  background = {};
	player = {};
	dog = {};
}

function World:__init(width, height)
	self.width = width
	self.height = height
  self.background = Background:new(width, height)
	self.player = Player:new()
	self.dog = Dog:new()
end

function World:update(dt)
	self.background:update(dt)
	self.player:update(dt)
	self.dog:update()
end

function World:draw()
	self.background:draw(self.offsetx, self.offsety)
	self.player:draw(self.offsetx, self.offsety)
	self.dog:draw(self.offsetx, self.offsety)
end
