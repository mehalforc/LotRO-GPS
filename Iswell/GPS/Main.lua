--[[
   Copyright 2025 SteveB (Iswell)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

-- Common imports.
import("Turbine")
import("Turbine.Gameplay")
import("Turbine.UI")
import("Turbine.UI.Lotro")

-- Utility functions
import("Iswell.GPS.Functions.GameWindowPieces")
import("Iswell.GPS.Functions.PluginCheck")
import("Iswell.GPS.Functions.Messages")

-- Map Database
import("Iswell.GPS.MapData.OutsideMapPoints")
import("Iswell.GPS.MapData.CategoryDescription")

-- Set the player's current locale
_G.locale = Turbine.Engine.GetLocale()

-- Set up the GPS alias based on locale using a table lookup
local actions = {
  en = function()
    return "/loc"
  end,
  de = function()
    return "/pos"
  end,
  fr = function()
    return "/emp"
  end,
}
local defaultLocale = function()
  return "/loc"
end
local selectedLocale = actions[locale] or defaultLocale
_G.aliasLocation = selectedLocale()
_G.aliasWaypoint = "/way help"

-- Initialize plugin on load
function Initialize()
  MessagesLoading()
  LoadCategory()
  LoadMap()
  ShowMyIcon()
  _G.plugins = { "Waypoint" }
  _G.allPluginsCheck = CheckPlugin(plugins)

  _G.okLoadMessage = "Welcome to GPS!!!\nPlease select a Category from above..."
  _G.okColor = Turbine.UI.Color.Gold

  if _G.allPluginsCheck then
    MessagesPluginsLoaded()
  end
end

-- Initialize plugin on load
Initialize()

-- /way help
-- /way show
-- /way hide
-- /way target <coordinate>
