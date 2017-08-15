Timers = {}
Timers.__index = Timers

local timers = {}
setmetatable(timers, Timers)

function Timers:addTimer(name, duration, isSingleShot, callback)
   timers[name] = {["duration"] = duration, ["isSingleShot"] = isSingleShot, ["callback"] = callback, ["passed"] = 0}
end

function Timers:removeTimer(name)
   timers[name] = nil
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