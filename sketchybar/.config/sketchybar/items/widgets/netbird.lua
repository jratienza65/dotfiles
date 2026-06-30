local colors = require("colors")
local settings = require("settings")

-- NetBird VPN status, driven by the `netbird` CLI (talks to the daemon over its
-- world-writable socket, so up/down need no sudo). Label color reflects state;
-- click toggles connect/disconnect.
local netbird = sbar.add("item", "widgets.netbird", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "NetBird",
    color = colors.grey,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 12.0,
    },
  },
  update_freq = 10,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg1,
    border_color = colors.black,
    border_width = 1,
  },
})

sbar.add("bracket", "widgets.netbird.bracket", { netbird.name }, {
  background = { color = colors.transparent, height = 30, border_color = colors.grey },
})

sbar.add("item", { position = "right", width = settings.group_paddings })

local function update()
  sbar.exec("netbird status 2>/dev/null", function(out)
    local color = colors.red -- daemon down / error
    if out and out:find("Management: Connected") then
      color = colors.green
    elseif out and out:find("Disconnected") then
      color = colors.grey
    end
    netbird:set({ label = { color = color } })
  end)
end

netbird:subscribe({ "routine", "forced", "system_woke" }, function() update() end)

netbird:subscribe("mouse.clicked", function(_)
  sbar.exec("netbird status 2>/dev/null", function(out)
    local cmd = (out and out:find("Management: Connected")) and "netbird down" or "netbird up"
    sbar.exec(cmd .. " >/dev/null 2>&1", function() update() end)
  end)
end)
