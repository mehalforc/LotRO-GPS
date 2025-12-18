--[[
    GPS - CommonFunctions Module
    Common functions that have no major description.
]]

-- Utility functions
import("Iswell.GPS.Functions.GameWindowPieces")

-- Math Round function
function _G.Round(num, idp)
  if idp and idp > 0 then
    local mult = 10 ^ idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function _G.ShowMainWindow()
  mainWindow:SetVisible(true)
end

function _G.HideMainWindow()
  mainWindow:SetVisible(false)
end

function _G.GetUniqueCategoryIds()
  local seen = {}
  local result = {}

  -- Collect unique categoryId values from outsideMapPoints
  for _, entry in ipairs(_G.outsideMapPoints) do
    if not seen[entry.c] then
      seen[entry.c] = true
      table.insert(result, entry.c)
    end
  end

  -- Build list of { categoryId, description }
  local output = {}
  for _, categoryId in ipairs(result) do
    table.insert(output, {
      categoryId = categoryId,
      description = _G.categoryDescription[categoryId] or "(missing)",
    })
  end

  -- Sort output by categoryId ascending
  table.sort(output, function(a, b)
    return a.categoryId < b.categoryId
  end)

  return output
end

function _G.resolveDescription(desc)
  local pointName = split(desc, "|")
  local main = _G.pointsT[tonumber(pointName[1])] or pointName[1]
  local subs = {}
  for _, id in ipairs(split(pointName[2], "/")) do
    table.insert(subs, _G.pointsT[tonumber(id)] or id)
  end
  return main, subs
end

function _G.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end
