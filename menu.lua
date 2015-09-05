require('button')

class "Menu" {
  width = 0;
  height = 0;
  startButton = {};
  creditsButton = {};
  quitButton = {};
}

function Menu:__init(width, height)
	self.width = width
	self.height = height
	self.startButton = Button:new(144, 128 + 0, 512, 128, "Start Game")
	self.creditsButton = Button:new(144, 128 + 144, 512, 128, "Credits")
	self.quitButton = Button:new(144, 128 + 288, 512, 128, "Quit Game")
end

function Menu:update(dt)

end

function Menu:draw()
	self.startButton:draw()
	self.creditsButton:draw()
	self.quitButton:draw()
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