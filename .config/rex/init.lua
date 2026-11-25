-- Rex config: Rex defaults are kept; extras live in plugins/, one file each.
-- Apply changes with `rex config reload`, inspect with `rex keymap`.

-- Sidebar: the default cmd+/ can't be pressed on a Swedish layout (/ is shift+7).
rex.bind("cmd+b", "client.sidebar.toggle")

require("plugins.mavis_popup")  -- shift+cmd+m
require("plugins.resize")       -- alt+cmd+r
require("plugins.copy_help")    -- ? in copy mode
require("plugins.dev_sessions") -- shift+cmd+o
require("plugins.bookmarks")    -- shift+cmd+b
