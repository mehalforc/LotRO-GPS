--[[
    GPS - LocationInfo Module
    Finds player's current location.
]]

-- Common imports.
import("Turbine")
import("Turbine.Gameplay")
import("Turbine.UI")
import("Turbine.UI.Lotro")

-- Main functions
import("Iswell.GPS.Main")

-- Common functions
import("Iswell.GPS.Functions.CommonFunctions")

function _G.SetMyLocation()
  Turbine.Chat.Received = function(sender, args)
    if args.ChatType == Turbine.ChatType.Standard then
      local msg = args.Message

      -- Match the full /loc output
      local r = tonumber(string.match(msg, "r(%-?%d+)"))
      local lx = tonumber(string.match(msg, "lx(%-?%d+%.?%d*)"))
      local ly = tonumber(string.match(msg, "ly(%-?%d+%.?%d*)"))
      local ox = tonumber(string.match(msg, "ox(%-?%d+%.?%d*)"))
      local oy = tonumber(string.match(msg, "oy(%-?%d+%.?%d*)"))
      local oz = tonumber(string.match(msg, "oz(%-?%d+%.?%d*)"))
      local h = tonumber(string.match(msg, "h(%-?%d+%.?%d*)"))
      local cInside = string.match(msg, "cInside") ~= nil

      if r and lx and ly then
        _G.loc = {
          r = r,
          lx = lx,
          ly = ly,
          ox = ox,
          oy = oy,
          oz = oz,
          h = h,
          cInside = cInside,
        }

        local lxValue = _G.loc.lx
        local lyValue = _G.loc.ly
        local oxValue = _G.loc.ox
        local oyValue = _G.loc.oy

        local xLocation = ((math.floor(lxValue / 8) * 160 + oxValue) - 29360) / 200
        local yLocation = ((math.floor(lyValue / 8) * 160 + oyValue) - 24880) / 200

        local pinside = "Outside"
        if loc.cInside then
          pinside = "Inside"
        end

        -- Optional: trigger your GPS logic
        if _G.loc and _G.loc.cInside == false then
          FindClosest(r, _G.selectedCategoryId, yLocation, xLocation)
        end

        local playerNS = "n"
        if yLocation <= 0 then
          playerNS = "s"
        end

        local playerEW = "e"
        if xLocation <= 0 then
          playerEW = "w"
        end

        if pinside == "Inside" then
          local message = "You are inside! Go outside and try again..."
          _G.MessagesGenericError(message)
        end
      end
    end
  end
end
