ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

function clamp(v, min, max)
 if v < min then return min end
 if v > max then return max end
 return v
end

function roundToNearest(x, d)
 d = d or 1
 return math.floor(x / d + 0.5) * d
end

function roundToDecimalFigures(x, d)
 local mult = 10^(d or 0)
 return math.floor(x * mult + 0.5) / mult
end
