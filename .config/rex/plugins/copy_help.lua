-- Copy mode cheat sheet: press ? in copy mode (shift+cmd+c) to list the keys
-- that are hard to remember. Rex's built-in copy mode is itself a key mode
-- named "copy" (which shows no list), so the list is a mode on top of it.

-- ? (shift++ on a Swedish layout) toggles the list.
rex.bind("copy/shift+[Minus]", "client.mode.enter", { name = "copy-help" })
rex.action {
  name = "copy_help_hide",
  title = "Toggle Help",
  category = "Copy Mode",
  run = function() rex.client.queue("client.mode.exit") end,
}
rex.bind("copy-help/shift+[Minus]", "copy_help_hide")

-- Hide the list, then run a copy mode action. Used for keys that end copy mode,
-- and for search and find, which read the text you type next.
local function hide_then(name, title, action, args)
  rex.action {
    name = name,
    title = title,
    category = "Copy Mode",
    run = function()
      rex.client.queue("client.mode.exit")
      rex.client.queue(action, args)
    end,
  }
  return name
end

local function help(key, action, args) rex.bind("copy-help/" .. key, action, args) end

-- Not exclusive: keys not listed here (hjkl, w, b, counts...) still reach copy mode.
help("v", "pane.copy_mode.select", { mode = "char" })
help("shift+v", "pane.copy_mode.select", { mode = "line" })
help("ctrl+v", "pane.copy_mode.select", { mode = "block" })
help("g", "pane.copy_mode.move", { to = "history_top" })
help("shift+g", "pane.copy_mode.move", { to = "history_bottom" })
help("shift+7", hide_then("copy_search", "Search /", "pane.copy_mode.search", { direction = "forward" }))
help("n", "pane.copy_mode.search_again", { direction = "same" })
help("shift+n", "pane.copy_mode.search_again", { direction = "opposite" })
help("f", hide_then("copy_find", "Jump to Character", "pane.copy_mode.find", { direction = "forward" }))
help("enter", hide_then("copy_yank", "Copy Selection", "pane.copy_mode.yank"))
hide_then("copy_yank_eol", "Copy to End of Line", "pane.copy_mode.copy_to_line_end")
help("esc", hide_then("copy_exit", "Exit Copy Mode", "pane.copy_mode.exit"))

-- Bound in copy mode itself, so they work but stay out of the list.
rex.bind("copy/q", "copy_exit")
rex.bind("copy/y", "copy_yank")
rex.bind("copy/shift+d", "copy_yank_eol")

-- Search with / (shift+7 on a Swedish layout; Rex's default / can't be pressed).
rex.bind("copy/shift+7", "pane.copy_mode.search", { direction = "forward" })
