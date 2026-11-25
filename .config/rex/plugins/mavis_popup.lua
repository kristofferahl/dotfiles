-- Mavis popup (like herdr's prefix+m): shift+cmd+m
local util = require("lib.util")

-- Wait for a keypress, after discarding pending input such as the
-- terminal's replies to capability queries, which would otherwise count as one.
local WAIT_FOR_KEY = 'while read -t 0.1 -sk; do :; done; read -sk "?Press any key to close"'

rex.action {
  name = "mavis_popup",
  title = "Run Mavis",
  category = "Tools",
  run = function(ctx)
    rex.session.new_layer {
      bounds = { 0.1, 0.25, 0.8, 0.5 }, -- x, y, width, height
      focus = true,
      layout = rex.layout.block {
        flavor = util.TERMINAL .. ".shell",
        options = {
          -- Interactive zsh so .zshrc (and OPENAI_API_KEY from addons) is loaded.
          -- `clear` hides the .zshrc output (sourcing messages, splash).
          command = { "zsh", "-ic", "clear; mavis --ai; " .. WAIT_FOR_KEY },
          shell = "none",
          cwd = util.current_dir(ctx),
        },
      },
    }
  end,
}

rex.bind("shift+cmd+m", "mavis_popup")
