function getRgb(hex)
    hex = hex:gsub("#","")
    return {["red"] = tonumber("0x"..hex:sub(1,2)), ["green"] = tonumber("0x"..hex:sub(3,4)), ["blue"] = tonumber("0x"..hex:sub(5,6))}
end