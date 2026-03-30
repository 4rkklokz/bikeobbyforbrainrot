local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local visited = {}

local GUI_SIZE = UDim2.new(0, 260, 0, 190)
local MINI_SIZE = UDim2.new(0, 46, 0, 46)

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = GUI_SIZE
frame.Position = UDim2.new(0.5, -130, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local titlebar = Instance.new("Frame")
titlebar.Size = UDim2.new(1,0,0,40)
titlebar.BackgroundColor3 = Color3.fromRGB(25,20,50)
titlebar.Parent = frame
Instance.new("UICorner", titlebar).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Teleports"
title.TextColor3 = Color3.fromRGB(220,210,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titlebar

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,26,0,26)
close.Position = UDim2.new(1,-32,0.5,-13)
close.BackgroundColor3 = Color3.fromRGB(170,50,70)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextSize = 12
close.Parent = titlebar
Instance.new("UICorner", close)

local mini = Instance.new("TextButton")
mini.Size = MINI_SIZE
mini.Position = frame.Position
mini.BackgroundColor3 = Color3.fromRGB(25,20,50)
mini.Text = "TP"
mini.TextColor3 = Color3.fromRGB(220,210,255)
mini.Font = Enum.Font.GothamBold
mini.TextSize = 13
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

local function drag(dragObj, moveObj)
	local dragging = false
	local dragStart, startPos

	dragObj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = moveObj.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			moveObj.Position = UDim2.new(
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

drag(titlebar, frame)
drag(mini, mini)

close.MouseButton1Click:Connect(function()
	local pos = frame.Position
	TweenService:Create(frame, TweenInfo.new(0.3), {Size = MINI_SIZE, Position = pos}):Play()
	task.wait(0.3)
	frame.Visible = false
	mini.Position = pos
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	local pos = mini.Position
	mini.Visible = false
	frame.Visible = true
	frame.Size = MINI_SIZE
	frame.Position = pos
	TweenService:Create(frame, TweenInfo.new(0.3), {Size = GUI_SIZE}):Play()
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

local function tp(x,y,z)
	local c = player.Character
	if c and c:FindFirstChild("HumanoidRootPart") then
		c.HumanoidRootPart.CFrame = CFrame.new(x,y,z)
	end
end

makeBtn("Teleport to Divine", 50, Color3.fromRGB(90,60,200), function()
	tp(-3434.6,1450.33,7881.85)
end)

makeBtn("Teleport to Home", 100, Color3.fromRGB(50,120,180), function()
	tp(-3392.6,1449.33,-2911.57)
end)

local function getServer()
	local cursor = ""
	local list = {}

	for i=1,5 do
		local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100&cursor="..cursor
		local s,r = pcall(function() return HttpService:GetAsync(url) end)
		if not s then break end

		local data = HttpService:JSONDecode(r)

		for _,v in ipairs(data.data) do
			if v.id ~= game.JobId and v.playing < v.maxPlayers and not visited[v.id] then
				table.insert(list, v.id)
			end
		end

		if data.nextPageCursor then
			cursor = data.nextPageCursor
		else
			break
		end
	end

	if #list > 0 then
		local pick = list[math.random(1,#list)]
		visited[pick] = true
		return pick
	end
end

makeBtn("Server Hop", 150, Color3.fromRGB(80,50,150), function()
	local id = getServer()
	if id then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, id, player)
	else
		TeleportService:Teleport(game.PlaceId, player)
	end
end)
