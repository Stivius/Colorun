local players = require "players"
local timers = require "timers"
require "color"
require "ini_parser"

function love.keypressed(key, scancode, isrepeat)
	if not gamePause then
		players:keypressed(key, scancode, isrepeat)
	end
end

function love.keyreleased(key, scancodep)
	if key == "f" then
    	if not love.window.getFullscreen() then
    		width, height = love.window.getMode()
    		love.window.setFullscreen(true)
    	else
    		love.window.setFullscreen(false)
    		love.window.setMode(width, height)
    	end
   	end
   	if key == "x" then
    	love.event.quit()
   	end
   	if key == "s" then
    	if music:isPlaying() then
    		music:stop()
    	else
    		music:play()
    	end
   	end
   	if key == "p" then
    	gamePause = not gamePause
   	end
end

function love.update(dt)
	timers:update(dt)
end

function love.load()
	love.graphics.setFont(love.graphics.newFont(100))
	math.randomseed(os.time())

	backgroundColors = {"#b9f9e8", "#b9ddf9", "#f28ca3", "#f3a5cd", "#f9dab9", "#a5bef2", "#8fd1cd", "#e2f0fd", "#f9cab9", "#ffa87f"}
	backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])

    initSettings()

	playersCount = data.general.playersCount
	countdown = data.general.countdown - 1

	assert(data.colors._size == data.colorKeys._size)
	assert(playersCount <= data.colors._size)

	music = love.audio.newSource(data.general.audioFile)
    music:setLooping(true)
    -- music:play()

	local playersColors = {}
	for i = 1, data.colors._size do -- need to be fixed
		playersColors[i] = Color:create(data.colors["color" .. i], data.colorKeys["colorKey" .. i])
	end

    for i = 1, playersCount do
    	local num = math.random(1, #playersColors)
    	players:addPlayer(i, playersColors[num])
   		table.remove(playersColors, num)
   	end


	timers:addTimer("BackgroundTimer", 1, false, function()
		local oldBackgroundColor = backgroundColor
		while backgroundColor == oldBackgroundColor do
			backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])
		end
	end)

	gamePause = true
	drawCountdown = true
	timers:addTimer("Countdown", 1, false, function()
		countdown = countdown - 1
		if countdown == 0 then
			drawCountdown = false
			gamePause = false
			timers:removeTimer("Countdown")
		end
	end)
end

function love.draw()
	love.graphics.setBackgroundColor(backgroundColor.red, backgroundColor.green, backgroundColor.blue)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineWidth(7)
	love.graphics.line(750, 0, 750, 600)

	players:draw()

	love.graphics.setColor(0, 0, 0)
	if gamePause and not drawCountdown then
		love.graphics.print("PAUSE", 400, 300)
	end

	if drawCountdown then
		if countdown - 1 ~= 0 then
			love.graphics.print(countdown - 1, 400, 300)
		else
			love.graphics.print("GO", 400, 300)
		end
	end
end