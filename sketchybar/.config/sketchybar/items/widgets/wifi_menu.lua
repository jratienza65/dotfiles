local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Opens the native macOS Wi-Fi menu (full network list) in one click.
-- The status item's description is e.g. "Wi‑Fi, connected, 3 bars", so match by
-- prefix to stay robust to the trailing state text.
local OPEN_WIFI =
  [[osascript -e 'tell application "System Events" to tell process "ControlCenter" to perform action "AXPress" of (first menu bar item of menu bar 1 whose description starts with "Wi")']]

local wifi_menu = sbar.add("item", "widgets.wifi_menu", {
  position = "right",
  icon = {
    string = icons.wifi.connected,
    color = colors.white,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
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

sbar.add("bracket", "widgets.wifi_menu.bracket", { wifi_menu.name }, {
  background = { color = colors.transparent, height = 30, border_color = colors.grey },
})

sbar.add("item", { position = "right", width = settings.group_paddings })

wifi_menu:subscribe("mouse.clicked", function(_)
  sbar.exec(OPEN_WIFI)
end)
