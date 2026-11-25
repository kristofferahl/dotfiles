-- Shared helpers for plugins: local util = require("lib.util")
local M = {}

M.TERMINAL = "com.superlogical.terminal"
local HOME = os.getenv("HOME")

-- Directory of the program running in the focused pane.
-- (The terminal's `pwd` is empty unless the shell reports it via OSC 7.)
function M.current_dir(ctx)
  if not ctx.block_id then return nil end
  local proc = rex.block.call(M.TERMINAL, "process", { block_id = ctx.block_id })
  return proc and proc.foreground and proc.foreground.cwd
end

-- Actions run with a minimal PATH (/usr/bin:/bin:...), so give commands the
-- rex CLI and Homebrew.
M.PATH = table.concat({
  HOME .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS",
  "/opt/homebrew/bin",
  "/usr/bin", "/bin", "/usr/sbin", "/sbin",
}, ":")

-- ~/... form of a path, for display.
function M.short_path(path)
  return path:sub(1, #HOME) == HOME and "~" .. path:sub(#HOME + 1) or path
end

return M
