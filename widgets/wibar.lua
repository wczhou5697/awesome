local _M = {}

-- TODO add power icon 
local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'

local apps = require'config.apps'
local mod = require'bindings.mod'

_M.awesomemenu = {
   {'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
   {'manual', apps.manual_cmd},
   {'edit config', apps.editor_cmd .. ' ' .. awesome.conffile},
   {'restart', awesome.restart}
}

_M.mainmenu = awful.menu{
   items = {
      {'awesome', _M.awesomemenu, beautiful.awesome_icon},
      {'open terminal', apps.terminal},
      {'quit', function() awesome.quit() end},
   }
}

_M.launcher = awful.widget.launcher{
   image = beautiful.awesome_icon,
   menu = _M.mainmenu
}

function _M.create_promptbox() return awful.widget.prompt() end

function _M.create_layoutbox(s)
   return awful.widget.layoutbox{
      screen = s,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function() awful.layout.inc(1) end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function() awful.layout.inc(1) end,
         },
      }
   }
end

function _M.create_taglist(s)
   return awful.widget.taglist{
      screen = s,
      filter = awful.widget.taglist.filter.noempty,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function(t) t:view_only() end,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 1,
            on_press  = function(t)
               if client.focus then
                  client.focus:move_to_tag(t)
               end
            end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = awful.tag.viewtoggle,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 3,
            on_press  = function(t)
               if client.focus then
                  client.focus:toggle_tag(t)
               end
            end
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function(t) awful.tag.viewprev(t.screen) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function(t) awful.tag.viewnext(t.screen) end,
         },
      }
   }
end

function _M.create_tasklist(s)
   return awful.widget.tasklist{
      screen = s,
      filter = awful.widget.tasklist.filter.focused,
   }
end

function _M.create_wibox(s)
   return awful.wibar{
      screen = s,
      position = 'top',
      height = 35,
      widget = {
         layout = wibox.layout.align.horizontal,
         expand = "outside",
         -- left widgets
         {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            {
               s.layoutbox,
               top = 5,
               bottom = 5,
               left = 10,
               widget = wibox.container.margin,
            },
            s.tasklist,
         },
         -- middle widgets
         {
            s.taglist,
            valign = 'center',
            widget = wibox.container.place,
         },
         -- right widgets
         {
            {
               widget = wibox.container.place,
               halign = "right",
               {
                  layout = wibox.layout.fixed.horizontal,
                  spacing = 5,
                  {
                     text = "",
                     font = "Material Symbols Rounded",
                     widget = wibox.widget.textbox,
                  },
                  {
                     format = "%a %d/%m",
                     font   = "JetBrains Mono",
                     widget = wibox.widget.textclock,
                  },
                  {
                     text = "",
                     font = "Material Symbols Rounded",
                     widget = wibox.widget.textbox,
                  },
                  {
                     format = "%H:%M",
                     font   = "JetBrains Mono",
                     widget = wibox.widget.textclock,
                  },
               }
            },
            widget = wibox.container.margin,
            right =  10,
         }
      }
   }
end

return _M
