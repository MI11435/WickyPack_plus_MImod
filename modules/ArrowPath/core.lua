-- Script property of Wicky

--=================================
--		 MAIN SCRIPT
--=================================

local execute = {}
execute.active = true

local opacity = 0.1 --透明度

local UnityEngine = CS.UnityEngine
local MeshRenderer = UnityEngine.MeshRenderer
local GameObject = UnityEngine.GameObject
local SpriteRenderer = UnityEngine.SpriteRenderer
local Vector3 = UnityEngine.Vector3
local BeatBarObjPool = nil
local _ArrowTexture = nil
local _ArrowSprite = nil
local _padSpriteObj = nil

local function KeepBeatBar()
	if BeatBarObjPool then
		local parentTransform = BeatBarObjPool.transform
		for i = 0, parentTransform.childCount - 1 do
			local childTransform = parentTransform:GetChild(i)
			local childGameObject = childTransform.gameObject
			local meshRenderer = childGameObject:GetComponent(typeof(MeshRenderer))
			meshRenderer.sortingOrder = 10
		end
	end
end

local function Pad_PlayAnimation()
	if not _padSpriteObj then return end
	_padSpriteObj.transform.localPosition = _padSpriteObj.transform.localPosition - Vector3(0, 0, 0.01)
	if _padSpriteObj.transform.localPosition.z <= 2.12 then
		_padSpriteObj.transform.localPosition = Vector3(0, 0, 5)
	end
end

execute.onloaded = function()
	BeatBarObjPool = GameObject.Find("BeatBarObjectPool")

	_ArrowTexture = execute.LoadTexture("ArrowSprite.png")
	_ArrowSprite = UTIL:CreateSprite(_ArrowTexture)
	local padSprite = GameObject.Instantiate(LaneSpritePrefab)
	padSprite:SetColor(1, 1, 1, opacity)
	padSprite:SetLanePosition(3)
	padSprite:SetSortingLayer(2)
	local padSpriteObj = padSprite.gameObject
	padSpriteObj.transform.localScale = Vector3(7, 0.8, 0)
	padSpriteObj.transform.localPosition = Vector3(0, 0, 5)
	local padSpriteComp = padSpriteObj:GetComponent(typeof(SpriteRenderer))
	padSpriteComp.sprite = _ArrowSprite
	_padSpriteObj = padSpriteObj
end

execute.update = function()
	KeepBeatBar()
	Pad_PlayAnimation()
end

execute.ondestroy = function()
	
end

return execute
