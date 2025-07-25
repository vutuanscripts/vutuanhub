local WEAPON_ID = "B9"
local DEFAULT_FIRE_DELAY = 0.3
local MAX_RANGE = 100
local ZOMBIE_FOLDER = workspace:WaitForChild("Enemies")
local ShootRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShootEnemy")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoShooterGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 190)
Frame.Position = UDim2.new(0.05, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Title = Instance.new("TextLabel", Frame)
Title.Text = "🌟 Vũ Tuấn Scripts"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Text = "▶ Start Auto Shoot"
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14

local SpamModeButton = Instance.new("TextButton", Frame)
SpamModeButton.Text = "⚡ Spam Mode: OFF"
SpamModeButton.Size = UDim2.new(1, -20, 0, 30)
SpamModeButton.Position = UDim2.new(0, 10, 0, 80)
SpamModeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpamModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamModeButton.Font = Enum.Font.Gotham
SpamModeButton.TextSize = 13

local ModeButton = Instance.new("TextButton", Frame)
ModeButton.Text = "🎯 Mode: Single"
ModeButton.Size = UDim2.new(1, -20, 0, 30)
ModeButton.Position = UDim2.new(0, 10, 0, 115)
ModeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeButton.Font = Enum.Font.Gotham
ModeButton.TextSize = 13

local StatusLabel = Instance.new("TextLabel", Frame)
StatusLabel.Text = "Status: Off"
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 155)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13

local autoShooting = false
local spamMode = false
local MultiTargetMode = false

task.spawn(function()
	while true do
		for h = 0, 1, 0.01 do
			local color = Color3.fromHSV(h, 1, 1)
			UIStroke.Color = color
			Title.TextColor3 = color
			ToggleButton.TextColor3 = color
			SpamModeButton.TextColor3 = color
			ModeButton.TextColor3 = color
			task.wait(0.03)
		end
	end
end)

local function getZombiesInRange()
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return {} end
	local hrp = character.HumanoidRootPart

	local targets = {}
	for _, zombie in pairs(ZOMBIE_FOLDER:GetChildren()) do
		if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
			local dist = (zombie.Head.Position - hrp.Position).Magnitude
			if dist <= MAX_RANGE then
				table.insert(targets, {zombie = zombie, distance = dist})
			end
		end
	end

	table.sort(targets, function(a, b)
		return a.distance < b.distance
	end)

	return targets
end

local function startShooting()
	while autoShooting do
		local targets = getZombiesInRange()
		if #targets > 0 then
			if MultiTargetMode then
				for _, target in ipairs(targets) do
					local zombie = target.zombie
					if zombie and zombie:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local dist = target.distance
						local args = {
							zombie,
							zombie.Head,
							zombie.Head.Position,
							0,
							WEAPON_ID
						}
						ShootRemote:FireServer(unpack(args))
						StatusLabel.Text = "Shooting: " .. zombie.Name .. " (" .. math.floor(dist) .. " studs)"
						if not spamMode then task.wait(DEFAULT_FIRE_DELAY) end
					end
				end
			else
				local target = targets[1]
				local zombie = target.zombie
				if zombie and zombie:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local dist = target.distance
					local args = {
						zombie,
						zombie.Head,
						zombie.Head.Position,
						0,
						WEAPON_ID
					}
					ShootRemote:FireServer(unpack(args))
					StatusLabel.Text = "Shooting: " .. zombie.Name .. " (" .. math.floor(dist) .. " studs)"
				end
			end
		else
			StatusLabel.Text = "Status: No Zombies in Range"
		end

		if spamMode then
			task.wait()
		else
			task.wait(DEFAULT_FIRE_DELAY)
		end
	end
end

ToggleButton.MouseButton1Click:Connect(function()
	autoShooting = not autoShooting
	if autoShooting then
		ToggleButton.Text = "⏸ Stop Auto Shoot"
		StatusLabel.Text = "Status: Searching..."
		task.spawn(startShooting)
	else
		ToggleButton.Text = "▶ Start Auto Shoot"
		StatusLabel.Text = "Status: Off"
	end
end)

SpamModeButton.MouseButton1Click:Connect(function()
	spamMode = not spamMode
	SpamModeButton.Text = spamMode and "⚡ Spam Mode: ON" or "⚡ Spam Mode: OFF"
end)

ModeButton.MouseButton1Click:Connect(function()
	MultiTargetMode = not MultiTargetMode
	ModeButton.Text = MultiTargetMode and "🎯 Mode: Multi" or "🎯 Mode: Single"
end)
