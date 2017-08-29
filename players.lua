require "rectangle"
require "utils"
require "timers"

Players = {}
Players.__index = Players

local players = {}
setmetatable(players, Players)

local speed = 20
local playerWinner = nil
local swapTimer

function Players:addPlayer(_color, _key)
   table.insert(players, {rectangle = Rectangle:create(50), color = getRgb(_color), key = _key})
   self:updateProportions(#players)
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


function makeTempColorsAndKeys(t)
   local colorsAndKeys = {}
   for _, v in pairs(t) do
      table.insert(colorsAndKeys, {color = getRgb(v.color), key = v.colorKey})
   end
   return colorsAndKeys
end

function colorsEquals(color1, color2)
   if color1.red == color2.red and color1.green == color2.green and color1.blue == color2.blue then
      return true
   else
      return false
   end
end

function Players:swap(colorsAndKeys)
   local tempColorsAndKeys = makeTempColorsAndKeys(colorsAndKeys)
   for i = 1, #players do
      local randNum = math.random(1, #tempColorsAndKeys)
      while #tempColorsAndKeys > 1 and colorsEquals(players[i].color, tempColorsAndKeys[randNum].color) do
         randNum = math.random(1, #tempColorsAndKeys)
      end
      players[i].color = tempColorsAndKeys[randNum].color
      players[i].key = tempColorsAndKeys[randNum].key
      table.remove(tempColorsAndKeys, randNum)
   end
end

function Players:startSwapping(minSwapTime, maxSwapTime, colorsAndKeys)
   local swapTime = math.random(minSwapTime, maxSwapTime)
   swapTimer = Timer:start("SwapRects", swapTime, false, function()
      players:swap(colorsAndKeys)
      swapTime = math.random(minSwapTime, maxSwapTime)
      swapTimer.duration = swapTime
   end)
end

function Players:stopSwapping()
   swapTimer:stop()
end

function Players:updateProportions(playersCount, prevWidth, prevHeight)
   local width, height = love.window.getMode()
   prevWidth = prevWidth or width
   prevHeight = prevHeight or height
   local side = math.max(width, height) * 0.0625
   local distance = (height / (playersCount + 1)) - side/2
   if playersCount > 1 then
      distance = math.min(distance, (height - distance * 2 - (side * playersCount)) / (playersCount - 1))
   end
   local y = distance
   for i = 1, #players do
      x =  width - (width * ((prevWidth - players[i].rectangle.x) / prevWidth))
      players[i].rectangle:setProportions(x, y, side, side)
      y = y + side + (height - distance * 2 - (side * playersCount)) / (playersCount - 1)
   end
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

return players