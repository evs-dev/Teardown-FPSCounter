local UPDATE_FREQUENCY = 0.5 -- seconds
local fps = 0
local timeSinceLastUpdate = 0

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
 UiText("FPS: "..fps)
end
