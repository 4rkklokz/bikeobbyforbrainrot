local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local WHITELIST = {
	["Strawberry Elephant"] = true,
	["Growl"] = true,
	["Dragon Cannelloni"] = true,
}

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotBrowser"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 420)
frame.Position = UDim2.new(0.5, -180, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(12, 11, 22)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 60, 180)
stroke.Thickness = 1.5
stroke.Transparency = 0.4
stroke.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 18, 42)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 9, 20)),
})
gradient.Rotation = 135
gradient.Parent = frame

local titlebar = Instance.new("Frame")
titlebar.Size = UDim2.new(1, 0, 0, 52)
titlebar.BackgroundColor3 = Color3.fromRGB(28, 22, 55)
titlebar.BorderSizePixel = 0
titlebar.ZIndex = 2
titlebar.Parent = frame
Instance.new("UICorner", titlebar).CornerRadius = UDim.new(0, 16)

local titlebarfix = Instance.new("Frame")
titlebarfix.Size = UDim2.new(1, 0, 0.5, 0)
titlebarfix.Position = UDim2.new(0, 0, 0.5, 0)
titlebarfix.BackgroundColor3 = titlebar.BackgroundColor3
titlebarfix.BorderSizePixel = 0
titlebarfix.ZIndex = 2
titlebarfix.Parent = titlebar

local titleglow = Instance.new("UIGradient")
titleglow.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 35, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 18, 55)),
})
titleglow.Rotation = 90
titleglow.Parent = titlebar

local titleicon = Instance.new("TextLabel")
titleicon.Size = UDim2.new(0, 30, 1, 0)
titleicon.Position = UDim2.new(0, 14, 0, 0)
titleicon.BackgroundTransparency = 1
titleicon.Text = "🧠"
titleicon.TextSize = 20
titleicon.Font = Enum.Font.GothamBold
titleicon.ZIndex = 3
titleicon.Parent = titlebar

local titlelabel = Instance.new("TextLabel")
titlelabel.Size = UDim2.new(1, -100, 1, 0)
titlelabel.Position = UDim2.new(0, 48, 0, 0)
titlelabel.BackgroundTransparency = 1
titlelabel.Text = "Brainrot Servers"
titlelabel.TextColor3 = Color3.fromRGB(215, 205, 255)
titlelabel.TextSize = 17
titlelabel.Font = Enum.Font.GothamBold
titlelabel.TextXAlignment = Enum.TextXAlignment.Left
titlelabel.ZIndex = 3
titlelabel.Parent = titlebar

local closebtn = Instance.new("TextButton")
closebtn.Size = UDim2.new(0, 30, 0, 30)
closebtn.Position = UDim2.new(1, -40, 0.5, -15)
closebtn.BackgroundColor3 = Color3.fromRGB(180, 50, 80)
closebtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closebtn.Text = "✕"
closebtn.TextSize = 13
closebtn.Font = Enum.Font.GothamBold
closebtn.BorderSizePixel = 0
closebtn.AutoButtonColor = false
closebtn.ZIndex = 4
closebtn.Parent = titlebar
Instance.new("UICorner", closebtn).CornerRadius = UDim.new(0, 8)

closebtn.MouseEnter:Connect(function()
	TweenService:Create(closebtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(220, 70, 100) }):Play()
end)
closebtn.MouseLeave:Connect(function()
	TweenService:Create(closebtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(180, 50, 80) }):Play()
end)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -30, 0, 1)
divider.Position = UDim2.new(0, 15, 0, 58)
divider.BackgroundColor3 = Color3.fromRGB(70, 50, 130)
divider.BorderSizePixel = 0
divider.BackgroundTransparency = 0.5
divider.Parent = frame

local countlabel = Instance.new("TextLabel")
countlabel.Size = UDim2.new(1, -30, 0, 20)
countlabel.Position = UDim2.new(0, 15, 0, 66)
countlabel.BackgroundTransparency = 1
countlabel.TextColor3 = Color3.fromRGB(120, 105, 175)
countlabel.TextSize = 12
countlabel.Font = Enum.Font.Gotham
countlabel.TextXAlignment = Enum.TextXAlignment.Left
countlabel.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -100)
scroll.Position = UDim2.new(0, 10, 0, 92)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 80, 210)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local lpadding = Instance.new("UIPadding")
lpadding.PaddingTop = UDim.new(0, 4)
lpadding.PaddingBottom = UDim.new(0, 8)
lpadding.Parent = scroll

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 46, 0, 46)
miniBtn.Position = UDim2.new(0.5, -23, 0.5, -23)
miniBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 55)
miniBtn.TextColor3 = Color3.fromRGB(215, 205, 255)
miniBtn.Text = "🧠"
miniBtn.TextSize = 22
miniBtn.Font = Enum.Font.GothamBold
miniBtn.BorderSizePixel = 0
miniBtn.AutoButtonColor = false
miniBtn.Visible = false
miniBtn.ZIndex = 10
miniBtn.Parent = gui
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(100, 70, 200)
miniStroke.Thickness = 2
miniStroke.Parent = miniBtn

miniBtn.MouseEnter:Connect(function()
	TweenService:Create(miniBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(45, 35, 85) }):Play()
end)
miniBtn.MouseLeave:Connect(function()
	TweenService:Create(miniBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(28, 22, 55) }):Play()
end)

local function makeDraggable(dragTarget, moveTarget)
	local dragging, dragStart, startPos = false, nil, nil
	dragTarget.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = moveTarget.Position
		end
	end)
	dragTarget.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			moveTarget.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

makeDraggable(titlebar, frame)
makeDraggable(miniBtn, miniBtn)

closebtn.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
		Size = UDim2.new(0, 360, 0, 0),
	}):Play()
	task.wait(0.25)
	frame.Visible = false
	miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
	miniBtn.Visible = false
	frame.Visible = true
	frame.Size = UDim2.new(0, 360, 0, 0)
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 360, 0, 420),
	}):Play()
end)

local entryCount = 0

local function makeEntry(name, order)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 60)
	card.BackgroundColor3 = Color3.fromRGB(22, 18, 42)
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	card.BackgroundTransparency = 1
	card.Parent = scroll
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Color3.fromRGB(70, 50, 130)
	cardStroke.Thickness = 1
	cardStroke.Transparency = 0.6
	cardStroke.Parent = card

	TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { BackgroundTransparency = 0 }):Play()

	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 3, 0.55, 0)
	accent.Position = UDim2.new(0, 0, 0.225, 0)
	accent.BackgroundColor3 = Color3.fromRGB(120, 80, 230)
	accent.BorderSizePixel = 0
	accent.Parent = card
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -110, 1, 0)
	label.Position = UDim2.new(0, 16, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(220, 212, 255)
	label.TextSize = 14
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 76, 0, 34)
	btn.Position = UDim2.new(1, -86, 0.5, -17)
	btn.BackgroundColor3 = Color3.fromRGB(95, 65, 215)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = "Join"
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = card
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

	local btnGrad = Instance.new("UIGradient")
	btnGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 85, 240)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 50, 190)),
	})
	btnGrad.Rotation = 90
	btnGrad.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(115, 85, 235) }):Play()
		TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 25, 52) }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(95, 65, 215) }):Play()
		TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(22, 18, 42) }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if not btn.Active then return end
		btn.Active = false

		TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(0, 68, 0, 30) }):Play()
		task.wait(0.1)
		TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(0, 76, 0, 34) }):Play()

		btn.Text = "..."
		TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(55, 40, 130) }):Play()

		local brainrotsFolder = ReplicatedStorage:FindFirstChild("Brainrots")
		if not brainrotsFolder then
			btn.Text = "Error"
			task.wait(2)
			btn.Text = "Join"
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(95, 65, 215) }):Play()
			btn.Active = true
			return
		end

		local opts = Instance.new("TeleportOptions")
		opts:SetTeleportData({ brainrot = name })

		local ok, err = pcall(function()
			TeleportService:TeleportAsync(game.PlaceId, { player }, opts)
		end)

		if not ok then
			warn(err)
			btn.Text = "Retry"
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(160, 50, 70) }):Play()
			task.wait(2)
			btn.Text = "Join"
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(95, 65, 215) }):Play()
			btn.Active = true
		end
	end)
end

local folder = ReplicatedStorage:WaitForChild("Brainrots", 10)
if folder then
	for i, v in ipairs(folder:GetChildren()) do
		if v:IsA("Folder") and WHITELIST[v.Name] then
			entryCount += 1
			makeEntry(v.Name, i)
		end
	end
	folder.ChildAdded:Connect(function(v)
		if v:IsA("Folder") and WHITELIST[v.Name] then
			entryCount += 1
			countlabel.Text = entryCount .. " server" .. (entryCount == 1 and "" or "s") .. " available"
			makeEntry(v.Name, #folder:GetChildren())
		end
	end)
end

countlabel.Text = entryCount .. " server" .. (entryCount == 1 and "" or "s") .. " available"

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)
