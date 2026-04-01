local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local STATE_FILE = "divine_farm_state.txt"

local function saveState(v)
	pcall(writefile, STATE_FILE, v and "1" or "0")
end

local function loadState()
	local ok, s = pcall(readfile, STATE_FILE)
	return ok and s == "1"
end

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://4307186075"
clickSound.Volume = 0.5
clickSound.Parent = player:WaitForChild("PlayerGui")
local function playClick() clickSound:Play() end

local function tpTo(cf)
	local c = player.Character or player.CharacterAdded:Wait()
	local hrp = c:WaitForChild("HumanoidRootPart")
	hrp.CFrame = cf
end

local promptConn = nil
local function instantPrompts()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
	end
	if promptConn then promptConn:Disconnect() end
	promptConn = workspace.DescendantAdded:Connect(function(v)
		if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
	end)
end
instantPrompts()

local function getSpawnedItems()
	local zone = workspace:FindFirstChild("ItemSpawns")
	if not zone then return {} end
	local slot = zone:FindFirstChild("10")
	if not slot then return {} end
	local items = {}
	for _, v in pairs(slot:GetChildren()) do
		if v.Name == "SpawnedItem" then table.insert(items, v) end
	end
	return items
end

local function getServer()
	local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
	local ok, res = pcall(function() return game:HttpGet(url) end)
	if not ok then return nil end
	local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
	if not ok2 or not data or not data.data then return nil end
	local servers = {}
	for _, server in pairs(data.data) do
		if server.id ~= game.JobId and server.playing < server.maxPlayers then
			table.insert(servers, server.id)
		end
	end
	if #servers > 0 then return servers[math.random(1, #servers)] end
end

local function hopServer()
	local id = getServer()
	if id then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, id, player)
	else
		TeleportService:Teleport(game.PlaceId, player)
	end
end

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local PANEL_W = 210
local PAD = 12
local BTN_H = 44
local BTN_GAP = 6
local BTN_START_Y = 86
local NUM_BTNS = 4
local PANEL_H = BTN_START_Y + NUM_BTNS * (BTN_H + BTN_GAP) - BTN_GAP + PAD
local CIRCLE = 32
local EDGE = 10

local panelOpenX = -(PANEL_W + EDGE)
local panelClosedX = 20
local btnOpenX = -(PANEL_W + EDGE + CIRCLE + 6)
local btnClosedX = -(CIRCLE + EDGE)

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.Position = UDim2.new(1, panelOpenX, 0, 60)
panel.BackgroundColor3 = Color3.fromRGB(11, 11, 17)
panel.BorderSizePixel = 0
panel.ClipsDescendants = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Parent = panel

local hue = 0
task.spawn(function()
	while true do
		hue += 0.004
		if hue > 1 then hue = 0 end
		stroke.Color = Color3.fromHSV(hue, 0.75, 1)
		task.wait(0.03)
	end
end)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, CIRCLE, 0, CIRCLE)
toggleBtn.Position = UDim2.new(1, btnOpenX, 0, 60 + PANEL_H / 2 - CIRCLE / 2)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 48)
toggleBtn.TextColor3 = Color3.fromRGB(190, 175, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
toggleBtn.Text = "›"
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 10
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleBtn
task.spawn(function()
	while true do
		task.wait(0.03)
		toggleStroke.Color = Color3.fromHSV(hue, 0.75, 1)
	end
end)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -PAD * 2, 0, 22)
titleLabel.Position = UDim2.new(0, PAD, 0, PAD + 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Bike Obby For Brainrots Script"
titleLabel.TextColor3 = Color3.fromRGB(215, 200, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
titleLabel.Parent = panel

local byLabel = Instance.new("TextLabel")
byLabel.Size = UDim2.new(1, -PAD * 2, 0, 14)
byLabel.Position = UDim2.new(0, PAD, 0, PAD + 22)
byLabel.BackgroundTransparency = 1
byLabel.Text = "by agl"
byLabel.TextColor3 = Color3.fromRGB(90, 90, 120)
byLabel.Font = Enum.Font.Gotham
byLabel.TextSize = 10
byLabel.TextXAlignment = Enum.TextXAlignment.Left
byLabel.Parent = panel

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -PAD * 2, 0, 1)
divider.Position = UDim2.new(0, PAD, 0, CIRCLE + PAD + 8)
divider.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
divider.BorderSizePixel = 0
divider.Parent = panel

local statusRow = Instance.new("Frame")
statusRow.Size = UDim2.new(1, -PAD * 2, 0, 18)
statusRow.Position = UDim2.new(0, PAD, 0, CIRCLE + PAD + 16)
statusRow.BackgroundTransparency = 1
statusRow.Parent = panel

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 7, 0, 7)
dot.Position = UDim2.new(0, 0, 0.5, -3)
dot.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
dot.BorderSizePixel = 0
dot.Parent = statusRow
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -14, 1, 0)
statusLabel.Position = UDim2.new(0, 14, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Idle"
statusLabel.TextColor3 = Color3.fromRGB(120, 120, 145)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusRow

local function setStatus(text, active)
	statusLabel.Text = text
	dot.BackgroundColor3 = active and Color3.fromRGB(90, 255, 150) or Color3.fromRGB(80, 80, 110)
end

local function makeBtn(text, index, color, callback)
	local y = BTN_START_Y + (index - 1) * (BTN_H + BTN_GAP)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -PAD * 2, 0, BTN_H)
	b.Position = UDim2.new(0, PAD, 0, y)
	b.BackgroundColor3 = color
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.BorderSizePixel = 0
	b.Parent = panel
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
	end)
	b.MouseButton1Click:Connect(function()
		playClick()
		callback()
	end)
	return b
end

makeBtn("Teleport to Divine", 1, Color3.fromRGB(110, 70, 210), function()
	tpTo(CFrame.new(-3434.6, 1450.33, 7881.85))
end)

makeBtn("Teleport to Home", 2, Color3.fromRGB(50, 130, 215), function()
	tpTo(CFrame.new(-3392.6, 1449.33, -2911.57))
end)

makeBtn("Server Hop", 3, Color3.fromRGB(205, 65, 85), function()
	hopServer()
end)

local farmRunning = false
local farmThread = nil
local watchdogThread = nil
local lastActivity = os.time()
local farmBtn = makeBtn("START FARM", 4, Color3.fromRGB(60, 180, 90), function() end)

local function findPrompt(root)
	for _, v in pairs(root:GetDescendants()) do
		if v:IsA("ProximityPrompt") then return v end
	end
end

local function runFarm()
	lastActivity = os.time()
	setStatus("Going to Divine...", true)
	tpTo(CFrame.new(-3434.6, 1450.33, 7881.85))
	task.wait(4)
	while farmRunning do
		lastActivity = os.time()
		setStatus("Scanning...", true)
		local ok, items = pcall(getSpawnedItems)
		if not ok then items = {} end
		if #items == 0 then
			setStatus("No items — hopping", true)
			task.wait(2)
			hopServer()
			return
		end
		setStatus("Collecting " .. #items .. " item(s)", true)
		for _, item in pairs(items) do
			if not farmRunning then break end
			local mesh = item:FindFirstChild("Mesh")
			if mesh then
				tpTo(mesh.CFrame)
				task.wait(1)
				local prompt = findPrompt(mesh) or findPrompt(item)
				if prompt then
					pcall(fireproximityprompt, prompt)
					task.wait(0.6)
				end
			end
			lastActivity = os.time()
		end
		if farmRunning then
			setStatus("Going home...", true)
			tpTo(CFrame.new(-3392.6, 1449.33, -2911.57))
			task.wait(3)
			setStatus("Hopping...", true)
			hopServer()
			return
		end
	end
end

local function startFarm()
	farmRunning = true
	saveState(true)
	farmBtn.Text = "STOP FARM"
	farmBtn.BackgroundColor3 = Color3.fromRGB(210, 55, 70)
	lastActivity = os.time()
	farmThread = task.spawn(runFarm)
	if watchdogThread then task.cancel(watchdogThread) end
	watchdogThread = task.spawn(function()
		while farmRunning do
			task.wait(30)
			if farmRunning and os.time() - lastActivity > 60 then
				setStatus("Watchdog restart...", true)
				if farmThread then task.cancel(farmThread) end
				farmThread = task.spawn(runFarm)
			end
		end
	end)
end

local function stopFarm()
	farmRunning = false
	saveState(false)
	if farmThread then task.cancel(farmThread) farmThread = nil end
	if watchdogThread then task.cancel(watchdogThread) watchdogThread = nil end
	farmBtn.Text = "START FARM"
	farmBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
	setStatus("Idle", false)
end

farmBtn.MouseButton1Click:Connect(function()
	playClick()
	if farmRunning then stopFarm() else startFarm() end
end)

local panelOpen = true
local tweenInfo = TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

toggleBtn.MouseButton1Click:Connect(function()
	playClick()
	panelOpen = not panelOpen
	TweenService:Create(panel, tweenInfo, {
		Position = UDim2.new(1, panelOpen and panelOpenX or panelClosedX, 0, 60)
	}):Play()
	TweenService:Create(toggleBtn, tweenInfo, {
		Position = UDim2.new(1, panelOpen and btnOpenX or btnClosedX, 0, 60 + PANEL_H / 2 - CIRCLE / 2)
	}):Play()
	toggleBtn.Text = panelOpen and "›" or "‹"
end)

task.wait(1)
if loadState() then
	startFarm()
end
