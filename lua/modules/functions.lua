local utils = require("modules.utils")
local M = {}

local ts = vim.treesitter

M.get_machine_object = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, "javascript") -- or "typescript"
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Load the query for the machine object
  local query = vim.treesitter.query.parse_query("javascript", [[
    (call_expression
      function: (identifier) @machine_func (#eq? @machine_func "createMachine")
      arguments: (object) @machine_object)

    (call_expression
      function: (member_expression
        object: (call_expression
          function: (identifier) @setup_func (#eq? @setup_func "setup"))
        property: (property_identifier) @machine_func (#eq? @machine_func "createMachine"))
      arguments: (object) @machine_object)
  ]])

  -- Find and return the machine object node
  for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
    local machine_object_node = match[2] -- The `@machine_object` capture
    return machine_object_node
  end
end

-- M.pick_state = function ()
--   local matches = utils.get_query_matches("xstate.state.name")
--   utils.picker_from_matches(matches)
-- end

-- Function to get query matches
M.get_query_matches = function(capture_type, buffer)
  buffer = buffer or 0 -- Default to current buffer
  local query_text = utils.load_query_file()

  -- Get the syntax tree for the buffer
  local parser = ts.get_parser(buffer, "typescript")
  local root = parser:parse()[1]:root()

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
