--著者: Wicky

-- require "tools/module.lua"

local _TextCanvasText = nil
local UnityEngine = CS.UnityEngine
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3
local Material = UnityEngine.Material
local Resources = UnityEngine.Resources
local GameObject = UnityEngine.GameObject

local execute = {}
execute.active = true

--=================================
--		 MAIN SCRIPT
--=================================

local function CreateLyricCanvas(WickyCanvas, name, pos, color, text, size)
	local TextCanvas = GameObject(name)
	TextCanvas.gameObject.transform:SetParent(WickyCanvas.transform, false)
	TextCanvas:AddComponent(typeof(UnityEngine.CanvasRenderer))
	_TextCanvasText = TextCanvas:AddComponent(typeof(UnityEngine.UI.Text))
	TextCanvas.transform.anchorMin = Vector2(0, 0)
	TextCanvas.transform.anchorMax = Vector2(1, 1)
	TextCanvas.transform.localPosition = pos
	TextCanvas.transform.sizeDelta = Vector2(0, 0)
	_TextCanvasText.font = util.GetFontJP()
	_TextCanvasText.fontSize = size
	_TextCanvasText.alignment = UnityEngine.TextAnchor.UpperRight
	_TextCanvasText.text = text
	_TextCanvasText.color = color
end

execute.onloaded = function(e)
	
	WickyCanvas = util.GetCanvas()

	Wicky_diffText = ''
	Wicky_diffColor = util:ColorRGB(0, 0, 0)
	Wicky_diffType = SONGMAN:GetDifficultyToInt()
	Wicky_diffMeter = SONGMAN:GetMeter()
   Wicky_diffX = false

	if Wicky_diffType == 0 then 
		Wicky_diffText = "Easy"
		Wicky_diffColor = util:ColorRGB(0, 255, 32)
	elseif Wicky_diffType == 1 then
		Wicky_diffText = "Normal"
		Wicky_diffColor = util:ColorRGB(0, 133, 255)
	elseif Wicky_diffType == 2 then
		Wicky_diffText = "Hard"
		Wicky_diffColor = util:ColorRGB(255, 235, 0)
	elseif Wicky_diffType == 3 then
		Wicky_diffText = "Extra"
		Wicky_diffColor = util:ColorRGB(255, 0, 34)
	elseif Wicky_diffType == 4 then
		Wicky_diffText = "Lunatic"
		Wicky_diffColor = util:ColorRGB(222, 0, 255)
	end
	UTIL:DelayAction(1,MIdelay) 
end
function MIdelay()
	if _Houkai==1 then
		Wicky_diffText = "壊:" .. Wicky_diffText
	end

    Wicky_diffX = Wicky_diffMeter == 12345678

    if (Wicky_diffX) then
        CreateLyricCanvas(WickyCanvas, "TextDifficultyShadow", Vector3(-33, -1002, 0), Wicky_diffColor, Wicky_diffText .. ' X', 36) --36 = サイズ
        CreateLyricCanvas(WickyCanvas, "TextDifficulty", Vector3(-35, -1000, 0), util:ColorRGB(255, 255, 255), Wicky_diffText .. ' X', 36) --36 = サイズ
    else 
        CreateLyricCanvas(WickyCanvas, "TextDifficultyShadow", Vector3(-33, -1002, 0), Wicky_diffColor, Wicky_diffText .. ' ' .. Wicky_diffMeter, 36) --36 = サイズ
        CreateLyricCanvas(WickyCanvas, "TextDifficulty", Vector3(-35, -1000, 0), util:ColorRGB(255, 255, 255), Wicky_diffText .. ' ' .. Wicky_diffMeter, 36) --36 = サイズ
    
    end
end

return execute