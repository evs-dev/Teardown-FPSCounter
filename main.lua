#include "keys.lua"

local UPDATE_FREQUENCY
local PREFIX
local NUM_DECIMAL_FIGURES
local OFFSET = 100
local ALIGNMENT_IS_RIGHT
local ALIGNMENT_IS_BOTTOM

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
 local alignment = getAlignment()
 ALIGNMENT_IS_RIGHT = alignment:find("right") ~= nil
 ALIGNMENT_IS_BOTTOM = alignment:find("bottom") ~= nil
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
 if ALIGNMENT_IS_RIGHT then UiAlign("right middle") end
 UiTranslate(
  ALIGNMENT_IS_RIGHT and UiWidth() - OFFSET or OFFSET,
  ALIGNMENT_IS_BOTTOM and UiHeight() - OFFSET or OFFSET
 )
 UiFont("regular.ttf", 26)
 UiText(PREFIX..fps)
end
