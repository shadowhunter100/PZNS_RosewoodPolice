require "PZNS_NPCGroupsManager";
-- Cows: Make sure the NPC spawning functions come AFTER PZNS_InitLoadNPCsData() to prevent duplicate spawns.
--[[
    Cows: Currently, NPCs cannot spawn off-screen because gridsquare data is not loaded outside of the player's range...
    Need to figure out how to handle gridsquare data loading.
--]]

local groupID = "PZNS_RosewoodPolice";

function PZNS_CreateRoseWoodPoliceGroup()
    local npcGroup = PZNS_NPCGroupsManager:getGroupByID(groupID);
    --
    if (npcGroup == nil) then
        PZNS_NPCGroupsManager:createGroup(groupID);
    end
    -- WIP - Cows: Needs more testing...
    -- local zoneBoundaries = {
    --     math.floor(zoneHighlightX1),
    --     math.floor(zoneHighlightX2),
    --     math.floor(zoneHighlightY1),
    --     math.floor(zoneHighlightY2),
    --     math.floor(getSpecificPlayer(0):getZ())
    -- };
    -- local zoneType = "ZoneHome";

    -- PZNS_SetGroupZoneBoundary(groupID, zoneType, zoneBoundaries);
end
