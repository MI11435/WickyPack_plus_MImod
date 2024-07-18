local execute = {}
execute.active = true

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