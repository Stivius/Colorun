require "rectangle"
require "utils"
require "timers"

Players = {}
Players.__index = Players

local players = {}
setmetatable(players, Players)

local speed = 20
local playerWinner = nil
local minSwapTime, maxSwapTime, swapTimer

function Players:addPlayer(_color, _key)
   table.insert(players, {rectangle = Rectangle:create(50), color = getRgb(_color), key = _key})
   self:update(#players)
end

function Players:update(playersCount, prevWidth, prevHeight)
   width, height = love.window.getMode()
   prevWidth = prevWidth or width
   prevHeight = prevHeight or height
   side = math.max(width, height) * 0.0625
   distance = ((height - (side * playersCount)) / playersCount)
   y = distance
   for i = 1, #players do
      x =  width - (width * ((prevWidth - players[i].rectangle.x) / prevWidth))
      players[i].rectangle:setProportions(x, y, side, side)
      y = y + side + (((height - distance) - (side * playersCount)) / playersCount)
   end
end

function Players:winner()
   return playerWinner
end

function Players:reset()
   for k, _ in ipairs(players) do
      players[k] = nil
   end
   playerWinner = nil
end

function Players:keypressed(key, scancode, isrepeat)
   for i = 1, #players do
      if key == players[i].key then 
         players[i].rectangle:moveHorizontally(speed)
      end
   end
end

function Players:intersectFinishLine(lineCoords)
   for i = 1, #players do
      if players[i].rectangle:intersectLine(lineCoords) then
         playerWinner = i
         return true
      end
   end
   return false
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
      local numberToDraw = love.graphics.newText(love.graphics.newFont(rect.width * 0.4), i)
      love.graphics.draw(numberToDraw, rect.x + ((rect.width - numberToDraw:getWidth())/2), rect.y + ((rect.height - numberToDraw:getHeight())/2))
   end
end

local function shuffleColorsAndKeys(players)
   local tempPlayers = {unpack(players)}
   local shuffled = {}
   while #tempPlayers > 0 do
      local randPlayer = math.random(1, #tempPlayers)
      table.insert(shuffled, {color = tempPlayers[randPlayer].color, key = tempPlayers[randPlayer].key})
      table.remove(tempPlayers, randPlayer)
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

function Players:setSwappingTimeRange(minTime , maxTime)
   minSwapTime, maxSwapTime = minTime, maxTime
end

return players