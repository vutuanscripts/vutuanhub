local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.Parent = gui
frame.ClipsDescendants = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

local shadow = Instance.new("Frame", frame)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.85
shadow.ZIndex = -1

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🚀 Vũ Tuấn TP"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local function createButton(text, positionY, color)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -30, 0, 30)
	btn.Position = UDim2.new(0, 15, 0, positionY)
	btn.Text = text
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn)
	return btn
end

local saveButton = createButton("💾 Save", 40, Color3.fromRGB(0, 170, 255))
local teleportButton = createButton("📍 Teleport", 75, Color3.fromRGB(0, 200, 130))
local autoButton = createButton("♻️ Auto: OFF", 110, Color3.fromRGB(255, 140, 0))

local savedPosition = nil
local autoTeleport = false

saveButton.MouseButton1Click:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		savedPosition = rootPart.Position
		saveButton.Text = "✅ Saved!"
		wait(1)
		saveButton.Text = "💾 Save"
	end
end)

teleportButton.MouseButton1Click:Connect(function()
	if savedPosition then
		local character = player.Character or player.CharacterAdded:Wait()
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			rootPart.CFrame = CFrame.new(savedPosition + Vector3.new(0, 3, 0))
		end
	end
end)

autoButton.MouseButton1Click:Connect(function()
	autoTeleport = not autoTeleport
	if autoTeleport then
		autoButton.Text = "♻️ Auto: ON"
		autoButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
	else
		autoButton.Text = "♻️ Auto: OFF"
		autoButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
	end
end)

-- Auto teleport loop
task.spawn(function()
	while true do
		if autoTeleport and savedPosition then
			local character = player.Character or player.CharacterAdded:Wait()
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				rootPart.CFrame = CFrame.new(savedPosition + Vector3.new(0, 3, 0))
			end
		end
		wait(0.1)
	end
end)

-- Kéo GUI
local dragging = false
local dragStart, startPos
local userInput = game:GetService("UserInputService")

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

userInput.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
