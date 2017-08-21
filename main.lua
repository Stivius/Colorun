local players = require "players"
local timers = require "timers"

require "ini_parser"
require "message"

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
   	if key == "p" and not gameFinished and not gameBeingStarted then
    	gamePause = not gamePause
    	if gamePause then
    		stopSwapping()
    	else
    		startSwapping()
    	end
   	end
end

function love.update(dt)
	timers:update(dt)
end

function love.load()
	math.randomseed(os.time())

	backgroundColors = {"#b9f9e8", "#b9ddf9", "#f28ca3", "#f3a5cd", "#f9dab9", "#a5bef2", "#8fd1cd", "#e2f0fd", "#f9cab9", "#ffa87f"}
	backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])
	timers:addTimer("BackgroundTimer", 1, false, function()
		local oldBackgroundColor = backgroundColor
		while backgroundColor == oldBackgroundColor do
			backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])
		end
	end)

    initSettings()

	countdown = data.general.countdown - 1
	minSwapTime = data.general.minSwapTime
	maxSwapTime = data.general.maxSwapTime
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

	local width, height = love.window.getMode()
	winMessage = Message:create("", (width - 300)/2, (height - 150)/2, 300, 150)
	infoTextToDraw = love.graphics.newText(love.graphics.newFont(100), "")

	music = love.audio.newSource(data.general.audioFile)
    music:setLooping(true)
    music:play()

	finishLineCoords = {750, 0, 750, 600}
    players:setFinishLine(finishLineCoords)

	gamePause = true
	startGame()
end

function startGame()
	players:reset()
	gameFinished = false
	gameBeingStarted = true
	countdown = data.general.countdown - 1

	timers:addTimer("Countdown", 1, false, function()
		countdown = countdown - 1
		if countdown == 0 then
			gameBeingStarted = false
			gamePause = false
			timers:removeTimer("Countdown")
			startSwapping()
		end
	end)
end

function startSwapping()
	local swapTime = math.random(minSwapTime, maxSwapTime)
	timers:addTimer("SwapRects", swapTime, false, function()
		players:swap()
		swapTime = math.random(minSwapTime, maxSwapTime)
		timers["SwapRects"].duration = swapTime
	end)
end

function stopSwapping()
	timers:removeTimer("SwapRects")
end

function finishGame()
	gameFinished = true
	gamePause = true
	winMessage:setText("Player " .. players:winner() .. " won the game!")
	stopSwapping()

	timers:addTimer("Restart", restartTime, true, function()
		startGame()
	end)
end

function love.draw()
	love.graphics.setBackgroundColor(backgroundColor.red, backgroundColor.green, backgroundColor.blue)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineWidth(7)
	love.graphics.line(finishLineCoords)

	players:draw()

	local width, height = love.window.getMode()

	love.graphics.setColor(0, 0, 0)
	if gamePause and not gameBeingStarted and not gameFinished then
		infoTextToDraw:set("PAUSE")
		love.graphics.draw(infoTextToDraw, (width - infoTextToDraw:getWidth())/2, (height - infoTextToDraw:getHeight())/2)
	end

	if gameBeingStarted then
		if countdown - 1 ~= 0 then
			infoTextToDraw:set(countdown - 1)
			love.graphics.draw(infoTextToDraw, (width - infoTextToDraw:getWidth())/2, (height - infoTextToDraw:getHeight())/2)
		else
			infoTextToDraw:set("GO")
			love.graphics.draw(infoTextToDraw, (width - infoTextToDraw:getWidth())/2, (height - infoTextToDraw:getHeight())/2)
		end
	end

	if gameFinished then
		winMessage:draw()
	end

end