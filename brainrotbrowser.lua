local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local function tpTo(cf)
	local c = player.Character or player.CharacterAdded:Wait()
	local hrp = c:WaitForChild("HumanoidRootPart")
	hrp.CFrame = cf
end

tpTo(CFrame.new(-3434.6,1450.33,7881.85))

local function instantPrompts()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			v.HoldDuration = 0
		end
	end
	workspace.DescendantAdded:Connect(function(v)
		if v:IsA("ProximityPrompt") then
			v.HoldDuration = 0
		end
	end)
end

instantPrompts()

local function getItem10()
	local zone = workspace:FindFirstChild("ItemSpawns")
	if not zone then return end
	local slot = zone:FindFirstChild("10")
	if not slot then return end
	return slot:FindFirstChild("SpawnedItem")
end

local function tpToItem()
	local item = getItem10()
	if not item then return end
	local part = item:FindFirstChildWhichIsA("BasePart", true)
	if part then
		tpTo(part.CFrame + Vector3.new(0,5,0))
	end
end

local function watchPickup()
	while true do
		local item = getItem10()
		if item then
			item.AncestryChanged:Connect(function(_, parent)
				if not parent then
					tpTo(CFrame.new(-3392.6,1449.33,-2911.57))
				end
			end)
			break
		end
		task.wait(0.5)
	end
end

task.spawn(watchPickup)

local function getServer()
	local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
	local ok, res = pcall(function()
		return game:HttpGet(url)
	end)

	if ok then
		local data = HttpService:JSONDecode(res)
		local servers = {}

		for _,server in pairs(data.data) do
			if server.id ~= game.JobId and server.playing < server.maxPlayers then
				table.insert(servers, server.id)
			end
		end

		if #servers > 0 then
			return servers[math.random(1,#servers)]
		end
	end
end

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 220)
frame.Position = UDim2.new(1, -240, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = frame

local hue = 0
task.spawn(function()
	while true do
		hue += 0.01
		if hue > 1 then hue = 0 end
		stroke.Color = Color3.fromHSV(hue,1,1)
		task.wait()
	end
end)

local function makeBtn(text, y, color, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,40)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = color
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Parent = frame
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(callback)
end

makeBtn("Teleport to Divine", 10, Color3.fromRGB(140, 90, 255), function()
	tpTo(CFrame.new(-3434.6,1450.33,7881.85))
end)

makeBtn("Teleport to Home", 60, Color3.fromRGB(80, 170, 255), function()
	tpTo(CFrame.new(-3392.6,1449.33,-2911.57))
end)

makeBtn("Server Hop", 110, Color3.fromRGB(255, 100, 120), function()
	local id = getServer()
	if id then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, id, player)
	else
		TeleportService:Teleport(game.PlaceId, player)
	end
end)

makeBtn("Server Hop++", 160, Color3.fromRGB(120, 255, 180), function()
	task.spawn(function()
		while true do
			local item = getItem10()
			if item then
				tpToItem()
				break
			end
			local id = getServer()
			if id then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, id, player)
			else
				TeleportService:Teleport(game.PlaceId, player)
			end
			task.wait(1.5)
		end
	end)
end)
