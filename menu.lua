require('button')

class "Menu" {
  width = 0;
  height = 0;
  startButton = {};
  creditsButton = {};
  quitButton = {};
  background = {};
  quad = {};
  timer = 0;
  title = nil;
}

function Menu:__init(width, height)
	self.width = width
	self.height = height
	self.startButton = Button:new(144, 128 + 0, 512, 128, "Start Game", "gfx/button.png")
	self.creditsButton = Button:new(144, 128 + 160, 512, 128, "Credits", "gfx/button.png")
	self.quitButton = Button:new(144, 128 + 320, 512, 128, "Quit Game", "gfx/button.png")

	self.background = love.graphics.newImage("gfx/menu.png");
	self.background:setWrap("repeat", "repeat")
	self.width = self.background:getWidth()
	self.height = self.background:getHeight()
	self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.background:getWidth(), self.background:getHeight());
	self.title = love.graphics.newImage("gfx/title.png");
end

function Menu:update(dt)
	self.timer = self.timer + dt * 10;
end

function Menu:draw()
	self.quad:setViewport(-self.timer, -self.timer, self.width, self.height)
	love.graphics.draw(self.background, self.quad, 0, 0, 0, 4, 4)
	self.startButton:draw()
	self.creditsButton:draw()
	self.quitButton:draw()
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.title, 0, 16, 0, 4, 4)
	
	love.graphics.setColor(0, 0, 0, 127)
	love.graphics.printf("RunAway", 2, 34, 800, "center")
	
	local f = 7
	local r = 127 + math.sin((love.timer.getTime() * 0.25) * 5 * f + 90) * 127
	local g = 127 + math.sin((love.timer.getTime() * 0.25) * 5 * f + 180) * 127
	local b = 127 + math.sin((love.timer.getTime() * 0.25) * 5 * f + 270) * 127
	
	love.graphics.setColor(r, g, b, 191)
	love.graphics.printf("RunAway", 0, 32, 800, "center")
	love.graphics.setColor(255, 255, 255, 255)
end

function Menu:mouseHit(x, y, button)
	if self.startButton:isHit(x, y) then
		gState = "game"
	elseif self.creditsButton:isHit(x, y) then
		gState = "credits"
	elseif self.quitButton:isHit(x, y) then
		love.event.quit()
	end
end

function Menu:mouseMoved(x, y)
	self.startButton:onHover(x, y)
	self.creditsButton:onHover(x, y)
	self.quitButton:onHover(x, y)
end