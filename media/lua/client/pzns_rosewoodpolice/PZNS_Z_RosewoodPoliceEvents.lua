require "PZNS_UtilsNPCs";
require "PZNS_NPCGroupsManager";
require "PZNS_NPCsManager";
--
local function clearBradNeeds()
    local PZNS_BradTester = "PZNS_BradTester";
    local npcSurvivor = PZNS_NPCsManager:getActiveNPCBySurvivorID(PZNS_BradTester);
    PZNS_ClearNPCAllNeedsLevel(npcSurvivor);
end
--
local function clearLeonNeeds()
    local PZNS_LeonTester = "PZNS_LeonTester";
    local npcSurvivor = PZNS_NPCsManager:getActiveNPCBySurvivorID(PZNS_LeonTester);
    PZNS_ClearNPCAllNeedsLevel(npcSurvivor);
end
--
local function clearMarvinNeeds()
    local PZNS_MarvinTester = "PZNS_MarvinTester";
    local npcSurvivor = PZNS_NPCsManager:getActiveNPCBySurvivorID(PZNS_MarvinTester);
    PZNS_ClearNPCAllNeedsLevel(npcSurvivor);
end
--
local function spawnRosewoodPoliceNPCs()
    local activatedMods = getActivatedMods();
    local frameworkID = "PZNS_Framework";
    --
    if (activatedMods:contains(frameworkID)) then
        PZNS_CreateRoseWoodPoliceGroup();
        local groupID = "PZNS_RosewoodPolice";
        local npcGroup = PZNS_NPCGroupsManager:getGroupByID(groupID);
        --
        if (npcGroup ~= nil) then
            PZNS_SpawnPoliceNPCBrad();
            PZNS_SpawnPoliceNPCMarvin();
            PZNS_SpawnPoliceNPCLeon();

            Events.EveryHours.Add(clearBradNeeds);
            Events.EveryHours.Add(clearLeonNeeds);
            Events.EveryHours.Add(clearMarvinNeeds);
        end
    else
        -- Cows: Else alert user about not having PZNS_Framework installed...
        local function callback()
            getSpecificPlayer(0):Say("!!! PZNS_RosewoodPolice IS NOT ACTIVE !!!");
            getSpecificPlayer(0):Say("!!! PZNS_Framework IS NOT INSTALLED !!!");
        end
        Events.EveryOneMinute.Add(callback);
    end
end

Events.OnGameStart.Add(spawnRosewoodPoliceNPCs);
