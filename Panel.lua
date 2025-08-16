--// Panel GUI Script (style Li)
-- Made for bro 😎

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Panel = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextButton", Panel)
local CmdBox = Instance.new("TextBox", Panel)
local Toggle = Instance.new("TextButton", ScreenGui)

-- Panel
Panel.Size = UDim2.new(0, 300, 0, 200)
Panel.Position = UDim2.new(0.3, 0, 0.3, 0)
Panel.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Panel.Active = true
Panel.Draggable = true

-- Title Bar
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "Panel"
Title.TextColor3 = Color3.fromRGB(255,255,255)

-- Command Box
CmdBox.Size = UDim2.new(1, -20, 0, 30)
CmdBox.Position = UDim2.new(0,10,0,50)
CmdBox.PlaceholderText = "Nhập lệnh ở đây..."
CmdBox.Text = ""
CmdBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
CmdBox.TextColor3 = Color3.fromRGB(0,0,0)

-- Toggle Button
Toggle.Size = UDim2.new(0,50,0,50)
Toggle.Position = UDim2.new(0,10,0.2,0)
Toggle.Text = "Li"
Toggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
Toggle.TextColor3 = Color3.fromRGB(0,0,0)

-- Toggle Show/Hide
local visible = true
Toggle.MouseButton1Click:Connect(function()
    visible = not visible
    Panel.Visible = visible
end)

-- Command System
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

function getPlayer(name)
    for _,p in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(p.Name),1,#name) == string.lower(name) then
            return p
        end
    end
end

CmdBox.FocusLost:Connect(function(enter)
    if enter then
        local args = string.split(CmdBox.Text," ")
        local cmd = string.lower(args[1])
        local target = args[2]
        local num = tonumber(args[2])

        if cmd == "headsit" and target then
            local plr = getPlayer(target)
            if plr and plr.Character and plr.Character:FindFirstChild("Head") then
                lp.Character.HumanoidRootPart.CFrame = plr.Character.Head.CFrame + Vector3.new(0,2,0)
                local weld = Instance.new("WeldConstraint", lp.Character.HumanoidRootPart)
                weld.Part0 = lp.Character.HumanoidRootPart
                weld.Part1 = plr.Character.Head
            end
        elseif cmd == "bang" and target then
            local plr = getPlayer(target)
            if plr and plr.Character then
                lp.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                local weld = Instance.new("WeldConstraint", lp.Character.HumanoidRootPart)
                weld.Part0 = lp.Character.HumanoidRootPart
                weld.Part1 = plr.Character.HumanoidRootPart
            end
        elseif cmd == "teleport" and target then
            local plr = getPlayer(target)
            if plr and plr.Character then
                lp.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
        elseif cmd == "view" and target then
            local plr = getPlayer(target)
            if plr then
                workspace.CurrentCamera.CameraSubject = plr.Character:FindFirstChild("Humanoid")
            end
        elseif cmd == "copyskin" and target then
            local plr = getPlayer(target)
            if plr and plr.Character then
                lp.Character:Destroy()
                plr.Character.Archivable = true
                local clone = plr.Character:Clone()
                clone.Parent = workspace
                lp.Character = clone
            end
        elseif cmd == "speed" and num then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = num
        elseif cmd == "jump" and num then
            lp.Character:FindFirstChildOfClass("Humanoid").JumpPower = num
        elseif cmd == "fly" then
            -- simple fly
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
            local flying = true
            local speed = tonumber(args[2]) or 50
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(4000,4000,4000)
            game:GetService("RunService").Heartbeat:Connect(function()
                if flying then
                    bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector) * speed
                else
                    bv:Destroy()
                end
            end)
        end

        CmdBox.Text = ""
    end
end)
