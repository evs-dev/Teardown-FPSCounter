#include "keys.lua"

local EXTRA_SPACE = 10

local distanceFromCornerSlider
local updateFreqSlider
local numDecimalFiguresSlider

function init()
 distanceFromCornerSlider = getDistanceFromCorner() * 2
 updateFreqSlider = getUpdateFrequency() * 100
 numDecimalFiguresSlider = getNumDecimalFigures() * 40
end

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
 local textWidth, textHeight = UiGetTextSize(label or "O")
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

 -- High contrast colour
 drawCheckbox(
  getHighContrast(),
  "High Contrast Colour",
  function()
   SetBool(KEY_HIGH_CONTRAST, not getHighContrast())
  end
 )

 -- Alignment
 UiPush()
  UiFont("bold.ttf", 26)
  UiText("Alignment")
 UiPop()
 UiTranslate(0, 24)
 local currentAlignment = getAlignment()
 UiPush()
  for i, alignment in ipairs({ "Top Left", "Bottom Left", "Top Right", "Bottom Right" }) do
   if i == 1 then UiTranslate(-100, 0) end
   if i == 3 then UiTranslate(200, -26 - EXTRA_SPACE) end
   if i == 2 or i == 4 then UiPush() end
   drawCheckbox(
    currentAlignment == alignment:lower(),
    alignment,
    function()
     SetString(KEY_ALIGNMENT, alignment:lower())
    end
   )
   if i == 2 or i == 4 then UiPop() end
  end
 UiPop()
 UiTranslate(0, 65 + EXTRA_SPACE)

 -- Distance from corner
 drawSlider(
  distanceFromCornerSlider,
  function(sliderValue)
   distanceFromCornerSlider = sliderValue
   return roundToNearest(sliderValue / 2, 1)
  end,
  function(mappedValue)
   return "Distance From Corner: "..mappedValue
  end,
  function(mappedValue)
   SetInt(KEY_DISTANCE_FROM_CORNER, mappedValue)
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
   return "Update Frequency: "..mappedValue.." seconds"
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

 -- Reset to default button
 UiTranslate(0, 20)
 UiButtonImageBox("ui/common/box-outline-6.png", 6, 6, 0.7, 0.2, 0.2)
 if UiTextButton("Reset to Default", 200, 40) then
  ClearKey("savegame.mod")
  init()
 end

 -- Close button
 UiTranslate(0, 45)
 UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
 if UiTextButton("Close", 200, 40) then
  Menu()
 end
end
