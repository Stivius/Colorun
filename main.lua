local players = require "players"
local timers = require "timers"

require "color"
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
   	if key == "p" and not gameFinished and not drawCountdown then
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
	mainFont = love.graphics.newFont(100)
	math.randomseed(os.time())

	backgroundColors = {"#b9f9e8", "#b9ddf9", "#f28ca3", "#f3a5cd", "#f9dab9", "#a5bef2", "#8fd1cd", "#e2f0fd", "#f9cab9", "#ffa87f"}
	backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])

    initSettings()

	playersCount = data.general.playersCount
	countdown = data.general.countdown - 1
	minSwapTime = data.general.minSwapTime
	maxSwapTime = data.general.maxSwapTime
	restartTime = data.general.restartTime

	assert(data.colors._size == data.colorKeys._size)
	assert(playersCount <= data.colors._size)

	music = love.audio.newSource(data.general.audioFile)
    music:setLooping(true)
    music:play()

    finishLineCoords = {750, 0, 750, 600}
    players:setFinishLine(finishLineCoords)

	local playersColors = {}
	for i = 1, data.colors._size do
		playersColors[i] = Color:create(data.colors["color" .. i], data.colorKeys["colorKey" .. i])
	end

    for i = 1, playersCount do
    	local num = math.random(1, #playersColors)
    	players:addPlayer(playersColors[num])
   		table.remove(playersColors, num)
   	end

	timers:addTimer("BackgroundTimer", 1, false, function()
		local oldBackgroundColor = backgroundColor
		while backgroundColor == oldBackgroundColor do
			backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])
		end
	end)

	gameFinished = false
	gamePause = true
	drawCountdown = true
	showWinMessage = false
	local width, height = love.window.getMode()
	winMessage = Message:create("", (width - 300)/2, (height - 150)/2, 300, 150)
	textToDraw = love.graphics.newText(mainFont, "")

	startCountdown()
end

function startCountdown()
	countdown = data.general.countdown - 1
	timers:addTimer("Countdown", 1, false, function()
		countdown = countdown - 1
		if countdown == 0 then
			drawCountdown = false
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
	showWinMessage = true
	winMessage:setText("Player " .. players:winner() .. " won the game!")
	stopSwapping()

	timers:addTimer("Restart", restartTime, true, function()
		showWinMessage = false
		gameFinished = false
		drawCountdown = true
		startCountdown()
		players:reset()
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
	if gamePause and not drawCountdown and not gameFinished then
		textToDraw:set("PAUSE")
		love.graphics.draw(textToDraw, (width - textToDraw:getWidth())/2, (height - textToDraw:getHeight())/2)
	end

	if drawCountdown then
		if countdown - 1 ~= 0 then
			textToDraw:set(countdown - 1)
			love.graphics.draw(textToDraw, (width - textToDraw:getWidth())/2, (height - textToDraw:getHeight())/2)
		else
			textToDraw:set("GO")
			love.graphics.draw(textToDraw, (width - textToDraw:getWidth())/2, (height - textToDraw:getHeight())/2)
		end
	end

	if showWinMessage then
		winMessage:draw()
	end

end