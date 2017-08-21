Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:create(x, y, width, height)
	local rect = {}
	setmetatable(rect, Rectangle)
	rect.x = x
	rect.y = y
	rect.width = width
	rect.height = height

	return rect
end

function Rectangle:draw(color)
	love.graphics.setColor(color.red, color.green, color.blue)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
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