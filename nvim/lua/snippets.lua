local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("tex", {
  s("tab", {
    t { "\\begin{table}[htbp]", "\t" },
    t { "\\centering", "\t" },
    i(1),
    t { "\t", "\\caption{" },
    i(2),
    t { "}", "\t" },
    t "\\end{table}",
  }),
})
