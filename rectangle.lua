require "color"

Rectangle = {}
Rectangle.__index = Rectangle

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

function Rectangle:draw()
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Rectangle:move()
	self.x = self.x + self.speed
end