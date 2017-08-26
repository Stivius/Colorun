require "rectangle"
require "utils"
require "timers"

Players = {}
Players.__index = Players

local players = {}
setmetatable(players, Players)

local playerWinner = nil
local minSwapTime, maxSwapTime
local swapTimer

function Players:addPlayer(_color, _key)
   table.insert(players, {rectangle = Rectangle:create(50), color = getRgb(_color), key = _key})
   self:update()
end

function Players:update(dt)
   width, height = love.window.getMode()
   side = math.max(width, height) * 0.0625
   distance = ((height - (side * 4)) / 4) -- FIXME: magic number
   speed = side * 0.4
   y = distance
   for i = 1, #players do
      players[i].rectangle:setSize(y, side, side) -- FIXME: add changing for x
      y = y + side + (((height - distance) - (side * 4)) / 4)
   end
end

function Players:winner()
   return playerWinner
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
      local numberToDraw = love.graphics.newText(love.graphics.newFont(20), i)
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