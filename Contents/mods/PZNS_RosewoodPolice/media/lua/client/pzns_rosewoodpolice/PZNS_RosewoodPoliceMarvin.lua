local PZNS_DebuggerUtils = require("02_mod_utils/PZNS_DebuggerUtils");
local PZNS_PlayerUtils = require("02_mod_utils/PZNS_PlayerUtils");
local PZNS_UtilsDataGroups = require("02_mod_utils/PZNS_UtilsDataGroups");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsDataZones = require("02_mod_utils/PZNS_UtilsDataZones");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");
require("pzns_rosewoodpolice/PZNS_RosewoodPolicePresets");

--- Cows: Example of spawning in an NPC. This NPC is "Marvin Tester"
---@param isSpawned boolean
function PZNS_SpawnPoliceNPCMarvin(isSpawned)
    local groupID = "PZNS_RosewoodPolice";                             -- Cows: Can be removed if NPC doesn't need or have a group
    local isGroupExists = PZNS_NPCGroupsManager.getGroupByID(groupID); -- Cows: Can be removed if NPC doesn't need or have a group..
    local npcSurvivorID = "PZNS_MarvinTester";
    local isNPCActive = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    -- Cows: Check if the group exists before attempting to create it
    if (isGroupExists == nil) then
        return;
    end
    -- Cows: Check if the NPC is active before continuing.
    if (isNPCActive == nil) then
        local playerSurvivor = getSpecificPlayer(0);
        -- Cows: This should spawn Marvin in the Rosewood police station.
        local spawnX, spawnY, spawnZ = 8064, 11728, 0;
        local isInSpawnRange = PZNS_WorldUtils.PZNS_IsSquareInPlayerSpawnRange(playerSurvivor, spawnX, spawnY, spawnZ);
        -- Cows: Check if npc isInSpawnRange
        if (isInSpawnRange == true) then
            --
            local spawnSquare = getCell():getGridSquare(
                spawnX, -- GridSquareX
                spawnY, -- GridSquareY
                spawnZ  -- Floor level
            );
            local npcSurvivor = PZNS_NPCsManager.createNPCSurvivor(
                npcSurvivorID, -- Unique Identifier for the npcSurvivor so that it can be managed.
                false,         -- isFemale
                "Tester",      -- Surname
                "Marvin",      -- Forename
                spawnSquare    -- Square to spawn at
            );
            --
            if (npcSurvivor ~= nil) then
                PZNS_UsePresetPolicePerks(npcSurvivor);
                -- Cows: Setup npcSurvivor outfit...
                PZNS_UsePresetPoliceLightOutfit(npcSurvivor);
                -- Cows: Set the job...
                PZNS_UtilsNPCs.PZNS_SetNPCJob(npcSurvivor, "Guard");
                -- Cows: Group Assignment
                PZNS_NPCGroupsManager.addNPCToGroup(npcSurvivor, groupID);
                PZNS_UtilsNPCs.PZNS_SetNPCGroupID(npcSurvivor, groupID); -- Cows: Can be removed if NPC doesn't need or have a group.
                PZNS_UtilsDataNPCs.PZNS_SaveNPCData(npcSurvivorID, npcSurvivor);
                isSpawned = true;
            end
        end
    else
        -- Cows: Else NPC already spawned or already exists.
        isSpawned = true;
    end
    return isSpawned;
end
