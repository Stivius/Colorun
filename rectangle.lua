Rectangle = {}
Rectangle.__index = Rectangle

local textToDraw = love.graphics.newText(love.graphics.newFont(20))

function Rectangle:create(x, y, width, height)
	local rect = {}
	setmetatable(rect, Rectangle)
	rect.x = x
	rect.y = y
	rect.width = width
	rect.height = height

	return rect
end

function Rectangle:draw(text, color)
	love.graphics.setColor(color.red, color.green, color.blue)
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
   if color.red > 128 and color.green > 128 and color.blue > 128 then
      love.graphics.setColor(0, 0, 0)
   else
      love.graphics.setColor(255, 255, 255)
   end
   textToDraw:set(text)
   love.graphics.draw(textToDraw, self.x + ((self.width - textToDraw:getWidth())/2), self.y + ((self.height - textToDraw:getHeight())/2))
end

function Rectangle:intersectLine(lineCoords)
   local xPos = self.x + self.width
   if xPos > lineCoords.x1 or xPos > lineCoords.x2 then
      return true
   else
      return false
   end
end

function Rectangle:moveHorizontally(xAmount)
   self.x = self.x + xAmount
end