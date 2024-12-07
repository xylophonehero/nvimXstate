local M = {}

M.ts_picker = function(symbols)
  require("telescope.builtin").treesitter({
    symbols = symbols,
  })
end

M.load_queries = function(root_path)
  local query_names = { "locals", "textobjects" }
  for _, query_name in ipairs(query_names) do
    local query_path = root_path .. "queries/typescript/" .. query_name .. ".scm"
    local custom_query = vim.fn.readfile(query_path)
    -- Register the custom query
    vim.treesitter.query.set("typescript", query_name, table.concat(custom_query, "\n"))
  end
end

return M
