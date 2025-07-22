if game:GetService("CoreGui"):FindFirstChild("VuTuanScriptGUI") then
    game:GetService("CoreGui"):FindFirstChild("VuTuanScriptGUI"):Destroy()
end


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VuTuanScriptGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (syn and syn.protect_gui and syn.protect_gui(ScreenGui)) or game:GetService("CoreGui")


local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 100)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui


local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)


local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Vũ Tuấn Script"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.Parent = MainFrame


local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 45)
ToggleButton.Text = "spamluckyblock: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 18
ToggleButton.Parent = MainFrame
ToggleButton.AutoButtonColor = false
ToggleButton.BorderSizePixel = 0
ToggleButton.ClipsDescendants = true
ToggleButton.TextWrapped = true


local autoSpawn = false


task.spawn(function()
	while true do
		if autoSpawn then
			local success, err = pcall(function()
				game:GetService("ReplicatedStorage"):WaitForChild("SpawnGalaxyBlock"):FireServer()
			end)
		end
		wait(0.5)
	end
end)


ToggleButton.MouseButton1Click:Connect(function()
	autoSpawn = not autoSpawn
	if autoSpawn then
		ToggleButton.Text = "spamluckyblock: ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		ToggleButton.Text = "spamluckyblock: OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)
