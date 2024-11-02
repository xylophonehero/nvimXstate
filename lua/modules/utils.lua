local M = {}

-- Loads the xstate query file
-- IDEA: break into multiple files down the line
M.load_query_file = function()
  -- Determine the directory of the current file (i.e., the plugin directory)
  local plugin_dir = debug.getinfo(1, "S").source:match("@(.*[/\\])") or ""

  local query_path = plugin_dir .. "queries/typescript/xstate.scm"

  -- Read the file contents
  local file = io.open(query_path, "r")
  if not file then
    print("Error: Could not open xstate query file.")
    return
  end
  local query_text = file:read("*a")
  file:close()

  return query_text
end

-- Custom function to get node text
M.get_node_text = function(node, buffer)
  buffer = buffer or 0 -- Default to the current buffer
  local start_row, start_col, end_row, end_col = node:range()
  local lines = vim.api.nvim_buf_get_text(buffer, start_row, start_col, end_row, end_col, {})
  return table.concat(lines, "\n")
end


return M
