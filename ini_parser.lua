data = {}

function initSettings()
	if love.filesystem.exists("settings.ini") then
		local section
		for line in love.filesystem.lines("settings.ini") do
		 	local key, value = line:match("([%a%d]+)%s*=%s*([%a%d%p]+)")
		 	local tempSection = line:match("[[](.+)[]]")

		 	if tempSection ~= nil then
		 		section = tempSection:sub(1,1):lower()..tempSection:sub(2)
		 		data[section] = {}
		 		data[section]["_size"] = 0
		 	elseif key ~= nil and value ~= nil then
		 		key = key:sub(1,1):lower()..key:sub(2)
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