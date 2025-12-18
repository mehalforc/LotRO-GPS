--[[
    GPS - FindClosestPoint Module
    Finds the closest Point based off of Player's Point filtering by Region and Category.
]]

-- Common imports.
import("Turbine")
import("Turbine.Gameplay")
import("Turbine.UI")
import("Turbine.UI.Lotro")

-- Main functions
import("Iswell.GPS.MapData.OutsideMapPoints")

-- Utility functions
import("Iswell.GPS.Functions.Messages")

-- Find the closest point, and optionally the next closest if the closest is < 0.1
local function FindClosestPoint(outsideMapPoints, myY, myX, targetR, targetC)
  local closestPoint, nextClosestPoint = nil, nil
  local minDistanceSquared, nextMinDistanceSquared = math.huge, math.huge
  local closestX, closestY, closestIndex = nil, nil, nil
  local nextX, nextY, nextIndex = nil, nil, nil

  for i, point in ipairs(outsideMapPoints) do
    if point.r == targetR and point.c == targetC then
      local dy = point.ns - myY
      local dx = point.ew - myX
      local distanceSquared = dx * dx + dy * dy

      if distanceSquared < minDistanceSquared then
        -- shift current closest into "next closest"
        nextClosestPoint = closestPoint
        nextMinDistanceSquared = minDistanceSquared
        nextX, nextY, nextIndex = closestX, closestY, closestIndex

        -- update closest
        minDistanceSquared = distanceSquared
        closestPoint = point
        closestY = point.ns
        closestX = point.ew
        closestIndex = i
      elseif distanceSquared < nextMinDistanceSquared then
        -- update next closest
        nextMinDistanceSquared = distanceSquared
        nextClosestPoint = point
        nextY = point.ns
        nextX = point.ew
        nextIndex = i
      end
    end
  end

  if closestPoint then
    local distance = math.sqrt(minDistanceSquared)
    if distance < 0.075 and nextClosestPoint then
      local nextDistance = math.sqrt(nextMinDistanceSquared)
      return nextClosestPoint, nextY, nextX, nextDistance, nextIndex
    else
      return closestPoint, closestY, closestX, distance, closestIndex
    end
  else
    return nil, nil, nil, nil, nil, nil
  end
end

function _G.FindClosest(regionId, categoryId, currentY, currentX)
  local point, y, x, distance, index = FindClosestPoint(_G.outsideMapPoints, currentY, currentX, regionId, categoryId)
  if point then
    distance = distance * 200 -- Convert to in-game distance units

    local main, subs = resolveDescription(point.description)
    local description = main
    if #subs > 0 then
      description = description .. "\nIn: " .. table.concat(subs, "/")
    end

    local message = _G.T and string.format(_G.T.CLOSEST_COORDINATES, description, y, x, distance, index) or string.format("Closest point: %s\nCoordinates: (%.5f, %.5f)\nDistance: ~%.5fm\nLine number: %d", description, y, x, distance, index)
    _G.MessagesGeneric(message)

    local playerNS = "n"
    if y <= 0 then
      playerNS = "s"
    end

    local playerEW = "e"
    if x <= 0 then
      playerEW = "w"
    end

    _G.aliasWaypoint = "/way target " .. y .. playerNS .. ", " .. x .. playerEW
    _G.waypointShortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, _G.aliasWaypoint)
    _G.waypointQuickslot:SetShortcut(_G.waypointShortcut)
  else
    if categoryId ~= nil and categoryId ~= 0 then
      local message = _G.T and string.format(_G.T.NO_POINTS_MATCHING, tostring(categoryId), tostring(regionId)) or string.format("No matching points found for Category: %s, in Region: %s", tostring(categoryId), tostring(regionId))
      _G.MessagesGenericError(message)
    else
      local message = _G.T and _G.T.SELECT_CATEGORY or "Please select a Category!"
      _G.MessagesGenericError(message)
    end
  end
end
