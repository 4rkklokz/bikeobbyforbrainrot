local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotBrowser"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 400)
frame.Position = UDim2.new(0.5, -170, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
title.BorderSizePixel = 0
title.Text = "🧠 Brainrot Servers"
title.TextColor3 = Color3.fromRGB(210, 200, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 14)

local titlefix = Instance.new("Frame")
titlefix.Size = UDim2.new(1, 0, 0.5, 0)
titlefix.Position = UDim2.new(0, 0, 0.5, 0)
titlefix.BackgroundColor3 = title.BackgroundColor3
titlefix.BorderSizePixel = 0
titlefix.Parent = title

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local function makeEntry(name, order)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 54)
	card.BackgroundColor3 = Color3.fromRGB(28, 24, 50)
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	card.Parent = scroll
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -110, 1, 0)
	label.Position = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(220, 215, 255)
	label.TextSize = 15
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 78, 0, 34)
	btn.Position = UDim2.new(1, -88, 0.5, -17)
	btn.BackgroundColor3 = Color3.fromRGB(95, 65, 215)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = "Join"
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = card
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(115, 85, 235) end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(95, 65, 215) end)

	btn.MouseButton1Click:Connect(function()
		btn.Text = "..."
		btn.BackgroundColor3 = Color3.fromRGB(55, 40, 130)
		btn.Active = false
		local opts = Instance.new("TeleportOptions")
		opts:SetTeleportData({ brainrot = name })
		local ok, err = pcall(function()
			TeleportService:TeleportAsync(game.PlaceId, { player }, opts)
		end)
		if not ok then
			warn(err)
			btn.Text = "Join"
			btn.BackgroundColor3 = Color3.fromRGB(95, 65, 215)
			btn.Active = true
		end
	end)
end

local folder = ReplicatedStorage:WaitForChild("Brainrots", 10)
if folder then
	for i, v in ipairs(folder:GetChildren()) do
		if v:IsA("Folder") then makeEntry(v.Name, i) end
	end
	folder.ChildAdded:Connect(function(v)
		if v:IsA("Folder") then makeEntry(v.Name, #folder:GetChildren()) end
	end)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)
