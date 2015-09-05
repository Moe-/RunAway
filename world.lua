class "World" {
  width = 0;
  height = 0;

  offsetx = 0;
  offsety = 0;
}

function World:__init()

end

function World:update(dt)
	
end

function World:draw()
	love.graphics.print("Test", 200, 200)
end
