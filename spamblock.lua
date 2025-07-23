local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "VuTuanScriptsCute"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(255, 220, 230)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3
task.spawn(function()
	local h = 0
	while true do
		stroke.Color = Color3.fromHSV(h, 0.7, 1)
		h = (h + 0.01) % 1
		task.wait(0.03)
	end
end)

local catIcon = Instance.new("ImageLabel", frame)
catIcon.Size = UDim2.new(0, 30, 0, 30)
catIcon.Position = UDim2.new(0, 5, 0, 5)
catIcon.BackgroundTransparency = 1
catIcon.Image = "rbxassetid://6031091007"

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 40, 0, 5)
title.Text = "Vũ Tuấn Scripts 🐱💖"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 105, 180)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255, 105, 105)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8, 0, 0, 50)
button.Position = UDim2.new(0.1, 0, 0, 60)
button.Text = "Spam Block VIP: OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 140, 160)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 100, 0, 40)
openBtn.Position = UDim2.new(0, 10, 1, -50)
openBtn.Text = "ON GUI"
openBtn.BackgroundColor3 = Color3.fromRGB(255, 160, 200)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.Gotham
openBtn.TextScaled = true
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)
openBtn.Visible = false

local auto = false
task.spawn(function()
	while true do
		if auto then
			pcall(function()
				game:GetService("ReplicatedStorage"):WaitForChild("SpawnGalaxyBlock"):FireServer()
			end)
		end
		task.wait()
	end
end)

button.MouseButton1Click:Connect(function()
	auto = not auto
	if auto then
		button.Text = "Spam Block VIP: ON"
		button.BackgroundColor3 = Color3.fromRGB(120, 255, 180)
	else
		button.Text = "Spam Block VIP: OFF"
		button.BackgroundColor3 = Color3.fromRGB(255, 140, 160)
	end
end)

close.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
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

UIS.TouchMoved:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
