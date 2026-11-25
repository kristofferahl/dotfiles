-- Dev sessions: shift+cmd+o picks a project with a rex-dev.sh script,
-- runs it (it creates the session unless it exists), and switches to it.
local util = require("lib.util")

local function find_dev_scripts()
  local r = rex.exec({ "find", os.getenv("HOME") .. "/develop", "-maxdepth", "5",
    "-name", "rex-dev.sh", "-not", "-path", "*/node_modules/*" }, { timeout = 10 })
  local items = {}
  for path in (r and r.stdout or ""):gmatch("[^\n]+") do
    local dir = path:match("(.*)/rex%-dev%.sh$")
    table.insert(items, {
      id = path,
      title = dir:match("([^/]+)$"),
      subtitle = util.short_path(dir),
      icon = "terminal",
    })
  end
  table.sort(items, function(a, b) return a.title < b.title end)
  return items
end

local function session_id(label)
  local list = rex.call("session.list")
  for _, s in ipairs(list and list.sessions or {}) do
    if s.label == label then return s.session_id end
  end
end

rex.action {
  name = "dev_session",
  title = "Start Dev Session…",
  category = "Tools",
  run = function()
    local script = rex.ui.pick {
      title = "Start dev session",
      placeholder = "Filter projects",
      items = find_dev_scripts(),
    }
    if not script then return end

    local r = rex.exec({ script }, { timeout = 60, env = { PATH = util.PATH } })
    if not r or not r.ok then
      rex.log("error", "rex-dev.sh failed: " .. (r and r.stderr or "did not run"))
      return
    end

    -- The script prints the session name in quotes, e.g. "Created Rex session 'mavis'."
    local id = session_id(r.stdout:match("'([^']+)'") or "")
    if id then rex.client.queue("session.select", { session_id = id }) end
  end,
}

rex.bind("shift+cmd+o", "dev_session")
