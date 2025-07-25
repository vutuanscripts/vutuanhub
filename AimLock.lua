local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "VuTuanAimbot_Hacker"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 240)
main.Position = UDim2.new(0, 20, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderColor3 = Color3.fromRGB(0, 255, 0)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 4)

local slideBtn = Instance.new("TextButton", gui)
slideBtn.Size = UDim2.new(0, 30, 0, 100)
slideBtn.Position = UDim2.new(0, 0, 0.5, -50)
slideBtn.Text = "⮞"
slideBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
slideBtn.TextColor3 = Color3.new(0, 0, 0)
slideBtn.Font = Enum.Font.Code
slideBtn.TextSize = 16
Instance.new("UICorner", slideBtn).CornerRadius = UDim.new(0, 4)

local opened = true
slideBtn.MouseButton1Click:Connect(function()
	opened = not opened
	slideBtn.Text = opened and "⮞" or "⮜"
	main:TweenPosition(
		UDim2.new(0, opened and 20 or -300, 0.5, -120),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.3
	)
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "💉 VŨ TUẤN SCRIPTS - AIMBOT 🔫"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.Code
title.TextSize = 16

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0, 240, 0, 35)
toggle.Position = UDim2.new(0.5, -120, 0, 40)
toggle.Text = "AIMBOT: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.Code
toggle.TextSize = 16
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 4)

local function createInput(labelText, positionY, default)
	local label = Instance.new("TextLabel", main)
	label.Position = UDim2.new(0, 10, 0, positionY)
	label.Size = UDim2.new(0, 130, 0, 25)
	label.Text = labelText
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 0)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	local box = Instance.new("TextBox", main)
	box.Position = UDim2.new(0, 150, 0, positionY)
	box.Size = UDim2.new(0, 130, 0, 25)
	box.Text = default
	box.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
	box.TextColor3 = Color3.fromRGB(0, 255, 0)
	box.BorderColor3 = Color3.fromRGB(0, 255, 0)
	box.Font = Enum.Font.Code
	box.TextSize = 14
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)
	return box
end

local radiusBox = createInput("Radius", 85, "100")
local colorBox  = createInput("Circle Color", 120, "#00ff00")
local partBox   = createInput("Target Part", 155, "Head")

local circle = Drawing.new("Circle")
circle.Radius = 100
circle.Filled = false
circle.Thickness = 1.5
circle.Transparency = 1
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Visible = true

local aimbotOn = false
local targetPart = "Head"

toggle.MouseButton1Click:Connect(function()
	aimbotOn = not aimbotOn
	toggle.Text = "AIMBOT: " .. (aimbotOn and "ON" or "OFF")
	toggle.BackgroundColor3 = aimbotOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 30, 30)
end)

radiusBox.FocusLost:Connect(function()
	local r = tonumber(radiusBox.Text)
	if r then circle.Radius = math.clamp(r, 10, 1000) end
end)

colorBox.FocusLost:Connect(function()
	local hex = colorBox.Text:gsub("#", "")
	if #hex == 6 then
		local r = tonumber(hex:sub(1,2),16)
		local g = tonumber(hex:sub(3,4),16)
		local b = tonumber(hex:sub(5,6),16)
		if r and g and b then circle.Color = Color3.fromRGB(r,g,b) end
	end
end)

partBox.FocusLost:Connect(function()
	local txt = partBox.Text
	if txt == "Head" or txt == "HumanoidRootPart" then
		targetPart = txt
	else
		partBox.Text = "Head"
		targetPart = "Head"
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
	circle.Position = center
	if not aimbotOn then return end

	local closest, shortest = nil, math.huge
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild(targetPart) then
			local part = p.Character[targetPart]
			local pos, vis = cam:WorldToViewportPoint(part.Position)
			local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
			if vis and dist < circle.Radius and dist < shortest then
				shortest = dist
				closest = part
			end
		end
	end

	if closest then
		cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
	end
end)
