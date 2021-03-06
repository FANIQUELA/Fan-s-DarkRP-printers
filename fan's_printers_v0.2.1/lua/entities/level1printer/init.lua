AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("fani_config.lua")
AddCSLuaFile("fani_config.lua")

ENT.SeizeReward = fanigreenprintamount

local PrintMore
function ENT:Initialize()
	local scolor = fanigreencolor
	local smaterial = fanimaterial

	self:SetModel("models/hunter/blocks/cube075x1x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetColor( scolor )
	self:SetMaterial( smaterial )
	local phys = self:GetPhysicsObject()
	phys:Wake()
	


	self.sparking = false
	self.damage = 100
	self.IsMoneyPrinter = true
	timer.Simple(fanigreenprinttime, function() PrintMore(self) end)

	self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	self.sound:SetSoundLevel(52)
	self.sound:PlayEx(1, 100)
end



function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded"))
end

function ENT:BurstIntoFlames()
	local stopBurst = hook.Run("moneyPrinterCatchFire", self)
	if stopBurst == true then return end

	DarkRP.notify(self:Getowning_ent(), 0, 4, DarkRP.getPhrase("money_printer_overheating"))
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	self:Remove()
end

PrintMore = function(ent)
	if not IsValid(ent) then return end

	ent.sparking = true
	timer.Simple(3, function()
		if not IsValid(ent) then return end
		ent:CreateMoneybag()
	end)
end

function ENT:CreateMoneybag()
	if not IsValid(self) or self:IsOnFire() then return end

	local MoneyPos = self:GetPos()

	local amount = fanigreenprintamount

	local prevent, hookAmount = hook.Run("moneyPrinterPrintMoney", self, amount)
	if prevent == true then return end

	amount = hookAmount or amount

	self:SetMoney( self:GetMoney() + amount )						
	
	--local moneybag = DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
	hook.Run("moneyPrinterPrinted", self, moneybag)
	self.sparking = false
	timer.Simple(fanigreenprinttime, function() PrintMore(self) end)
end

function ENT:Think()

	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end
end
	

function ENT:Use( ply )
	if self:GetMoney() > 0 then
		
		ply:addMoney( self:GetMoney() )
		
		DarkRP.notify( ply, 0, 5, "You took $" .. self:GetMoney() .. " from printer!")

		self:SetMoney( 0 )
		
	end
end


function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end
