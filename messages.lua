require "timers"
require "rectangle"

Messages = {}
Messages.__index = Messages
Message = {}
Message.__index = Message

local messages = {}
setmetatable(messages, Messages)

idCount = 0

function Message:show(text, fontSize, x, y, width, height, textColor, backgroundColor, hideInterval)
   	local newMessage = {}
   	setmetatable(newMessage, Message)

	newMessage.id = idCount
   	newMessage.text = love.graphics.newText(love.graphics.newFont(fontSize), text)
   	newMessage.textColor = textColor
	if backgroundColor then
		newMessage.backgroundColor = backgroundColor
	end
	newMessage.background = Rectangle:create(x, y, width, height)

	if hideInterval then
		newMessage.timer = Timer:start("Autohide" .. newMessage.id, hideInterval, true, function ()
			newMessage.timer:stop()
			messages[newMessage.id] = nil 
		end)
	end

	messages[newMessage.id] = newMessage 
	idCount = idCount + 1

	return newMessage
end

function Message:setText(text)
	self.text:set(text)
end

function Message:hide()
   	messages[self.id] = nil
end

function Messages:draw()
	for id, message in pairs(messages) do
		local back = message.background
		local text = message.text
		if message.backgroundColor then
			back:draw(message.backgroundColor)
		end
		love.graphics.setColor(message.textColor.red, message.textColor.blue, message.textColor.red)
      	love.graphics.draw(text, back.x + ((back.width - text:getWidth())/2), back.y + ((back.height - text:getHeight())/2))
	end
end

return messages