require('utils')
require('world')
require('menu')
require('credits')
require('lib/postshader')

gScreenWidth = 0
gScreenHeight = 0
gWorld = {}
gCredits = {}
gState = "menu"

function love.load()
	if arg[#arg] == "-debug" then 
		require("mobdebug").start()
	end
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	FONT_MENU = love.graphics.newFont("font/font.ttf", 48)
	FONT_SAUSAGE = love.graphics.newImageFont("gfx/sausage_numbers.png", "0123456789")
	love.graphics.setFont(FONT_MENU)
	math.randomseed( os.time() )
	gScreenWidth, gScreenHeight = love.graphics.getDimensions( )
	resetGame()
	gScreenCount = 0
end

function love.update(dt)
	if gState == "menu" then
		gMenu:update(dt)
	elseif gState == "credits" then
		gCredits:update(dt)
	else
		gWorld:update(dt)
	end
end

function love.draw()
	love.window.setTitle(love.timer.getFPS() .. " FPS")
	love.postshader.setBuffer("render")

	if gState == "menu" then
		gMenu:draw()
	elseif gState == "credits" then
		gCredits:draw()
	else
		gWorld:draw()
	end

	love.postshader.addEffect("wind", math.max(0, math.min(math.floor(gWorld.player.physics.body:getLinearVelocity() * 0.1) - 16, 32)), 0)
	love.postshader.addEffect("tiltshift", 2, 2)
	
	if gState == "game" then
		gWorld:draw2()
	end
	if gWorld.lost then
	love.postshader.addEffect("chromatic", math.sin(love.timer.getTime()*5) * 8, math.sin(love.timer.getTime()*4) * 3, math.sin(love.timer.getTime()*3) * 5, math.cos(love.timer.getTime()*7) * 3, math.cos(love.timer.getTime()*4) * -5, math.sin(love.timer.getTime()*9) * 7)
	end
	love.postshader.addEffect("scanlines")
	love.postshader.draw()
end

function resetGame()
	gWorld = World:new(gScreenWidth, gScreenHeight)
	gMenu = Menu:new(gScreenWidth, gScreenHeight)
	gCredits = Credits:new(gScreenWidth, gScreenHeight)
end

function love.mousepressed(x, y, button)
	if gState == "menu" then
		gMenu:mouseHit(x, y, button)
	elseif gState == "credits" then
		gCredits:mouseHit(x, y, button)
	end
end

function love.mousemoved(x, y)
	if gState == "menu" then
		gMenu:mouseMoved(x, y)
	elseif gState == "credits" then
		gCredits:mouseMoved(x, y)
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
	gWorld:keyPressed(key)
end

function love.keyreleased(key)
  if key == 'escape' then
		love.event.quit()
	elseif key == 'r' then
		resetGame()
  end
	gWorld:keyReleased(key)
end