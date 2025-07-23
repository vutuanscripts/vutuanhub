local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.Parent = gui
frame.ClipsDescendants = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local shadow = Instance.new("Frame", frame)
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, -6)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.85
shadow.ZIndex = -1

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "📦 Vũ Tuấn Scripts"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", title)
titleCorner.CornerRadius = UDim.new(0, 12)

local saveButton = Instance.new("TextButton", frame)
saveButton.Size = UDim2.new(1, -40, 0, 40)
saveButton.Position = UDim2.new(0, 20, 0, 50)
saveButton.Text = "💾 Save"
saveButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Font = Enum.Font.GothamBold
saveButton.TextSize = 18
Instance.new("UICorner", saveButton)

local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(1, -40, 0, 40)
teleportButton.Position = UDim2.new(0, 20, 0, 100)
teleportButton.Text = "🚀 Teleport"
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 18
Instance.new("UICorner", teleportButton)

local savedPosition = nil

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
