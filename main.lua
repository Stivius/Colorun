local players = require "players"
local timers = require "timers"
local messages = require "messages"

require "ini_parser"
require "utils"

function love.keypressed(key, scancode, isrepeat)
	if not gamePause then
		players:keypressed(key, scancode, isrepeat)
		local wnr = players:winner()
		if wnr then
			finishGame()
		end
	end
end

function love.keyreleased(key, scancodep)
	if key == "f" then
    	if not love.window.getFullscreen() then
    		beforeFullscreenWidth, beforeFullscreenHeight = love.window.getMode()
    		love.window.setFullscreen(true)
    	else
    		love.window.setFullscreen(false)
    		love.window.setMode(beforeFullscreenWidth, beforeFullscreenHeight)
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
   	if key == "p" and not gameFinished and not gameBeingStarted then
    	gamePause = not gamePause
    	if gamePause then
    		pauseMessage = Message:show("PAUSE", 100, (windowWidth - 300)/2, (windowHeight - 150)/2, 300, 150, getRgb("#000000"))
    		players:stopSwapping()
    	else
    		pauseMessage:hide()
    		players:startSwapping()
    	end
   	end
end

function love.update(dt)
	windowWidth, windowHeight = love.window.getMode()
	timers:update(dt)
end

function love.load()
	math.randomseed(os.time())

	backgroundColors = {"#b9f9e8", "#b9ddf9", "#f28ca3", "#f3a5cd", "#f9dab9", "#a5bef2", "#8fd1cd", "#e2f0fd", "#f9cab9", "#ffa87f"}
	backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])
	Timer:start("BackgroundTimer", 1, false, function()
		local oldBackgroundColor = backgroundColor
		while backgroundColor == oldBackgroundColor do
			backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])
		end
	end)

    initSettings()

	countdown = data.general.countdown - 1
	restartTime = data.general.restartTime

	assert(data.colors._size == data.colorKeys._size)
	assert(data.general.playersCount <= data.colors._size)

	local colorsAndKeys = {}
	for i = 1, data.colors._size do
		colorsAndKeys[i] = {["color"] = data.colors["color" .. i], ["colorKey"] = data.colorKeys["colorKey" .. i]}
	end

    for i = 1, data.general.playersCount do
    	local num = math.random(1, #colorsAndKeys)
    	players:addPlayer(colorsAndKeys[num].color, colorsAndKeys[num].colorKey)
   		table.remove(colorsAndKeys, num)
   	end

	music = love.audio.newSource(data.general.audioFile)
    music:setLooping(true)
    -- music:play()

	finishLineCoords = {750, 0, 750, 600}
    players:setFinishLine(finishLineCoords)
    players:setSwappingTimeRange(data.general.minSwapTime, data.general.maxSwapTime)

	gamePause = true
	startGame()
end

function startGame()
	players:reset()
	gameFinished = false
	gameBeingStarted = true
	countdown = data.general.countdown - 1
	windowWidth, windowHeight = love.window.getMode()

    countdownMessage = Message:show(countdown - 1, 100, (windowWidth - 300)/2, (windowHeight - 150)/2, 300, 150, getRgb("#000000"))
	countdownTimer = Timer:start("Countdown", 1, false, function()
		countdown = countdown - 1
		if countdown == 0 then
			gameBeingStarted = false
			gamePause = false
			countdownMessage:hide()
			countdownTimer:stop()
			players:startSwapping()
		else
			if countdown - 1 == 0 then
				countdownMessage:setText("GO")
			else
				countdownMessage:setText(countdown - 1)
			end
		end
	end)
end

function finishGame()
	gameFinished = true
	gamePause = true
	players:stopSwapping()

	local text = "Player " .. players:winner() .. " won the game!"
	Message:show(text, 22, (windowWidth - 300)/2, (windowHeight - 150)/2, 300, 150, getRgb("#FFFFFF"), getRgb("#000000"), restartTime)

	Timer:start("Restart", restartTime, true, function()
		startGame()
	end)
end

function love.draw()
	love.graphics.setBackgroundColor(backgroundColor.red, backgroundColor.green, backgroundColor.blue)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineWidth(7)
	love.graphics.line(finishLineCoords)

	players:draw()
	messages:draw()
end