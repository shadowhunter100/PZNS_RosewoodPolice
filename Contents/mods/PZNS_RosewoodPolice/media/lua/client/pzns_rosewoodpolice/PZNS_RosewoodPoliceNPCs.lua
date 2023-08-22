local PZNS_DebuggerUtils = require("02_mod_utils/PZNS_DebuggerUtils");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");
--------------------------------------- End Framework Requirements ---------------------------------------------
local PZNS_RosewoodPolicePresets = require("pzns_rosewoodpolice/PZNS_RosewoodPolicePresets");
local PZNS_RosewoodPoliceNPCs = {};
local groupID = "PZNS_RosewoodPolice";

--- Cows: Helper function to reduce copy-paste conditional spawn range checks.
---@param spawnX number
---@param spawnY number
---@param spawnZ number
---@return boolean
local function isNPCInSpawnRange(spawnX, spawnY, spawnZ)
    local playerSurvivor = getSpecificPlayer(0);
    local isInSpawnRange = PZNS_WorldUtils.PZNS_IsSquareInPlayerSpawnRange(playerSurvivor, spawnX, spawnY, spawnZ);
    return isInSpawnRange;
end

--- Cows: Example of spawning in an NPC. This NPC is "Brad Tester"
---@return boolean
function PZNS_RosewoodPoliceNPCs.spawnPoliceNPCBrad()
    local npcSurvivorID = "PZNS_BradTester"; -- Cows: CHANGE THIS VALUE AND MAKE SURE IT IS UNIQUE! Otherwise PZNS will not be able to manage this NPC.
    local isGroupExists = PZNS_NPCGroupsManager.getGroupByID(groupID);
    local isNPCActive = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    local isSpawned = false;
    -- Cows: Check if the group exists before attempting to create the NPC
    if (isGroupExists == nil) then
        return isSpawned;
    end
    -- Cows: Check if the NPC is active before continuing.
    if (isNPCActive == nil) then
        local spawnX, spawnY, spawnZ = 8064, 11726, 0; -- Cows: This should spawn Brad in the Rosewood police station.
        -- Cows: Check if npc isInSpawnRange
        if (isNPCInSpawnRange(spawnX, spawnY, spawnZ) == true) then
            local spawnSquare = getCell():getGridSquare(
                spawnX, -- GridSquareX
                spawnY, -- GridSquareY
                spawnZ  -- Floor level
            );
            local npcSurvivor = PZNS_NPCsManager.createNPCSurvivor(
                npcSurvivorID, -- Unique Identifier for the npcSurvivor so that it can be managed.
                false,         -- isFemale
                "Tester",      -- Surname
                "Brad",        -- Forename
                spawnSquare    -- Square to spawn at
            );
            --
            if (npcSurvivor ~= nil) then
                PZNS_RosewoodPolicePresets.usePresetPerks(npcSurvivor);
                -- Cows: Setup npcSurvivor outfit...
                PZNS_RosewoodPolicePresets.usePresetLightOutfit(npcSurvivor);
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
        isSpawned = true; -- Cows: Else NPC already spawned or already exists.
    end
    return isSpawned;
end

--- Cows: Example of spawning in an NPC. This NPC is "Leon Tester"
---@return boolean
function PZNS_RosewoodPoliceNPCs.spawnPoliceNPCLeon()
    local npcSurvivorID = "PZNS_LeonTester"; -- Cows: CHANGE THIS VALUE AND MAKE SURE IT IS UNIQUE! Otherwise PZNS will not be able to manage this NPC.
    local isGroupExists = PZNS_NPCGroupsManager.getGroupByID(groupID);
    local isNPCActive = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    local isSpawned = false;
    -- Cows: Check if the group exists before attempting to create the NPC
    if (isGroupExists == nil) then
        return isSpawned;
    end
    -- Cows: Check if the NPC is active before continuing.
    if (isNPCActive == nil) then
        local spawnX, spawnY, spawnZ = 8061, 11728, 0; -- Cows: This should spawn Leon in the Rosewood police station near the armory.
        -- Cows: Check if npc isInSpawnRange
        if (isNPCInSpawnRange(spawnX, spawnY, spawnZ) == true) then
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
                PZNS_RosewoodPolicePresets.usePresetPerks(npcSurvivor);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorTraits(npcSurvivor, "Lucky");
                -- Cows: Setup npcSurvivor outfit... Example mod patcher check
                -- "leon_rpd" is a costume mod created/uploaded by "Satispie" at https://steamcommunity.com/sharedfiles/filedetails/?id=2908201158
                if (PZNS_DebuggerUtils.PZNS_IsModActive("leon_rpd") == true) then
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.leon_rpd");
                else
                    PZNS_RosewoodPolicePresets.usePresetLightOutfit(npcSurvivor);
                end
                PZNS_UtilsNPCs.PZNS_AddEquipWeaponNPCSurvivor(npcSurvivor, "Base.Shotgun");
                PZNS_UtilsNPCs.PZNS_AddItemsToInventoryNPCSurvivor(npcSurvivor, "Base.ShotgunShells", 24);
                PZNS_UtilsNPCs.PZNS_SetLoadedGun(npcSurvivor);
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
        isSpawned = true; -- Cows: Else NPC already spawned or already exists.
    end
    return isSpawned;
end

--- Cows: Example of spawning in an NPC. This NPC is "Marvin Tester"
---@return boolean
function PZNS_RosewoodPoliceNPCs.spawnPoliceNPCMarvin()
    local npcSurvivorID = "PZNS_MarvinTester"; -- Cows: CHANGE THIS VALUE AND MAKE SURE IT IS UNIQUE! Otherwise PZNS will not be able to manage this NPC.
    local isGroupExists = PZNS_NPCGroupsManager.getGroupByID(groupID);
    local isNPCActive = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    local isSpawned = false;
    -- Cows: Check if the group exists before attempting to create the NPC
    if (isGroupExists == nil) then
        return isSpawned;
    end
    -- Cows: Check if the NPC is active before continuing.
    if (isNPCActive == nil) then
        local spawnX, spawnY, spawnZ = 8064, 11728, 0; -- Cows: This should spawn Marvin in the Rosewood police station.
        -- Cows: Check if npc isInSpawnRange
        if (isNPCInSpawnRange(spawnX, spawnY, spawnZ) == true) then
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
                PZNS_RosewoodPolicePresets.usePresetPerks(npcSurvivor);
                -- Cows: Setup npcSurvivor outfit...
                PZNS_RosewoodPolicePresets.usePresetLightOutfit(npcSurvivor);
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
        isSpawned = true; -- Cows: Else NPC already spawned or already exists.
    end
    return isSpawned;
end

return PZNS_RosewoodPoliceNPCs;
