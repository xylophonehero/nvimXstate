-- main module file
local functions = require("modules.functions")

---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
  -- commands.setup()
end

M.pick_state = function ()
  local root = functions.get_machine_object()
  local matches = functions.get_query_matches("xstate.state.name", root)
  functions.picker_from_matches(matches)
end

return M
