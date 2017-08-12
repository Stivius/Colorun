Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:create(x, y, width, height, color, key)
	local rect = {}
   	setmetatable(rect, Rectangle)
   	rect.x = x
   	rect.y = y
   	rect.width = width
   	rect.height = height
   	rect.color = getRgb(color)
   	rect.key = key
   	rect.speed = 20

   	return rect
end

function Rectangle:draw()
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Rectangle:move()
	self.x = self.x + self.speed
end

function love.keypressed(key, scancode, isrepeat)
	for i =1, playersCount do
		if key == rectangles[i].key then 
			rectangles[i]:move()
		end
	end
end

function initSettings()
	if love.filesystem.exists("settings.ini") then
		for line in love.filesystem.lines("settings.ini") do
		 	local key, value = line:match("(%a+)%s*=%s*(.+)")
		 	if key ~= nil and value ~= nil then
		 		parse(key, value)
		 	end
		end
	end
end

function parse(key, value)
	if key == "PlayersCount" then
		playersCount = value
	elseif key == "WhiteKey" then
		players[1].key = value
	elseif key == "GreenKey" then
		players[2].key = value
	elseif key == "BlueKey" then
		players[3].key = value
	elseif key == "BlackKey" then
		players[4].key = value
	elseif key == "RedKey" then
		players[5].key = value
	elseif key == "YellowKey" then
		players[6].key = value
	elseif key == "CyanKey" then
		players[7].key = value
	elseif key == "PinkKey" then
		players[8].key = value
	end
end


function love.update(dt)
	test = test + love.timer.getDelta()
	if test >= 1 then
		backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)]) -- for future: cannot be repeated twice in a row
		test = 0
	end
end

function love.load()
	test = 0
	math.randomseed(os.time())

	backgroundColors = {"#b9f9e8", "#b9ddf9", "#f28ca3", "#f3a5cd", "#f9dab9", "#a5bef2", "#8fd1cd", "#e2f0fd", "#f9cab9", "#ffa87f"}
	backgroundColor = getRgb(backgroundColors[math.random(1, #backgroundColors)])

	players = {}
	players[1] = {["color"] = "#ffffff"} -- white
	players[2] = {["color"] = "#62c633"} -- green
	players[3] = {["color"] = "#2353ce"} -- blue
	players[4] = {["color"] = "#000000"} -- black
	players[5] = {["color"] = "#d61006"} -- red
	players[6] = {["color"] = "#f2ee21"} -- yellow
	players[7] = {["color"] = "#20f1e7"} -- cyan
	players[8] = {["color"] = "#f01fdf"} -- pink

	initSettings()

	rectangles = {}

	local y = 15
	for i = 1, playersCount do
		local num = math.random(1, #players)
		rectangles[i] = Rectangle:create(100, y, 50, 50, players[num].color, players[num].key)
		y = y + 70
		table.remove(players, num)
	end

end


function getRgb(hex)
    hex = hex:gsub("#","")
    return {["red"] = tonumber("0x"..hex:sub(1,2)), ["green"] = tonumber("0x"..hex:sub(3,4)), ["blue"] = tonumber("0x"..hex:sub(5,6))}
end


function love.draw()
	love.graphics.setBackgroundColor(backgroundColor.red, backgroundColor.green, backgroundColor.blue)
	for i = 1, playersCount do
		rectangles[i]:draw()
	end
end