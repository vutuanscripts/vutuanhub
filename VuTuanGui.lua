if game:GetService("CoreGui"):FindFirstChild("VuTuanScriptGUI") then
    game:GetService("CoreGui"):FindFirstChild("VuTuanScriptGUI"):Destroy()
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", (syn and syn.protect_gui and syn.protect_gui()) or game.CoreGui)
gui.Name = "VuTuanScriptGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

task.spawn(function()
	while true do
		local t = tick() * 0.5
		local r = math.sin(t) * 127 + 128
		local g = math.sin(t + 2) * 127 + 128
		local b = math.sin(t + 4) * 127 + 128
		frame.BackgroundColor3 = Color3.fromRGB(r, g, b)
		task.wait(0.03)
	end
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Vũ Tuấn Scripts"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -20, 0, 35)
btn.Position = UDim2.new(0, 10, 0, 50)
btn.Text = "Auto: OFF"
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.Gotham
btn.TextSize = 16
btn.AutoButtonColor = false
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local auto = false
local blinkTween

task.spawn(function()
	while true do
		if auto then
			pcall(function()
				game:GetService("ReplicatedStorage"):WaitForChild("SpawnGalaxyBlock"):FireServer()
			end)
		end
		wait(0.5)
	end
end)

btn.MouseButton1Click:Connect(function()
	auto = not auto
	if auto then
		btn.Text = "Auto: ON"
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		local goal = {BackgroundColor3 = Color3.fromRGB(240, 240, 240)}
		blinkTween = TweenService:Create(btn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), goal)
		blinkTween:Play()
		local stroke = Instance.new("UIStroke", btn)
		stroke.Name = "GlowStroke"
		stroke.Thickness = 2
		stroke.Transparency = 0.3
		stroke.Color = Color3.fromRGB(255, 255, 255)
	else
		btn.Text = "Auto: OFF"
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		if blinkTween then blinkTween:Cancel() blinkTween = nil end
		local s = btn:FindFirstChild("GlowStroke") if s then s:Destroy() end
	end
end)
