--[[
    GPS - CategoryDescription Module
    Creates Point Data from a list of files used with PHP.
]]

-- Common imports.
import("Turbine")
import("Turbine.Gameplay")
import("Turbine.UI")
import("Turbine.UI.Lotro")

-- Category Description Data
function _G.LoadCategory()
  _G.categoryDescription = {
    [2] = "Quest",
    [21] = "Tunnel Entrance",
    [22] = "Dock-master",
    [23] = "Far-ranging Stable-master",
    [24] = "Eagle",
    [27] = "Task",
    [29] = "Item-master",
    [30] = "Homestead",
    [31] = "Town Crier",
    [33] = "Crafting Vendor",
    [34] = "Mailbox",
    [38] = "Vendor",
    [39] = "No Icon",
    [40] = "Vault-keeper",
    [41] = "Settlement",
    [42] = "Trainer",
    [43] = "Point of Interest",
    [45] = "Crafting Facility",
    [48] = "Waypoint",
    [50] = "Crafting Resource",
    [51] = "Stable-master",
    [52] = "Reflecting Pool",
    [53] = "Auctioneer",
    [54] = "Bard",
    [55] = "Milestone",
    [56] = "Fellowship Shared Tracking",
    [57] = "Camp-site",
    [58] = "Trader",
    [60] = "Barber",
    [61] = "Faction Representative",
    [63] = "Escrow",
    [70] = "NPC",
    [71] = "Monster",
    [72] = "Container",
    [73] = "Item",
    [74] = "Landmark",
    [77] = "Crop",
    [78] = "Critter",
    [100] = "Other",
  }
end
