#include "util.lua"

function updateKeys()
 getShowPrefix, setShowPrefix = key("showPrefix", true)
 getHighContrast, setHighContrast = key("highContrast", false)
 getEnableShowHideKeybind, setEnableShowHideKeybind = key("enableShowHideKeybind", false)
 getShowHideKeybind, setShowHideKeybind = key("showHideKeybind", "H", string.upper)
 getAlignment, setAlignment = key("alignment", "top left")
 getDistanceFromCorner, setDistanceFromCorner = key("distanceFromCorner", 10, 0, 100)
 getUpdateFrequency, setUpdateFrequency = key("updateFrequency", 0.2, 0, 2)
 getNumDecimalFigures, setNumDecimalFigures = key("numDecimalFigures", 0, 0, 5)
 getSize, setSize = key("size", 26, 0, 100)
end

function key(registerName, defaultValue, ...)
 local keyType = type(defaultValue)
 local args = {...}
 local getFunc, setFunc
 registerName = "savegame.mod."..registerName

 if keyType == "number" then
  getFunc = function()
   return GetFloat(registerName)
  end
  setFunc = function(value)
   SetFloat(registerName, clamp(value, args[1], args[2]))
  end
 elseif keyType == "string" then
  getFunc = function()
   return GetString(registerName)
  end
  setFunc = function(value)
   SetString(registerName, args[1] and args[1](value) or value)
  end
 elseif keyType == "boolean" then
  getFunc = function()
   return GetBool(registerName)
  end
  setFunc = function(value)
   SetBool(registerName, value)
  end
 end

 if HasKey(registerName) then
  setFunc(getFunc())
 else
  setFunc(defaultValue)
 end

 return getFunc, setFunc
end

updateKeys()
