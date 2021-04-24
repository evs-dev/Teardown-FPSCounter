#include "keys.lua"

local updateFreqSlider = getUpdateFrequency() * 100
local numDecimalFiguresSlider = getNumDecimalFigures() * 40

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
  UiRect(200, 5)
  UiPush()
   UiTranslate(-100, 0)
   updateFreqSlider, done = UiSlider("ui/common/dot.png", "x", updateFreqSlider, 0, 200)
  UiPop()
  local updateFrequency = roundToNearest(updateFreqSlider / 100, 0.1)
  if done then
   SetFloat(KEY_UPDATE_FREQUENCY, updateFrequency)
  end
  UiPush()
   UiTranslate(0, -22)
   UiText(updateFrequency.." seconds")
  UiPop()
 UiPop()

 -- Show prefix
 UiTranslate(0, 40)
 UiText("Show \"FPS\" Prefix")
 UiTranslate(0, 22)
 UiPush()
  UiButtonImageBox()
  local showPrefix = getShowPrefix()
  if UiTextButton(showPrefix and "Enabled" or "Disabled") then
   SetBool(KEY_SHOW_PREFIX, not showPrefix)
  end
 UiPop()

 -- Number of decimal figures
 UiTranslate(0, 40)
 UiPush()
  UiRect(200, 5)
  UiPush()
   UiTranslate(-100, 0)
   numDecimalFiguresSlider, done = UiSlider("ui/common/dot.png", "x", numDecimalFiguresSlider, 0, 200)
  UiPop()
  local numDecimalFigures = roundToNearest(numDecimalFiguresSlider / 40, 1)
  if done then
   SetFloat(KEY_NUM_DECIMAL_FIGURES, numDecimalFigures)
  end
  UiPush()
   UiTranslate(0, -22)
   UiText(numDecimalFigures.." decimal figures")
  UiPop()
 UiPop()

 -- Close button
 UiTranslate(0, 100)
 if UiTextButton("Close", 200, 40) then
  Menu()
 end
end
