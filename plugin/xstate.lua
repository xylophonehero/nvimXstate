vim.api.nvim_create_user_command("XStatePickState", require("xstate").pick_state, {})
vim.api.nvim_create_user_command("XStatePickEvent", require("xstate").pick_event, {})

