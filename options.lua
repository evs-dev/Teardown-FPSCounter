#include "keys.lua"
#include "util.lua"

local EXTRA_SPACE = 10

local verticalSize
local lastVerticalSize
local firstDraw = true
verticalSizeSmooth = 0

local showHideKeybindSlider
local distanceFromCornerSlider
local updateFreqSlider
local numDecimalFiguresSlider
local sizeSlider

function translate(x, y)
 UiTranslate(x, y)
 verticalSize = verticalSize + y
end

function init()
 showHideKeybindSlider = ALPHABET:find(getShowHideKeybind()) * 8 - 1
 distanceFromCornerSlider = getDistanceFromCorner() * 2
 updateFreqSlider = getUpdateFrequency() * 100
 numDecimalFiguresSlider = getNumDecimalFigures() * 40
 sizeSlider = getSize() * 2
end

function drawSlider(value, mapSliderValueFunc, formatLabelFunc, doneFunc)
 -- Translate down by the height of the current font ('I' would work instead of 'O')
 translate(0, select(2, UiGetTextSize("O")))
 UiRect(200, 5)
 UiPush()
  translate(-100, 0)
  local sliderValue, done = UiSlider("ui/common/dot.png", "x", value, 0, 200)
  local mappedValue = mapSliderValueFunc(sliderValue)
  translate(100, -22)
  local textWidth, textHeight = UiText(formatLabelFunc(mappedValue))
 UiPop()
 if done then doneFunc(mappedValue) end
 translate(0, textHeight + EXTRA_SPACE)
end

function drawCheckbox(checked, label, clickedFunc)
 local image = "ui/common/box-"..(checked and "solid-6.png" or "outline-6.png")
 local boxSize = 24
 local textWidth, textHeight = UiGetTextSize(label or "O")
 local width = textWidth + boxSize
 UiPush()
  UiAlign("left middle")
  translate(-width / 2, 0)
  UiButtonImageBox()
  if UiImageButton(image, boxSize, boxSize) then
   clickedFunc()
  end
  translate(boxSize, 0)
  UiText(label)
 UiPop()
 translate(0, textHeight + EXTRA_SPACE - 2)
end

function draw()
 -- Aligns all options so they are always centred
 -- Recalculates height every draw() call to account for not always visible elements
 -- The alignment is also smoothed
 if verticalSize ~= lastVerticalSize then
  SetValue("verticalSizeSmooth", verticalSize, "easeout", firstDraw and 0 or 0.2)
  firstDraw = false
 end
 lastVerticalSize = verticalSize
 verticalSize = 0

 UiTranslate(UiCenter(), UiMiddle() - verticalSizeSmooth / 2)
 UiAlign("center middle")

 -- Title
 UiFont("bold.ttf", 48)
 UiText("FPSCounter Options")

 UiFont("regular.ttf", 26)
 translate(0, 70)

 -- Show prefix
 drawCheckbox(
  getShowPrefix(),
  "Show \"FPS: \" Prefix",
  function()
   setShowPrefix(not getShowPrefix())
  end
 )

 -- High contrast colour
 drawCheckbox(
  getHighContrast(),
  "High Contrast Colour",
  function()
   setHighContrast(not getHighContrast())
  end
 )

 -- Enable show/hide keybind
 drawCheckbox(
  getEnableShowHideKeybind(),
  "Enable Show/Hide Keybind",
  function()
   setEnableShowHideKeybind(not getEnableShowHideKeybind())
  end
 )

 if getEnableShowHideKeybind() then
  drawSlider(
   showHideKeybindSlider,
   function(sliderValue)
    showHideKeybindSlider = sliderValue
    local index = sliderValue / 8 + 1
    return ALPHABET:sub(index, index)
   end,
   function(mappedValue)
    return "Show/Hide Keybind: "..mappedValue
   end,
   function(mappedValue)
    setShowHideKeybind(mappedValue)
   end
  )
 end

 -- Alignment
 UiPush()
  UiFont("bold.ttf", 26)
  UiText("Alignment")
 UiPop()
 translate(0, 24)
 local currentAlignment = getAlignment()
 UiPush()
  for i, alignment in ipairs({ "Top Left", "Bottom Left", "Top Right", "Bottom Right" }) do
   if i == 1 then translate(-100, 0) end
   if i == 3 then translate(200, -26 - EXTRA_SPACE) end
   -- Probably faster than an unnecessary modulo
   local isBottom = i == 2 or i == 4
   if isBottom then UiPush() end
   drawCheckbox(
    currentAlignment == alignment:lower(),
    alignment,
    function()
     setAlignment(alignment:lower())
    end
   )
   if isBottom then UiPop() end
  end
 UiPop()
 translate(0, 65 + EXTRA_SPACE)

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
   setDistanceFromCorner(mappedValue)
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
   setUpdateFrequency(mappedValue)
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
   return "Decimal Places: "..mappedValue
  end,
  function(mappedValue)
   setNumDecimalFigures(mappedValue)
  end
 )

 -- Size
 drawSlider(
  sizeSlider,
  function(sliderValue)
   sizeSlider = sliderValue
   return roundToNearest(sliderValue / 2, 1)
  end,
  function(mappedValue)
   return "Size: "..mappedValue
  end,
  function(mappedValue)
   setSize(mappedValue)
  end
 )

 -- Reset to default button
 translate(0, 20)
 UiButtonImageBox("ui/common/box-outline-6.png", 6, 6, 0.7, 0.2, 0.2)
 if UiTextButton("Reset to Default", 200, 40) then
  ClearKey("savegame.mod")
  updateKeys()
  init()
 end

 -- Close button
 translate(0, 45)
 UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
 if UiTextButton("Close", 200, 40) then
  Menu()
 end
end
