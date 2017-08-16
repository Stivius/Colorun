require "rectangle"
require "color"

Players = {}
Players.__index = Players

local players = {}
setmetatable(players, Players)

local y = 15
local finishLineCoords
local playerWinner = nil

function Players:addPlayer(color)
   table.insert(players, {["rectangle"] = Rectangle:create(100, y, 50, 50, color.rgb, color.key)})
   y = y + 70
end

function Players:reset()
   for i = 1, #players do
      players[i].rectangle.x = 100
   end
   playerWinner = nil
end

function Players:setFinishLine(coords)
   finishLineCoords = {["x1"] = coords[1], ["y1"] = coords[2], ["x2"] = coords[3], ["y2"] = coords[4]}
end

function Players:keypressed(key, scancode, isrepeat)
   for i = 1, #players do
      if key == players[i].rectangle.key then 
         players[i].rectangle:move(i)
         if players[i].rectangle:intersect(finishLineCoords) then
            playerWinner = i
         end
      end
   end
end

function Players:winner()
   return playerWinner
end

function Players:draw()
   for i = 1, #players do
      players[i].rectangle:draw(i)
   end
end

function Players:swap()
   local shuffledColors = shufflePlayersColors(players)
   for i = 1, #players do
      players[i].rectangle.color = shuffledColors[i].color
      players[i].rectangle.key = shuffledColors[i].key
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

return players