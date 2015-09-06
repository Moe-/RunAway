class "Credits" {
  width = 0;
  height = 0;
  backButton = {};
  names = {"Moe", "eggwithcheese", "PriorBlue", "R0Age0D", "PixelGuy", "Phaselock"};
  background = nil;
  quad = nil;
  timer = 0;
}

function Credits:__init(width, height)
	self.width = width
	self.height = height
	self.backButton = Button:new(144, 448, 512, 128, "Back", "gfx/button2.png")
	self.background = love.graphics.newImage("gfx/credits.png")
	self.quad = love.graphics.newQuad(0, 0, self.background:getWidth(), self.background:getHeight(), self.background:getWidth(), self.background:getHeight())
end

function Credits:update(dt)
	self.timer = self.timer + dt;
end

function Credits:draw()
	local f = 7
	local r = 127 + math.sin((love.timer.getTime() * 0.1) * 5 * f + 90) * 127
	local g = 127 + math.sin((love.timer.getTime() * 0.1) * 5 * f + 180) * 127
	local b = 127 + math.sin((love.timer.getTime() * 0.1) * 5 * f + 270) * 127

	love.graphics.setColor(r, g, b, 15)
	love.graphics.draw(self.background, self.quad, 400, 300, self.timer * 0.1, 4, 4, 100, 75, math.sin(self.timer), math.sin(self.timer))
	
	for i = 1, #self.names do
		r = 127 + math.sin(love.timer.getTime() * 5 - i * f + 90) * 127
		g = 127 + math.sin(love.timer.getTime() * 5 - i * f + 180) * 127
		b = 127 + math.sin(love.timer.getTime() * 5 - i * f + 270) * 127
		local x = math.sin(love.timer.getTime() * 5 + i) * 8
		local y = 48 + i * 48
		love.graphics.setColor(r, g, b, 255)
		love.graphics.printf(self.names[i], x, y, 800, "center")
	end
	
	self.backButton:draw()
end

function Credits:mouseHit(x, y, button)
	if self.backButton:isHit(x, y) then
		gState = "menu"
	end
end

function Credits:mouseMoved(x, y)
	self.backButton:onHover(x, y)
end