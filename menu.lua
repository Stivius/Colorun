require "rectangle"
require "utils"

Menu = {}
Menu.__index = Menu

local menu = {items = {}, isShown = false,  inEditing = false, currentItem = 1}

setmetatable(menu, Menu)

function Menu:addItem(item)
   local newItem = {}
   newItem.text = love.graphics.newText(love.graphics.newFont(25), item.text)
   newItem.actions = {clicked = item.actions.clicked, rightChosen = item.actions.rightChosen, leftChosen = item.actions.leftChosen}
   newItem.rectangle = Rectangle:create()
   newItem.inEditing = false
   table.insert(menu.items, newItem)
   self:updateProportions(#menu.items)
   return newItem
end

function Menu:keypressed(key, scancode, isrepeat)
   if menu.isShown then
      local item = menu.items[menu.currentItem]
      local itemActions = item.actions

      if key == "up" and not item.inEditing then
         menu.currentItem = menu.currentItem - 1 >= 1 and menu.currentItem - 1 or #menu.items
      elseif key == "down" and not item.inEditing then
         menu.currentItem = menu.currentItem + 1 <= #menu.items and menu.currentItem + 1 or 1
      elseif key == "right" and itemActions.rightChosen and item.inEditing then
         itemActions.rightChosen()
      elseif key == "left" and itemActions.leftChosen and item.inEditing then
         itemActions.leftChosen()
      elseif key == "a" and itemActions.clicked then
         itemActions.clicked()
         if menu.isShown then
            menu.items[menu.currentItem].inEditing = not menu.items[menu.currentItem].inEditing
            menu.inEditing = not menu.inEditing
         end
      end
   end
end

function Menu:show()
   if not menu.isShown then
      menu.isShown = true
   end
end

function Menu:hide()
   if menu.isShown then
      for i = 1, #menu.items do
         menu.items[i].inEditing = false
      end
      menu.isShown = false
      menu.isEditing = false
      menu.currentItem = 1
   end
end

function Menu:updateProportions(itemsCount)
   local width, height = love.window.getMode()
   local itemWidth = width * 0.25
   local itemHeight = height * 0.1
   local y = height / 2 - itemHeight
   for i = 1, #menu.items do
      menu.items[i].text:setFont(love.graphics.newFont(itemHeight * 0.5))
      menu.items[i].rectangle:setProportions((width - itemWidth) / 2, y, itemWidth, itemHeight)
      y = y + itemHeight + itemHeight * 0.5
   end
end

function Menu:draw()
   if menu.isShown then
      for i = 1, #menu.items do
         local rect = menu.items[i].rectangle
         local text = menu.items[i].text
         if menu.currentItem ~= i then
            rect:draw({red = 0, green = 0, blue = 0})
         elseif menu.currentItem == i and not menu.items[i].inEditing then
            rect:draw({red = 128, green = 128, blue = 128})
         elseif menu.currentItem == i and menu.items[i].inEditing then
            rect:draw({red = 50, green = 150, blue = 250})
         end
         love.graphics.setColor(255, 255, 255)
         love.graphics.draw(text, rect.x + ((rect.width - text:getWidth())/2), rect.y + ((rect.height - text:getHeight())/2))
      end
   end
end

return menu