# xstate.nvim

A bunch of utilities for working with xstate in Neovim

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  dependencies = {
    "telescope.nvim",
    "nvim-treesitter",
  },
  cmd = { "XStatePickEvent", "XStatePickState" },
  config = function()
    require("xstate").setup()
  end,
  ft = "typescript",
  keys = {
    { "<leader>m", "", desc = "+Machines", mode = "n" },
    { "<leader>ms", "<cmd>XStatePickState<cr>", desc = "Pick state", mode = "n" },
    { "<leader>me", "<cmd>XStatePickEvent<cr>", desc = "Pick event", mode = "n" },
  },
},
```

## Usage

### Picking a state

```lua
require("xstate").pick_state()
```

Opens a telescope picker with all the states for the machine in the current buffer.

### Picking an event

```lua
require("xstate").pick_event()
```

Opens a telescope picker with all the events for the machine in the current buffer.
