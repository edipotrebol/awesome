-- bamboo, awesome3 theme, by zhuravlik, based on Zenburn

--{{{ Main
require("awful.util")

theme = {}

home          = os.getenv("HOME")
config        = awful.util.getdir("config")
shared        = "/usr/share/awesome"
if not awful.util.file_readable(shared .. "/icons/awesome16.png") then
    shared    = "/usr/share/local/awesome"
end
sharedicons   = shared .. "/icons"
sharedthemes  = shared .. "/themes"
themes        = config .. "/themes"
themename     = "/rotate"
if not awful.util.file_readable(themes .. themename .. "/theme.lua") then
       themes = sharedthemes
end
themedir      = themes .. themename

wallpaper1    = themedir .. "/charlesdarwin.jpg"
--wallpaper1    = themedir .. "/elphomega.jpg"
wallpaper2    = sharedthemes .. "/default/wallpaper.png"
wpscript      = home .. "/.wallpaper"

if awful.util.file_readable(wallpaper1) then
	theme.wallpaper_cmd = { "feh --bg-scale " .. wallpaper1 }
elseif awful.util.file_readable(wallpaper2) then
	theme.wallpaper_cmd = { "awsetbg " .. wallpaper2 }
end

if awful.util.file_readable(config .. "/vain/init.lua") then
    theme.useless_gap_width  = "3"
end
--}}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors #dbcfaa
-- Green: #3a1e1a
theme.fg_normal = "#ffffff"
theme.fg_focus  = "#000000"
theme.fg_urgent = "#000000"
theme.bg_normal = "#000000"
theme.bg_focus  = "#ffffff"
theme.bg_urgent = "#ffffff"
-- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#ffffff"
theme.border_marked = "#ffffff"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#000000"
theme.titlebar_bg_normal = "#000000"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "30"
theme.menu_width  = "260"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themedir .. "/icons/taglist/squarefz.png"                                                                         
theme.taglist_squares_unsel = themedir .. "/icons/taglist/squareza.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themedir .. "/icons/awesome.png"
theme.menu_submenu_icon      = sharedthemes .. "/default/submenu.png"
theme.tasklist_floating_icon = sharedthemes .. "/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themedir .. "/icons/layouts/tile.png"
theme.layout_tileleft   = themedir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom = themedir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop    = themedir .. "/icons/layouts/tiletop.png"
theme.layout_fairv      = themedir .. "/icons/layouts/fairv.png"
theme.layout_fairh      = themedir .. "/icons/layouts/fairh.png"
theme.layout_spiral     = themedir .. "/icons/layouts/spiral.png"
theme.layout_dwindle    = themedir .. "/icons/layouts/dwindle.png"
theme.layout_max        = themedir .. "/icons/layouts/max.png"
theme.layout_fullscreen = themedir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier  = themedir .. "/icons/layouts/magnifier.png"
theme.layout_floating   = themedir .. "/icons/layouts/floating.png"
-- }}}

-- {{{ Titlebari
theme.titlebar_close_button_focus  = themedir .. "/icons/titlebar/close_focus.png"                                                              
theme.titlebar_close_button_normal = themedir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active    = themedir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active   = themedir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themedir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themedir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active    = themedir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active   = themedir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themedir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themedir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active    = themedir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active   = themedir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themedir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themedir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = themedir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = themedir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themedir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themedir .. "/icons/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
