#include "keys.lua"

local UPDATE_FREQUENCY
local PREFIX
local NUM_DECIMAL_FIGURES
local DISTANCE_FROM_CORNER
local ALIGNMENT
local ALIGNMENT_IS_RIGHT
local ALIGNMENT_IS_BOTTOM
local HIGH_CONTRAST

local fps = 0
local timeSinceLastUpdate = 0

function roundToDecimalFigures(x, d)
 local mult = 10^(d or 0)
 return math.floor(x * mult + 0.5) / mult
end

function init()
 UPDATE_FREQUENCY = getUpdateFrequency()
 PREFIX = getShowPrefix() and "FPS: " or ""
 NUM_DECIMAL_FIGURES = getNumDecimalFigures()
 DISTANCE_FROM_CORNER = getDistanceFromCorner()
 ALIGNMENT = getAlignment()
 ALIGNMENT_IS_RIGHT = ALIGNMENT:find("right") ~= nil
 ALIGNMENT_IS_BOTTOM = ALIGNMENT:find("bottom") ~= nil
 HIGH_CONTRAST = getHighContrast()
 -- Force FPS to be updated instantly rather than starting at 0
 timeSinceLastUpdate = UPDATE_FREQUENCY
end

function tick(dt)
 if timeSinceLastUpdate < UPDATE_FREQUENCY then
  timeSinceLastUpdate = timeSinceLastUpdate + dt
 else
  fps = roundToDecimalFigures(1 / dt, NUM_DECIMAL_FIGURES)
  timeSinceLastUpdate = 0
 end
end

function draw()
 UiAlign(ALIGNMENT)
 UiTranslate(
  ALIGNMENT_IS_RIGHT and UiWidth() - DISTANCE_FROM_CORNER or DISTANCE_FROM_CORNER,
  ALIGNMENT_IS_BOTTOM and UiHeight() - DISTANCE_FROM_CORNER or DISTANCE_FROM_CORNER
 )
 UiFont("regular.ttf", 26)
 if HIGH_CONTRAST then
  UiColor(0, 1, 0)
 end
 UiText(PREFIX..fps)
end
