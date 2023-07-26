local PZNS_DebuggerUtils = require("02_mod_utils/PZNS_DebuggerUtils");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_UtilsZones = require("02_mod_utils/PZNS_UtilsZones");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");
local PZNS_NPCZonesManager = require("04_data_management/PZNS_NPCZonesManager");
require "11_events_spawning/PZNS_Events";            -- Cows: THIS IS REQUIRED, DON'T MESS WITH IT, ALWAYS KEEP THIS AT TOP
-- Cows: Make sure the NPC spawning functions come AFTER PZNS_InitLoadNPCsData() to prevent duplicate spawns.
require("pzns_rosewoodpolice/PZNS_RosewoodPoliceBrad");
require("pzns_rosewoodpolice/PZNS_RosewoodPoliceLeon");
require("pzns_rosewoodpolice/PZNS_RosewoodPoliceMarvin");

local isFrameWorkIsInstalled = false;
local isBradSpawned = false;
local isLeonSpawned = false;
local isMarvinSpawned = false;
local groupID = "PZNS_RosewoodPolice";

--- Cows: Creates the preset group
local function PZNS_CreateRoseWoodPoliceGroup()
    local npcGroup = PZNS_NPCGroupsManager.getGroupByID(groupID);
    --
    if (npcGroup == nil) then
        PZNS_NPCGroupsManager.createGroup(groupID);
    end

    local zoneHome = "ZoneHome";
    if (PZNS_UtilsZones.PZNS_GetGroupZoneBoundary(groupID, zoneHome) == nil) then
        PZNS_NPCZonesManager.createZone(groupID, zoneHome);
        local zoneBoundaries = {
            math.floor(8063),
            math.floor(8077),
            math.floor(11725),
            math.floor(11735),
            0
        };
        PZNS_UtilsZones.PZNS_SetGroupZoneBoundary(groupID, zoneHome, zoneBoundaries);
    end
end

--- Cows: Check if the Framework installed and create a group if true (and if needed)
---@return boolean
local function checkIsFrameWorkIsInstalled()
    local activatedMods = getActivatedMods();
    local frameworkID = "PZNS_Framework";
    --
    if (activatedMods:contains(frameworkID)) then
        isFrameWorkIsInstalled = true;
        PZNS_CreateRoseWoodPoliceGroup(); -- Cows: Optional
    else
        -- Cows: Else alert user about not having PZNS_Framework installed...
        local function callback()
            getSpecificPlayer(0):Say("!!! PZNS_RosewoodPolice IS NOT ACTIVE !!!");
            getSpecificPlayer(0):Say("!!! PZNS_Framework IS NOT INSTALLED !!!");
        end
        Events.EveryOneMinute.Add(callback);
    end

    return isFrameWorkIsInstalled;
end

-- Cows: with the recent sandbox options update, users can use the sandbox option to clear ALL NPCs needs hourly. Only use this function if you want to override the sandbox option.
local function clearNPCsNeeds()
    --
    local PZNS_BradTester = "PZNS_BradTester";
    local survivorBrad = PZNS_NPCsManager.getActiveNPCBySurvivorID(PZNS_BradTester);
    PZNS_UtilsNPCs.PZNS_ClearNPCAllNeedsLevel(survivorBrad);
    --
    local PZNS_LeonTester = "PZNS_LeonTester";
    local survivorLeon = PZNS_NPCsManager.getActiveNPCBySurvivorID(PZNS_LeonTester);
    PZNS_UtilsNPCs.PZNS_ClearNPCAllNeedsLevel(survivorLeon);
    --
    local PZNS_MarvinTester = "PZNS_MarvinTester";
    local survivorMarvin = PZNS_NPCsManager.getActiveNPCBySurvivorID(PZNS_MarvinTester);
    PZNS_UtilsNPCs.PZNS_ClearNPCAllNeedsLevel(survivorMarvin);
end

--[[
    Cows: Currently, NPCs cannot spawn off-screen because gridsquare data is not loaded outside of the player's range...
    Need to figure out how to handle gridsquare data loading.
--]]
--- Cows: This is an in-game every one minute check (about 2 seconds in real-life time by default)
--- This is needed because not all NPCs will spawn within range of the player's loaded cell and must therefore be checked regularly to spawn in-game.
local function npcsSpawnCheck()
    if (isFrameWorkIsInstalled == true) then
        local function bradCallback()
            PZNS_SpawnPoliceNPCBrad(isBradSpawned);
        end
        local function leonCallback()
            PZNS_SpawnPoliceNPCLeon(isLeonSpawned);
        end
        local function marvinCallback()
            PZNS_SpawnPoliceNPCMarvin(isMarvinSpawned);
        end
        --
        local function checkIsNPCSpawned()
            if (isBradSpawned == true) then
                Events.EveryOneMinute.Remove(bradCallback);
            end
            if (isLeonSpawned == true) then
                Events.EveryOneMinute.Remove(leonCallback);
            end
            if (isMarvinSpawned == true) then
                Events.EveryOneMinute.Remove(marvinCallback);
            end
            if (isBradSpawned == true and isLeonSpawned == true and isMarvinSpawned == true) then
                Events.EveryOneMinute.Remove(checkIsNPCSpawned);
            end
        end
        Events.EveryOneMinute.Add(bradCallback);
        Events.EveryOneMinute.Add(leonCallback);
        Events.EveryOneMinute.Add(marvinCallback);
        Events.EveryOneMinute.Add(checkIsNPCSpawned);
        -- Events.EveryHours.Add(clearNPCsNeeds); -- Cows: Optional
    end
end

Events.OnGameStart.Add(checkIsFrameWorkIsInstalled);
Events.OnGameStart.Add(npcsSpawnCheck);
