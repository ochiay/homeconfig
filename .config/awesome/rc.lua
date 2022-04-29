#!/usr/bin/lua
-- Standard awesome library
local gears         = require("gears")
local awful         = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")
-- Theme handling library
local beautiful     = require("beautiful")
-- Notification library
local os = os
local menubar       = require("menubar")
--local hp_popup = require("awful.hotkeys_popup").widget --.new(width=150)
local hotkeys_popup = require("awful.hotkeys_popup").widget --hp_widget.new({width=60,},)
local freedesktop   = require("freedesktop")

local quake = require('lain/util/quake')

require("in_error")
require("awful.hotkeys_popup.keys")
--
local lain = require("lain")
--
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
-- theme
beautiful.init(string.format("%s/.config/awesome/themes/carnation/theme.lua", os.getenv("HOME")))
-- beautiful.init(gears.filesystem.get_themes_dir() .. "cesious/theme.lua")
-- apps


terminal = 'terminator'
fm = "pcmanfm"
--
local separators = lain.util.separators

local ranger = lain.util.quake({
      app=terminal,
      extra=" -e ranger",
      name="xterm",
      height=1,
      width=0.5,
      horiz="right",
})
markup = lain.util.markup
local net_icon = wibox.widget.imagebox(beautiful.widget_net)
local net = lain.widget.net({
      settings = function()
         widget:set_markup( markup.fontfg( beautiful.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
      end
})

local wifi_icon = wibox.widget.imagebox()
local eth_icon = wibox.widget.imagebox()




editor = os.getenv("EDITOR") or "emacsclient" or "gvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
altkey = "Mod1"
modkey = "Mod4"
monkey = "135"
-- schema
local layouts = {
   awful.layout.suit.tile,           --"web"
   awful.layout.suit.tile,           --"dev"
   awful.layout.suit.tile.right,     --"gui"
   awful.layout.suit.tile.right,     --"cfg"
   awful.layout.suit.tile.right,     --"rtfm"
   awful.layout.suit.fair,           --"Xterm"
   awful.layout.suit.max,            --"dk"
   awful.layout.suit.fair,           --"stuff"
   awful.layout.suit.spiral.dwindle, --"etc"
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier,
   awful.layout.suit.corner.nw,
}

-- {{{ Helper functions
local function client_menu_toggle_fn()
   local instance = nil

   return function ()
      if instance and instance.wibox.visible then
         instance:hide()
         instance = nil
      else
         instance = awful.menu.clients({ theme = { width = 250 } })
      end
   end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys"      , function() return false, hotkeys_popup.show_help end},
   { "manual"       , terminal .. " -e man awesome" },
   { "edit config"  , editor_cmd .. " " .. awesome.conffile },
   { "restart"      , awesome.restart },
   { "quit"         , function() awesome.quit() end}
}
myexitmenu = {
   { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
   { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
   { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
   { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
   { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}

mymainmenu = freedesktop.menu.build({
      icon_size = 32,
      before = {
         { 'Awesome', myawesomemenu, beautiful.awesome_icon },
         -- other triads can be put here
      },
      after = {
         { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
         { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
         -- other triads can be put here
      }
})

-- {{{ widgets }}}
-- layouts_list =
mylauncher = awful.widget.launcher(
   { image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- clock
cld_clock = wibox.widget.textclock()
calendar = awful.widget.calendar_popup.month()
calendar:attach(cld_clock)
local volume = lain.widget.pulsebar(
   { timeout = 1, ticks = true, ticks_size=6, width = 59, border_width=0,
     --     height = 2,
     --     margins = 5,
     --     paddings = 5,

     colors = { unmute='#a46E6E', background='black', mute='#ff0000'}
})
volume.bar:buttons(awful.util.table.join(
                      awful.button({}, 1, function() -- left click
                            awful.spawn('pavucontrol')
                      end),
                      awful.button({}, 2, function() -- middle click
                            os.execute(string.format('pactl set-sink-volume %d 100%%', volume.device))
                            volume.update()
                      end),
                      awful.button({}, 3, function() -- right click
                            os.execute(string.format('pactl set-sink-mute %d toggle', volume.device))
                            volume.update()
                      end),
                      awful.button({}, 4, function() -- scroll up
                            os.execute(string.format('pactl set-sink-volume %d +5%%', volume.device))
                            volume.update()
                      end),
                      awful.button({}, 5, function() -- scroll down
                            os.execute(string.format('pactl set-sink-volume %d -5%%', volume.device))
                            volume.update()
                      end)
))

local volumebar = wibox.container.margin(volume.bar, 2,7,5,5)
carnation = '#F47D67'
spr = wibox.widget.textbox(' ')--'<span color='#F6784F'> |bb</span')
sep_left = separators.arrow_left(carnation ,'alpha')
sep_start = separators.arrow_left('alpha' , carnation)

sep_right = separators.arrow_right('alpha' , carnation)
sep_end = separators.arrow_right(carnation ,'alpha')
local taglist_buttons = awful.util.table.join(
   awful.button({ }, 1, function(t) t:view_only() end),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end),
   awful.button({ modkey }, 1, function(t)
         if client.focus then
            client.focus:move_to_tag(t)
         end
   end),
   awful.button({ modkey }, 3, function(t)
         if client.focus then
            client.focus:toggle_tag(t)
         end
   end)
)

local tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
         if c == client.focus then
            c.minimized = true
         else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
               c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
         end
   end),
   awful.button({ }, 3, client_menu_toggle_fn()),
   awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
   awful.button({ }, 5, function () awful.client.focus.byidx(-1) end))

local function set_wallpaper(s)
   -- Wallpaper
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == 'function' then
         wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s, true)
   end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)
names = {'web', 'dev', 'gui', 'etc', 'man', 'cmd', 'app', 'pwd', 'tmp'}

awful.screen.connect_for_each_screen( function(s)
      -- Wallpaper
      set_wallpaper(s)
      -- Each screen has its own tag table.
      s.quake = quake({ app = "alacritty",argname = "--title %s",extra = "--class QuakeDD -e tmux", visible = true, height = 0.9, screen = s })
      awful.tag( names, s, layouts)
      -- freedesktop.desktop.add_icons({screen=s})
      -- Create a promptbox for each screen
      s.mypromptbox = awful.widget.prompt()
      -- Create an imagebox widget which will contains an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(
         awful.util.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
         )
      )
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist(
         s, awful.widget.taglist.filter.all, taglist_buttons)

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist(
         s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

      -- Create the wibox
      s.mywibox = awful.wibar({ position = 'top', screen = s, visible = true, height=24 })

      -- Add widgets to the wibox
      s.mywibox:setup {
         layout = wibox.layout.align.horizontal,
         { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            spr,
            sep_start,
            sep_left,
            spr,
            s.mytaglist,
            sep_right,
            sep_end,
            s.mypromptbox,
            spr,
         },
         s.mytasklist, -- Middle widget
         { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            sep_start,
            sep_left,
            wibox.container.margin(wibox.widget { nil, net_icon, net.widget, layout = wibox.layout.align.horizontal }, 3, 3),
            volumebar,
            mykeyboardlayout,
            wibox.widget.systray(),
            cld_clock,
            s.mylayoutbox,

         },
      }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
                awful.button({ }, 3, function () mymainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
local function run_or_raise (a, b)
   local matcher = function(c)
      return awful.rules.match(c, {class = a})
   end
   awful.client.run_or_raise(b, matcher)
end
-- {{{ hotkeys Keybindings
globalkeys = awful.util.table.join(
   awful.key({}, 'XF86AudioLowerVolume', function ()
         awful.util.spawn('amixer -q -D pulse sset Master 5%-', false)
   end),
   awful.key({}, 'XF86AudioRaiseVolume', function ()
         awful.util.spawn('amixer -q -D pulse sset Master 5%+', false)
   end),
   awful.key({ modkey,}, 'o', function ()
         calendar:toggle()
   end),
   awful.key({ }, 'Print', function ()
         awful.util.spawn('scrot -e \'mv $f ~/Pictures/screenshot/ 2>/dev/null\'', false)
   end),
   awful.key({ modkey, },  '\'',
      function()
         awful.menu.show()
      end,
      {description='make test', group='awesome'}
   ),
   awful.key({ modkey, }, 'i',      hotkeys_popup.show_help,
      {description='show help', group='awesome'}),
   awful.key({ modkey, 'Shift'}, 'Left',   awful.tag.viewprev,
      {description = 'view previous', group = 'tag'}),
   awful.key({ modkey, 'Shift'}, 'Right',  awful.tag.viewnext,
      {description = 'view next', group = 'tag'}),
   awful.key({ modkey, }, 'Escape', awful.tag.history.restore,
      {description = 'go back', group = 'tag'}),
   awful.key({ modkey, }, 'j', function () awful.client.focus.byidx( 1) end,
      {description = 'focus next by index', group = 'client'}),
   awful.key({ modkey, }, 'k', function () awful.client.focus.byidx(-1) end,
      {description = 'focus previous by index', group = 'client'}),
   awful.key({modkey }, 'Menu', function () mymainmenu:show() end,
      {description = 'show main menu', group = 'awesome'}),

   -- Layout manipulation
   awful.key({ modkey, 'Shift'   }, 'j', function () awful.client.swap.byidx(1) end,
      {description = 'swap with next client by index', group = 'client'}),
   awful.key({ modkey, 'Shift'   }, 'k', function () awful.client.swap.byidx(-1) end,
      {description = 'swap with previous client by index', group = 'client'}),
   awful.key({ modkey, 'Control' }, 'j', function () awful.screen.focus_relative(1) end,
      {description = 'focus the next screen', group = 'screen'}),
   awful.key({ modkey, 'Control' }, 'k', function () awful.screen.focus_relative(-1) end,
      {description = 'focus the previous screen', group = 'screen'}),
   awful.key({ modkey,           }, 'u', awful.client.urgent.jumpto,
      {description = 'jump to urgent client', group = 'client'}),
   awful.key({ modkey,           }, 'Tab',
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
      {description = 'go back', group = 'client'}),
   awful.key({ altkey,           }, ']',
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
      {description = 'go back', group = 'client'}),

   -- Standard program

   -- awful.key({ modkey,           }, '\\',
   --    function () awful.spawn('Xterm -e ranger') end,
   --    {description = 'open midnight commander', group = 'launcher'}),
   
   awful.key({modkey }, "F12", nil, function () my_dropdown:toggle() end),
   awful.key({ modkey, }, "Return", function () awful.screen.focused().quake:toggle() end, {description = "dropdown application", group = "launcher"}),
   -- awful.key({ modkey,           }, 'Return',
   --    function () quake:toggle() end,
   --    {description = 'popup terminal', group = 'launcher'}),
   awful.key({ modkey,           }, ';',
      function () ranger:toggle() end,
      {description = 'popup a terminal', group = 'launcher'}),
   -- launcher
   awful.key({ modkey,           }, 'e',
      function () run_or_raise('Emacs', 'emacs') end,
      {description = 'popup a emacs', group = 'launcher'}),
   -- awful.key({ modkey,           }, '`',
   --    function () run_or_raise('Xterm', 'Xterm') end,
   --    {description = 'popup a Xterm', group = 'launcher'}),
   awful.key({ modkey,           }, 'z',
      function () run_or_raise('Zathura', 'zathura') end,
      {description = 'popup a zathura', group = 'launcher'}),
   -- awful.key({ modkey,           }, 'l',
   --    function () run_or_raise('Goldendict', 'goldendict') end,
   --    {description = 'popup a goldendict', group = 'launcher'}),
   awful.key({ modkey,           }, ',',
      function () run_or_raise('Pcmanfm', 'pcmanfm') end,
      {description = 'popup a pcmanfm', group = 'launcher'}),
   awful.key({ modkey, 'Control' }, 'i', awesome.restart,
      {description = 'reload awesome', group = 'awesome'}),
   awful.key({ modkey, 'Shift'   }, 'q', awesome.quit,
      {description = 'quit awesome', group = 'awesome'}),
   awful.key({ modkey,           }, 'l',
      function () awful.tag.incmwfact( 0.05) end,
      {description = 'increase master width factor', group = 'layout'}),
   awful.key({ modkey,           }, 'h',
      function () awful.tag.incmwfact(-0.05) end,
      {description = 'decrease master width factor', group = 'layout'}),
   awful.key({ modkey, 'Shift'   }, 'h',
      function () awful.tag.incnmaster( 1, nil, true) end,
      {description = 'increase the number of master clients', group = 'layout'}),
   awful.key({ modkey, 'Shift'   }, 'l',
      function () awful.tag.incnmaster(-1, nil, true) end,
      {description = 'decrease the number of master clients', group = 'layout'}),
   awful.key({ modkey, 'Control' }, 'h',
      function () awful.tag.incncol( 1, nil, true) end,
      {description = 'increase the number of columns', group = 'layout'}),
   awful.key({ modkey, 'Control' }, 'l',
      function () awful.tag.incncol(-1, nil, true) end,
      {description = 'decrease the number of columns', group = 'layout'}),
   awful.key({ modkey,           }, 'space',
      function () awful.layout.inc( 1) end,
      {description = 'select next', group = 'layout'}),
   awful.key({ modkey, 'Shift'   }, 'space',
      function () awful.layout.inc(-1) end,
      {description = 'select previous', group = 'layout'}),

   awful.key({ modkey, 'Control' }, 'n',
      function ()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      {description = 'restore minimized', group = 'client'}),

   -- Prompt
   awful.key({ modkey }, 'r',
      function () awful.screen.focused().mypromptbox:run() end,
      {description = 'run prompt', group = 'launcher'}
   ),

   awful.key({ modkey, 'Shift' }, 'x',
      function ()
         awful.prompt.run {
            prompt       = 'Run Lua code: ',
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. '/history_eval'
         }
      end,
      {description = 'lua execute prompt', group = 'awesome'}),
   -- Menubar
   awful.key({ modkey }, 'p', function() menubar.show() end,
      {description = 'show the menubar', group = 'launcher'})
)

clientkeys = awful.util.table.join(
   awful.key({ modkey, altkey }, 'Next',  function (c) c:relative_move( 20,  20, -40, -40) end),
   awful.key({ modkey, altkey }, 'Prior', function (c) c:relative_move(-20, -20,  40,  40) end),
   awful.key({ modkey, }, 'Up',
      function (c)
         local axis = 'horizontally'
         local f = awful.placement.scale + awful.placement.top + (axis and awful.placement['maximize_'..axis] or nil)
         local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})
   end),

   awful.key({ modkey }, 'Down',
      function (c)
         local axis = 'horizontally'
         local f = awful.placement.scale + awful.placement.bottom + (axis and awful.placement['maximize_'..axis] or nil)
         local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})
   end),
   awful.key({ modkey }, 'Right',
      function (c)
         local axis = 'vertically'
         local f = awful.placement.scale + awful.placement.right + (axis and awful.placement['maximize_'..axis] or nil)
         local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})
   end),
   awful.key({ modkey }, 'Left',
      function (c)
         local axis = 'vertically'
         local f = awful.placement.scale + awful.placement.left + (axis and awful.placement['maximize_'..axis] or nil)
         local geo = f(client.focus, {honor_workarea=true, to_percent = 0.5})
   end),
   awful.key({ modkey,           }, 'f',
      function (c)
         c.fullscreen = not c.fullscreen
         c:raise()
      end,
      {description = 'toggle fullscreen', group = 'client'}),
   awful.key({ altkey, }, 'q',
      function (c) c:kill() end,
      {description = 'close', group = 'client'}),
   awful.key({ modkey, 'Control' }, 'space',  awful.client.floating.toggle,
      {description = 'toggle floating', group = 'client'}),
   awful.key({ modkey, 'Control' }, 'Return', function (c) c:swap(awful.client.getmaster()) end,
      {description = 'move to master', group = 'client'}),
   awful.key({ modkey,           }, 'o',      function (c) c:move_to_screen()               end,
      {description = 'move to screen', group = 'client'}),
   awful.key({ modkey,           }, 't',      function (c) c.ontop = not c.ontop            end,
      {description = 'toggle keep on top', group = 'client'}),
   awful.key({ modkey,           }, 'n', function (c) c.minimized = true end ,
      {description = 'minimize', group = 'client'}),
   -- \m+m go to man page
   awful.key({ modkey,           }, 'm',
      function (c)
         c.maximized = not c.maximized
         c:raise()
      end ,
      {description = 'maximize', group = 'client'}),
   awful.key({ modkey, 'Control' }, 'm',
      function (c)
         c.maximized_vertical = not c.maximized_vertical
         c:raise()
      end ,
      {description = '(un)maximize vertically', group = 'client'}),
   awful.key({ modkey, 'Shift'   }, 'm',
      function (c)
         c.maximized_horizontal = not c.maximized_horizontal
         c:raise()
      end ,
      {description = '(un)maximize horizontally', group = 'client'})
)

-- TAGSBIND
local np_map = {87, 88, 89, 83, 84, 85, 79, 80, 81}
local function view_tag (it)
   local screen = awful.screen.focused()
   local tag = screen.tags[it]
   if tag then
      tag:view_only()
   end
end

------------------
local function move_to_tag(it)
   if client.focus then
      local tag = client.focus.screen.tags[it]
      if tag then
         client.focus:move_to_tag(tag)
      end
   end
end
-- SPECIAL KEY :3
globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ modkey, 'Shift'}, '`',
      function()
         view_tag(6)
         run_or_raise('Terminator', terminal)
      end,
      {descriptrion = 'run terminal on \'CMD\' tag'}
   ),
   awful.key({ modkey }, 'w',--'#' .. i + 9,
      function() view_tag(4) end,
      {description = 'go to web', group = 'tag'}
   ),
   awful.key({ modkey }, 'c',--'#' .. i + 9,
      function() view_tag(4) end,
      {description = 'go to etc', group = 'tag'}
   ),
   awful.key({ modkey }, 'd',--'#' .. i + 9,
      function() view_tag(5) end,
      {description = 'go to man', group = 'tag'}
   ),
   awful.key({ modkey }, 's',--'#' .. i + 9,
      function() view_tag(6) end,
      {description = 'go to cfg', group = 'tag'}
   ),
   awful.key({ modkey }, '`',--'#' .. i + 9,
      function() view_tag(6) end,
      {description = 'go to cmd', group = 'tag'}
   ),
   awful.key({ modkey }, 'a',--'#' .. i + 9,
      function() view_tag(8) end,
      {description = 'go to pwd', group = 'tag'}
   ),
   awful.key({ modkey }, 'v',--'#' .. i + 9,
      function() view_tag(7) end,
      {description = 'go to cfg', group = 'tag'}
   ),
   awful.key({ modkey }, '.',--'#' .. i + 9,
      function() view_tag(7) end,
      {description = 'go to cfg', group = 'tag'}
   )

   -- awful.key({ modkey, }, '`',
   --    function ()
   --       local matcher = function(c)
   --          return awful.rules.match(c, {class='Pcmanfm'})
   --       end
   --       awful.client.run_or_raise('pcmanfm', matcher)
   --    end,
   --    {description = '                  open pcmanfm', group = 'launcher'}),

)

for i = 1, 9 do
   globalkeys = awful.util.table.join(
      globalkeys,
      -- View tag only.
      awful.key({ modkey }, '#' .. np_map[i],--'#' .. i + 9,
         function() view_tag(i) end,
         {description = 'view tag #'..i, group = 'tag'}
      ),
      -- awful.key({ '#135j' }, '#' .. i + 9,--'#' .. i + 9,
      --    function() view_tag(i) end
      -- ),
      -- View tag only.
      awful.key({ modkey }, '#' .. i + 9,
         function() view_tag(i) end
      ),
      -- Toggle tag display.
      awful.key({ modkey, 'Control' }, '#' .. i + 9,
         function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
         end,
         {description = 'toggle tag #' .. i, group = 'tag'}),
      -- Move client to tag.
      awful.key({ modkey, 'Shift' }, '#' .. i + 9,
         function ()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:move_to_tag(tag)
               end
            end
         end,
         {description = 'move focused client to tag #'..i,
          group = 'tag'}),
      -- Toggle tag on focused client.
      awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9,
         function ()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:toggle_tag(tag)
               end
            end
         end,
         {description = 'toggle focused client on tag #' .. i,
          group = 'tag'}
      ),
      awful.key({ modkey, 'Shift'} , '#' .. np_map[i],
         function() move_to_tag(i) end,
         {description = 'move to tag #' .. i, group = 'navigation'}
      )--,
   )
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ #RULES
-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
   },
   { rule = { class = 'nwnmain-linux'},
     properties = { floating = true, maximized = true, fullscreen = true, ontop=true, minimize=false}
   },
   { rule = { class = 'Conky'},
     properties = { border_width = 0 }
   },
   { rule = { class = 'Zathura'},
     properties = {tag='man'}
   },
   { rule = { name = 'ranger', instance = 'Xterm'},
     properties = {tag='pwd'}
   },
   { rule = { class = 'Plank'},
     properties = {
        border_width=0,
        floating = true,
        sticky = true,
        ontop = true,
        focusable = false,
        below = true,
     }
   },
   -- { rule = { instance = 'cairo-dock' },
   -- --      type = 'dock',
   --       properties = {
   --          floating = true,
   --          ontop = true,
   --          focus = false
   --       }
   --    },
   -- Floating clients.
   { rule_any = {
        instance = {
           'DTA',  -- Firefox addon DownThemAll.
           'copyq',  -- Includes session name in class.
        },
        class = {
           'Galculator',
           'GoldenDict',
           'URxvt',
           'Arandr',
           'Gpick',
           'Kruler',
           'MessageWin',  -- kalarm.
           'Sxiv',
           'Wpa_gui',
           'pinentry',
           'veromix',
           'xtightvncviewer'},

        name = {
           'Event Tester',  -- xev.
           'qae_exp',
           'MainWindow',
        },
        role = {
           'AlarmWindow',  -- Thunderbird's calendar.
           'pop-up',       -- e.g. Google Chrome's (detached) Developer Tools.
        }
   }, properties = { floating = true }},
   { rule = {class = 'Pcmanfm'},
     properties = { tag = 'pwd'},
   },

   -- Add titlebars to normal clients and dialogs
   { rule_any = {type = { 'normal', 'dialog' }
                }, properties = { titlebars_enabled = true }
   },

   -- Set Firefox to always map on the tag named '2' on screen 1.
   -- { rule = { class = 'Firefox' },
   --   properties = { screen = 1, tag = '2' } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.

client.connect_signal(
   'manage', function (c)
      -- Set the windows at the slave,
      -- i.e. put it at the end of others instead of setting it master.
      -- if not awesome.startup then awful.client.setslave(c) end

      if awesome.startup and
         not c.size_hints.user_position
      and not c.size_hints.program_position then
         -- Prevent clients from being unreachable after screen count changes.
         awful.placement.no_offscreen(c)
      end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
   'request::titlebars', function(c)
      -- buttons for the titlebar
      local buttons = awful.util.table.join(
         awful.button({ }, 1, function()
               client.focus = c
               c:raise()
               awful.mouse.client.move(c)
         end),
         awful.button({ }, 3, function()
               client.focus = c
               c:raise()
               awful.mouse.client.resize(c)
         end)
      )

      -- REMOVED DEKORATOR
      -- awful.titlebar(c) : setup {
      --    { -- Left
      --       awful.titlebar.widget.iconwidget(c),
      --       buttons = buttons,
      --       layout  = wibox.layout.fixed.horizontal
      --    },
      --    { -- Middle
      --       { -- Title
      --          align  = 'center',
      --          widget = awful.titlebar.widget.titlewidget(c)
      --       },
      --       buttons = buttons,
      --       layout  = wibox.layout.flex.horizontal
      --    },
      --    { -- Right
      --       awful.titlebar.widget.floatingbutton (c),
      --       awful.titlebar.widget.maximizedbutton(c),
      --       awful.titlebar.widget.stickybutton   (c),
      --       awful.titlebar.widget.ontopbutton    (c),
      --       awful.titlebar.widget.closebutton    (c),
      --       layout = wibox.layout.fixed.horizontal()
      --    },
      --    layout = wibox.layout.align.horizontal
      -- }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
   'mouse::enter',
   function(c)
      if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
         and awful.client.focus.filter(c)
      then
         client.focus = c
      end
   end
)

function border_adjust(c)
   if c.maximized then -- no borders if only 1 client visible
      c.border_width = 0
   elseif #awful.screen.focused().clients > 1 then
      c.border_width = beautiful.border_width
      c.border_color = beautiful.border_focus
   end
end

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- client.connect_signal('property::maximized', border_adjust)
-- client.connect_signal('focus', border_adjust)
-- client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)
-- client.connect_signal(
--    'focus', function(c)
--       c.border_color = beautiful.border_focus end)
-- client.connect_signal(
--    'unfocus', function(c)
--       c.border_color = beautiful.border_normal end)
-- }}}
