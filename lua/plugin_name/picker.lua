---@class CustomModule
local M = {}
local ts = vim.treesitter
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Load the Treesitter query from the bundled file
local function load_query_file()
  -- Determine the directory of the current file (i.e., the plugin directory)
  local plugin_dir = debug.getinfo(1, "S").source:match("@(.*[/\\])") or ""

  local query_path = plugin_dir .. "queries/typescript/xstate.scm"

  -- Read the file contents
  local file = io.open(query_path, "r")
  if not file then
    print("Error: Could not open query file.")
    return
  end
  local query_text = file:read("*a")
  file:close()

  return query_text
end

-- Custom function to get node text
local function get_node_text(node, buffer)
  buffer = buffer or 0 -- Default to the current buffer
  local start_row, start_col, end_row, end_col = node:range()
  local lines = vim.api.nvim_buf_get_text(buffer, start_row, start_col, end_row, end_col, {})
  return table.concat(lines, "\n")
end

-- Function to display captures in Telescope and jump to selected node
function M.treesitter_capture_picker()
  local capture_type = "xstate.state.name" -- Default to xstate.state.name
  local buffer = 0 -- Default to current buffer

  local query_text = load_query_file()

  -- Get the syntax tree for the buffer
  local parser = ts.get_parser(buffer, "typescript")
  local root = parser:parse()[1]:root()

  -- Parse the query
  local query = ts.query.parse( "typescript", query_text)

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

  -- Use Telescope to display the captures
  pickers
    .new({}, {
      prompt_title = "Pick state",
      finder = finders.new_table({
        results = matches,
        entry_maker = function(entry)
          return {
            value = entry,
            display = get_node_text(entry.node, buffer),
            ordinal = get_node_text(entry.node, buffer),
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
