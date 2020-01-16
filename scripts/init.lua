--  Load configuration options up front
ScriptHost:LoadScript("scripts/settings.lua")

Tracker:AddItems("items/items.json")

Tracker:AddLayouts("layouts/broadcast_layout.json")
Tracker:AddLayouts("layouts/tracker_layout.json")

Tracker:AddLocations("locations/locations.json")
Tracker:AddMaps("maps/maps.json")

if _VERSION == "Lua 5.3" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
else    
    print("Auto-tracker is unsupported by your tracker version")
end
