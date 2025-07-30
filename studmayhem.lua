local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "VuTuanScriptsGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 210)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "📂 Vũ Tuấn Scripts 🇻🇳"
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.TextColor3 = Color3.fromRGB(255, 255, 0)

local collectBtn = Instance.new("TextButton", frame)
collectBtn.Size = UDim2.new(0.9, 0, 0, 35)
collectBtn.Position = UDim2.new(0.05, 0, 0, 40)
collectBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
collectBtn.TextColor3 = Color3.new(1, 1, 1)
collectBtn.Font = Enum.Font.GothamBold
collectBtn.TextSize = 14
collectBtn.Text = "Auto Collect: OFF"
Instance.new("UICorner", collectBtn).CornerRadius = UDim.new(0, 8)

local sellBtn = Instance.new("TextButton", frame)
sellBtn.Size = UDim2.new(0.9, 0, 0, 35)
sellBtn.Position = UDim2.new(0.05, 0, 0, 85)
sellBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sellBtn.TextColor3 = Color3.new(1, 1, 1)
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 14
sellBtn.Text = "Auto Sell: OFF"
Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0, 8)

local distanceLabel = Instance.new("TextLabel", frame)
distanceLabel.Size = UDim2.new(0.9, 0, 0, 20)
distanceLabel.Position = UDim2.new(0.05, 0, 0, 130)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "Distance (Studs):"
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.TextSize = 14
distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local distanceBox = Instance.new("TextBox", frame)
distanceBox.Size = UDim2.new(0.9, 0, 0, 25)
distanceBox.Position = UDim2.new(0.05, 0, 0, 155)
distanceBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
distanceBox.PlaceholderText = "100"
distanceBox.Text = "100"
distanceBox.TextColor3 = Color3.new(1, 1, 1)
distanceBox.Font = Enum.Font.Gotham
distanceBox.TextSize = 14
Instance.new("UICorner", distanceBox)

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 0.9, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Text = "Mở Giao Diện"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner", toggleBtn)

local collectEnabled, sellEnabled = false, false
local radius = 100
local RunService = game:GetService("RunService")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

collectBtn.MouseButton1Click:Connect(function()
	collectEnabled = not collectEnabled
	collectBtn.Text = collectEnabled and "Auto Collect: ON" or "Auto Collect: OFF"
	collectBtn.BackgroundColor3 = collectEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)

sellBtn.MouseButton1Click:Connect(function()
	sellEnabled = not sellEnabled
	sellBtn.Text = sellEnabled and "Auto Sell: ON" or "Auto Sell: OFF"
	sellBtn.BackgroundColor3 = sellEnabled and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(60, 60, 60)
end)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleBtn.Text = frame.Visible and "Đóng Giao Diện" or "Mở Giao Diện"
end)

distanceBox.FocusLost:Connect(function()
	local val = tonumber(distanceBox.Text)
	if val and val > 0 then
		radius = val
	else
		distanceBox.Text = tostring(radius)
	end
end)

local function touch(part)
	pcall(function()
		firetouchinterest(hrp, part, 0)
		task.wait()
		firetouchinterest(hrp, part, 1)
	end)
end

RunService.RenderStepped:Connect(function()
	if collectEnabled then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name:find("Stud") and obj:IsDescendantOf(workspace.Spawners) then
				if (hrp.Position - obj.Position).Magnitude <= radius then
					touch(obj)
				end
			end
		end
	end
end)

task.spawn(function()
	while true do
		if sellEnabled then
			pcall(function()
				game:GetService("ReplicatedStorage"):WaitForChild("Sell"):WaitForChild("SellEvent"):FireServer("All", player)
			end)
		end
		task.wait(1)
	end
end)

task.spawn(function()
	local hue = 0
	while gui do
		hue = (hue + 0.005) % 1
		local color = Color3.fromHSV(hue, 1, 1)
		stroke.Color = color
		title.TextColor3 = color
		task.wait(0.02)
	end
end)
