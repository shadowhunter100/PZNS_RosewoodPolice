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

--- Cows: Example of spawning in an NPC. This NPC is "Leon Tester"
---@param isSpawned boolean
function PZNS_SpawnPoliceNPCLeon(isSpawned)
    local groupID = "PZNS_RosewoodPolice";                             -- Cows: Can be removed if NPC doesn't need or have a group.
    local isGroupExists = PZNS_NPCGroupsManager.getGroupByID(groupID); -- Cows: Can be removed if NPC doesn't need or have a group.
    local npcSurvivorID = "PZNS_LeonTester";
    local isNPCActive = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    -- Cows: Check if the group exists before attempting to create it
    if (isGroupExists == nil) then
        return;
    end
    -- Cows: Check if the NPC is active before continuing.
    if (isNPCActive == nil) then
        local playerSurvivor = getSpecificPlayer(0);
        -- Cows: This should spawn Leon in the Rosewood police station near the armory.
        local spawnX, spawnY, spawnZ = 8061, 11728, 0;
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
                "Leon",        -- Forename
                spawnSquare    -- Square to spawn at
            );
            --
            if (npcSurvivor ~= nil) then
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Strength", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Fitness", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Aiming", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Reloading", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorTraits(npcSurvivor, "Lucky");
                -- Cows: Setup npcSurvivor outfit... Example mod patcher check
                -- "leon_rpd" is a costume mod created/uploaded by "Satispie" at https://steamcommunity.com/sharedfiles/filedetails/?id=2908201158
                if (PZNS_DebuggerUtils.PZNS_IsModActive("leon_rpd") == true) then
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.leon_rpd");
                else
                    PZNS_UsePresetPoliceLightOutfit(npcSurvivor);
                end
                PZNS_UtilsNPCs.PZNS_AddEquipWeaponNPCSurvivor(npcSurvivor, "Base.Shotgun");
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
