local utils = require("modules.utils")
local M = {}

local ts = vim.treesitter

-- Function to get the machine or setup object
M.get_machine_object = function()
  local buffer = 0 -- Default to current buffer

  -- Get the syntax tree for the buffer
  local parser = ts.get_parser(buffer, "typescript")
  local root = parser:parse()[1]:root()

  local matches = M.get_query_matches("xstate.machine_config", root, buffer)
  return matches[1].node
end

-- Function to get query matches
M.get_query_matches = function(capture_type, root, buffer)
  buffer = buffer or 0 -- Default to current buffer
  local query_text = utils.load_query_file()

  -- Parse the query
  local query = ts.query.parse("typescript", query_text)

  -- Collect matching nodes with positions
  local matches = {}
  for _, captures, _ in query:iter_matches(root, buffer) do
    for id, node in pairs(captures) do
      local capture_name = query.captures[id]
      if capture_name == capture_type then -- Filter by capture type
        table.insert(matches, {
          capture_name = capture_name,
          node = node,
          pos = { node:range() },
        })
      end
    end
  end

  return matches
end

M.picker_from_matches = function(matches, buffer)
  buffer = buffer or 0 -- Default to current buffer

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Use Telescope to display the captures
  pickers
    .new({}, {
      prompt_title = "Pick state",
      finder = finders.new_table({
        results = matches,
        entry_maker = function(entry)
          return {
            value = entry,
            display = utils.get_node_text(entry.node, 0),
            ordinal = utils.get_node_text(entry.node, 0),
          }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local pos = selection.value.pos
          -- Move cursor to the node's position
          vim.api.nvim_win_set_cursor(0, { pos[1] + 1, pos[2] + 1 })
        end)
        return true
      end,
    })
    :find()
end

return M
