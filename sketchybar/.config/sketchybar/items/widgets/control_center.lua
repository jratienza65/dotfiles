local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Opens the native macOS Control Center (the panel with Wi-Fi / Bluetooth /
-- AirDrop / Focus / Display / Sound). Targets the menu bar item by its
-- accessibility description so it survives reordering of the status items.
local OPEN_CONTROL_CENTER =
  [[osascript -e 'tell application "System Events" to tell process "ControlCenter" to perform action "AXPress" of (first menu bar item of menu bar 1 whose description is "Control Center")']]

local cc = sbar.add("item", "widgets.control_center", {
  position = "right",
  icon = {
    string = icons.gear, -- gear glyph (proven to render); swap for a preferred SF Symbol if desired
    color = colors.white,
    font = {
      style = settings.font.style_map["Regular"],
      size = 16.0,
    },
    padding_left = 8,
    padding_right = 8,
  },
  label = { drawing = false },
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg1,
    border_color = colors.black,
    border_width = 1,
  },
})

-- Double border to match the calendar/wifi item styling
sbar.add("bracket", "widgets.control_center.bracket", { cc.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.grey,
  },
})

-- Padding item required because of the bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cc:subscribe("mouse.clicked", function(_)
  sbar.exec(OPEN_CONTROL_CENTER)
end)
