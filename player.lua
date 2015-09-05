class "Player" {

}

function Player:__init()
  self.image = love.graphics.newImage("gfx/human.png")
  self.image:setWrap("repeat", "repeat")
  self.quad = love.graphics.newQuad(0, 0, self.image:getWidth(), self.image:getHeight(), self.image:getWidth(), self.image:getHeight())
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function Player:draw(offsetx, offsety)
  love.graphics.draw(self.image, self.quad, 0 + offsetx, 0 + offsety)
end

function Player:update(dt)
end

function Player:getSize()
  return self.width, self.height
end

function Player:getWidth()
  return self.width
end

function Player:getHeight()
  return self.height
end