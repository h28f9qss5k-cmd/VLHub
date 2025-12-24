-- Volleyball Legends Auto Hub
-- Auto Dive / Auto Set / Auto Spike
-- Xeno Loader Version

if _G.VL_AUTOHUB_LOADED then return end
_G.VL_AUTOHUB_LOADED = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

local function getChar()
    return lp.Character or lp.CharacterAdded:Wait()
end

-- ===== 状態 =====
local AutoDive = false
local AutoSet = false
local AutoSpike = false

-- ===== ボール取得 =====
local function getBall()
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("ball") then
            return v
        end
    end
end

-- ===== 攻撃 =====
local function useTool(char)
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function()
            tool:Activate()
        end)
    end
end

-- ===== メイン処理 =====
task.spawn(function()
    while task.wait(0.05) do
        local char = getChar()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then continue end

        local ball = getBall()
        if not ball then continue end

        local dist = (ball.Position - hrp.Position).Magnitude
        local y = ball.Position.Y - hrp.Position.Y

        -- Auto Dive（低い）
        if AutoDive and dist < 14 and y < 2 then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            useTool(char)
        end

        -- Auto Set（頭付近）
        if AutoSet and dist < 10 and y >= 3 and y < 5 then
            useTool(char)
        end

        -- Auto Spike（高い）
        if AutoSpike and dist < 9 and y >= 5 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            useTool(char)
        end
    end
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "VL_AutoHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0, 30, 0.5, -105)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Volleyball Legends Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

local function makeBtn(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.Parent = frame
    b.MouseButton1Click:Connect(function()
        callback(b)
    end)
end

makeBtn("Auto Dive : OFF", 50, function(b)
    AutoDive = not AutoDive
    b.Text = "Auto Dive : " .. (AutoDive and "ON" or "OFF")
end)

makeBtn("Auto Set : OFF", 100, function(b)
    AutoSet = not AutoSet
    b.Text = "Auto Set : " .. (AutoSet and "ON" or "OFF")
end)

makeBtn("Auto Spike : OFF", 150, function(b)
    AutoSpike = not AutoSpike
    b.Text = "Auto Spike : " .. (AutoSpike and "ON" or "OFF")
end)

print("VL AutoHub Loaded")
