--[[
	/*
	 * IMPORTS
	 */
--]]

local api = vim.api
local _stringSplit = require('libmodal/src/collections/ParseTable').stringSplit

--[[
	/*
	 * MODULE
	 */
--]]

local _TIMEOUT_GLOBAL_NAME = 'libmodalTimeouts'

local Vars = {
	[_TIMEOUT_GLOBAL_NAME] = api.nvim_get_var(_TIMEOUT_GLOBAL_NAME),
	['TYPE'] = 'libmodal-vars'
}

--[[
	/*
	 * META `_metaVars`
	 */
--]]

local _metaVars = require('libmodal/src/classes').new(Vars.TYPE)

---------------------------------
--[[ SUMMARY:
	* Get the name of `modeName`s global setting.
]]
--[[ PARAMS:
	* `modeName` => the name of the mode.
]]
---------------------------------
function _metaVars:name()
	return string.lower(self._modeName) .. self._varName
end

------------------------------------
--[[ SUMMARY:
	* Retrieve a variable value.
]]
--[[ PARAMS:
	* `modeName` => the mode name this value is being retrieved for.
]]
------------------------------------
function _metaVars:nvimGet()
	return api.nvim_get_var(self:name())
end

-----------------------------------------
--[[ SUMMARY:
	* Set a variable value.
]]
--[[ PARAMS:
	* `modeName` => the mode name this value is being retrieved for.
	* `val` => the value to set `self`'s Vimscript var to.
]]
-----------------------------------------
function _metaVars:nvimSet(val)
	api.nvim_set_var(self:name(), val)
end

--[[
	/*
	 * CLASS `VARS`
	 */
--]]

--------------------------
--[[ SUMMARY:
	* Create a new entry in `Vars`
]]
--[[ PARAMS:
	* `keyName` => the name of the key used to refer to this variable in `Vars`.
]]
--------------------------
function Vars.new(keyName, modeName)
	local self = setmetatable({}, _metaVars)

	local function noSpaces(str, firstLetterModifier)
		local splitStr = _stringSplit(
			string.gsub(
				modeName,
				vim.pesc('_'),
				vim.pesc(' ')
			), ' '
		)

		for i, subStr in ipairs(splitStr) do
			splitStr[i] = firstLetterModifier(
				string.sub(subStr, 0, 1)
			) .. string.lower(
				string.sub(subStr, 2)
			)
		end

		return splitStr
	end

	self._modeName = noSpaces(modeName, string.lower)
	self._varName  = 'Mode' .. noSpaces(keyName, string.upper)

	return self
end

--[[
	/*
	 * PUBLICIZE MODULE
	 */
--]]

return Vars
