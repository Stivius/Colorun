data = {}
function initSettings()
	local lines = {"PlayersCount1", "Countdown = 5"}
	data["general"] = {}
	for i = 1, #lines do
	 	local key = string.match(lines[i], "([%a%d]+)")
	 	print(key:len(), key)
	 	data["general"][key] = 1
	end
end
initSettings()
for k,v in pairs(data.general) do
	print(k,v)
	print(data.general["PlayersCount1"])
end