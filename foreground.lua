class "Foreground" {
	screenWdith = 0;
	screenHeight = 0;
}

function Foreground:__init(width, height)
	self.screenWidth = width;
	self.screenHeight = height;
  self.image = love.graphics.newImage("gfx/light.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function Foreground:draw(offsetx, offsety)
	love.graphics.setBlendMode("multiplicative")

	love.graphics.setColor(255, 255, 255, 63)
	love.graphics.draw(self.image, self.quad, 0 - offsetx % (self.width * 2), 0 - offsety % self.height, 0, 2, 2)
	love.graphics.draw(self.image, self.quad, 0 - (offsetx % (self.width * 2)) + (self.width * 2), 0 - offsety % self.height, 0, 2, 2)
	
	love.graphics.setBlendMode("alpha")
end

function Foreground:update(dt)
end

function Foreground:getSize()
  return self.width, self.height
end

function Foreground:getWidth()
  return self.width
end

function Foreground:getHeight()
  return self.height
end

function Background:getType()
	return "Foreground"
end
