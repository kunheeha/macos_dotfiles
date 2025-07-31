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
