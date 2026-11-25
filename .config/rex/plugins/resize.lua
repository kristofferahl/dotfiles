-- Resize mode: alt+cmd+r, then arrows or hjkl (shift = bigger steps)

rex.mode("resize", { exclusive = true })
rex.bind("alt+cmd+r", "client.mode.enter", { name = "resize" })

local function resize(key, direction)
  rex.bind("resize/" .. key, "pane.resize", { direction = direction })
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = direction, amount = 15 })
end

resize("h", "left")
resize("j", "down")
resize("k", "up")
resize("l", "right")
resize("left", "left")
resize("down", "down")
resize("up", "up")
resize("right", "right")

rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
