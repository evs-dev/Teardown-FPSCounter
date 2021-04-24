#include "keys.lua"

local updateFreqSlider = getUpdateFrequency() * 100
local numDecimalFiguresSlider = getNumDecimalFigures() * 40

function roundToNearest(x, d)
	d = d or 1
	return math.floor(x / d + 0.5) * d
end

function drawSlider(value, mapSliderValueFunc, formatLabelFunc, doneFunc)
 UiRect(200, 5)
 UiPush()
  UiTranslate(-100, 0)
  local sliderValue, done = UiSlider("ui/common/dot.png", "x", value, 0, 200)
 UiPop()
 local mappedValue = mapSliderValueFunc(sliderValue)
 UiPush()
  UiTranslate(0, -22)
  UiText(formatLabelFunc(mappedValue))
 UiPop()
 if done then doneFunc(mappedValue) return end
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
 drawSlider(
  updateFreqSlider,
  function(sliderValue)
   updateFreqSlider = sliderValue
   return roundToNearest(sliderValue / 100, 0.1)
  end,
  function(mappedValue)
   return mappedValue.." seconds"
  end,
  function(mappedValue)
   SetFloat(KEY_UPDATE_FREQUENCY, mappedValue)
  end
 )

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
 drawSlider(
  numDecimalFiguresSlider,
  function(sliderValue)
   numDecimalFiguresSlider = sliderValue
   return roundToNearest(sliderValue / 40, 1)
  end,
  function(mappedValue)
   return mappedValue.." decimal figures"
  end,
  function(mappedValue)
   SetInt(KEY_NUM_DECIMAL_FIGURES, mappedValue)
  end
 )

 -- Close button
 UiTranslate(0, 100)
 if UiTextButton("Close", 200, 40) then
  Menu()
 end
end
