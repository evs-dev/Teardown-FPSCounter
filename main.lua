local UPDATE_FREQUENCY -- seconds
local fps = 0
local timeSinceLastUpdate = 0

function init()
 if not HasKey("savegame.mod.updateFrequency") then
  SetFloat("savegame.mod.updateFrequency", 0.2)
 end
 UPDATE_FREQUENCY = GetFloat("savegame.mod.updateFrequency")
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
 UiText("FPS: "..fps)
end
