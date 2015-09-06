class "Button" {
	x = 0,
	y = 0,
	width = 0;
	height = 0;
	image = nil;
	text = "Test";
	hover = false;
}

function Button:__init(x, y, width, height, text, path)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.image = love.graphics.newImage(path);
	self.image:setFilter("nearest", "nearest")
	self.text = text;
end

function Button:update(dt)
	
end

function Button:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, self.x, self.y, 0, 4, 4)
	
	love.graphics.setColor(0, 0, 0, 127)
	love.graphics.printf(self.text, self.x + 4, self.y + 40 + 4, 512, "center")
	if self.hover then
		love.graphics.setColor(255, 255, 127)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.printf(self.text, self.x, self.y + 40, 512, "center")
end

function Button:onHover(x, y)
	if x >= self.x and y >= self.y and x <= self.width + self.x and y <= self.height + self.y then
		self.hover = true
	else
		self.hover = false
	end
end

function Button:isHit(x, y)
	if x >= self.x and y >= self.y and x <= self.width + self.x and y <= self.height + self.y then
		return true
	else
		return false
	end
end