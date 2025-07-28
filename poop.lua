pcall(function()
	game.CoreGui:FindFirstChild("VuTuanScriptsMenu"):Destroy()
end)

local RS = game:GetService("ReplicatedStorage")
local PoopEvent = RS:WaitForChild("PoopEvent")
local PoopResponseChosen = RS:WaitForChild("PoopResponseChosen")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "VuTuanScriptsMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 190)
frame.Position = UDim2.new(0.5, -115, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
task.spawn(function()
	while stroke and stroke.Parent do
		for i = 0, 1, 0.02 do
			stroke.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromHSV(i, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV((i + 0.1) % 1, 1, 1))
			}
			task.wait(0.02)
		end
	end
end)

task.spawn(function()
	while frame and frame.Parent do
		for i = 0, 1, 0.01 do
			frame.BackgroundColor3 = Color3.fromHSV(i, 0.5, 0.15 + 0.1 * math.abs(math.sin(tick())))
			task.wait(0.03)
		end
	end
end)

local title = Instance.new("TextLabel", frame)
title.Text = "🌈 Vũ Tuấn Scripts"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local poopBtn = Instance.new("TextButton", frame)
poopBtn.Size = UDim2.new(0.9, 0, 0, 45)
poopBtn.Position = UDim2.new(0.05, 0, 0, 45)
poopBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
poopBtn.Text = "💩 Poop Now"
poopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
poopBtn.Font = Enum.Font.GothamBold
poopBtn.TextSize = 18
Instance.new("UICorner", poopBtn)

local autoSellBtn = Instance.new("TextButton", frame)
autoSellBtn.Size = UDim2.new(0.9, 0, 0, 45)
autoSellBtn.Position = UDim2.new(0.05, 0, 0, 100)
autoSellBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
autoSellBtn.Text = "🛒 Auto Sell: OFF"
autoSellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoSellBtn.Font = Enum.Font.GothamBold
autoSellBtn.TextSize = 18
Instance.new("UICorner", autoSellBtn)

poopBtn.MouseButton1Click:Connect(function()
	PoopEvent:FireServer(1)
end)

local autoSelling = false
autoSellBtn.MouseButton1Click:Connect(function()
	autoSelling = not autoSelling
	autoSellBtn.Text = autoSelling and "🛒 Auto Sell: ON" or "🛒 Auto Sell: OFF"
	autoSellBtn.BackgroundColor3 = autoSelling and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 140, 0)
end)

task.spawn(function()
	while true do
		if autoSelling then
			PoopResponseChosen:FireServer("2. [I want to sell my inventory.]")
		end
		task.wait(3)
	end
end)
