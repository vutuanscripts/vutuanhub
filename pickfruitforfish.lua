local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remoteArgs = {
	"\233\163\159\231\137\169\231\130\185\229\135\187",
	1002
}
local sellArgs = {
	"\229\141\150\230\142\137\229\133\168\233\131\168\229\174\157\231\137\169",
	{}
}

local autoSend = false
local autoSell = false

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoFarmPro"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0.5, -125, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌟 Vũ Tuấn Scripts"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local function createToggle(name, positionY, text)
	local button = Instance.new("TextButton", frame)
	button.Name = name
	button.Size = UDim2.new(0, 210, 0, 40)
	button.Position = UDim2.new(0.5, -105, 0, positionY)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 14
	button.Text = text .. ": OFF"
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
	return button
end

local sendButton = createToggle("SendButton", 40, "⚡ Auto Send")
local sellButton = createToggle("SellButton", 90, "💰 Auto Sell")

sendButton.MouseButton1Click:Connect(function()
	autoSend = not autoSend
	sendButton.Text = "⚡ Auto Send: " .. (autoSend and "ON" or "OFF")
	sendButton.BackgroundColor3 = autoSend and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(50, 50, 50)
end)

sellButton.MouseButton1Click:Connect(function()
	autoSell = not autoSell
	sellButton.Text = "💰 Auto Sell: " .. (autoSell and "ON" or "OFF")
	sellButton.BackgroundColor3 = autoSell and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(50, 50, 50)
end)

task.spawn(function()
	while true do
		if autoSend then
			pcall(function()
				ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(remoteArgs))
			end)
		end
		if autoSell then
			pcall(function()
				ReplicatedStorage:WaitForChild("Msg"):WaitForChild("TalkFunc"):InvokeServer(unpack(sellArgs))
			end)
		end
		task.wait(0.01)
	end
end)
