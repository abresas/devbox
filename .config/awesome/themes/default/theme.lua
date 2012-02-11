---------------------------
-- Default awesome theme --
---------------------------

-- {{{ Definitions
theme = {}
theme.icons = os.getenv("HOME") .. "/.config/awesome/icons/zenburn"
theme.default = "/usr/share/awesome/themes/default"
-- }}}
-- {{{ Attributes
-- theme.font          = "sans 8"
-- theme.font          = "Droid Sans 8"
theme.font          = "Terminus 8"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "2"
theme.border_normal = "#000000"
theme.border_focus  = "#000000"
--theme.border_focus  = "#FFFE45"
theme.border_marked = "#91231c"

theme.border_widget    = nil
theme.fg_off_widget    = "#494B4F"
theme.fg_widget        = "#FF5656"
theme.fg_center_widget = "#88A175"
theme.fg_end_widget    = "#AECF96"
theme.fg_netup_widget  = "#7F9F7F"
theme.fg_netdn_widget  = theme.fg_urgent
theme.bg_widget        = theme.bg_normal
theme.border_widget    = theme.bg_normal

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- overriding the default one when
-- There are other variable sets
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
-- }}}
-- {{{ Taglist 
-- Display the taglist squares
theme.taglist_squares_sel    = theme.default .. "/taglist/squarefw.png"
theme.taglist_squares_unsel  = theme.default .. "/taglist/squarew.png"
theme.tasklist_floating_icon = theme.default .. "/tasklist/floatingw.png"
-- }}}
-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.default .. "/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}
-- {{{ Images 
-- Define the image to load
--theme.titlebar_close_button_normal              = theme.default .. "/titlebar/close_normal.png"
theme.titlebar_close_button_normal = os.getenv("HOME") .. "/.config/awesome/icons/close.png"
theme.titlebar_close_button_focus = os.getenv("HOME") .. "/.config/awesome/icons/close.png"
--theme.titlebar_close_button_focus               = theme.default .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = os.getenv("HOME") .. "/.config/awesome/icons/ontop.png"
theme.titlebar_ontop_button_focus_inactive = os.getenv("HOME") .. "/.config/awesome/icons/ontop.png"
theme.titlebar_ontop_button_normal_active = os.getenv("HOME") .. "/.config/awesome/icons/ontop_active.png"
theme.titlebar_ontop_button_focus_active = os.getenv("HOME") .. "/.config/awesome/icons/ontop_active.png"

-- You can use your own command to set your wallpaper
-- theme.wallpaper_cmd = { "awsetbg /usr/share/awesome/themes/default/background.png"}
theme.wallpaper_cmd = { "awsetbg -f " .. os.getenv("HOME") .. "/downloads/rassilon.jpg" }

-- You can use your own layout icons like this:
theme.layout_fairh      = theme.default .. "/layouts/fairhw.png"
theme.layout_fairv      = theme.default .. "/layouts/fairvw.png"
theme.layout_floating   = theme.default .. "/layouts/floatingw.png"
theme.layout_magnifier  = theme.default .. "/layouts/magnifierw.png"
theme.layout_max        = theme.default .. "/layouts/maxw.png"
theme.layout_fullscreen = theme.default .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = theme.default .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = theme.default .. "/layouts/tileleftw.png"
theme.layout_tile       = theme.default .. "/layouts/tilew.png"
theme.layout_tiletop    = theme.default .. "/layouts/tiletopw.png"
theme.layout_spiral     = theme.default .. "/layouts/spiralw.png"
theme.layout_dwindle    = theme.default .. "/layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"


theme.widget_bat    = theme.icons .. "/bat.png"
theme.widget_cpu    = theme.icons .. "/cpu.png"
theme.widget_crypto = theme.icons .. "/crypto.png"
theme.widget_date   = theme.icons .. "/time.png"
theme.widget_fs     = theme.icons .. "/disk.png"
theme.widget_mail   = theme.icons .. "/mail.png"
theme.widget_music  = theme.icons .. "/music.png"
theme.widget_mem    = theme.icons .. "/mem.png"
theme.widget_net    = theme.icons .. "/down.png"
theme.widget_netup  = theme.icons .. "/up.png"
theme.widget_org    = theme.icons .. "/cal.png"
theme.widget_temp   = theme.icons .. "/temp.png"
theme.widget_sep    = theme.icons .. "/separator.png"
theme.widget_vol    = theme.icons .. "/vol.png"
theme.widget_wifi   = theme.icons .. "/wifi.png"
-- }}}

return theme
-- vim:set filetype=lua expandtab shiftwidth=4 tabstop=8 softtabstop=4 textwidth=80 foldmethod=marker nospell:
