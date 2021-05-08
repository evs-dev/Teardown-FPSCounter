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

function resetKeysToDefault()
 ClearKey("savegame.mod")
 updateKeys()
end

-- Create a registry entry ("key") and return a getter and setter
function key(registryName, defaultValue, ...)
 local keyType = type(defaultValue)
 local args = {...}
 local getFunc, setFunc
 registryName = "savegame.mod."..registryName

 if keyType == "number" then
  getFunc = function()
   return GetFloat(registryName)
  end
  setFunc = function(value)
   SetFloat(registryName, clamp(value, args[1], args[2]))
  end
 elseif keyType == "string" then
  getFunc = function()
   return GetString(registryName)
  end
  setFunc = function(value)
   SetString(registryName, args[1] and args[1](value) or value)
  end
 elseif keyType == "boolean" then
  getFunc = function()
   return GetBool(registryName)
  end
  setFunc = function(value)
   SetBool(registryName, value)
  end
 end

 if HasKey(registryName) then
  setFunc(getFunc())
 else
  -- Set key to the given default value if it doesn't already exist
  setFunc(defaultValue)
 end

 return getFunc, setFunc
end

-- Ensure keys are up-to-date when this file is included in others
updateKeys()
