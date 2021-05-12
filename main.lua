#include "keys.lua"
#include "util.lua"

local PREFIX
local HIGH_CONTRAST
local ENABLE_SHOW_HIDE_KEYBIND
local SHOW_HIDE_KEYBIND
local ALIGNMENT
local ALIGNMENT_IS_RIGHT
local ALIGNMENT_IS_BOTTOM
local DISTANCE_FROM_CORNER
local UPDATE_FREQUENCY
local NUM_DECIMAL_FIGURES
local SIZE

local fps = 0
local timeSinceLastUpdate = 0
local initted = false
visible = true

function init()
 PREFIX = getShowPrefix() and "FPS: " or ""
 HIGH_CONTRAST = getHighContrast()
 ENABLE_SHOW_HIDE_KEYBIND = getEnableShowHideKeybind()
 SHOW_HIDE_KEYBIND = getShowHideKeybind()

 ALIGNMENT = getAlignment()
 ALIGNMENT_IS_RIGHT = ALIGNMENT:find("right") ~= nil
 ALIGNMENT_IS_BOTTOM = ALIGNMENT:find("bottom") ~= nil

 DISTANCE_FROM_CORNER = getDistanceFromCorner()
 UPDATE_FREQUENCY = getUpdateFrequency()
 NUM_DECIMAL_FIGURES = getNumDecimalFigures()
 SIZE = getSize()

 initted = true
 -- Force FPS to be updated instantly rather than starting at 0
 timeSinceLastUpdate = UPDATE_FREQUENCY
end

function tick(dt)
 -- Quick Load doesn't run init(), so do it here to avoid nil errors
 if not initted then
  init()
 end

 if timeSinceLastUpdate < UPDATE_FREQUENCY then
  timeSinceLastUpdate = timeSinceLastUpdate + dt
 elseif visible then
  fps = roundToDecimalFigures(1 / dt, NUM_DECIMAL_FIGURES)
  timeSinceLastUpdate = 0
 end

 if ENABLE_SHOW_HIDE_KEYBIND and InputPressed(SHOW_HIDE_KEYBIND) then
  visible = not visible
 end
end

function draw()
 if not visible then return end
 UiAlign(ALIGNMENT)
 UiTranslate(
  ALIGNMENT_IS_RIGHT and UiWidth() - DISTANCE_FROM_CORNER or DISTANCE_FROM_CORNER,
  ALIGNMENT_IS_BOTTOM and UiHeight() - DISTANCE_FROM_CORNER or DISTANCE_FROM_CORNER
 )
 UiFont("regular.ttf", SIZE)
 if HIGH_CONTRAST then
  UiColor(0, 1, 0)
 end
 UiText(PREFIX..fps)
end
