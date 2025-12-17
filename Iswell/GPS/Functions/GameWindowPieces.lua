--[[
    GPS - GameWindowPieces Module
    Makes the Main Window and parts inside the Main Window.
]]

-- Common imports.
import("Turbine")
import("Turbine.Gameplay")
import("Turbine.UI")
import("Turbine.UI.Lotro")

-- Common functions
import("Iswell.GPS.Functions.CommonFunctions")
import("Iswell.GPS.Functions.LocationInfo")
import("Iswell.GPS.Functions.FindClosestPoint")
import("Iswell.GPS.MapData.CategoryDescription")
import("Iswell.GPS.Functions.Messages")

-- Utility functions
import("Iswell.GPS.Main")

-- Show the GPS icon
function _G.ShowMyIcon()
  -- Create a window
  _G.iconWindow = Turbine.UI.Window()
  iconWindow:SetSize(32, 44)
  iconWindow:SetPosition(Turbine.UI.Display.GetWidth() - 48, 16)
  iconWindow:SetVisible(true)
  iconWindow:SetZOrder(1)
  iconWindow:SetMouseVisible(true)
  iconWindow:SetBackColor(Turbine.UI.Color(0, 0, 0, 0))

  -- Create a graphic control to act as the button
  _G.gpsButton = Turbine.UI.Button()
  gpsButton:SetParent(iconWindow)
  gpsButton:SetSize(32, 44)
  gpsButton:SetPosition(0, 0)
  gpsButton:SetBackground("Iswell/GPS/Icons/GPS-Button.tga") -- use .tga or .jpg
  gpsButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
  gpsButton:SetMouseVisible(true)

  gpsButton.MouseClick = function()
    --gpsQuickslot:SetMouseVisible(false);
    gpsButton:SetMouseVisible(true)
    WindowToggleGPS()
  end
end

function WindowToggleGPS()
  if _G.mainWindow == nil then
    _G.mainWindow = Turbine.UI.Lotro.Window()
    mainWindow:SetSize(10, 345)
    mainWindow:SetText("GPS")
    mainWindow:SetVisible(true)
    mainWindow:SetResizable(false)
    mainWindow:SetPosition((Turbine.UI.Display.GetWidth() - mainWindow:GetWidth()) - 64, 0)

    -- Quickslot for alias execution only
    local gpsShortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, aliasLocation)
    _G.gpsQuickslot = Turbine.UI.Lotro.Quickslot()
    gpsQuickslot:SetParent(mainWindow)
    gpsQuickslot:SetSize(32, 32)
    gpsQuickslot:SetShortcut(gpsShortcut)
    gpsQuickslot:SetVisible(true)
    gpsQuickslot:SetMouseVisible(true)
    gpsQuickslot:SetAllowDrop(false)

    -- Button for Lua logic
    _G.gpsCalculate = Turbine.UI.Button()
    gpsCalculate:SetParent(mainWindow)
    gpsCalculate:SetSize(32, 32)

    -- Position at bottom-right of mainWindow
    local buttonWidth, buttonHeight = gpsCalculate:GetSize()

    gpsCalculate:SetPosition(32, 32)
    gpsQuickslot:SetPosition(gpsCalculate:GetPosition())

    gpsCalculate:SetBackground("Iswell/GPS/Icons/GPS-Paths.tga")
    gpsCalculate:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
    gpsCalculate:SetMouseVisible(false) -- must be true to receive clicks

    gpsQuickslot.MouseClick = function()
      SetMyLocation()
    end

    local radioGroup = {}
    local selectedIndex = nil
    _G.selectedCategoryId = nil

    _G.myUniqueIcons = _G.GetUniqueCategoryIds()

    local qty = #_G.myUniqueIcons

    local iconsPerColumn = math.ceil(qty / 2)
    local rowHeight = 30
    local columnWidth = 270
    local startX, startY = gpsCalculate:GetPosition()
    startY = startY + buttonHeight

    -- Registry for metadata
    local registry = {}

    for i, entry in ipairs(_G.myUniqueIcons) do
      local rowIndex = (i - 1) % iconsPerColumn
      local colIndex = math.floor((i - 1) / iconsPerColumn)

      -- Row container
      local row = Turbine.UI.Control()
      row:SetParent(mainWindow)
      row:SetSize(250, 32)
      row:SetPosition(startX + colIndex * columnWidth, startY + rowIndex * rowHeight)
      row:SetMouseVisible(true)

      -- Checkbox
      local cb = Turbine.UI.Lotro.CheckBox()
      cb:SetParent(row)
      cb:SetSize(24, 24)
      cb:SetPosition(8, 4)
      cb:SetText("")
      cb:SetChecked(false)

      -- Icon
      local icon = Turbine.UI.Control()
      icon:SetParent(row)
      icon:SetSize(32, 32)
      icon:SetPosition(32, 0)
      icon:SetBackground("Iswell/GPS/Icons/Categories/" .. entry.categoryId .. ".tga")
      icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
      icon:SetMouseVisible(false)

      -- Label
      local label = Turbine.UI.Label()
      label:SetParent(row)
      label:SetSize(250, 32)
      label:SetPosition(70, 0)
      label:SetText(entry.description)
      label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
      label:SetForeColor(Turbine.UI.Color.White)
      label:SetMouseVisible(false)

      mainWindow:SetSize(startX + colIndex * 2 * columnWidth, startY + rowIndex * 2 * rowHeight)
      mainWindow:SetPosition((Turbine.UI.Display.GetWidth() - mainWindow:GetWidth()) - 64, 0)

      -- Store metadata externally
      registry[cb] = {
        categoryId = entry.categoryId,
        description = entry.description,
      }

      -- Selection logic
      cb.CheckedChanged = function(sender, args)
        if sender:IsChecked() then
          -- Uncheck all others first
          for _, other in ipairs(radioGroup) do
            if other ~= sender and other:IsChecked() then
              other:SetChecked(false)
            end
          end

          -- Update global selection
          local tag = registry[sender]
          _G.selectedCategoryId = tag.categoryId

          local message = _G.T and string.format(_G.T.SELECTED_CATEGORY, tag.description, tag.categoryId) or string.format("Selected: %s (Category %d)", tag.description, tag.categoryId)
          _G.MessagesGeneric(message)
        else
          _G.selectedCategoryId = 0
          local message = _G.T and _G.T.NO_CATEGORY_SELECTED or "No Category Selected..."
          _G.MessagesGenericError(message)
        end
      end

      row.MouseClick = function()
        cb:SetChecked(true)
      end

      -- Hover highlight
      row.MouseEnter = function()
        row:SetBackColor(Turbine.UI.Color(1, 0.2, 0.2, 0.4))
      end

      row.MouseLeave = function()
        ---@diagnostic disable-next-line: param-type-mismatch
        row:SetBackColor(nil)
      end

      table.insert(radioGroup, cb)
    end

    local parentWidth, parentHeight = mainWindow:GetSize()
    local x, y = gpsCalculate:GetPosition()

    _G.label = Turbine.UI.Label()
    label:SetParent(mainWindow)
    label:SetPosition(x, (startY + iconsPerColumn * rowHeight) + 6)
    x, y = label:GetPosition()
    label:SetFont(Turbine.UI.Lotro.Font.Verdana16)
    local myMessageHeight = 16
    label:SetSize(parentWidth - 50, myMessageHeight * 6)

    label:SetText(_G.okLoadMessage)
    label:SetForeColor(_G.okColor)
    label:SetZOrder(2)

    mainWindow:SetSize(mainWindow:GetWidth(), y + (myMessageHeight * 6) + 18)

    -- Quickslot for alias execution only
    _G.waypointShortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, _G.aliasWaypoint)
    _G.waypointQuickslot = Turbine.UI.Lotro.Quickslot()
    waypointQuickslot:SetParent(mainWindow)
    waypointQuickslot:SetSize(32, 32)
    waypointQuickslot:SetShortcut(_G.waypointShortcut)
    waypointQuickslot:SetVisible(true)
    waypointQuickslot:SetMouseVisible(true)
    waypointQuickslot:SetAllowDrop(false)

    -- Do Something with Waypoint
    _G.waypointButton = Turbine.UI.Button()
    waypointButton:SetParent(mainWindow)
    waypointButton:SetSize(32, 32)
    waypointButton:SetBackground("Iswell/GPS/Icons/GPS-Map.tga")

    -- Position at bottom-right of mainWindow
    local buttonX, buttonY = gpsCalculate:GetPosition()
    waypointButton:SetPosition(buttonX + 32, buttonY)
    waypointButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
    waypointButton:SetMouseVisible(false) -- must be true to receive clicks
    waypointButton:SetVisible(true)

    waypointQuickslot:SetPosition(waypointButton:GetPosition())
    if _G.allPluginsCheck then
      waypointButton:SetVisible(true)
      waypointQuickslot:SetVisible(true)
    else
      waypointButton:SetVisible(false)
      waypointQuickslot:SetVisible(false)
    end

    ShowMainWindow()
    _G.allPluginsCheck = CheckPlugin(plugins)
  else
    if mainWindow:IsVisible() then
      HideMainWindow()
    else
      ShowMainWindow()
      _G.allPluginsCheck = CheckPlugin(plugins)
      if _G.allPluginsCheck then
        -- load button
        waypointButton:SetVisible(true)
        waypointQuickslot:SetVisible(true)
      else
        waypointQuickslot:SetVisible(false)
      end
    end
  end
end
