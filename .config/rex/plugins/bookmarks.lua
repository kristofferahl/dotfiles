-- Bookmarks: shift+cmd+b lists bookmarked directories. Pick one to open it in
-- a new tab or session, cd to it, or remove it. The first row bookmarks the current dir.
-- Stored in ~/.local/share/rex/bookmarks.json (machine-local, not in dotfiles).
local util = require("lib.util")

local DATA_DIR = os.getenv("HOME") .. "/.local/share/rex"
local BOOKMARKS_FILE = DATA_DIR .. "/bookmarks.json"

local function load_bookmarks()
  local f = io.open(BOOKMARKS_FILE, "r")
  if not f then return {} end
  local ok, list = pcall(rex.json.decode, f:read("*a"))
  f:close()
  return ok and type(list) == "table" and list or {}
end

local function save_bookmarks(list)
  table.sort(list, function(a, b) return a.name:lower() < b.name:lower() end)
  rex.exec({ "mkdir", "-p", DATA_DIR })
  local f = assert(io.open(BOOKMARKS_FILE, "w"))
  f:write(rex.json.encode(list))
  f:close()
end

local function add_bookmark(ctx)
  local dir = util.current_dir(ctx)
  if not dir then return end
  local name = rex.ui.input {
    title = "Bookmark " .. util.short_path(dir),
    value = dir:match("([^/]+)$"),
    confirm = "Add bookmark",
  }
  if not name or name == "" then return end

  local list = {}
  for _, b in ipairs(load_bookmarks()) do
    if b.path ~= dir then table.insert(list, b) end -- re-adding renames it
  end
  table.insert(list, { name = name, path = dir })
  save_bookmarks(list)
end

-- Session named after the bookmark: switch to it, or create it first.
local function open_session(b)
  local id
  local list = rex.call("session.list")
  for _, s in ipairs(list and list.sessions or {}) do
    if s.label == b.name then id = s.session_id end
  end
  if not id then
    local r = rex.exec({ "rex", "new", b.name, "-c", b.path, "--json" }, { env = { PATH = util.PATH } })
    local created = r and r.ok and rex.json.decode(r.stdout)
    if not created then
      rex.log("error", "rex new failed: " .. (r and r.stderr or "did not run"))
      return
    end
    id = created.session_id
  end
  rex.client.queue("session.select", { session_id = id })
end

local function open_bookmark(ctx, b)
  local choice = rex.ui.pick {
    title = b.name .. " · " .. util.short_path(b.path),
    items = {
      { id = "tab", title = "Open in new tab", icon = "plus" },
      { id = "session", title = "Open in new session", subtitle = "or switch to it if it exists", icon = "server" },
      { id = "cd", title = "cd here", subtitle = "in the current pane", icon = "terminal" },
      { id = "remove", title = "Remove bookmark", icon = "gear" },
    },
  }
  if choice == "tab" then
    local w = rex.session.new_window {
      layout = rex.layout.block { flavor = util.TERMINAL .. ".shell", options = { cwd = b.path } },
    }
    if w then rex.session.set_window_label { window_id = w.window_id, label = b.name } end
  elseif choice == "session" then
    open_session(b)
  elseif choice == "cd" then
    rex.block.call(util.TERMINAL, "write", { block_id = ctx.block_id, data = "cd '" .. b.path .. "'\r" })
  elseif choice == "remove" then
    local list = {}
    for _, other in ipairs(load_bookmarks()) do
      if other.path ~= b.path then table.insert(list, other) end
    end
    save_bookmarks(list)
  end
end

rex.action {
  name = "bookmarks",
  title = "Bookmarks…",
  category = "Tools",
  run = function(ctx)
    local list = load_bookmarks()
    local items = { { id = "+", title = "Bookmark current directory", icon = "plus" } }
    for i, b in ipairs(list) do
      table.insert(items, { id = tostring(i), title = b.name, subtitle = util.short_path(b.path), icon = "folder" })
    end

    local picked = rex.ui.pick { title = "Bookmarks", placeholder = "Filter bookmarks", items = items }
    if picked == "+" then
      add_bookmark(ctx)
    elseif picked then
      open_bookmark(ctx, list[tonumber(picked)])
    end
  end,
}

rex.bind("shift+cmd+b", "bookmarks")
