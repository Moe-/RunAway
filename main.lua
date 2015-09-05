require('utils')


gScreenWidth = 0
gScreenHeight = 0

function love.load()
	if arg[#arg] == "-debug" then 
		require("mobdebug").start() 
	end
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	math.randomseed( os.time() )
	gScreenWidth, gScreenHeight = love.graphics.getDimensions( )
	resetGame()
	gScreenCount = 0
end

function love.update(dt)

end

function love.draw()
	love.graphics.print("Test", 200, 200)
end

function resetGame()

end

function love.mousepressed(x, y, button)
  
end

function love.mousereleased(x, y, button)

end

function love.keypressed(key)
	if key == "f4" then
    local s = love.graphics.newScreenshot() --ImageData
    s:encode("pic" .. gScreenCount .. ".png", 'png')
    gScreenCount = gScreenCount + 1
	end
end

function love.keyreleased(key)
  if key == 'escape' then
		love.event.quit()
	elseif key == 'r' then
		resetGame()
  end
end