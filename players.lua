require "rectangle"
require "color"

Players = {}
Players.__index = Players

local players = {}
setmetatable(players, Players)

local y = 15


function Players:addPlayer(playerNum, color)
   players[playerNum] = {["rectangle"] = Rectangle:create(100, y, 50, 50, color.rgb, color.key)}
   y = y + 70
end

function Players:keypressed(key, scancode, isrepeat)
   for i =1, #players do
      if key == players[i].rectangle.key then 
         players[i].rectangle:move()
      end
   end
end

function Players:draw()
   for i =1, #players do
      players[i].rectangle:draw()
   end
end

return players