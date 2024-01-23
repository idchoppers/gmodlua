-- Author     : idchoppers
-- Description: A Lua script that gives you some advantages in game.

-- global pi
PI = math.pi

print(string.format("\n\n\n*** cheat.lua by idchoppers ***\n\n\n"))

-- finds dist between and entity and player
function target_dist(ent)
    local dist = -1
    if ent == nil then
        print("target_dist(nil)")
        return dist
    else
        local myHeadPos = LocalPlayer():EyePos()

        local BonePos, BoneAng = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
        local entHeadPos = BonePos
        local relativeX = (entHeadPos.x) - (myHeadPos.x)
        local relativeY = (entHeadPos.y) - (myHeadPos.y)
        local relativeZ = (entHeadPos.z) - (myHeadPos.z)
        dist = math.sqrt((relativeX * relativeX) + (relativeY * relativeY))
    end
    return dist
end
hook.Add("Think", "target_dist", target_dist)

-- finds the closest player for the aimbot by using a min algo
function closest_player()
    local min = 9999999999999999999.99
    local playerID = -1
    local myHeadPos = LocalPlayer():EyePos()

    for k, v in pairs (player.GetAll()) do
        if v == nil then
            print("closest_player(nil)")
            return playerID
        elseif v != LocalPlayer() and v:Health() > 0 then
            local BonePos, BoneAng = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
            local entHeadPos = BonePos
            local relativeX = (entHeadPos.x) - (myHeadPos.x)
            local relativeY = (entHeadPos.y) - (myHeadPos.y)
            local relativeZ = (entHeadPos.z) - (myHeadPos.z)
            local distanceFromMe = math.sqrt((relativeX * relativeX) + (relativeY * relativeY))

            if distanceFromMe <= min then
                min = distanceFromMe
                playerID = k
            end
        end
    end
    return playerID
end
hook.Add("Think", "closest_player", closest_player)

-- tan for ratio, arctan2 for yaw and pitch
-- need the distance vector of the target's head to use
-- distance vector = sqrt((x*x)+(y*y))
-- can use lua's math lib for tan and arctan2 functions
-- we need the arctan2 to allow for a pi interval to allow results in all 4 quadrants and not pi/2,
-- giving us only results in 2 quadrants
-- this function uses closest_entity() and TraceLine() for targeting
function aimbot()
    local target
    for k, v in pairs (player.GetAll()) do
        if v == nil then
            print("aimbot(nil)")
            break
        else
            if k == closest_player() then
                target = v

                local myHeadPos = LocalPlayer():EyePos()
                local BonePos, BoneAng = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
                local entHeadPos = BonePos
                local relativeX = (entHeadPos.x) - (myHeadPos.x)
                local relativeY = (entHeadPos.y) - (myHeadPos.y)
                local relativeZ = (entHeadPos.z) - (myHeadPos.z)
                local distanceFromMe = math.sqrt((relativeX * relativeX) + (relativeY * relativeY))

                local yaw = math.atan2(relativeY, relativeX)
                local pitch = math.atan2(relativeZ, distanceFromMe)

                yaw = (yaw * 180 / PI)
                -- the pitch should be converted to its opposite for it to work in source
                pitch = (pitch * 180 / PI) * -1

                -- traceline from player to target to check line of sight
                local trace = { start = myHeadPos, endpos = entHeadPos, filter = LocalPlayer()}
                local traceResult = util.TraceLine(trace, LocalPlayer())

                if traceResult.Entity == target then
                    LocalPlayer():SetEyeAngles(Angle(pitch, yaw, 0))
                end
            end
        end
    end
end

-- puts a nametag above all players in server
function esp() 
    local myPos = LocalPlayer():GetPos()
    for k, v in pairs (player.GetAll()) do
        if v == nil then
            print("esp(nil)")
            break
        elseif v:SteamID() == LocalPlayer():SteamID() then
        elseif v:Health() <= 0 then
        elseif v:IsAdmin() or v:IsSuperAdmin() then
            local plrpos = (v:GetPos() + Vector(0, 0, 80)):ToScreen()
            draw.DrawText("< "..v:Name().." >", "Trebuchet24", plrpos.x, plrpos.y + 30, Color(220, 60, 90, 255), 1)
            draw.DrawText("Health: " ..v:Health().. " Armor: " ..v:Armor().. "", "Trebuchet24", plrpos.x, plrpos.y + 15, Color(220, 60, 90, 255), 1)
            draw.DrawText("" ..target_dist(v).. "", "Trebuchet24", plrpos.x, plrpos.y, Color(220, 60, 90, 255), 1)
        else
            local plrpos = (v:GetPos() + Vector(0, 0, 80)):ToScreen()
            draw.DrawText("< "..v:Name().." >", "Trebuchet24", plrpos.x, plrpos.y + 30, Color(0, 255, 0), 1)
            draw.DrawText("Health: " ..v:Health().. " Armor: " ..v:Armor().. "", "Trebuchet24", plrpos.x, plrpos.y + 15, Color(0, 255, 0), 1)
            draw.DrawText("" ..target_dist(v).. "", "Trebuchet24", plrpos.x, plrpos.y, Color(0, 255, 0), 1)
        end
    end
end

-- draws a line on the screen from the center to all other player heads
function tracers()
    local myPos = LocalPlayer():GetPos()
    local center = Vector(ScrW() / 2, ScrH() / 2, 0)

    for k, v in pairs (player.GetAll()) do
        if v == nil then
            print("tracers(nil)")
            break
        elseif v:SteamID() == LocalPlayer():SteamID() then
        elseif v:Health() <= 0 then
        elseif v:IsAdmin() or v:IsSuperAdmin() then
            local BonePos, BoneAng = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
            local entHeadPos = BonePos:ToScreen()
            surface.SetDrawColor(220, 60, 90, 255)
            surface.DrawLine(center.x, center.y, entHeadPos.x, entHeadPos.y) 
        else
            local BonePos, BoneAng = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1"))
            local entHeadPos = BonePos:ToScreen()
            surface.SetDrawColor(0, 255, 0)
            surface.DrawLine(center.x, center.y, entHeadPos.x, entHeadPos.y)
        end 
    end
end

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

function triggerbot()
    local Target = LocalPlayer():GetEyeTrace().Entity
    if LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() and Target:IsPlayer() then
        RunConsoleCommand("+attack")
        timer.Create("trigga", 0, 0.149, function()
        RunConsoleCommand( "-attack" )
        end)
    end
end

-------------------------
-- add toggle commands --
-------------------------

-- add esp toggle
concommand.Add("+esp", function()
    hook.Add("HUDPaint", "esp", esp)
end)
concommand.Add("-esp", function()
    hook.Remove("HUDPaint", "esp")
end)

-- add tracers toggle
concommand.Add("+tracers", function()
    hook.Add("HUDPaint", "tracers", tracers)
end)
concommand.Add("-tracers", function()
    hook.Remove("HUDPaint", "tracers")
end)

-- add aimbot toggle (due to this being tied to the game, ab cant run constantly, so it runs
-- at the min possible delay, 0.149)
concommand.Add("+aimbot", function()
    hook.Add("Think", "aimbot", aimbot)
    timer.Create("aimbot", 0, 0.149, function() aimbot() end)
end)
concommand.Add("-aimbot", function()
    timer.Remove("aimbot")
    hook.Remove("Think", "aimbot")
end)

-- add triggerbot toggle
concommand.Add("+triggerbot", function()
    hook.Add("Think", "triggerbot", triggerbot)
end)
concommand.Add("-triggerbot", function()
    hook.Remove("Think", "triggerbot")
end)

-- add bhop toggle
concommand.Add("+bhop", function()
    hook.Add("HUDPaint", "bhop", bhop)
end)
concommand.Add("-bhop", function()
    hook.Remove("Think", "bhop")
end)

print(string.format("=== loaded cheat.lua ===\n\n"..
                    "+esp/-esp\t\t\t\ttoggles esp (red: admin, green: user)\n"..
                    "+tracers/-tracers\t\ttoggles tracers\n"..
                    "+aimbot/-aimbot\t\ttoggles aimbot\n"..
                    "+triggerbot/-triggerbot\ttoggles triggerbot\n"..
                    "+bhop/-bhop\t\t\ttoggles bhop\n\n"..
                    "====== enjoy! =======\n"))
