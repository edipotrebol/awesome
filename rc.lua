-- Standard awesome library
require("vicious")
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/edipotrebol/.config/awesome/themes/forrst/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
    {
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.floating,
        awful.layout.suit.max.fullscreen
    }
layouts_simple =
    {
        awful.layout.suit.floating,
        awful.layout.suit.max.fullscreen
    }

-- }}}

-- {{{ Tags

-- gold = 0.618
-- tags = {
--     --names  = { "♏",    "⌥",     "⌘",      "♒",      "☊",        "♓",     "♐",      "✿",  "♉"  },
--     --names = {  "1:code", "2:web", "3:chat", "4:term", "5:media", "6:work", "7:mail", "8:gimp", "9:play" },
--     { name = "♏",  layout = layouts[1], mwfact = 0.5 },
--     { name = "♐",   layout = layouts[1], mwfact = 0.55 },
--     { name = "⌘",  layout = layouts[1], mwfact = 0.6 },
--     --{ name = "✿♉♒",  layout = layouts[1], mwfact = 0.4, nmaster = 1, ncol = 2 },
--     { name = "☊", layout = layouts_simple[1], mwfact = 0.65 },
--     { name = "♒",  layout = layouts[1], mwfact = gold },
--     --{ name = "♒",  layout = layouts[1] },
--     { name = "⌥",  layout = layouts_simple[1], mwfact = 0.8 },
--     { name = "♓",  layout = layouts[12], hide = true },
-- }

-- for s = 1, screen.count() do
--     --tags[s] = {}
--     for i, v in ipairs(tags) do
--         tags[s][i] = tag({ name = v.name })
--         tags[s][i].screen = s
--         awful.tag.setproperty(tags[s][i], "layout", v.layout)
--         awful.tag.setproperty(tags[s][i], "mwfact", v.mwfact)
--         awful.tag.setproperty(tags[s][i], "ncol", v.ncol)
--         awful.tag.setproperty(tags[s][i], "nmaster", v.nmaster)
--         awful.tag.setproperty(tags[s][i], "hide",   v.hide)
--     end
--     tags[s][1].selected = true
-- end

tags = {
    names  = { "shell", "web", "editor", "media", "alt1", "alt2" },
    layout = { layouts[1], layouts_simple[1], layouts_simple[1], layouts_simple[1], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end

--}}}

-- }}}

-- {{{ Menu

-- {"Take screenshot", "import -window root ~/screenshot.png"}

myvolumemenu = {
    {"VolMute", "amixer -D pulse set Master 1+ mute"},
    {"VolUnmute", "amixer -D pulse set Master 1+ unmute"},
    {"VolInc", "amixer set Master 10%+"},
    {"VolDec", "amixer set Master 10%-"}
}

myadminmenu = {
    {"Volume", myvolumemenu}
}

myshutdownmenu = { 
	{ "Shutdown", "gksudo halt" },
	{ "Reboot", "gksudo reboot" },
	{ "LockScreen", "slock" },
	{ "Screensaver", "xscreensaver-command -lock" },
	{ "Suspend", "gksudo acpitool -s" }
}

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    --{ "Debian", debian.menu.Debian_menu.Debian },
                                    { "Admin", myadminmenu },
				                    { "shutdown", '~/.config/awesome/shutdown_dialog.sh'},
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget

-- Network usage widget
--Initialize widget

volume_widget = widget({ type = "textbox", name = "tb_volume",
    align = "center" })
function update_volume(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()
                                                                     
    local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
    -- volume = string.format("% 3d", volume)
    status = string.match(status, "%[(o[^%]]*)%]")
    -- starting colour
    local sr, sg, sb = 0x3F, 0x3F, 0x3F
    -- ending colour
    local er, eg, eb = 0xDC, 0xDC, 0xCC
    local ir = volume * (er - sr) + sr
    local ig = volume * (eg - sg) + sg
    local ib = volume * (eb - sb) + sb
    interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
    if string.find(status, "on", 1, true) then
        volume = " <span background='#" .. interpol_colour .. "'>   </span>"
    else
        volume = " <span color='red' background='#" .. interpol_colour .. "'> M </span>"
    end
    widget.text = volume
end

update_volume(volume_widget)
awful.hooks.timer.register(1, function () update_volume(volume_widget) end)

netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="#ffffff">Down:${wlan0 down_kb}</span> <span color="#ffffff">Up:${wlan0 up_kb}</span>', 3)

-- Memory widget
memwidget = widget({ type = "textbox" })
-- Register widget
--vicious.register(memwidget, vicious.widgets.mem, '<span color="#ffffff">Mem: $1% ($2MB/$3MB)</span>', 13)
vicious.register(memwidget, vicious.widgets.mem, '<span color="#ffffff">M$1%</span>', 13)
-- { Acpitool-based battery widget
mybattmon = widget({ type = "textbox", name = "mybattmon", align = "right" })
function battery_status ()
    local output={} --output buffer
    local fd=io.popen("acpitool -b", "r") --list present batteries
    local line=fd:read()
    while line do --there might be several batteries.
        local battery_num = string.match(line, "Battery \#(%d+)")
        local battery_load = string.match(line, " (%d*\.%d+)%%")
        local time_rem = string.match(line, "(%d+\:%d+)\:%d+")
	local discharging
	if string.match(line, "discharging")=="discharging" then --discharging: always red
		discharging="<span color=\"red\">"
	elseif tonumber(battery_load)>85 then --almost charged
		discharging="<span color=\"#ffffff\">"
	else --charging
		discharging="<span color=\"green\">"
	end
        if battery_num and battery_load and time_rem then
            --table.insert(output,discharging.."BAT#"..battery_num.." "..battery_load.."% "..time_rem.."</span>")
            table.insert(output,discharging..""..battery_load.."%("..time_rem..")</span>")
        elseif battery_num and battery_load then --remaining time unavailable
            table.insert(output,discharging..""..battery_num..""..battery_load.."%%</span>")
        end --even more data unavailable: we might be getting an unexpected output format, so let's just skip this line.
        line=fd:read() --read next line
    end
    return table.concat(output," ") 
-- FIXME: better separation for several batteries. maybe a pipe?
end
mybattmon.text = " " .. battery_status() .. " "
my_battmon_timer=timer({timeout=30})
my_battmon_timer:add_signal("timeout", function()
    --mytextbox.text = " " .. os.date() .. " "
    mybattmon.text = " " .. battery_status() .. " "
end)
my_battmon_timer:start()
-- } end acpitool battery widget

--graphical CPU Widget
-- Initialize widget
cpuwidget = awful.widget.graph()
--Graph properties
--cpuwidget:set_width(50)
--cpuwidget:set_background_color("#494B4F")
--cpuwidget:set_color("#FF5656")
--cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })

-- text CPU Widget
cpuwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="#ffffff">CPU$1%</span>')

--Seperators Widget
seperator = widget({ type = "textbox" })
 seperator.text  = "|"

--Text clock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
	seperator,
    volume_widget,
    seperator,
	mybattmon,
	seperator,
	netwidget,
	seperator,
	cpuwidget,
	seperator,
	memwidget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "w", awesome.quit),
    awful.key({ modkey, "Shift"   }, "q", function () awful.util.spawn("shutdown"); end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    --Volume 
    --awful.key({ modkey, "Control" }, "m", function()  amixer -D pulse set Master 1+ mute end),
    --awful.key({ modkey, "Control" }, "u", function()  amixer -D pulse set Master 1+ unmute end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
    
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)



-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
--

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "chromium-browser" },
      properties = { floating = true } },
    { rule = { class = "firefox" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    --{ rule = { class = "Firefox" },
    --  properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart Apps
--os.execute("nm-applet &")
awful.util.spawn_with_shell("~/.config/awesome/run_once /run_once nm-applet")
awful.util.spawn_with_shell("~/.config/awesome/run_once kupfer")
awful.util.spawn_with_shell("~/.config/awesome/run_once zeal")
