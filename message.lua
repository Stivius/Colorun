local timers = require "timers"

Message = {}
Message.__index = Message

local textFont = love.graphics.newFont(22)

function Message:create(text, x, y, width, height)
	local message = {}
	setmetatable(message, Message)
   	message.text = love.graphics.newText(textFont, text)
	message.x = x
	message.y = y
	message.width = width
	message.height = height

	return message
end

function Message:setText(text)
   self.text:set(text)
end

function Message:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
   	love.graphics.setColor(255, 255, 255)
   	love.graphics.draw(self.text, self.x + ((self.width - self.text:getWidth())/2), self.y + ((self.height - self.text:getHeight())/2))
end