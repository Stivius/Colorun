Timers = {}
Timers.__index = Timers
Timer = {}
Timer.__index = Timer

local timers = {}
setmetatable(timers, Timers)

function Timer:start(name, duration, isSingleShot, callback)
   local newTimer = {}
   setmetatable(newTimer, Timer)
   newTimer.name = name
   newTimer.duration = duration
   newTimer.isSingleShot = isSingleShot
   newTimer.callback = callback
   newTimer.passed = 0
   timers[name] = newTimer
   return newTimer
end

function Timer:stop()
   timers[self.name] = nil
end

function Timers:update(dt)
	for name, timer in pairs(timers) do
      timer.passed = timer.passed + dt
      if timer.passed >= timer.duration then
         timer.passed = 0
         timer.callback()
         if timer.isSingleShot  then
            timers[name] = nil
         end
      end
   end
end

return timers