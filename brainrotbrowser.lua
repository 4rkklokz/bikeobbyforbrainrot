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

-- GUI dimensions
local GUI_W = 340
local GUI_H = 460
local MINI = 40

-- Center on screen open
local function getCenterPos()
	local vp = workspace.CurrentCamera.ViewportSize
	return UDim2.new(0, math.floor((vp.X - GUI_W) / 2), 0, math.floor((vp.Y - GUI_H) / 2))
end

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotBrowser"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ── MAIN FRAME ──────────────────────────────────────────────────────────────
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, GUI_W, 0, GUI_H)
frame.Position = getCenterPos()
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local frameBorder = Instance.new("UIStroke")
frameBorder.Color = Color3.fromRGB(55, 45, 100)
frameBorder.Thickness = 1
frameBorder.Transparency = 0
frameBorder.Parent = frame

-- subtle gradient background
local frameBG = Instance.new("UIGradient")
frameBG.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 12, 26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 12)),
})
frameBG.Rotation = 135
frameBG.Parent = frame

-- thin top accent line
local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 1)
topLine.BackgroundColor3 = Color3.fromRGB(95, 70, 200)
topLine.BorderSizePixel = 0
topLine.ZIndex = 5
topLine.Parent = frame

-- ── TITLE BAR ───────────────────────────────────────────────────────────────
local titlebar = Instance.new("Frame")
titlebar.Size = UDim2.new(1, 0, 0, 48)
titlebar.BackgroundColor3 = Color3.fromRGB(14, 12, 28)
titlebar.BorderSizePixel = 0
titlebar.ZIndex = 2
titlebar.Parent = frame
Instance.new("UICorner", titlebar).CornerRadius = UDim.new(0, 14)

-- fix bottom corners showing
local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0.5, 0)
tbFix.Position = UDim2.new(0, 0, 0.5, 0)
tbFix.BackgroundColor3 = titlebar.BackgroundColor3
tbFix.BorderSizePixel = 0
tbFix.ZIndex = 2
tbFix.Parent = titlebar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BRAINROT SERVERS"
titleLabel.TextColor3 = Color3.fromRGB(200, 190, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.LetterSpacing = 2
titleLabel.ZIndex = 3
titleLabel.Parent = titlebar

-- close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -36, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(140, 35, 55)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "x"
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 4
closeBtn.Parent = titlebar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(200, 50, 75) }):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(140, 35, 55) }):Play()
end)

-- divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.new(0, 12, 0, 54)
divider.BackgroundColor3 = Color3.fromRGB(55, 45, 100)
divider.BorderSizePixel = 0
divider.Parent = frame

-- status label
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -80, 0, 20)
countLabel.Position = UDim2.new(0, 14, 0, 59)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3 = Color3.fromRGB(90, 80, 140)
countLabel.TextSize = 11
countLabel.Font = Enum.Font.Gotham
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Parent = frame

-- refresh button (top right near count)
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 60, 0, 20)
refreshBtn.Position = UDim2.new(1, -72, 0, 59)
refreshBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 52)
refreshBtn.TextColor3 = Color3.fromRGB(130, 110, 220)
refreshBtn.Text = "Refresh"
refreshBtn.TextSize = 11
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.BorderSizePixel = 0
refreshBtn.AutoButtonColor = false
refreshBtn.Parent = frame
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

local refreshStroke = Instance.new("UIStroke")
refreshStroke.Color = Color3.fromRGB(65, 50, 130)
refreshStroke.Thickness = 1
refreshStroke.Parent = refreshBtn

refreshBtn.MouseEnter:Connect(function()
	TweenService:Create(refreshBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(42, 32, 78) }):Play()
end)
refreshBtn.MouseLeave:Connect(function()
	TweenService:Create(refreshBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(28, 22, 52) }):Play()
end)

-- ── SCROLL LIST ──────────────────────────────────────────────────────────────
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -210)
scroll.Position = UDim2.new(0, 8, 0, 86)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(90, 65, 185)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local lpad = Instance.new("UIPadding")
lpad.PaddingTop = UDim.new(0, 4)
lpad.PaddingBottom = UDim.new(0, 4)
lpad.PaddingLeft = UDim.new(0, 2)
lpad.PaddingRight = UDim.new(0, 2)
lpad.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)

-- ── BOTTOM DIVIDER + TELEPORT BUTTONS ───────────────────────────────────────
local bottomDiv = Instance.new("Frame")
bottomDiv.Size = UDim2.new(1, -24, 0, 1)
bottomDiv.Position = UDim2.new(0, 12, 1, -150)
bottomDiv.BackgroundColor3 = Color3.fromRGB(55, 45, 100)
bottomDiv.BorderSizePixel = 0
bottomDiv.Parent = frame

local bottomLabel = Instance.new("TextLabel")
bottomLabel.Size = UDim2.new(1, -24, 0, 18)
bottomLabel.Position = UDim2.new(0, 14, 1, -144)
bottomLabel.BackgroundTransparency = 1
bottomLabel.TextColor3 = Color3.fromRGB(70, 60, 115)
bottomLabel.TextSize = 10
bottomLabel.Font = Enum.Font.GothamBold
bottomLabel.TextXAlignment = Enum.TextXAlignment.Left
bottomLabel.Text = "QUICK TELEPORT"
bottomLabel.Parent = frame

local function makeTeleportBtn(text, yOff, x, y, z)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 38)
	btn.Position = UDim2.new(0, 8, 1, yOff)
	btn.BackgroundColor3 = Color3.fromRGB(18, 15, 32)
	btn.TextColor3 = Color3.fromRGB(185, 175, 240)
	btn.Text = text
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamSemibold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(55, 45, 100)
	s.Thickness = 1
	s.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(28, 22, 48) }):Play()
		TweenService:Create(s, TweenInfo.new(0.12), { Color = Color3.fromRGB(90, 70, 175) }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(18, 15, 32) }):Play()
		TweenService:Create(s, TweenInfo.new(0.12), { Color = Color3.fromRGB(55, 45, 100) }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.07), { Size = UDim2.new(1, -24, 0, 34) }):Play()
		task.wait(0.08)
		TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(1, -16, 0, 38) }):Play()
		local char = player.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(x, y, z)
		end
	end)
end

makeTeleportBtn("Divine Area", -125, -3434.6, 1450.33, 7881.85)
makeTeleportBtn("Home", -80, -3392.6, 1449.33, -2911.57)

-- ── MINI BUTTON (collapsed state) ────────────────────────────────────────────
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, MINI, 0, MINI)
miniBtn.Position = UDim2.new(0, 20, 0, 20)
miniBtn.BackgroundColor3 = Color3.fromRGB(14, 12, 28)
miniBtn.TextColor3 = Color3.fromRGB(180, 165, 255)
miniBtn.Text = "B"
miniBtn.TextSize = 16
miniBtn.Font = Enum.Font.GothamBold
miniBtn.BorderSizePixel = 0
miniBtn.AutoButtonColor = false
miniBtn.Visible = false
miniBtn.ZIndex = 10
miniBtn.Parent = gui
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 10)

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(90, 65, 185)
miniStroke.Thickness = 1.5
miniStroke.Parent = miniBtn

miniBtn.MouseEnter:Connect(function()
	TweenService:Create(miniBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(28, 22, 50) }):Play()
end)
miniBtn.MouseLeave:Connect(function()
	TweenService:Create(miniBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(14, 12, 28) }):Play()
end)

-- ── DRAGGING ─────────────────────────────────────────────────────────────────
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

-- ── CLOSE: tween shrink to top-left corner, save position ────────────────────
closeBtn.MouseButton1Click:Connect(function()
	local savedPos = frame.Position
	local collapseX = savedPos.X.Offset
	local collapseY = savedPos.Y.Offset
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Size = UDim2.new(0, MINI, 0, MINI),
		Position = UDim2.new(0, collapseX, 0, collapseY),
	}):Play()
	task.wait(0.31)
	frame.Visible = false
	miniBtn.Size = UDim2.new(0, MINI, 0, MINI)
	miniBtn.Position = UDim2.new(0, collapseX, 0, collapseY)
	miniBtn.Visible = true
end)

-- ── OPEN: tween from top-left of final position outward to full size ──────────
miniBtn.MouseButton1Click:Connect(function()
	local fromPos = miniBtn.Position
	miniBtn.Visible = false
	frame.Visible = true
	-- Start small at same position (top-left corner of where GUI will appear)
	frame.Size = UDim2.new(0, MINI, 0, MINI)
	frame.Position = fromPos
	-- Expand to full size; GUI grows toward bottom-right from that top-left anchor
	TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, GUI_W, 0, GUI_H),
		Position = fromPos,
	}):Play()
end)

-- ── EMPTY STATE ──────────────────────────────────────────────────────────────
local emptyLabel = Instance.new("TextLabel")
emptyLabel.Size = UDim2.new(1, 0, 0, 50)
emptyLabel.BackgroundTransparency = 1
emptyLabel.Text = "Empty :("
emptyLabel.TextColor3 = Color3.fromRGB(70, 60, 115)
emptyLabel.TextSize = 13
emptyLabel.Font = Enum.Font.GothamSemibold
emptyLabel.Visible = false
emptyLabel.Parent = scroll

-- ── ENTRY BUILDER ────────────────────────────────────────────────────────────
local entryCount = 0

local function clearEntries()
	for _, c in ipairs(scroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	emptyLabel.Visible = false
	entryCount = 0
end

local function makeEntry(name, order)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 52)
	card.BackgroundColor3 = Color3.fromRGB(16, 13, 30)
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	card.BackgroundTransparency = 0
	card.Parent = scroll
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Color3.fromRGB(50, 40, 90)
	cardStroke.Thickness = 1
	cardStroke.Transparency = 0
	cardStroke.Parent = card

	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 2, 0.5, 0)
	accent.Position = UDim2.new(0, 0, 0.25, 0)
	accent.BackgroundColor3 = Color3.fromRGB(110, 75, 210)
	accent.BorderSizePixel = 0
	accent.Parent = card
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -100, 1, 0)
	label.Position = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(200, 192, 248)
	label.TextSize = 13
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 68, 0, 28)
	btn.Position = UDim2.new(1, -78, 0.5, -14)
	btn.BackgroundColor3 = Color3.fromRGB(80, 55, 185)
	btn.TextColor3 = Color3.fromRGB(240, 235, 255)
	btn.Text = "Join"
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = card
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(105, 75, 220) }):Play()
		TweenService:Create(cardStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(80, 60, 150) }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(80, 55, 185) }):Play()
		TweenService:Create(cardStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(50, 40, 90) }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if not btn.Active then return end
		btn.Active = false

		TweenService:Create(btn, TweenInfo.new(0.07), { Size = UDim2.new(0, 60, 0, 24) }):Play()
		task.wait(0.08)
		TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 68, 0, 28) }):Play()

		btn.Text = "..."
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(45, 32, 110) }):Play()

		-- Use Teleport (client-side safe) instead of TeleportAsync
		local ok, err = pcall(function()
			TeleportService:Teleport(game.PlaceId, player)
		end)

		if not ok then
			warn(err)
			btn.Text = "Failed"
			TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(140, 38, 58) }):Play()
			task.wait(2.5)
			btn.Text = "Join"
			TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(80, 55, 185) }):Play()
			btn.Active = true
		end
	end)
end

-- ── POPULATE LIST ─────────────────────────────────────────────────────────────
local function populateList()
	clearEntries()
	local folder = ReplicatedStorage:FindFirstChild("Brainrots")
	if folder then
		local order = 0
		for _, v in ipairs(folder:GetChildren()) do
			if v:IsA("Folder") and WHITELIST[v.Name] then
				order += 1
				entryCount += 1
				makeEntry(v.Name, order)
			end
		end
	end
	if entryCount == 0 then
		emptyLabel.Visible = true
	end
	countLabel.Text = entryCount .. " server" .. (entryCount == 1 and "" or "s") .. " found"
end

-- Initial load with wait
task.spawn(function()
	local folder = ReplicatedStorage:WaitForChild("Brainrots", 10)
	populateList()
	if folder then
		folder.ChildAdded:Connect(function()
			populateList()
		end)
		folder.ChildRemoved:Connect(function()
			populateList()
		end)
	end
end)

refreshBtn.MouseButton1Click:Connect(function()
	refreshBtn.Text = "..."
	refreshBtn.AutoButtonColor = false
	task.wait(0.4)
	populateList()
	refreshBtn.Text = "Refresh"
end)
