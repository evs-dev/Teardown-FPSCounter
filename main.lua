local fps

function tick(dt)
 fps = 1 / dt
end

function draw()
 UiTranslate(100, 100)
 UiFont("regular.ttf", 26)
 UiText("FPS: "..fps)
end
