local players = require "players"
local timers = require "timers"
local messages = require "messages"
local menu = require "menu"

require "ini_parser"
require "utils"

function love.keypressed(key, scancode, isrepeat)
	if not gamePause then
		players:keypressed(key, scancode, isrepeat)
		if players:intersectFinishLine(finishLineCoords) then
			finishGame()
		end
	end
	menu:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
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
   	if key == "p" and not gameFinished and not gameBeingStarted and not menu.isShown then
    	gamePause = not gamePause
    	if gamePause then
    		pauseMessage = Message:show("PAUSE", 100, (windowWidth - 300)/2, (windowHeight - 150)/2, 300, 150, getRgb("#000000"))
    		players:stopSwapping()
    	else
    		pauseMessage:hide()
    		players:startSwapping(data.general.minSwapTime, data.general.maxSwapTime, colorsAndKeys)
    	end
   	end
   	if key == "m" and not gameFinished and not gameBeingStarted then
   		if menu.isShown and not menu.inEditing then
   			menu:hide()
   			gamePause = false
   			players:startSwapping(data.general.minSwapTime, data.general.maxSwapTime, colorsAndKeys)
   		else
   			menu:show()
   			gamePause = true
   			players:stopSwapping()
   		end
   	end
end

function love.update(dt)
	local newWidth, newHeight = love.window.getMode()
	timers:update(dt)
	if windowWidth ~= newWidth or windowHeight ~= newHeight then
		players:updateProportions(data.general.playersCount, windowWidth, windowHeight)
		messages:updateProportions(windowWidth, windowHeight)
		menu:updateProportions(#menu.items)
		windowWidth, windowHeight = newWidth, newHeight
		finishLineCoords = {x1 = newWidth - 50, y1 = 0, x2 = newWidth - 50, y2 = newHeight}
	end
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

	if not love.filesystem.exists("settings.ini") then
		createSettings("settings.ini")
	end

    loadSettings("settings.ini")

	countdown = data.general.countdown - 1
	restartTime = data.general.restartTime
	windowWidth, windowHeight = love.window.getMode()
	colorsAndKeys = getColorsAndKeys()

	assert(data.colors._size == data.colorKeys._size)
	assert(data.general.playersCount <= data.colors._size)

   	local item
   	item = menu:addItem({text = data.general.playersCount .. " players", actions = {
	   	clicked = function()
	   		if item.inEditing then
	   			saveSettings("settings.ini")
	   			startGame()
	   			menu:hide()
	   		end
	   	end, 
	   	rightChosen = function()
	   		if data.general.playersCount < data.colors._size then
	   			data.general.playersCount = data.general.playersCount + 1
	   		end
	   		item.text:set(data.general.playersCount .. " players")
	   	end, 
	   	leftChosen = function()
	   		if data.general.playersCount > 1 then
	   			data.general.playersCount = data.general.playersCount - 1
	   		end
	   		item.text:set(data.general.playersCount .. " players")
	   	end
   	}})
   	menu:addItem({text = "Exit menu", actions = {clicked = function() menu:hide() end}})

	music = love.audio.newSource(data.general.audioFile)
    music:setLooping(true)
    -- music:play()

	finishLineCoords = {x1 = windowWidth - 50, y1 = 0, x2 = windowWidth - 50, y2 = windowHeight}

	gamePause = true
	startGame()
end

function getColorsAndKeys()
	local colorsAndKeys = {}
	for i = 1, data.colors._size do
		colorsAndKeys[i] = {color = data.colors["color" .. i], colorKey = data.colorKeys["colorKey" .. i]}
	end
	return colorsAndKeys
end

function initPlayers()
	local tempColorsAndKeys = getColorsAndKeys()
    for i = 1, data.general.playersCount do
    	local num = math.random(1, #tempColorsAndKeys)
    	players:addPlayer(tempColorsAndKeys[num].color, tempColorsAndKeys[num].colorKey)
   		table.remove(tempColorsAndKeys, num)
   	end
end

function startGame()
	players:reset()
	initPlayers()

	gameFinished = false
	gameBeingStarted = true
	countdown = data.general.countdown - 1

    countdownMessage = Message:show(countdown - 1, 100, (windowWidth - 300)/2, (windowHeight - 150)/2, 300, 150, getRgb("#000000"))
	countdownTimer = Timer:start("Countdown", 1, false, function()
		countdown = countdown - 1
		if countdown == 0 then
			gameBeingStarted = false
			gamePause = false
			countdownMessage:hide()
			countdownTimer:stop()
			players:startSwapping(data.general.minSwapTime, data.general.maxSwapTime, colorsAndKeys)
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
	love.graphics.line(finishLineCoords.x1, finishLineCoords.y1, finishLineCoords.x2, finishLineCoords.y2)

	players:draw()
	menu:draw()
	messages:draw()
end