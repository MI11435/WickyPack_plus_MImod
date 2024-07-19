local execute = {}
execute.active = true
MIpozZ = function(noteController)
    local noteZ = noteController.JustBeat - GAMESTATE:GetSongBeat()
    return noteController:SetBeatPosition(noteZ)
end
MIpozZ2 = function (noteController)
    local noteZ = noteController.JustBeat - GAMESTATE:GetSongBeat()
    return noteController:SetBeatPosition(noteZ*0.75)
end
MIpozZ3 = function(noteController)
    local noteZ = noteController.JustBeat - GAMESTATE:GetSongBeat()
    return noteController:SetBeatPosition(noteZ*0.5)
end
execute.onloaded = function()
    GAMESTATE:SetActiveSameTimeBar(false)
    GAMESTATE:SetVisibleRate(18)
    _SoftLanding_MI = true
end
execute.ondestroy = function ()
    _SoftLanding_MI = false
end
return execute
--[[

ここにあったfunction onSpawnNote()はここに置くと、どう頑張っても無理だったので、main.luaに書いています。
上の関数で絶対に被らない様なグローバル変数を使って、動かしています。
これで被ったら奇跡を感じます。
by M I

]]