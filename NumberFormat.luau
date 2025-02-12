-- Made by Hiatus
-- Functions for formatting numbers e.g. 10000 -> 10K or 10,000 or 10,000.00

local Units = {
	"K",  "K",  "K",
	"M",  "M",  "M",
	"B",  "B",  "B",
	"T",  "T",  "T",
	"Qd", "Qd", "Qd",
	"Qn", "Qn", "Qn",
	"Sx", "Sx", "Sx",
	"Sp", "Sp", "Sp",
	"Oc", "Oc", "Oc",
	"No", "No", "No",
	"Dc", "Dc", "Dc",
}

local Formatters = {}

--[[
	Abbreviates a large integer into a string (Max value: 999Dc)
	@param int number | string
	@param decimalPlaces number?
]]
Formatters.Abbreviate = function (int: number | string, decimalPlaces: number?): string
		
	local int = tonumber(int) :: number
	if int < 1000 then return int.."" end

	local digits = math.floor(math.log10(int))
	local mod = digits % 3

	if not decimalPlaces or decimalPlaces == 0 then
		return math.floor(int / 10 ^ (digits - mod)) .. Units[digits - 2]
	end

	return math.floor(int / 10 ^ (digits - mod - decimalPlaces)) / (10 ^ decimalPlaces) .. Units[digits - 2]

end

--[[
	Adds commas to large integers
	@param int number | string
]]
Formatters.	Pad = function (int: number | string): string -- adds commas to large integers
		
	local int = tonumber(int) :: number
	if int < 1000 then return int.."" end

	local digits = math.floor(math.log10(int)) + 1
	local mod = digits % 3

	local output = string.sub(int, 1, mod)

	for i = mod + 1, digits, 3 do
		output = output .. "," .. string.sub(int, i, i + 2)
	end

	if mod == 0 then
		output = string.sub(output, 2)
	end

	return output

end

--[[
	Adds commas to large floats and appends a certain number of decimal places
	@param float number | string
	@param decimalPlaces number
]]
Formatters.PadFloat = function (float: number | string, decimalPlaces: number): string -- adds commas to large integers

	if not decimalPlaces or decimalPlaces == 0 then return Formatters.Pad(float) end
	
	local float = tonumber(float) :: number
	if float < 1000 then return string.format(`%.{decimalPlaces}f`, float) end

	local digits = math.floor(math.log10(float)) + 1
	local mod = digits % 3

	local output = string.sub(float, 1, mod)

	for i = mod + 1, digits, 3 do
		output = output .. "," .. string.sub(float, i, i + 2)
	end

	if mod == 0 then
		output = string.sub(output, 2)
	end

	local decimal = string.match(float, "%.(%d+)")
	if not decimal then
		return `{output}.{string.rep("0", decimalPlaces)}`
	else
		return `{output}.{string.sub(decimal, 1, decimalPlaces)}{string.rep("0", decimalPlaces - #decimal)}`
	end

end

return Formatters
