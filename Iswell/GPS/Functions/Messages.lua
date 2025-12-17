--[[
    GPS - Messages Module
    Handles displaying messages for the GPS plugin.
]]

-- Common imports.
import("Turbine")
import("Turbine.Gameplay")
import("Turbine.UI")
import("Turbine.UI.Lotro")

-- Show loading message
function _G.MessagesLoading()
  local message = "Loading... <rgb=#ff00ff>" .. plugin:GetName() .. "</rgb> v" .. plugin:GetVersion() .. " by <rgb=#00ff00>" .. plugin:GetAuthor() .. "</rgb>"
  Turbine.Shell.WriteLine(message)
end

-- Show unloading message
function _G.MessagesUnloading()
  local message = "Unloading... <rgb=#ff00ff>" .. plugin:GetName() .. "</rgb> v" .. plugin:GetVersion() .. " by <rgb=#00ff00>" .. plugin:GetAuthor() .. "</rgb>"
  Turbine.Shell.WriteLine(message)
end

-- Show plugins loaded message
function _G.MessagesPluginsLoaded()
  local message = "All required plugins are loaded and running."
  Turbine.Shell.WriteLine("<rgb=#ff00ff>GPS:</rgb><rgb=#00ff00> " .. message .. "</rgb>")
end

-- Error message
function _G.MessagesPluginsError(pluginNotLoaded)
  local message = pluginNotLoaded .. " not loaded or running."
  Turbine.Shell.WriteLine("<rgb=#ff00ff>GPS:</rgb><rgb=#ff0000> " .. message .. "</rgb>")
end

-- Generic message
function _G.MessagesGeneric(message)
  message = string.gsub(message, "|", "\n")
  _G.label:SetText("GPS:\n" .. message)
  label:SetForeColor(Turbine.UI.Color.Green)
end

-- Generic ERROR message
function _G.MessagesGenericError(message)
  message = string.gsub(message, "|", "\n")
  _G.label:SetText("GPS:\n" .. message)
  label:SetForeColor(Turbine.UI.Color.Red)
end

-- Generic WARNING message
function _G.MessagesGenericWarning(message)
  message = string.gsub(message, "|", "\n")
  _G.label:SetText("GPS:\n" .. message)
  label:SetForeColor(Turbine.UI.Color.Yellow)
end
