KEY_UPDATE_FREQUENCY = "savegame.mod.updateFrequency"

function getUpdateFrequency()
 if not HasKey(KEY_UPDATE_FREQUENCY) then
  SetFloat(KEY_UPDATE_FREQUENCY, 0.2)
 end
 return GetFloat(KEY_UPDATE_FREQUENCY)
end
