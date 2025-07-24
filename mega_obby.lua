local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

local maxStage, teleportDelay = 727, 0.1
local isRunning = false
local currentStage = player:GetAttribute("LastStage") or 0

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	root = char:WaitForChild("HumanoidRootPart")
end)

local function teleportToStage(stageNum)
	local stageFolder = workspace:FindFirstChild("Stages")
	if not stageFolder then return end
	local stage = stageFolder:FindFirstChild(tostring(stageNum))
	if stage then
		local spawnPart = stage:FindFirstChild("Spawn")
		if spawnPart and spawnPart:IsA("BasePart") then
			root.CFrame = spawnPart.CFrame + Vector3.new(0, 4, 0)
		end
	end
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "VuTuanScripts"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 190)
main.Position = UDim2.new(0.5, -150, 0.5, -95)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

task.spawn(function()
	while gui do
		for h = 0, 1, 0.01 do
			stroke.Color = Color3.fromHSV(h, 1, 1)
			wait(0.02)
		end
	end
end)

local icon = Instance.new("ImageLabel", main)
icon.Size = UDim2.new(0, 24, 0, 24)
icon.Position = UDim2.new(0, 10, 0, 6)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://7734053864"
icon.ImageColor3 = Color3.fromRGB(0, 255, 255)

local glow = Instance.new("UIStroke", icon)
glow.Thickness = 4
glow.Transparency = 0.25

task.spawn(function()
	while icon and glow do
		for h = 0, 1, 0.01 do
			local c = Color3.fromHSV(h, 1, 1)
			icon.ImageColor3 = c
			glow.Color = c
			wait(0.03)
		end
	end
end)

task.spawn(function()
	while icon do
		local tween = ts:Create(icon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			Position = icon.Position + UDim2.new(0, 0, 0, 2)
		})
		tween:Play()
		wait(2)
	end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -44, 0, 28)
title.Position = UDim2.new(0, 42, 0, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Text = "Vũ Tuấn Scripts"

local stageLabel = Instance.new("TextLabel", main)
stageLabel.Size = UDim2.new(1, -20, 0, 20)
stageLabel.Position = UDim2.new(0, 10, 0, 44)
stageLabel.BackgroundTransparency = 1
stageLabel.Font = Enum.Font.Gotham
stageLabel.TextSize = 15
stageLabel.TextXAlignment = Enum.TextXAlignment.Left
stageLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
stageLabel.Text = "Stage: " .. currentStage .. " / " .. maxStage

local speedLabel = stageLabel:Clone()
speedLabel.Position = UDim2.new(0, 10, 0, 66)
speedLabel.Text = string.format("Speed: %.2f sec", teleportDelay)
speedLabel.TextColor3 = Color3.fromRGB(255, 230, 180)
speedLabel.Parent = main

local progress = Instance.new("Frame", main)
progress.Size = UDim2.new(currentStage / maxStage, 0, 0, 6)
progress.Position = UDim2.new(0, 0, 1, -6)
progress.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
Instance.new("UICorner", progress).CornerRadius = UDim.new(1, 0)

local inputBox = Instance.new("TextBox", main)
inputBox.Size = UDim2.new(0, 100, 0, 26)
inputBox.Position = UDim2.new(0, 20, 0, 100)
inputBox.PlaceholderText = "Start stage"
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

local delayBox = inputBox:Clone()
delayBox.PlaceholderText = "Delay (sec)"
delayBox.Position = UDim2.new(0, 140, 0, 100)
delayBox.Size = UDim2.new(0, 130, 0, 26)
delayBox.Parent = main

inputBox.FocusLost:Connect(function()
	local val = tonumber(inputBox.Text)
	if val and val >= 0 and val <= maxStage then
		currentStage = val
		stageLabel.Text = "Stage: " .. currentStage .. " / " .. maxStage
		progress.Size = UDim2.new(currentStage / maxStage, 0, 0, 6)
	end
end)

delayBox.FocusLost:Connect(function()
	local val = tonumber(delayBox.Text)
	if val and val > 0 then
		teleportDelay = val
		speedLabel.Text = string.format("Speed: %.2f sec", teleportDelay)
	end
end)

local function createBtn(text, pos, color)
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(0, 130, 0, 30)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local startBtn = createBtn("▶ Start", UDim2.new(0, 20, 1, -40), Color3.fromRGB(0, 170, 255))
startBtn.Parent = main

local resetBtn = createBtn("⟳ Reset", UDim2.new(1, -150, 1, -40), Color3.fromRGB(255, 85, 85))
resetBtn.Parent = main

resetBtn.MouseButton1Click:Connect(function()
	currentStage = 0
	player:SetAttribute("LastStage", 0)
	stageLabel.Text = "Stage: 0 / " .. maxStage
	progress.Size = UDim2.new(0, 0, 0, 6)
	startBtn.Text = "▶ Start"
	isRunning = false
end)

local function autoTeleport()
	while isRunning and currentStage <= maxStage do
		teleportToStage(currentStage)
		stageLabel.Text = "Stage: " .. currentStage .. " / " .. maxStage
		progress.Size = UDim2.new(currentStage / maxStage, 0, 0, 6)
		player:SetAttribute("LastStage", currentStage)
		currentStage += 1
		wait(teleportDelay)
	end
	if currentStage > maxStage then
		startBtn.Text = "✅ Done"
		isRunning = false
	end
end

startBtn.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	startBtn.Text = isRunning and "⏸ Stop" or "▶ Start"
	if isRunning then
		autoTeleport()
	end
end)

local dragging, dragInput, startPos, startInputPos
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		startPos = main.Position
		startInputPos = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
uis.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - startInputPos
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
