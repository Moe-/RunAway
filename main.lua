require('utils')
require('world')
require('menu')

gScreenWidth = 0
gScreenHeight = 0
gWorld = {}
gState = "menu"

function love.load()
	if arg[#arg] == "-debug" then 
		require("mobdebug").start()
	end
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	FONT_MENU = love.graphics.newFont("font/font.ttf", 48)
	love.graphics.setFont(FONT_MENU)
	math.randomseed( os.time() )
	gScreenWidth, gScreenHeight = love.graphics.getDimensions( )
	resetGame()
	gScreenCount = 0
end

function love.update(dt)
	if gState == "menu" then
		gMenu:update(dt)
	else
		gWorld:update(dt)
	end
end

function love.draw()
	if gState == "menu" then
		gMenu:draw()
	else
		gWorld:draw()
	end
end

function resetGame()
	gWorld = World:new(gScreenWidth, gScreenHeight)
	gMenu = Menu:new(gScreenWidth, gScreenHeight)
end

function love.mousepressed(x, y, button)
	if gState == "menu" then
		gMenu:mouseHit(x, y, button)
	end
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