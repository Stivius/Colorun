require "rectangle"
require "utils"
require "timers"

Players = {}
Players.__index = Players

local players = {}
setmetatable(players, Players)

local y = 15
local finishLineCoords
local playerWinner = nil
local speed = 20
local minSwapTime, maxSwapTime
local swapTimer

function Players:addPlayer(color, key)
   table.insert(players, {["rectangle"] = Rectangle:create(50, y, 50, 50), ["color"] = getRgb(color), ["key"] = key})
   y = y + 70
end

function Players:reset()
   for i = 1, #players do
      players[i].rectangle.x = 50
   end
   playerWinner = nil
end

function Players:keypressed(key, scancode, isrepeat)
   for i = 1, #players do
      if key == players[i].key then 
         players[i].rectangle:moveHorizontally(speed)
         if players[i].rectangle:intersectLine(finishLineCoords) then
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
      local rect = players[i].rectangle
      local color = players[i].color
      rect:draw(color)
      if color.red > 128 and color.green > 128 and color.blue > 128 then
         love.graphics.setColor(0, 0, 0)
      else
         love.graphics.setColor(255, 255, 255)
      end
      local numberToDraw = love.graphics.newText(love.graphics.newFont(20), i)
      love.graphics.draw(numberToDraw, rect.x + ((rect.width - numberToDraw:getWidth())/2), rect.y + ((rect.height - numberToDraw:getHeight())/2))
   end
end

local function shuffleColorsAndKeys(players)
   local tempPlayers = {unpack(players)}
   local shuffled = {}
   while #tempPlayers > 0 do
      local num = math.random(1, #tempPlayers)
      table.insert(shuffled, {["color"] = tempPlayers[num].color, ["key"] = tempPlayers[num].key})
      table.remove(tempPlayers, num)
   end
   return shuffled
end

function Players:swap()
   local shuffled = shuffleColorsAndKeys(players)
   for i = 1, #players do
      players[i].color = shuffled[i].color
      players[i].key = shuffled[i].key
   end
end

function Players:startSwapping()
   local swapTime = math.random(minSwapTime, maxSwapTime)
   swapTimer = Timer:start("SwapRects", swapTime, false, function()
      players:swap()
      swapTime = math.random(minSwapTime, maxSwapTime)
      swapTimer.duration = swapTime
   end)
end

function Players:stopSwapping()
   swapTimer:stop()
end

function Players:setFinishLine(coords)
   finishLineCoords = {["x1"] = coords[1], ["y1"] = coords[2], ["x2"] = coords[3], ["y2"] = coords[4]}
end

function Players:setSwappingTimeRange(minTime , maxTime)
   minSwapTime, maxSwapTime = minTime, maxTime
end

return players