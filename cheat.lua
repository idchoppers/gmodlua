-- idchoppers goofy ah gmod cheats

function thirdeye()
    for k, v in pairs (player.GetAll()) do
        local plrpos = (v:GetPos() + Vector(0, 0, 80)):ToScreen()
        if v:IsAdmin() or v:IsSuperAdmin() then
            draw.DrawText("" ..v:Name().. "[ADMIN]", "Trebuchet24", plrpos.x, plrpos.y, Color(220, 60, 90, 255), 1)
        else
            draw.DrawText(v:Name(), "Trebuchet24", plrpos.x, plrpos.y, Color(0, 255, 0), 1)
        end
    end
end
hook.Add("HUDPaint", "thirdeye", thirdeye)

function norecoil()
	if Recoil == false and WeaponCheck() then
		LocalPlayer():GetActiveWeapon().Primary.Recoil = 0
	end
end
hook.Add("Think", "norecoil", norecoil)

function bhop()
    if input.IsKeyDown(KEY_SPACE) then
        if LocalPlayer():IsOnGround() then
            RunConsoleCommand("+jump")
            timer.Create("bhop", 0, 0.01, function()
            RunConsoleCommand("-jump")
            end)
        end
    end
end
hook.Add("Think", "bhop", bhop)

function trigga()
    local Target = LocalPlayer():GetEyeTrace().Entity
    if LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() and ( Target:IsPlayer() or Target:IsNPC() ) then
        RunConsoleCommand("+attack")
        timer.Create("trigga", 0, 0.01, function()
        RunConsoleCommand( "-attack" )
        end)
    end
end

function aimbot()
    local me = LocalPlayer()
    local trace = util.GetPlayerTrace(me)
    local traceres = util.TraceLine(trace)

    if traceres.HitNonWorld then
        local target = traceres.Entity
        
        if target:IsPlayer() then 
            local targethead = target:LookupBone("ValveBiped.Bip01_Head1")
            local targetheadpos, targetheadang = target:GetBonePosition(targethead)
            me:SetEyeAngles((targetheadpos - me:GetShootPos()):Angle())
        end
    end
end
hook.Add("Think", "aimbot", aimbot)
hook.Add( "Think", "trigga", trigga)