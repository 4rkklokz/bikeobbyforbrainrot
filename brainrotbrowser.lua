local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.Parent = gui
Instance.new("UICorner", frame)

local function makeBtn(text, y, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = frame
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
end

local function tp(x,y,z)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(x,y,z)
	end
end

makeBtn("Teleport to Divine", 10, Color3.fromRGB(90,60,200), function()
	tp(-3434.6, 1450.33, 7881.85)
end)

makeBtn("Teleport to Home", 60, Color3.fromRGB(50,120,180), function()
	tp(-3392.6, 1449.33, -2911.57)
end)

local function getServer()
	local cursor = ""
	local servers = {}

	for i = 1,3 do
		local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100&cursor="..cursor
		local success, result = pcall(function()
			return HttpService:GetAsync(url)
		end)
		if not success then break end

		local data = HttpService:JSONDecode(result)
		for _,v in ipairs(data.data) do
			if v.playing < v.maxPlayers and v.id ~= game.JobId then
				table.insert(servers, v.id)
			end
		end

		if data.nextPageCursor then
			cursor = data.nextPageCursor
		else
			break
		end
	end

	if #servers > 0 then
		return servers[math.random(1, #servers)]
	end
end

makeBtn("Server Hop", 110, Color3.fromRGB(80,50,150), function()
	local id = getServer()
	if id then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, id, player)
	else
		TeleportService:Teleport(game.PlaceId, player)
	end
end)
