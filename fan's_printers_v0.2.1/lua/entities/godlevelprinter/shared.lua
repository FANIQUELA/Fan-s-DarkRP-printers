include("fani_config.lua")
AddCSLuaFile("fani_config.lua")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = fanigodname	
ENT.Author = "FANIQUELA"
ENT.AdminSpawnable = true
ENT.Spawnable = true
ENT.Category = "Fan's Addons"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Int", 1, "Money")
	
end
	