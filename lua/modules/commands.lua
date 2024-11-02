local M = {}

M.commands = {
  PickState = {
    function()
      require("modules.functions").pick_state()
    end,
    {},
  },
}

M.setup = function()
  for name, def in pairs(M.commands) do
    vim.api.nvim_create_user_command(name, def[1], def[2])
  end
end

return M
