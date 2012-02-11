--
-- (c) 2011 Juan C. Muller
--
-- This program is free software; you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by the Free
-- Software Foundation; either version 2 of the License, or (at your option)
-- any later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-- more details.
--
-- You should have received a copy of the GNU General Public License along with
-- this program; if not, write to the Free Software Foundation, Inc., 51
-- Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

-- Awesome configuration

-- TODO
-- globalkeys:
-- 	* Check if tag key pressed is different from current tag, and only change
-- 	  if so. This will prevent the history form getting messed up.

-- {{{ Libraries 
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")

-- Theme handling library
require("beautiful")

-- support for awesome-client
require("awful.remote")

-- Notification library
require("naughty")

-- Revelation (https://github.com/bioe007/awesome-configs/blob/master/revelation.lua)
require("revelation")

-- Different system status widget providers
require("vicious")

-- Application switcher 
require("aweswt")
-- }}}
-- {{{ Variable Definitions
-- Themes define colors, icons, and wallpapers
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
local commands = {
	terminal        = "sakura",
	editor          = "sakura -x vim",
	browser_chrome  = "chromium",
	capture_task    = "capture_task.sh",
	suspend         = "/usr/sbin/pm-suspend",
	manual          = "sakura -x man awesome",
	autolock_now    = "xautolock -enable && xautolock -locknow",
	xlock           = "xlock +usefirst -echokey '*' -echokeys -timeout 3 -lockdelay 5 -mode blank",
	pianobar = {
		toggle  = "pianobar-toggle",
		status  = "pianobar-status",
		stop    = "pianobar-stop",
		next    = "pianobar-next",
		love    = "pianobar-love",
		ban     = "pianobar-ban",
		station = "pianobar-choose-station",
	},
	awesome = {
		debug   = "awesome-debug.sh"
	},
}

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell

local default_submenu_position = { x = 525, y = 330 }

-- Define menu keys
awful.menu.menu_keys.down  = { "Down",   "j" }
awful.menu.menu_keys.up    = { "Up",     "k" }
awful.menu.menu_keys.exec  = { "Right",  "l", "Return" }
awful.menu.menu_keys.back  = { "Left",   "h", "Backspace" }
awful.menu.menu_keys.close = { "Escape" }

-- }}}
-- {{{ Function Definitions 
function show_window_info(c)
	local geom = c:geometry()

	local t = ""
	if c.class    then t = t .. "<b>Class</b>: "    .. c.class    .. "\n" end
	if c.instance then t = t .. "<b>Instance</b>: " .. c.instance .. "\n" end
	if c.role     then t = t .. "<b>Role</b>: "     .. c.role     .. "\n" end
	if c.name     then t = t .. "<b>Name</b>: "     .. c.name     .. "\n" end
	if c.type     then t = t .. "<b>Type</b>: "     .. c.type     .. "\n" end
	if geom.width and geom.height and geom.x and geom.y then
		t = t .. "<b>Dimensions</b>: <b>x</b>:" .. geom.x .. "<b> y</b>:" .. geom.y .. "<b> w</b>:" .. geom.width .. "<b> h</b>:" .. geom.height
	end

	naughty.notify({
		text = t,
		timeout = 30
	})
end

function toggle_titlebar(c)
	if c.titlebar then
 		awful.titlebar.remove(c)
	else
		awful.titlebar.add(c, { modkey = modkey, height = "20" })
	end
end

function toggle_titlebar(c)
	if c.titlebar then
		awful.titlebar.remove(c)
	else
		awful.titlebar.add(c, { modkey = modkey, height = "20" })
	end
end

function toggle_minimized(c)
	c.minimized = not c.minimized
end

function toggle_maximized_vertical(c)
	c.maximized_vertical = not c.maximized_vertical
end

function toggle_maximized(c)
	c.maximized_horizontal = not c.maximized_horizontal
	c.maximized_vertical   = not c.maximized_vertical
	set_client_border_color(c)
	client.focus = c
	c:raise()
end

function focus_last_focused()
	awful.client.focus.history.previous()
	if client.focus then
		client.focus:raise()
	end
end

function toggle_main_menu_and_set_keys(position)
	options = { keygrabber = true }
	if position then
		options.coords = position
	end
	mpdmenu:hide()
	pianobarmenu:hide()
	mymainmenu:toggle(options)
end

function dmenu_prompt()
	sexec("exec `dmenu_run -l 2 -nf '#888888' -nb '#222222' -sf '#ffffff' -sb '#285577' -p 'run application:' -fn 'Terminus 8' -i`")
end

-- This will be set from an external utility
musiccover = {
	path = '',
	body = ''
}

local musicnotification = nil
function show_music_notification()
	if musiccover.path == "" then
		return nil
	else
		if not musicnotification then
			musicnotification = naughty.notify({
				timeout = 0,
				icon = musiccover.path,
				text = musiccover.body,
				position = "bottom_right",
				run = function()
					naughty.destroy(musicnotification)
					musicnotification = nil
				end
			})
		else
			naughty.destroy(musicnotification)
			musicnotification = nil
		end
	end
end

function show_mpd_menu(position)
	options = { keygrabber = true }
	if position then
		options.coords = position
	end
	mymainmenu:hide()
	pianobarmenu:hide()
	mpdmenu:toggle(options)
end

function show_pianobar_menu(position)
	options = { keygrabber = true }
	if position then
		options.coords = position
	end
	mymainmenu:hide()
	mpdmenu:hide()
	pianobarmenu:toggle(options)
end

function run_once(prg)
	if not prg then
		do return nil end
	end
	sexec("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
end

function set_client_border_color(c)
	if c then
		if not (
			awful.layout.get(c.screen) == awful.layout.suit.max
			or awful.layout.get(c.screen) == awful.layout.suit.max.fullscreen
			or awful.layout.get(c.screen) == awful.layout.suit.magnifier
			or (c.maximized_horizontal and c.maximized_vertical)
			or c.fullscreen
		) then
			c.border_color = beautiful.border_focus
		else
			c.border_color = beautiful.border_normal
		end
	end
end

function create_vertical_progress_bar()
	bar = awful.widget.progressbar()
	bar:set_vertical(true)
	bar:set_width(8)
	bar:set_border_color(beautiful.border_widget)
	bar:set_background_color(beautiful.fg_off_widget)
	bar:set_gradient_colors ({
		beautiful.fg_widget,
		beautiful.fg_center_widget,
		beautiful.fg_end_widget
	})

	return bar
end

-- Change layout and define whether focused client needs border highlighted
-- @param increment
function change_layout(inc)
	awful.layout.inc(layouts, inc)
	set_client_border_color(client.focus)
end

function get_definition(word)
	local f = io.popen("dict -d wn " .. word .. " 2>&1")
	--local f = io.popen("dict " .. word .. " 2>&1")
	local fr = ""
	for line in f:lines() do
		fr = fr .. line .. '\n'
	end
	f:close()
	naughty.notify({ text = fr, timeout = 0, width = 450 })
end

local clientsmenu = nil
function toggle_clients_menu(default_position)
	local options = { keygrabber = true }
	if default_position then
		options.coords = default_submenu_position
	end
	if clientsmenu then
		clientsmenu:hide()
		clientsmenu = nil
	else
		clientsmenu = awful.menu.clients({ width = 250 }, options)
	end
end

function get_volume()

    local mixer_state = {
        ["on"]  = "♫", -- "",
        ["off"] = "♩"  -- "M"
    }

    -- Get mixer control contents
    local f = io.popen("amixer get Master")
    local mixer = f:read("*all")
    f:close()

    -- Capture mixer control state:          [5%] ... ... [on]
    local vol, mute = string.match(mixer, "([%d]+)%%.*%[([%l]*)")

    -- Handle mixers without mute
    if mute == "" and vol == "0"
    -- Handle mixers that are muted
    or mute == "off" then
       mute = mixer_state["off"]
    else
       mute = mixer_state["on"]
    end

	volwidget.text = string.format("%s%s", vol, mute)
	awful.widget.progressbar.set_value(volbar, tonumber(vol) / 100)
end

function change_volume(lower)
	local sign = '+'
	if lower == true then
		sign = '-'
	else
		exec("amixer -q set Master on", false)
	end
	exec("amixer -q set Master 2dB" .. sign, false)
	get_volume()
end

function mute_volume()
	exec("amixer -q set Master toggle", false)
	get_volume()
end
-- {{{ Debug function
function dbg(vars)
	local text = ""
	for i=1, #vars do text = text .. vars[i] .. " | " end
	naughty.notify({ text = text, timeout = 0 })
end
-- }}}
-- }}}
-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.fair,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.magnifier,
	awful.layout.suit.floating,
}
-- }}}
-- {{{ Tags
-- Define a tag table which hold all screen tags.
labels1 = { "main", "work", "web", "skype", "music", "p2p", "other" }

tags = {
	settings = {
		{
			names  = labels1,
			layout = {
				awful.layout.suit.tile,
				awful.layout.suit.tile,
				awful.layout.suit.tile,
				awful.layout.suit.floating,
				awful.layout.suit.max,
				awful.layout.suit.max,
				awful.layout.suit.max,
				awful.layout.suit.max,
			}
		},
	}
}

for s = 1, screen.count() do
	tags[s] = awful.tag(tags.settings[s].names, s, tags.settings[s].layout)
end
-- }}}
-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
	{ "manual",      commands.manual},
	{ "edit config", commands.editor .. " " .. awful.util.getdir("config") .. "/rc.lua" },
	{ "debug",       commands.awesome.debug },
	{ "restart",     awesome.restart },
	{ "quit",        awesome.quit },
}

mymainmenu = awful.menu.new({
	auto_expand = true,
	items = {
		{ "awesome",  myawesomemenu, beautiful.awesome_icon },
		{ "chrome",   commands.browser_chrome },
		{ "editor",   commands.editor },
		{ "terminal", commands.terminal },
	}
})

mylauncher = awful.widget.launcher({
	image = image(beautiful.awesome_icon),
	menu = mymainmenu
})
-- }}}
-- {{{ Music Menus
mpdmenu = awful.menu.new({
	auto_expand = true,
	items = {
		{ "toggle", "mpc toggle" },
		{ "pause",  "mpc pause"  },
		{ "play",   "mpc play"   },
		{ "next",   "mpc next"   },
		{ "prev",   "mpc prev"   },
	}
})

pianobarmenu = awful.menu.new({
	auto_expand = true,
	items = {
		{ "play/pause", commands.pianobar.toggle  },
		{ "status",     commands.pianobar.status  },
		{ "stop",       commands.pianobar.stop   },
		{ "next",       commands.pianobar.next    },
		{ "station",    commands.pianobar.station },
		{ "love",       commands.pianobar.love    },
		{ "ban",        commands.pianobar.ban     },
		{ "pianobar" },
	}
})
-- }}}
-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
-- }}}
-- {{{ Wibox
-- {{{ Clock 
-- Create a textclock widget
myclock = awful.widget.textclock({ align = "right" }, " %a %D %I:%M%P %Z ")

--local clockclicked = false

-- {{{ Systray 
-- Create a systray
mysystray = widget({ type = "systray" })
-- }}}
-- {{{ Task bar 
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({        }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({        }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({        }, 4, awful.tag.viewnext),
	awful.button({        }, 5, awful.tag.viewprev))

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if not c:isvisible() then
			awful.tag.viewonly(c:tags()[1])
		end
		client.focus = c
		c:raise()
	end),
	awful.button({ }, 3, function () toggle_clients_menu(false) end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end))
-- }}}
--
-- {{{ Weather
tempicon = widget({ type = "imagebox" })
tempicon.image = image(beautiful.widget_temp)

homeweather = widget({ type = "textbox" })
vicious.register(homeweather, vicious.widgets.weather, "${tempc}C", 300, "LGAV")

--coretemp = widget({ type = "textbox" })
--vicious.register(coretemp, vicious.widgets.thermal, "core: $1C", 3, "core")

--proctemp = widget({ type = "textbox" })
--vicious.register(proctemp, vicious.widgets.thermal, "proc: $1C", "proc")

--systemp = widget({ type = "textbox" })
--vicious.register(systemp, vicious.widgets.thermal, "sys: $1C", "sys")
-- }}}
--
-- {{{ Set Up
for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
		awful.button({ }, 1, function () change_layout(1) end),
		awful.button({ }, 3, function () change_layout(-1) end),
		awful.button({ }, 4, function () change_layout(1) end),
		awful.button({ }, 5, function () change_layout(-1) end)))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(function(c)
		return awful.widget.tasklist.label.currenttags(c, s)
	end, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s, border_width = 1, border_color = "#000000" })
	-- Add widgets to the wibox - order matters
	mywibox[s].widgets = {
		{
			mylauncher,
			mytaglist[s],
			mypromptbox[s],
			layout = awful.widget.layout.horizontal.leftright
		},
		mylayoutbox[s],
		tempicon, homeweather, separator,
		myclock, separator,
		s == 1 and mysystray or nil,
		s == 1 and separator or nil,
		mytasklist[s], separator,
		layout = awful.widget.layout.horizontal.rightleft
	}
end
-- }}}
-- }}}
-- {{{ My Wibox
-- {{{ Set vicious caching
vicious.cache(vicious.widgets.mem)
vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.uptime)
vicious.cache(vicious.widgets.volume)
-- }}}
-- {{{ Battery 
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)

batterywidget = widget({type = "textbox", name = "batterywidget", align="right"})
vicious.register(batterywidget, vicious.widgets.bat, "$1 $2% $3 ", 61, "BAT0")

batterybar = create_vertical_progress_bar()
vicious.register(batterybar, vicious.widgets.bat, "$2", 61, "BAT0")

-- }}}
-- {{{ Music Status
-- Initialize widget
musicicon = widget({ type = "imagebox" })
musicicon.image = image(beautiful.widget_music)

-- Music widget gets populated by an external application using awesome-client
musicwidget = widget({ type = "textbox" })
musicwidget.text = "  -  "
-- Register widget
vicious.register(musicwidget, vicious.widgets.mpd,
   function (widget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return ' ' .. args["{Artist}"]..' (' .. args["{Album}"] .. ') - '.. args["{Title}"]
        end
    end, 10)
-- }}}
-- {{{ Memory & Swap
-- Initialize widget
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)

--
-- Initialize widget
membar = create_vertical_progress_bar()
vicious.register(membar, vicious.widgets.mem, "$1", 30)

-- }}}
-- {{{ CPU Info (usage & freq)
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)

cpugraph = awful.widget.graph()
cpugraph:set_width(40)
cpugraph:set_background_color("#494B4F")
cpugraph:set_color("#FF5656")
cpugraph:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
vicious.register(cpugraph, vicious.widgets.cpu, "$1 ", 10)
-- }}}
-- {{{ Uptime
uptimewidget = widget({ type = "textbox" })
vicious.register(uptimewidget, vicious.widgets.uptime,
	function (widget, args)
		return string.format(" %2d<i>d</i> %02d<i>h</i> %02d<i>m</i>", args[1], args[2], args[3])
	end, 60)
	--
-- }}}
-- {{{ Volume 
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)

volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume, "$1$2", 11, "Master")

volbar    = create_vertical_progress_bar()
vicious.register(volbar,    vicious.widgets.volume,  "$1",  11, "Master")
-- }}}
-- {{{ Network usage
dnicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)

upicon = widget({ type = "imagebox" })
upicon.image = image(beautiful.widget_netup)

netwidget = widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${eth1 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${eth1 up_kb}</span>', 5)
-- }}}
-- {{{ Register buttons

-- widgets that pop out 'top' output
widgets = {
	cpuicon,
	memicon,
	uptimewidget,
}

for i = 1, table.getn(widgets) do
	widgets[i]:buttons(awful.util.table.join(awful.button({ }, 1, show_top_output)))
end

volbar.widget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () exec("gnome-volume-control") end),
	awful.button({ }, 2, mute_volume),
	awful.button({ }, 4, function () change_volume(false) end),
	awful.button({ }, 5, function () change_volume(true) end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())
volicon:buttons(volbar.widget:buttons())

musicwidget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () show_pianobar_menu(nil) end),
	awful.button({ }, 3, function () show_mpd_menu(nil) end)
))
musicicon:buttons(musicwidget:buttons())

awful.tooltip({
	objects = { musicwidget },
	timer_function = function ()
		return musiccover.body
	end,
})

-- }}}
-- {{{ Set up
mywibox2 = {}
mywibox2 = awful.wibox({ position = "bottom", screen = 1, border_width = 1, border_color = '#000000' })
mywibox2.widgets = {
	{
		-- Left to Right
		dnicon, netwidget, upicon,
		baticon, batterybar,
		memicon, membar,
		cpuicon, cpugraph,
		uptimewidget,
		layout = awful.widget.layout.horizontal.leftright
	},
	-- Right to Left
	volbar.widget, volwidget, volicon, separator,
	musicwidget, musicicon, separator, 
	layout = awful.widget.layout.horizontal.rightleft
}
-- }}}
-- }}}
-- {{{ Mouse root bindings
root.buttons(awful.util.table.join(
	--awful.button({ }, 1, function () mymainmenu:hide(); mpdmenu:hide(); pianobarmenu:hide(); end),
	awful.button({ }, 1, function () exec( "mpc toggle" ) end ),
	awful.button({ }, 3, toggle_main_menu_and_set_keys),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ Key bindings
local globalkeys = awful.util.table.join(
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

	awful.key({ modkey,           }, "j", function () awful.client.focus.byidx( 1) if client.focus then client.focus:raise() end end),
	awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) if client.focus then client.focus:raise() end end),

	awful.key({ modkey,           }, "w", function () toggle_main_menu_and_set_keys(default_submenu_position) end),

	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j",   function () awful.client.swap.byidx(  1) end),
	awful.key({ modkey, "Shift"   }, "k",   function () awful.client.swap.byidx( -1) end),
	awful.key({ modkey, "Control" }, "j",   function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k",   function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u",   awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab", focus_last_focused),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () exec(commands.terminal) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
	awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
	awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

	awful.key({ modkey,           }, "space", function () change_layout( 1) end),
	awful.key({ modkey, "Shift"   }, "space", function () change_layout(-1) end),

	awful.key({ modkey            }, "b", function ()
		local show = not mywibox[mouse.screen].visible
		mywibox[mouse.screen].visible = show
		mywibox2.visible = show
	end),

	-- Music stuff
	awful.key({ modkey, "Shift"   }, "m",   function () show_mpd_menu(default_submenu_position) end),
	awful.key({ modkey, "Shift"   }, "p",   function () show_pianobar_menu(default_submenu_position) end),
	awful.key({ "Shift"           }, "F6",  function () exec(commands.pianobar.status) end),
	awful.key({ "Shift"           }, "F7",  function () naughty.notify({ text = "Imagine that pandora can go backwards." }) end),
	awful.key({ "Shift"           }, "F8",  function () exec(commands.pianobar.toggle) end),
	awful.key({ "Shift"           }, "F9",  function () exec(commands.pianobar.next) end),
	awful.key({ "Shift"           }, "F10", mute_volume),
	awful.key({ "Shift"           }, "F11", function () change_volume(true)  end),
	awful.key({ "Shift"           }, "F12", function () change_volume(false) end),


	-- Prompt
	awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
	-- Prompt with dmenu (install dmenu)
	awful.key({ modkey }, "p", dmenu_prompt),
	-- Switch apps with dmenu
	awful.key({ modkey }, "a", aweswt.switch),
	-- LUA prompt
	awful.key({ modkey }, "x",
		function ()
			awful.prompt.run({ prompt = "Run Lua code: " },
			mypromptbox[mouse.screen].widget,
			awful.util.eval, nil,
			awful.util.getdir("cache") .. "/history_eval")
		end),

	-- Task list
	awful.key({ "Mod1" }, "Escape", function ()
		if clientsmenu then
			clientsmenu:hide()
			clientsmenu = nil
		end
		toggle_clients_menu(true)
	end),

	-- Present user with a prompt to enter a word to look for its definition
	awful.key({ modkey }, "d",
		function ()
			awful.prompt.run({ prompt = "Dict: " },
			mypromptbox[mouse.screen].widget,
			get_definition,
			nil, awful.util.getdir("cache") .. "/dict")
		end),

	-- Search for definition of word highlighted
	awful.key({ modkey, "Shift" }, "d",
		function ()
			local word = awful.util.pread("xsel -o")
			if word ~= "" then
				get_definition(word)
			end
		end),

	-- Revelation
	awful.key({ modkey }, "e", revelation.revelation)
)
-- }}}
-- {{{ Global key bindings
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
	keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
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
			end),
		awful.key({ modkey, "Mod1" }, "#" .. i + 9,
			function ()
				for s = 1, screen.count() do
					awful.tag.viewonly(tags[s][i])
				end
			end))
end

root.keys(globalkeys)
-- }}}
-- {{{ Rules
-- {{{ Client Key bindings
local clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",               function (c) c.fullscreen = not c.fullscreen set_client_border_color(c) end),
	awful.key({ modkey, "Shift"   }, "c",               function (c) c:kill() end),
	-- Teporary work around. 
	-- 	Super + Shift + C doesn't seem to be working on my keyboard.
	awful.key({ modkey, "Shift"   }, "w",               function (c) c:kill() end),
	awful.key({ modkey, "Control" }, "space",           awful.client.floating.toggle),
	awful.key({ modkey, "Control" }, "Return",          function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",               awful.client.movetoscreen),
	awful.key({ modkey, "Shift"   }, "r",               function (c) c:redraw() end),
	awful.key({ modkey, "Shift"   }, "t",               function (c) c.ontop = not c.ontop end),
	awful.key({ modkey,           }, "n",               toggle_minimized),
	awful.key({ modkey, "Shift"   }, "n",               toggle_minimized),
	awful.key({ modkey,           }, "m",               toggle_maximized),
	awful.key({ modkey,           }, "v",               toggle_maximized_vertical),
	awful.key({ modkey, "Shift"   }, "v",               toggle_maximized_vertical),
	awful.key({ modkey,           }, "t",               toggle_titlebar),
	awful.key({ modkey,           }, "s",               function (c) c.sticky = not c.sticky end),

	awful.key({ modkey, "Shift", "Control" }, "Down",   function () awful.client.moveresize(  0,   0,   0,  20) end),
	awful.key({ modkey, "Shift", "Control" }, "Up",      function () awful.client.moveresize(  0,   0,   0, -20) end),
	awful.key({ modkey, "Shift", "Control" }, "Right",  function () awful.client.moveresize(  0,   0,  20,   0) end),
	awful.key({ modkey, "Shift", "Control" }, "Left",   function () awful.client.moveresize(  0,   0, -20,   0) end),
	awful.key({ modkey, "Shift"   }, "Down",            function () awful.client.moveresize(  0,  20,   0,   0) end),
	awful.key({ modkey, "Shift"   }, "Up",              function () awful.client.moveresize(  0, -20,   0,   0) end),
	awful.key({ modkey, "Shift"   }, "Left",            function () awful.client.moveresize(-20,   0,   0,   0) end),
	awful.key({ modkey, "Shift"   }, "Right",           function () awful.client.moveresize( 20,   0,   0,   0) end),

	awful.key({ modkey,           }, "i",               show_window_info),

	awful.key({ modkey, "Control" }, "t",               commands.capture_task)
)
-- }}}

--  {{{ Client Buttons
local clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))
--  }}}

awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = true,
			keys = clientkeys,
			buttons = clientbuttons,
			size_hints_honor = false,
			maximized_horizontal = false,
			maximized_vertical   = false,
			fullscreen = false,
		},
	},
	{
		rule = { class = "Chromium-browser" },
        properties = {
            tag = tags[1][3]
        },
	},
	{
		rule = { class = "Skype" },
		properties = {
			tag = tags[1][4]
		},
        callback = toggle_titlebar,
	},
	{
		rule = { class = "Gmpc" },
        properties = {
            tag = tags[1][5]
        },
	},
	{
		rule = { class = "Gimp" },
		properties = { 
            floating = true,
            tag = tags[1][6]
        },
        callback = toggle_titlebar,
	},
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
		awful.client.setslave(c)

		-- Put windows in a smart way, only if they do not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)

client.add_signal("focus",   function(c) set_client_border_color(c) end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
-- {{{ Autostart
-- Network Manager
os.execute("nm-applet &")
-- Gnome settings
os.execute("gnome-power-manager &")
-- Gnome settings
os.execute("/usr/lib/gnome-settings-daemon/gnome-settings-daemon &")
-- }}}

-- vim:set ft=lua foldmethod=marker noexpandtab sw=4 ts=4:
