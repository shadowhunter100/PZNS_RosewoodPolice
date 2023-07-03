require "PZNS_UtilsNPCs";

---comment
function PZNS_UsePresetPoliceLightOutfit(npcSurvivor)
    PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Tshirt_PoliceBlue");
    PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Trousers_Police");
    PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Socks_Ankle");
    PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Shoes_Black");
    PZNS_AddEquipWeaponNPCSurvivor(npcSurvivor, "Base.Pistol");
    return npcSurvivor;
end
