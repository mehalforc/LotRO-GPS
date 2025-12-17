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

-- Detect game locale
local locale = Turbine.Engine.GetLocale()

-- Table of GPS aliases by locale
local actions = {
  en = "/loc",
  de = "/pos",
  fr = "/emp",
}

-- Fallback if locale not found
local defaultAlias = "/loc"

-- Select alias
_G.aliasLocation = actions[locale] or defaultAlias
_G.aliasWaypoint = "/way help"

-- Initialize plugin on load
function Initialize()
  MessagesLoading()
  LoadCategory()
  LoadMap()
  ShowMyIcon()
  _G.plugins = { "Waypoint" }
  _G.allPluginsCheck = CheckPlugin(plugins)

  _G.T = {}
  local localeMap = {
    en = "Iswell.GPS.Locales.en",
    de = "Iswell.GPS.Locales.de",
    fr = "Iswell.GPS.Locales.fr",
  }

  -- Pick the module path, default to English
  local modulePath = localeMap[locale] or localeMap["en"]

  -- Load the translations
  import(modulePath)

  -- Use the translated string
  _G.okLoadMessage = _G.T and _G.T.MAIN_WELCOME or "Welcome"

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
