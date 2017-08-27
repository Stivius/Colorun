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
		 		section = tempSection:sub(1,1):lower() .. tempSection:sub(2)
		 		data[section] = {}
		 		data[section]["_size"] = 0
		 	elseif key ~= nil and value ~= nil then
		 		key = key:sub(1,1):lower() .. key:sub(2)
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

function saveSettings(filename)
	love.filesystem.remove(filename)
	local file = love.filesystem.newFile(filename)
	file:open("a")
	for section, values in pairs(data) do
		section = section:sub(1,1):upper() .. section:sub(2)
		file:write("[" .. section .. "]" .. "\n")
		for key, value in pairs(values) do
			if key:byte(1) ~= string.byte("_") then
				key = key:sub(1,1):upper() .. key:sub(2)
				file:write(key .. " = " .. value .. "\n")
			end
		end
		file:write("\n")
	end
end