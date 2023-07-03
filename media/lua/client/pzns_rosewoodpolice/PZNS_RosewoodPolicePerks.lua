require "PZNS_UtilsNPCs";
---comment
---@param npcSurvivor any
---@return any
function PZNS_UsePresetPolicePerks(npcSurvivor)
    PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Strength", 5);
    PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Fitness", 5);
    PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Aiming", 3);
    PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Reloading", 3);
    return npcSurvivor;
end
