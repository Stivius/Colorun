require "rectangle"
require "color"

Players = {}
Players.__index = Players

local players = {}
setmetatable(players, Players)

local y = 15

function Players:addPlayer(color)
   table.insert(players, {["rectangle"] = Rectangle:create(100, y, 50, 50, color.rgb, color.key)})
   y = y + 70
end

function Players:keypressed(key, scancode, isrepeat)
   for i =1 , #players do
      if key == players[i].rectangle.key then 
         players[i].rectangle:move()
      end
   end
end

function Players:draw()
   for i = 1, #players do
      players[i].rectangle:draw(i)
   end
end

function shufflePlayersColors(players)
   local params = {unpack(players)}
   local shuffledPlayers = {}
   while #params > 0 do
      local num = math.random(1, #params)
      table.insert(shuffledPlayers, {["color"] = params[num].rectangle.color, ["key"] = params[num].rectangle.key})
      table.remove(params, num)
   end
   return shuffledPlayers
end

function Players:swap()
   print("swapped")
   local shuffledColors = shufflePlayersColors(players)
   for i = 1, #players do
      players[i].rectangle.color = shuffledColors[i].color
      players[i].rectangle.key = shuffledColors[i].key
   end
end

return players