include("shared.lua")
include("fani_config.lua")
AddCSLuaFile("fani_config.lua")

function ENT:Initialize()
end

surface.CreateFont( "PrinterFont", {
	font = "Helvatica", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 75,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "MoneyFont", {
	font = "Helvatica", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 60,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "uiFont", {
	font = "Helvatica", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )



function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	local pcurrency = faniprintercurrency
	local money = pcurrency .. self:GetMoney()
	local rateui = fanigodprintamount * 12
  	local level = fanigodname

  	local ratetr = faniratetranslate
  	local ratemin = faniminutetranslate 




  	
Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up() * 6, Ang, 0.07)
	--base
	
	draw.RoundedBox(7, -340, -254, 680, 500, Color(85,34,37))
	draw.RoundedBox(7, -335, -155, 670, 310, Color(30,30,30))
	
	
	--ustpencere

    draw.RoundedBox(7, -320, -140, 640, 275, Color(50,50,50))
	draw.RoundedBox(7, -320, -140, 640, 30, Color(40,40,40))

	--altpencere

	--draw.RoundedBox(7, -320, 15, 640, 120, Color(50,50,50))
	--draw.RoundedBox(7, -320, 0, 640, 30, Color(40,40,40))



	draw.SimpleText(level, "PrinterFont", 0, -207,  Color( 255, 255, 255, 255 ), 1, 1)
	draw.SimpleText(owner, "PrinterFont", 2, 195, Color( 255, 255, 255, 255 ), 1, 1)
	draw.SimpleText(ratetr..": "..pcurrency ..rateui.."/" ..ratemin , "uiFont", 0, -126, Color( 255, 255, 255, 255 ), 1, 1)		
		
	cam.End3D2D()
	
	Ang:RotateAroundAxis(Ang:Up(), 0)
	
	
	cam.Start3D2D(Pos + Ang:Up() * 6, Ang, 0.11)
		draw.SimpleText(money, "MoneyFont", 0, 0, Color( 255, 255, 255, 255 ), 1, 1)
	
	cam.End3D2D()
end



function ENT:Think()
end
