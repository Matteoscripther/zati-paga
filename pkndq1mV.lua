local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CamlockState = false
local Prediction = 0.18474847487487474
local enemy = nil

-- Create Tool
local Tool = Instance.new("Tool")
Tool.Name = "zati.tool"
Tool.RequiresHandle = false
Tool.Parent = LocalPlayer.Backpack

-- Function to find the nearest enemy
local function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local CenterPosition = Vector2.new(game:GetService("GuiService"):GetScreenResolution().X / 2, game:GetService("GuiService"):GetScreenResolution().Y / 2)

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 then
                local Position, IsVisibleOnViewport = workspace.CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character.HumanoidRootPart
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

-- Function to toggle camlock
local function ToggleCamlock()
    CamlockState = not CamlockState

    if CamlockState then
        enemy = FindNearestEnemy()
        if enemy then
            print("Locking on to: " .. enemy.Parent.Name)
        else
            print("No enemy found")
        end
    else
        enemy = nil
        print("Camlock off")
    end
end

-- Function to determine prediction based on ping
local function GetPredictionBasedOnPing(ping)
    if ping <= 40 then return 0.122202322
    elseif ping <= 70 then return 0.13301432
    elseif ping <= 90 then return 0.141011312
    elseif ping <= 120 then return 0.151230
    elseif ping <= 140 then return 0.1633
    elseif ping <= 160 then return 0.1700
    elseif ping <= 180 then return 0.180440
    elseif ping <= 200 then return 0.19433
    elseif ping <= 220 then return 0.2043
    elseif ping <= 240 then return 0.213
    elseif ping <= 260 then return 0.223
    elseif ping <= 280 then return 0.230
    else return 0.244
    end
end

-- Equip tool and connect ToggleCamlock to the tool's activation
Tool.Equipped:Connect(function(mouse)
    mouse.Button1Down:Connect(function()
        ToggleCamlock()
    end)
end)

-- Aim the camera at the nearest enemy's HumanoidRootPart
RunService.Heartbeat:Connect(function()
    if CamlockState and enemy then
        local ping = game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue()
        Prediction = GetPredictionBasedOnPing(ping)
        local camera = workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.p, enemy.Position + enemy.Velocity * Prediction)
    end
end)