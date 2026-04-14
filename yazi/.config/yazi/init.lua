
-- https://github.com/wylie102/duckdb.yazi?tab=readme-ov-file#configurationcustomisation
require("duckdb"):setup({
  mode = "summarized",                      -- Default: "summarized" ("standard"/"summarized")
  cache_size = 500,                         -- Default: 500
  row_id = false,                           -- Default: false (true/false/"dynamic")
  minmax_column_width = 21,                 -- Default: 21
  column_fit_factor = 10.0,                 -- Default: 10.0
})
