data = {}

function loadSettings(filename)
	local file = love.filesystem.newFile(filename)
	if love.filesystem.exists(filename) then
		file:open("r")
		local section
		for line in file:lines() do
		 	local key, value = line:match("([%a%d]+)%s*=%s*([%a%d%p]+)")
		 	local tempSection = line:match("[[](.+)[]]")

		 	if tempSection ~= nil then
		 		section = tempSection:gsub("^(%u)(.+)", function(l, w) return l:lower() .. w end)
		 		data[section] = {}
		 		data[section]["_size"] = 0
		 	elseif key ~= nil and value ~= nil then
		 		key = key:gsub("^(%u)(.+)", function(l, w) return l:lower() .. w end)
		 		convertedValue = tonumber(value)
		 		if convertedValue ~= nil then
		 			data[section][key] = convertedValue
		 		else
		 			data[section][key] = value
		 		end
		 		data[section]["_size"] = data[section]["_size"] + 1
		 	end
		end
	end
end

function createSettings(filename)
	local file = love.filesystem.newFile(filename)
	file:open("a")
	local defaultSettings = [[
[General]
Countdown = 5
MinSwapTime = 1
MaxSwapTime = 5
AudioFile = music.mp3
PlayersCount = 8
RestartTime = 5

[ColorKeys]
ColorKey2 = g
ColorKey7 = n
ColorKey4 = k
ColorKey1 = w
ColorKey6 = y
ColorKey3 = b
ColorKey8 = i
ColorKey5 = r

[Colors]
Color7 = #20f1e7
Color2 = #62c633
Color1 = #ffffff
Color4 = #000000
Color3 = #2353ce
Color6 = #f2ee21
Color5 = #d61006
Color8 = #f01fdf
]]
	file:write(defaultSettings)
end

function saveSettings(filename)
	love.filesystem.remove(filename)
	local file = love.filesystem.newFile(filename)
	file:open("a")
	for section, values in pairs(data) do
		section = section:gsub("^(%u)(.+)", function(l, w) return l:upper() .. w end)
		file:write("[" .. section .. "]" .. "\n")
		for key, value in pairs(values) do
			if key:byte(1) ~= string.byte("_") then
				key = key:gsub("^(%u)(.+)", function(l, w) return l:upper() .. w end)
				file:write(key .. " = " .. value .. "\n")
			end
		end
		file:write("\n")
	end
end