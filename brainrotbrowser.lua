local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 170)
frame.Position = UDim2.new(0.5, -120, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame)

local function drag(obj)
	local dragging = false
	local dragStart, startPos

	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = obj.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			obj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

drag(frame)

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

local function tp(x,y,z)
	local c = player.Character
	if c and c:FindFirstChild("HumanoidRootPart") then
		c.HumanoidRootPart.CFrame = CFrame.new(x,y,z)
	end
end

makeBtn("Teleport to Divine", 10, Color3.fromRGB(90,60,200), function()
	tp(-3434.6,1450.33,7881.85)
end)

makeBtn("Teleport to Home", 60, Color3.fromRGB(50,120,180), function()
	tp(-3392.6,1449.33,-2911.57)
end)

local function getServer()
	local servers = {}
	local cursor = ""

	for i = 1,6 do
		local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100&cursor="..cursor
		local s,r = pcall(function() return HttpService:GetAsync(url) end)
		if not s then break end

		local data = HttpService:JSONDecode(r)

		for _,v in ipairs(data.data) do
			if v.id ~= game.JobId and v.playing < math.floor(v.maxPlayers * 0.5) then
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
		return servers[math.random(1,#servers)]
	end
end

makeBtn("Server Hop", 110, Color3.fromRGB(80,50,150), function()
	for i = 1,5 do
		local id = getServer()
		if id then
			local success = pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, id, player)
			end)
			if success then break end
		end
	end
end)
