require "PZNS_UtilsDataNPCs";
require "PZNS_UtilsNPCs";
require "PZNS_PresetsOutfit";
require "PZNS_PresetsPerks";
require "PZNS_NPCGroupsManager";
require "PZNS_NPCsManager";

local groupID = "PZNS_RosewoodPolice"; -- Cows: Can be removed if NPC doesn't need or have a group.
local npcSurvivorID = "PZNS_BradTester";

--- Cows: Example of spawning in an NPC. This Npc is "Brad Tester"
function PZNS_SpawnPoliceNPCBrad()
    local isGroupExists = PZNS_NPCGroupsManager:getGroupByID(groupID); -- Cows: Can be removed if NPC doesn't need or have a group.
    local isNPCActive = PZNS_NPCsManager:getActiveNPCBySurvivorID(npcSurvivorID);
    -- Cows: This should spawn Brad in the Rosewood police station.
    local spawnSquare = getCell():getGridSquare(
        8064,  -- GridSquareX
        11726, -- GridSquareY
        0      -- Floor level
    );
    -- Cows: Check if the group exists before attempting to create it
    if (isGroupExists == nil) then
        return;
    end
    -- Cows: Check if the NPC is active before continuing.
    if (isNPCActive == nil) then
        -- Cows: Check spawnSquare is loaded in the world.
        if (spawnSquare ~= nil) then
            --
            local npcSurvivor = PZNS_NPCsManager:createNPCSurvivor(
                npcSurvivorID, -- Unique Identifier for the npcSurvivor so that it can be managed.
                false,         -- isFemale
                "Tester",      -- Surname
                "Brad",        -- Forename
                spawnSquare    -- Square to spawn at
            );
            --
            if (npcSurvivor ~= nil) then
                PZNS_UsePresetPolicePerks(npcSurvivor);
                PZNS_AddNPCSurvivorTraits(npcSurvivor, "Lucky");
                -- Cows: Setup npcSurvivor outfit...
                PZNS_UsePresetPoliceLightOutfit(npcSurvivor);
                -- Cows: Set the job...
                PZNS_SetNPCJob(npcSurvivor, "Guard");
                -- Cows: Group Assignment
                PZNS_NPCGroupsManager:addNPCToGroup(npcSurvivor, groupID);
                PZNS_SetNPCGroupID(npcSurvivor, groupID); -- Cows: Can be removed if NPC doesn't need or have a group.
                PZNS_SaveNPCData(npcSurvivorID, npcSurvivor);
                Events.EveryOneMinute.Remove(PZNS_SpawnPoliceNPCBrad);
            end
        else
            -- Cows: Else need to retry the spawning process until the square is loaded
            Events.EveryOneMinute.Add(PZNS_SpawnPoliceNPCBrad);
        end
    end
end

-- Cows: NPC Cleanup function...
function PZNS_DeletePoliceNPCBrad()
    local npcSurvivor = PZNS_NPCsManager:getActiveNPCBySurvivorID(npcSurvivorID);
    PZNS_ClearQueuedNPCActions(npcSurvivor);
    PZNS_NPCGroupsManager:removeNPCFromGroupBySurvivorID(groupID, npcSurvivorID); -- Cows: REMOVE THE NPC FROM THEIR GROUP BEFORE DELETING THEM! OTHERWISE IT'S A NIL REFERENCE
    PZNS_NPCsManager:deleteActiveNPCBySurvivorID(npcSurvivorID);
end
