function draw()
 UiTranslate(UiCenter(), 250)
 UiAlign("center middle")

 -- Title
 UiFont("bold.ttf", 48)
 UiText("FPSCounter Options")

 -- Close button
 UiTranslate(0, 100)
 UiFont("regular.ttf", 26)
 UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
 if UiTextButton("Close", 200, 40) then
  Menu()
 end
end
