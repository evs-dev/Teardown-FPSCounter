#include "keys.lua"

local EXTRA_SPACE = 10

local updateFreqSlider = getUpdateFrequency() * 100
local numDecimalFiguresSlider = getNumDecimalFigures() * 40

function roundToNearest(x, d)
	d = d or 1
	return math.floor(x / d + 0.5) * d
end

function drawSlider(value, mapSliderValueFunc, formatLabelFunc, doneFunc)
 -- Translate down by the height of the current font ('I' would work instead of 'O')
 UiTranslate(0, select(2, UiGetTextSize("O")))
 UiRect(200, 5)
 UiPush()
  UiTranslate(-100, 0)
  local sliderValue, done = UiSlider("ui/common/dot.png", "x", value, 0, 200)
  local mappedValue = mapSliderValueFunc(sliderValue)
  UiTranslate(100, -22)
  local textWidth, textHeight = UiText(formatLabelFunc(mappedValue))
 UiPop()
 if done then doneFunc(mappedValue) end
 UiTranslate(0, textHeight + EXTRA_SPACE)
end

function drawCheckbox(checked, label, clickedFunc)
 local image = "ui/common/box-"..(checked and "solid-6.png" or "outline-6.png")
 local boxSize = 24
 local textWidth, textHeight = UiGetTextSize(label)
 local width = textWidth + boxSize
 UiPush()
  UiAlign("left middle")
  UiTranslate(-width / 2, 0)
  UiButtonImageBox()
  if UiImageButton(image, boxSize, boxSize) then
   clickedFunc()
  end
  UiTranslate(boxSize, 0)
  UiText(label)
 UiPop()
 UiTranslate(0, textHeight + EXTRA_SPACE)
end

function draw()
 UiTranslate(UiCenter(), 250)
 UiAlign("center middle")

 -- Title
 UiFont("bold.ttf", 48)
 UiText("FPSCounter Options")

 UiFont("regular.ttf", 26)
 UiTranslate(0, 70)

 -- Show prefix
 drawCheckbox(
  getShowPrefix(),
  "Show \"FPS: \" Prefix",
  function()
   SetBool(KEY_SHOW_PREFIX, not getShowPrefix())
  end
 )

 -- Update frequency
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

 -- Number of decimal figures
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
 UiTranslate(0, 20)
 UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
 if UiTextButton("Close", 200, 40) then
  Menu()
 end
end
