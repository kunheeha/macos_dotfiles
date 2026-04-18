local hotkey = require("hs.hotkey")
local window = require("hs.window")
local spaces = require("hs.spaces")
local Drag = hs.loadSpoon("Drag")

local function getSpaceIdByIndex(index)
  local screen = hs.screen.mainScreen()
  local uuid = screen:getUUID()
  local spaceList = spaces.spacesForScreen(uuid)
  return spaceList and spaceList[index]
end

-- Move Focused Window to Space (1 to 9)
for i = 1, 9 do
  hotkey.bind({"shift", "alt"}, tostring(i), function ()
    local win = window.focusedWindow()
    if not win then
      hs.alert.show("No focused window")
      return
    end

    local spaceID = getSpaceIdByIndex(i)
    if spaceID then
      Drag:focusedWindowToSpace(spaceID)
      spaces.gotoSpace(spaceID)
    else
      hs.alert.show("Space ".. i .. " not found")
    end
  end)
end

-- Switch to Space (1 to 9)
for i = 1, 9 do
  hotkey.bind({"alt"}, tostring(i), function ()
    local spaceID = getSpaceIdByIndex(i)
    if spaceID then
      spaces.gotoSpace(spaceID)
    else
      hs.alert.show("Space ".. i .. " not found")
    end
  end)
end

-- Cycle macOS input source (replaces Ctrl-Space, which is reserved for vim LSP)
hotkey.bind({"cmd", "shift"}, "space", function ()
  local sources = {}
  for _, s in ipairs(hs.keycodes.layouts(true) or {}) do table.insert(sources, s) end
  for _, s in ipairs(hs.keycodes.methods(true) or {}) do table.insert(sources, s) end
  if #sources < 2 then return end

  local current = hs.keycodes.currentSourceID()
  local nextIdx = 1
  for i, s in ipairs(sources) do
    if s == current then
      nextIdx = (i % #sources) + 1
      break
    end
  end
  hs.keycodes.currentSourceID(sources[nextIdx])
end)
