class "Dog" {

}

function Dog:__init()
  self.image = love.graphics.newImage("gfx/dog.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function Dog:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, 0 + offsetx, 0 + offsety)
end

function Dog:update(dt)
end

function Dog:getSize()
  return self.width, self.height
end

function Dog:getWidth()
  return self.width
end

function Dog:getHeight()
  return self.height
end