---------------------------------------------
-- Awesome theme which follows xrdb config --
--   by Yauhen Kirylau                    --
---------------------------------------------
local theme_name = 'carnation/'
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local os = os
-- inherit default theme
local theme = dofile(themes_path.."default/theme.lua")
-- load vector assets' generators for this theme

theme.font         = "Misc Tamsyn 11.5"
theme.taglist_font = "Icons 10"
theme.dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name
theme.wallpaper = theme.dir .. "wall.png"
--"Tamzen 12 "FontAwesome" "Roboto Bold 14"
home = os.getenv("HOME")

-- theme.fg_normal            = xrdb.foreground
-- theme.fg_focus             = "#e3e3e3"
-- theme.bg_normal            = "#150841aa"
-- theme.bg_focus             = "#8f27ff55" --
-- theme.fg_urgent            = "pink"
-- theme.bg_urgent            = xrdb.color9
-- theme.border_width         = dpi(1)
-- theme.border_normal        = xrdb.color0
-- theme.border_focus         = theme.bg_focus
-- theme.bg_minimize          = xrdb.color8
-- theme.bg_systray           = "pink"
-- theme.fg_minimize          = theme.bg_normal
-- theme.hotkeys_bg           = "#424242"
-- theme.hotkeys_fg           = "#C4BFBF"
-- theme.hotkeys_modifiers_fg = "#C3DCDA"
-- theme.border_marked        = xrdb.color10
theme.useless_gap          = dpi(1)
theme.fg_normal            = "#D7D7D7"
theme.fg_focus             = "#F6784F"
theme.bg_normal            = "#06060622"
theme.bg_focus             = "#06060655"
theme.fg_urgent            = "#CC9393"
theme.bg_urgent            = "#2A1F1E"
theme.border_normal        = "#0E0E0E"
theme.border_focus         = "#F79372"
theme.taglist_fg_focus     = "#F6784F"
theme.taglist_bg_focus     = "#060606"
theme.tasklist_fg_focus    = "#F6784F"
theme.tasklist_bg_focus    = "#060606"

theme.hotkeys_bg           = "#060606da"
theme.hotkeys_fg           = "#C4BFBF"
theme.hotkeys_modifiers_fg = "#9A4C6C"
theme.hotkeys_group_margin = 20

theme.tooltip_fg = "red"
theme.tooltip_bg = "#060606"
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- theme.calendar
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(18)
theme.menu_width  = dpi(190)
theme.menu_bg_normal = "#060606da"
--theme.bg_widget = "#cc0000"

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_focus)

-- Recolor titlebar icons:
--
local function darker(color_value, darker_n)
   local result = "#"
   for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
      local bg_numeric_value = tonumber("0x"..s) - darker_n
      if bg_numeric_value < 0 then bg_numeric_value = 0 end
      if bg_numeric_value > 255 then bg_numeric_value = 255 end
      result = result .. string.format("%2.2x", bg_numeric_value)
   end
   return result
end

theme = theme_assets.recolor_titlebar(
   theme, theme.fg_normal, "normal"
)
theme = theme_assets.recolor_titlebar(
   theme, darker(theme.fg_normal, -60), "normal", "hover"
)
theme = theme_assets.recolor_titlebar(
   theme, xrdb.color1, "normal", "press"
)
theme = theme_assets.recolor_titlebar(
   theme, theme.fg_focus, "focus"
)
theme = theme_assets.recolor_titlebar(

   theme, darker(theme.fg_focus, -60), "focus", "hover"
)
theme = theme_assets.recolor_titlebar(
   theme, xrdb.color1, "focus", "press"
)

-- theme.icon_theme = "Arc"--"Adwaita" --"Arc"
theme.menu_submenu_icon     = theme.dir .. "/icons/submenu.png"
theme.awesome_icon          = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel   = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"



theme.hotkeys_border_width = dpi(2)


local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
   bg_numberic_value = bg_numberic_value + tonumber("0x"..s);
end
local is_dark_bg = (bg_numberic_value < 383)


return theme

-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
