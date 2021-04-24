#include "keys.lua"

local UPDATE_FREQUENCY -- seconds
local PREFIX
local fps = 0
local timeSinceLastUpdate = 0

function init()
 UPDATE_FREQUENCY = getUpdateFrequency()
 PREFIX = getShowPrefix() and "FPS: " or ""
end

function tick(dt)
 if timeSinceLastUpdate < UPDATE_FREQUENCY and fps > 0 then
  timeSinceLastUpdate = timeSinceLastUpdate + dt
 else
  fps = 1 / dt
  timeSinceLastUpdate = 0
 end
end

function draw()
 UiTranslate(100, 100)
 UiFont("regular.ttf", 26)
 UiText(PREFIX..fps)
end
