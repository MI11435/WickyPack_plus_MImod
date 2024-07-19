-- --著者: Wicky
local File = CS.System.IO.File
local Directory = CS.System.IO.Directory
local Path = CS.System.IO.Path
local Assembly = CS.System.Reflection.Assembly

local parentDir = nil
local LIP = require("tools\\LIP.lua")

local settingsDir = nil
local settings = nil

local allModules = {}
local modules = {}
local scripts = {}

local function loadAllScripts()
	local files = Directory.GetDirectories(Path.Combine(parentDir, "modules"));

	for i = 0, files.Length -1 do
		local path = Path.Combine(files[i], "core.lua")
		if File.Exists(path) then
			local folderName = Path.GetFileNameWithoutExtension(files[i])

			if folderName ~= "Settings" then
				table.insert(allModules, folderName)
			end

			if settings[folderName] ~= nil and settings[folderName].enable == 1 then
				local script = require(path)

				if script ~= nil and script.active == true then
					script.GetOption  = function(key)
						if settings[folderName] == nil then
							return nil
						end
						return settings[folderName][key]
					end
					script.SetOption  = function(key, value)
						if settings[folderName] == nil then
							settings[folderName] = {}
						end
						settings[folderName][key] = value
					end
					script.SaveOption = function()
						LIP.save(settingsDir, settings)
					end
					table.insert(modules, files[i])
					table.insert(scripts, script)
				end
			end
		end
	end

	print("Loaded " .. #scripts .. " scripts")
	util.InsertModules(allModules)
end

function onloaded()
	local platform = APPMAN:GetPlatformInt()

	if platform == 3 or platform == 4 then
		parentDir = CS.UnityEngine.Application.persistentDataPath .. "/GlobalLua/DankaguLike_GLWickyPack/"
	else
		parentDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) .. "\\GlobalLua\\DankaguLike_GLWickyPack\\"
	end

	util = require("tools\\utils.lua")
	settingsDir = parentDir .. "settings.ini"
	settings = LIP.load(settingsDir);

	util.InsertParentDir(parentDir)
	util.InsertSettings(LIP, settingsDir)
	loadAllScripts()

	for i = 1, #scripts do
		scripts[i].LoadTexture = function(asset)
			return UTIL:LoadTexture(modules[i] .. "\\" .. asset)
		end
		scripts[i].LoadAssetBundle = function(asset)
			return ASSETMAN:LoadAssetBundle(modules[i] .. "\\" .. asset)
		end
		scripts[i].LoadAudio = function (asset,name)
			return name:LoadAudio(modules[i] .. "\\" .. asset)
		end
		if scripts[i].onloaded == nil then goto continue end
		scripts[i]:onloaded()
		::continue::
	end
end

function start()
	local canvas = util.GetCanvas()
	local canvasComp = canvas:GetComponent(typeof(CS.UnityEngine.Canvas))
	canvasComp.renderMode = CS.UnityEngine.RenderMode.ScreenSpaceOverlay
	canvasComp.sortingOrder = 5

	for i = 1, #scripts do
		if scripts[i].start == nil then goto continue end
		scripts[i]:start()
		::continue::
	end
end

function update()
	for i = 1, #scripts do
		if scripts[i].update == nil then goto continue end
		scripts[i]:update()
		::continue::
	end
end

function finish()
	for i = 1, #scripts do
		if scripts[i].finish == nil then goto continue end
		scripts[i]:finish()
		::continue::
	end
end

function onHitNote(id, lane, noteType, judgeType)
	for i = 1, #scripts do
		if scripts[i].onHitNote == nil then goto continue end
		scripts[i]:onHitNote(id, lane, noteType, judgeType)
		::continue::
	end
end

function onMissedNote(id, lane, noteType)
	for i = 1, #scripts do
		if scripts[i].onMissedNote == nil then goto continue end
		scripts[i]:onMissedNote(id, lane, noteType)
		::continue::
	end
end
---MImod
---
--- @param noteController CS.NoteController
---
function onSpawnNote(noteController)
	if (noteController.NoteType==CS.NoteType.Fuzzy or noteController.NoteType==CS.NoteType.Normal) and _SoftLanding_MI == true then
        if noteController.NoteIndex%3==0 then
            GAMESTATE:SetAutoType(1)
            noteController:EnableDefaultMove(false)
            noteController:SetLanePosition(noteController.Lane)
            noteController:SetDelegate(MIpozZ)
        elseif noteController.NoteIndex%3==1 then
            GAMESTATE:SetAutoType(1)
            noteController:EnableDefaultMove(false)
            noteController:SetLanePosition(noteController.Lane)
            noteController:SetDelegate(MIpozZ2)
        else
            GAMESTATE:SetAutoType(1)
            noteController:EnableDefaultMove(false)
            noteController:SetLanePosition(noteController.Lane)
            noteController:SetDelegate(MIpozZ3)
        end
    end
end
--
function onPause()
	for i = 1, #scripts do
		if scripts[i].onPause == nil then goto continue end
		scripts[i]:onPause()
		::continue::
	end
end

function onResume()
	for i = 1, #scripts do
		if scripts[i].onResume == nil then goto continue end
		scripts[i]:onResume()
		::continue::
	end
end

function onInputDown(touchId, posX, screenPosX, screenPosY)
	for i = 1, #scripts do
		if scripts[i].onInputDown == nil then goto continue end
		scripts[i]:onInputDown(touchId, posX, screenPosX, screenPosY)
		::continue::
	end
end

function onInputMove(touchId, posX, screenPosX, screenPosY)
	for i = 1, #scripts do
		if scripts[i].onInputMove == nil then goto continue end
		scripts[i]:onInputMove(touchId, posX, screenPosX, screenPosY)
		::continue::
	end
end

function onInputUp(touchId, posX, screenPosX, screenPosY)
	for i = 1, #scripts do
		if scripts[i].onInputUp == nil then goto continue end
		scripts[i]:onInputUp(touchId, posX, screenPosX, screenPosY)
		::continue::
	end
end

function ondestroy()
	for i = 1, #scripts do
		if scripts[i].ondestroy == nil then goto continue end
		scripts[i]:ondestroy()
		::continue::
	end

	for _, moduleName in ipairs(modules) do
		package.loaded[moduleName] = nil
	end

	for _, moduleName in ipairs(modules) do
		_G[moduleName] = nil
	end

	package.loaded['tools\\utils.lua'] = nil
	_G['tools\\utils.lua'] = nil
end
