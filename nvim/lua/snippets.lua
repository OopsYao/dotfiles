local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require "luasnip.extras"

ls.add_snippets("tex", {
  s("tab", {
    t "\\begin{table}",
    i(1, "[htbp]"),
    t { "", "\t\\centering", "\t\\caption{" },
    i(3),
    t { "}", "\t" },
    i(2),
    t { "", "\\end{table}" },
  }),
  s("fig", {
    t "\\begin{figure}",
    i(1, "[htbp]"),
    t { "", "\t\\centering", "\t" },
    i(2),
    t { "", "\t\\caption{" },
    i(3),
    t { "}", "\\end{figure}" },
  }),
  s("beg", {
    t "\\begin{",
    i(1),
    t "}",
    t { "", "\t" },
    i(2),
    t { "", "\\end{" },
    extras.rep(1),
    t "}",
  }),
  s("mul", {
    t { "\\[\\begin{split}", "\t" },
    i(1),
    t { "", "\\end{split}\\]" },
  }),
  s("mulb", {
    t { "\\[", "\t\\left\\{\\begin{aligned}", "\t" },
    i(1),
    t { "", "\t\\end{aligned}\\right.", "\\]" },
  }),
  s("~ci", {
    t "~\\cite{",
    i(1),
    t "}",
  }),
  s("lb", {
    t "\\label{",
    i(1),
    t "}",
  }),
})
