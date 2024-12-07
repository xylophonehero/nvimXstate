-- main module file
local functions = require("xstate.modules.functions")

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

  functions.load_queries(debug.getinfo(1).source:match("@?(.*/)"))
end

M.pick_state = function ()
  functions.ts_picker({ "state" })
end

M.pick_event = function ()
  functions.ts_picker({ "event" })
end

return M
