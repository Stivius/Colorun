require "color"

Rectangle = {}
Rectangle.__index = Rectangle

local numberFont = love.graphics.newFont(20)

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
   love.graphics.setFont(numberFont)
   love.graphics.print(number, self.x + (self.width / 3), self.y + (self.height / 3))
end

function Rectangle:move()
	self.x = self.x + self.speed
end