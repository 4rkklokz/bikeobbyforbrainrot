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

local GUI_SIZE = UDim2.new(0, 370, 0, 500)
local MINI_SIZE = UDim2.new(0, 46, 0, 46)

-- Start centered on screen
local function getCenterPos()
	local vp = workspace.CurrentCamera.ViewportSize
	return UDim2.new(0, math.floor((vp.X - 370) / 2), 0, math.floor((vp.Y - 500) / 2))
end
local GUI_POS = getCenterPos()

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotBrowser"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = GUI_SIZE
frame.Position = GUI_POS
frame.BackgroundColor3 = Color3.fromRGB(10, 9, 20)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(100, 65, 200)
frameStroke.Thickness = 1.5
frameStroke.Transparency = 0.3
frameStroke.Parent = frame

local frameBG = Instance.new("UIGradient")
frameBG.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 16, 40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 18)),
})
frameBG.Rotation = 145
frameBG.Parent = frame


local titlebar = Instance.new("Frame")
titlebar.Size = UDim2.new(1, 0, 0, 54)
titlebar.BackgroundColor3 = Color3.fromRGB(24, 18, 50)
titlebar.BorderSizePixel = 0
titlebar.ZIndex = 2
titlebar.Parent = frame
Instance.new("UICorner", titlebar).CornerRadius = UDim.new(0, 18)

local titlebarFix = Instance.new("Frame")
titlebarFix.Size = UDim2.new(1, 0, 0.5, 0)
titlebarFix.Position = UDim2.new(0, 0, 0.5, 0)
titlebarFix.BackgroundColor3 = titlebar.BackgroundColor3
titlebarFix.BorderSizePixel = 0
titlebarFix.ZIndex = 2
titlebarFix.Parent = titlebar

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 30, 85)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 14, 42)),
})
titleGrad.Rotation = 90
titleGrad.Parent = titlebar

local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 32, 1, 0)
titleIcon.Position = UDim2.new(0, 14, 0, 0)
titleIcon.BackgroundTransparency = 1
titleIcon.Text = "🧠"
titleIcon.TextSize = 22
titleIcon.Font = Enum.Font.GothamBold
titleIcon.ZIndex = 3
titleIcon.Parent = titlebar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -110, 1, 0)
titleLabel.Position = UDim2.new(0, 50, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Brainrot Servers"
titleLabel.TextColor3 = Color3.fromRGB(220, 210, 255)
titleLabel.TextSize = 17
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 3
titleLabel.Parent = titlebar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 45, 70)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 4
closeBtn.Parent = titlebar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(215, 65, 95) }):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(170, 45, 70) }):Play()
end)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -30, 0, 1)
divider.Position = UDim2.new(0, 15, 0, 60)
divider.BackgroundColor3 = Color3.fromRGB(80, 55, 145)
divider.BorderSizePixel = 0
divider.BackgroundTransparency = 0.5
divider.Parent = frame

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -100, 0, 22)
countLabel.Position = UDim2.new(0, 15, 0, 67)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3 = Color3.fromRGB(110, 95, 165)
countLabel.TextSize = 12
countLabel.Font = Enum.Font.Gotham
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Parent = frame

-- Refresh button
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 72, 0, 20)
refreshBtn.Position = UDim2.new(1, -82, 0, 69)
refreshBtn.BackgroundColor3 = Color3.fromRGB(30, 22, 60)
refreshBtn.TextColor3 = Color3.fromRGB(140, 115, 230)
refreshBtn.Text = "Refresh"
refreshBtn.TextSize = 11
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.BorderSizePixel = 0
refreshBtn.AutoButtonColor = false
refreshBtn.Parent = frame
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)
local refreshStroke = Instance.new("UIStroke")
refreshStroke.Color = Color3.fromRGB(70, 50, 140)
refreshStroke.Thickness = 1
refreshStroke.Parent = refreshBtn

refreshBtn.MouseEnter:Connect(function()
	TweenService:Create(refreshBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(45, 34, 88) }):Play()
end)
refreshBtn.MouseLeave:Connect(function()
	TweenService:Create(refreshBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 22, 60) }):Play()
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -235)
scroll.Position = UDim2.new(0, 10, 0, 94)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 75, 215)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local lpad = Instance.new("UIPadding")
lpad.PaddingTop = UDim.new(0, 4)
lpad.PaddingBottom = UDim.new(0, 8)
lpad.Parent = scroll

-- Empty state label (shown when no whitelisted brainrots exist in folder)
local emptyLabel = Instance.new("TextLabel")
emptyLabel.Size = UDim2.new(1, 0, 0, 58)
emptyLabel.BackgroundTransparency = 1
emptyLabel.Text = "Empty :("
emptyLabel.TextColor3 = Color3.fromRGB(80, 65, 130)
emptyLabel.TextSize = 14
emptyLabel.Font = Enum.Font.GothamSemibold
emptyLabel.Visible = false
emptyLabel.Parent = scroll

local bottomDivider = Instance.new("Frame")
bottomDivider.Size = UDim2.new(1, -30, 0, 1)
bottomDivider.Position = UDim2.new(0, 15, 1, -138)
bottomDivider.BackgroundColor3 = Color3.fromRGB(80, 55, 145)
bottomDivider.BorderSizePixel = 0
bottomDivider.BackgroundTransparency = 0.5
bottomDivider.Parent = frame

local function makeTeleportBtn(text, yOff, bg, hover, x, y, z)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 44)
	btn.Position = UDim2.new(0, 10, 1, yOff)
	btn.BackgroundColor3 = bg
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = hover }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = bg }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), { Size = UDim2.new(1, -28, 0, 40) }):Play()
		task.wait(0.09)
		TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(1, -20, 0, 44) }):Play()
		local char = player.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(x, y, z)
		end
	end)
end

makeTeleportBtn("Teleport to Divine Area", -128, Color3.fromRGB(78, 48, 172), Color3.fromRGB(100, 65, 210), -3434.6, 1450.33, 7881.85)
makeTeleportBtn("Teleport to Home", -76, Color3.fromRGB(38, 108, 158), Color3.fromRGB(52, 132, 188), -3392.6, 1449.33, -2911.57)

local miniBtn = Instance.new("TextButton")
miniBtn.Size = MINI_SIZE
miniBtn.Position = GUI_POS
miniBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 50)
miniBtn.TextColor3 = Color3.fromRGB(220, 210, 255)
miniBtn.Text = "BR"
miniBtn.TextSize = 14
miniBtn.Font = Enum.Font.GothamBold
miniBtn.BorderSizePixel = 0
miniBtn.AutoButtonColor = false
miniBtn.Visible = false
miniBtn.ZIndex = 10
miniBtn.Parent = gui
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(110, 75, 215)
miniStroke.Thickness = 2
miniStroke.Parent = miniBtn

miniBtn.MouseEnter:Connect(function()
	TweenService:Create(miniBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 30, 80) }):Play()
end)
miniBtn.MouseLeave:Connect(function()
	TweenService:Create(miniBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(24, 18, 50) }):Play()
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

-- Close: shrink to top-left corner of current frame position
closeBtn.MouseButton1Click:Connect(function()
	local collapsePos = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
	TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 46, 0, 46),
		Position = collapsePos,
	}):Play()
	task.wait(0.36)
	frame.Visible = false
	miniBtn.Position = collapsePos
	miniBtn.Visible = true
end)

-- Open: grow from top-left (miniBtn pos) toward bottom-right — Position stays the same, only Size grows
miniBtn.MouseButton1Click:Connect(function()
	local fromPos = miniBtn.Position
	miniBtn.Visible = false
	frame.Visible = true
	frame.Size = UDim2.new(0, 46, 0, 46)
	frame.Position = fromPos
	TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = GUI_SIZE,
		Position = fromPos,
	}):Play()
end)

local entryCount = 0
local HttpService = game:GetService("HttpService")

local function clearEntries()
	for _, c in ipairs(scroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	emptyLabel.Visible = false
	entryCount = 0
end

local function makeEntry(name, jobId, order)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 58)
	card.BackgroundColor3 = Color3.fromRGB(20, 16, 38)
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	card.BackgroundTransparency = 1
	card.Parent = scroll
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Color3.fromRGB(65, 45, 120)
	cardStroke.Thickness = 1
	cardStroke.Transparency = 0.55
	cardStroke.Parent = card

	TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint), { BackgroundTransparency = 0 }):Play()

	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 3, 0.5, 0)
	accent.Position = UDim2.new(0, 0, 0.25, 0)
	accent.BackgroundColor3 = Color3.fromRGB(125, 82, 238)
	accent.BorderSizePixel = 0
	accent.Parent = card
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -115, 1, 0)
	label.Position = UDim2.new(0, 16, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(218, 210, 255)
	label.TextSize = 14
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 74, 0, 32)
	btn.Position = UDim2.new(1, -84, 0.5, -16)
	btn.BackgroundColor3 = Color3.fromRGB(92, 62, 210)
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
		ColorSequenceKeypoint.new(0, Color3.fromRGB(118, 82, 238)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 48, 185)),
	})
	btnGrad.Rotation = 90
	btnGrad.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(112, 80, 232) }):Play()
		TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(28, 22, 50) }):Play()
		TweenService:Create(cardStroke, TweenInfo.new(0.15), { Transparency = 0.2 }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(92, 62, 210) }):Play()
		TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(20, 16, 38) }):Play()
		TweenService:Create(cardStroke, TweenInfo.new(0.15), { Transparency = 0.55 }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		if not btn.Active then return end
		btn.Active = false

		TweenService:Create(btn, TweenInfo.new(0.08), { Size = UDim2.new(0, 66, 0, 28) }):Play()
		task.wait(0.09)
		TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 74, 0, 32) }):Play()

		btn.Text = "..."
		TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(50, 35, 120) }):Play()

		local ok, err = pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
		end)

		if not ok then
			warn(err)
			btn.Text = "Failed"
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(155, 45, 65) }):Play()
			task.wait(2.5)
			btn.Text = "Join"
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(92, 62, 210) }):Play()
			btn.Active = true
		end
	end)
end

-- Check if current server has any whitelisted brainrot folders
local function checkCurrentServer()
	local folder = ReplicatedStorage:FindFirstChild("Brainrots")
	if not folder then return {} end
	local found = {}
	for _, v in ipairs(folder:GetChildren()) do
		if v:IsA("Folder") and WHITELIST[v.Name] then
			table.insert(found, { name = v.Name, jobId = game.JobId })
		end
	end
	return found
end

-- Get a list of server JobIds from Roblox API, excluding current server
local function getServerJobIds(excludeJobId)
	local jobIds = {}
	local ok, result = pcall(function()
		return HttpService:GetAsync(
			"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		)
	end)
	if not ok or not result then return jobIds end
	local decoded
	pcall(function() decoded = HttpService:JSONDecode(result) end)
	if not decoded or not decoded.data then return jobIds end
	for _, server in ipairs(decoded.data) do
		if server.id and server.id ~= excludeJobId then
			table.insert(jobIds, server.id)
		end
	end
	return jobIds
end

local function populateList()
	clearEntries()
	countLabel.Text = "Searching..."

	task.spawn(function()
		-- First check the server we're already in
		local found = checkCurrentServer()

		if #found > 0 then
			for order, entry in ipairs(found) do
				entryCount += 1
				makeEntry(entry.name, entry.jobId, order)
			end
			countLabel.Text = entryCount .. " server" .. (entryCount == 1 and "" or "s") .. " available"
		else
			emptyLabel.Visible = true
			countLabel.Text = "0 servers available"
		end
	end)
end

refreshBtn.MouseButton1Click:Connect(function()
	refreshBtn.Text = "..."
	populateList()
	task.wait(0.5)
	refreshBtn.Text = "Refresh"
end)

-- On load, check current server immediately
task.spawn(function()
	task.wait(2) -- wait for RS to replicate
	populateList()
end)

-- Auto re-check when teleported into a new server
TeleportService.LocalPlayerArrivedFromTeleport:Connect(function()
	task.wait(3)
	populateList()
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)

-- SERVER HOP button — fetches server list and jumps to a different server each time
local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(1, -20, 0, 36)
hopBtn.Position = UDim2.new(0, 10, 1, -180)
hopBtn.BackgroundColor3 = Color3.fromRGB(55, 38, 110)
hopBtn.TextColor3 = Color3.fromRGB(220, 200, 255)
hopBtn.Text = "⚡  SERVER HOP"
hopBtn.TextSize = 13
hopBtn.Font = Enum.Font.GothamBold
hopBtn.BorderSizePixel = 0
hopBtn.AutoButtonColor = false
hopBtn.Parent = frame
Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0, 10)

local hopStroke = Instance.new("UIStroke")
hopStroke.Color = Color3.fromRGB(110, 75, 215)
hopStroke.Thickness = 1.2
hopStroke.Parent = hopBtn

local hopGrad = Instance.new("UIGradient")
hopGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 55, 165)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 28, 90)),
})
hopGrad.Rotation = 90
hopGrad.Parent = hopBtn

hopBtn.MouseEnter:Connect(function()
	TweenService:Create(hopBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(75, 52, 145) }):Play()
end)
hopBtn.MouseLeave:Connect(function()
	TweenService:Create(hopBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(55, 38, 110) }):Play()
end)

hopBtn.MouseButton1Click:Connect(function()
	if not hopBtn.Active then return end
	hopBtn.Active = false
	hopBtn.Text = "Finding server..."
	TweenService:Create(hopBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 28, 90) }):Play()

	task.spawn(function()
		local jobIds = getServerJobIds(game.JobId)
		if #jobIds > 0 then
			-- Pick a random one from the list so we don't always go to the same server
			local pick = jobIds[math.random(1, #jobIds)]
			local ok, err = pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, pick, player)
			end)
			if not ok then
				warn(err)
				hopBtn.Text = "⚡  SERVER HOP"
				TweenService:Create(hopBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(55, 38, 110) }):Play()
				hopBtn.Active = true
			end
		else
			-- No other servers found, fallback
			pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
		end
	end)
end)

makeTeleportBtn("Teleport to Divine Area", -128, Color3.fromRGB(78, 48, 172), Color3.fromRGB(100, 65, 210), -3434.6, 1450.33, 7881.85)
makeTeleportBtn("Teleport to Home", -76, Color3.fromRGB(38, 108, 158), Color3.fromRGB(52, 132, 188), -3392.6, 1449.33, -2911.57)
