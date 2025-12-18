--[[
    GPS - PluginCheck Module
    Checks if required plugins are installed and running.
]]

-- Common imports.
import("Turbine")
import("Turbine.Gameplay")
import("Turbine.UI")
import("Turbine.UI.Lotro")

-- Utility functions
import("Iswell.GPS.Functions.Messages")

-- Check if a plugin is installed and running
function _G.CheckPlugin(plugins)
  local pluginInstalled = false
  local pluginRunning = false
  local allPluginsRunning = true

  local pluginData = {}

  for index, value in ipairs(plugins) do
    local tmpPlugins = Turbine.PluginManager.GetAvailablePlugins()
    for pluginIndex = 1, #tmpPlugins do
      if tmpPlugins[pluginIndex].Name == value then
        pluginInstalled = true
        break
      end
    end

    if pluginInstalled then
      Turbine.PluginManager.LoadPlugin(value)
      tmpPlugins = Turbine.PluginManager.GetLoadedPlugins()
      for pluginIndex = 1, #tmpPlugins do
        if tmpPlugins[pluginIndex].Name == value then
          pluginRunning = true
          break
        end
      end
    end

    table.insert(pluginData, { name = value, installed = pluginInstalled, running = pluginRunning })
  end

  for _, data in ipairs(pluginData) do
    if not data.installed or not data.running then
      allPluginsRunning = false
    end
  end

  return allPluginsRunning
end

