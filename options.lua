local updateFreqSlider = 0

function roundToNearest(x, d)
	d = d or 1
	return math.floor(x / d + 0.5) * d
end

function draw()
 UiTranslate(UiCenter(), 250)
 UiAlign("center middle")

 -- Title
 UiFont("bold.ttf", 48)
 UiText("FPSCounter Options")

 UiFont("regular.ttf", 26)
 UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)

 -- Update frequency
 UiTranslate(0, 100)
 UiPush()
  if not HasKey("savegame.mod.updateFrequency") then
   SetFloat("savegame.mod.updateFrequency", 0.5)
  end
  UiRect(200, 5)
  UiPush()
   UiTranslate(-100, 0)
   updateFreqSlider, done = UiSlider("ui/common/dot.png", "x", updateFreqSlider, 0, 200)
  UiPop()
  local updateFrequency = roundToNearest(updateFreqSlider / 100, 0.1)
  if done then
   SetFloat("savegame.mod.updateFrequency", updateFrequency)
  end
  UiPush()
   UiTranslate(0, -22)
   UiText(updateFrequency.." seconds")
  UiPop()
 UiPop()

 -- Close button
 UiTranslate(0, 100)
 if UiTextButton("Close", 200, 40) then
  Menu()
 end
end
