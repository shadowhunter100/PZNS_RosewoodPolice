local PZNS_DebuggerUtils = require("02_mod_utils/PZNS_DebuggerUtils");
local PZNS_PlayerUtils = require("02_mod_utils/PZNS_PlayerUtils");
local PZNS_UtilsDataGroups = require("02_mod_utils/PZNS_UtilsDataGroups");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsDataZones = require("02_mod_utils/PZNS_UtilsDataZones");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_UtilsZones = require("02_mod_utils/PZNS_UtilsZones");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");
local PZNS_NPCZonesManager = require("04_data_management/PZNS_NPCZonesManager");
require "11_events_spawning/PZNS_Events"; -- Cows: THIS IS REQUIRED, DON'T MESS WITH IT, ALWAYS KEEP THIS AT TOP
--------------------------------------- End Framework Requirements ---------------------------------------------
-- Cows: Make sure the NPC spawning functions come AFTER PZNS_InitLoadNPCsData() to prevent duplicate spawns.
local PZNS_RosewoodPoliceNPCs = require("pzns_rosewoodpolice/PZNS_RosewoodPoliceNPCs");

-- Cows: Mod Variables.
local isFrameWorkIsInstalled = false;
local frameworkID = "PZNS_Framework";
local groupID = "PZNS_RosewoodPolice"; -- Cows: CHANGE THIS VALUE AND MAKE SURE IT IS UNIQUE! Otherwise PZNS will not be able to manage this group.
local isBradSpawned = false;           -- Cows: These flags are set to clean up EveryOneMinute calls when true.
local isLeonSpawned = false;           -- Cows: These flags are set to clean up EveryOneMinute calls when true.
local isMarvinSpawned = false;         -- Cows: These flags are set to clean up EveryOneMinute calls when true.

--- Cows: Creates the preset group with a ZoneHome
local function createNPCGroup()
    local npcGroup = PZNS_NPCGroupsManager.getGroupByID(groupID);
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
    if (activatedMods:contains(frameworkID)) then
        isFrameWorkIsInstalled = true;
        createNPCGroup();
    else
        local function callback()
            getSpecificPlayer(0):Say("!!! PZNS_RosewoodPolice IS NOT ACTIVE !!!");
            getSpecificPlayer(0):Say("!!! PZNS_Framework IS NOT INSTALLED !!!");
        end
        Events.EveryOneMinute.Add(callback); -- Cows: Else alert user about not having PZNS_Framework installed...
    end

    return isFrameWorkIsInstalled;
end


--- Cows: This is an in-game every one minute check (about 2 seconds in real-life time by default)
--- This is needed because not all NPCs will spawn within range of the player's loaded cell and must therefore be checked regularly to spawn in-game.
local function npcsSpawnCheck()
    if (isFrameWorkIsInstalled == true) then
        -- Cows: These callbacks are essential to clean up the EveryOneMinute event calls, otherwise they remain in-game forever.
        local function bradCallback()
            isBradSpawned = PZNS_RosewoodPoliceNPCs.spawnPoliceNPCBrad();
        end
        local function leonCallback()
            isLeonSpawned = PZNS_RosewoodPoliceNPCs.spawnPoliceNPCLeon();
        end
        local function marvinCallback()
            isMarvinSpawned = PZNS_RosewoodPoliceNPCs.spawnPoliceNPCMarvin();
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
