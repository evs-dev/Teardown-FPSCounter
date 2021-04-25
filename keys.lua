KEY_UPDATE_FREQUENCY = "savegame.mod.updateFrequency"

function getUpdateFrequency()
 if not HasKey(KEY_UPDATE_FREQUENCY) then
  SetFloat(KEY_UPDATE_FREQUENCY, 0.2)
 end
 return GetFloat(KEY_UPDATE_FREQUENCY)
end

KEY_SHOW_PREFIX = "savegame.mod.showPrefix"

function getShowPrefix()
 if not HasKey(KEY_SHOW_PREFIX) then
  SetBool(KEY_SHOW_PREFIX, true)
 end
 return GetBool(KEY_SHOW_PREFIX)
end

KEY_NUM_DECIMAL_FIGURES = "savegame.mod.numDecimalFigures"

function getNumDecimalFigures()
 if not HasKey(KEY_NUM_DECIMAL_FIGURES) then
  SetInt(KEY_NUM_DECIMAL_FIGURES, 0)
 end
 return GetInt(KEY_NUM_DECIMAL_FIGURES)
end

KEY_ALIGNMENT = "savegame.mod.alignment"

function getAlignment()
 if not HasKey(KEY_ALIGNMENT) then
  SetString(KEY_ALIGNMENT, "top left")
 end
 return GetString(KEY_ALIGNMENT)
end

KEY_HIGH_CONTRAST = "savegame.mod.highContrast"

function getHighContrast()
 if not HasKey(KEY_HIGH_CONTRAST) then
  SetBool(KEY_HIGH_CONTRAST, false)
 end
 return GetBool(KEY_HIGH_CONTRAST)
end
