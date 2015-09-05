class "Background" {
	screenWdith = 0;
	screenHeight = 0;
}

function Background:__init(width, height)
	self.screenWidth = width;
	self.screenHeight = height;
  self.image = love.graphics.newImage("gfx/background.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function Background:draw(offsetx, offsety)
	love.graphics.setBackgroundColor(200, 255, 200, 255)
  love.graphics.draw(self.image, self.quad, 0 - offsetx % self.width, 0 - offsety % self.height, 0, 4, 4)
end

function Background:update(dt)
end

function Background:getSize()
  return self.width, self.height
end

function Background:getWidth()
  return self.width
end

function Background:getHeight()
  return self.height
end

function Background:getType()
	return "Background"
end
