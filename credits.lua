class "Credits" {
  width = 0;
  height = 0;
  backButton = {};
}

function Credits:__init(width, height)
	self.width = width
	self.height = height
	self.backButton = Button:new(144, 416, 512, 128, "Back")
end

function Credits:update(dt)

end

function Credits:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Moe\neggwithcheese\nPriorBlue\nR0Age0D\nPixelGuy", 0, 40, 800, "center")

	self.backButton:draw()
end

function Credits:mouseHit(x, y, button)
	if self.backButton:isHit(x, y) then
		gState = "menu"
	end
end