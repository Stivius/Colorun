require "color"

Rectangle = {}
Rectangle.__index = Rectangle

local numberFont = love.graphics.newFont(20)
local text = love.graphics.newText(numberFont)

function Rectangle:create(x, y, width, height, rgb, key)
	local rect = {}
   	setmetatable(rect, Rectangle)
   	rect.x = x
   	rect.y = y
   	rect.width = width
   	rect.height = height
   	rect.color = rgb
   	rect.key = key
   	rect.speed = 20

   	return rect
end

function Rectangle:draw(number)
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
   if self.color.red > 128 and self.color.green > 128 and self.color.blue > 128 then
      love.graphics.setColor(0, 0, 0)
   else
      love.graphics.setColor(255, 255, 255)
   end
   text:set(number)
   love.graphics.draw(text, self.x + ((self.width - text:getWidth())/2), self.y + ((self.height - text:getHeight())/2))
end

function Rectangle:move(number)
	self.x = self.x + self.speed
end

function Rectangle:intersect(finishLineCoords)
   if self.x + self.width > finishLineCoords.x1 then
      return true
   end
   return false
end