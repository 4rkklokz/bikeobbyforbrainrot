local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local placeId = game.PlaceId

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotBrowser"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 420)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, 5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.ZIndex = MainFrame.ZIndex - 1
Shadow.Parent = MainFrame

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 14)
ShadowCorner.Parent = Shadow

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 54)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 28, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size = UDim2.new(1, 0, 0.5, 0)
TitleBarFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleBarFix.BackgroundColor3 = TitleBar.BackgroundColor3
TitleBarFix.BorderSizePixel = 0
TitleBarFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🧠  Brainrot Servers"
TitleLabel.TextColor3 = Color3.fromRGB(230, 220, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, -20, 0, 18)
SubLabel.Position = UDim2.new(0, 16, 0, 58)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Pick a server to join:"
SubLabel.TextColor3 = Color3.fromRGB(140, 130, 180)
SubLabel.TextSize = 13
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -96)
ScrollFrame.Position = UDim2.new(0, 10, 0, 82)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 180)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollFrame

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 4)
ListPadding.PaddingBottom = UDim.new(0, 4)
ListPadding.Parent = ScrollFrame

local function createEntry(brainrotName, order)
	local Entry = Instance.new("Frame")
	Entry.Name = "Entry_" .. brainrotName
	Entry.Size = UDim2.new(1, -4, 0, 58)
	Entry.BackgroundColor3 = Color3.fromRGB(32, 30, 52)
	Entry.BorderSizePixel = 0
	Entry.LayoutOrder = order
	Entry.Parent = ScrollFrame

	local EntryCorner = Instance.new("UICorner")
	EntryCorner.CornerRadius = UDim.new(0, 10)
	EntryCorner.Parent = Entry

	local Stripe = Instance.new("Frame")
	Stripe.Size = UDim2.new(0, 4, 0.6, 0)
	Stripe.Position = UDim2.new(0, 0, 0.2, 0)
	Stripe.BackgroundColor3 = Color3.fromRGB(130, 90, 240)
	Stripe.BorderSizePixel = 0
	Stripe.Parent = Entry

	local StripeCorner = Instance.new("UICorner")
	StripeCorner.CornerRadius = UDim.new(1, 0)
	StripeCorner.Parent = Stripe

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, -110, 1, 0)
	NameLabel.Position = UDim2.new(0, 18, 0, 0)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = brainrotName
	NameLabel.TextColor3 = Color3.fromRGB(225, 220, 255)
	NameLabel.TextSize = 15
	NameLabel.Font = Enum.Font.GothamSemibold
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	NameLabel.Parent = Entry

	local JoinBtn = Instance.new("TextButton")
	JoinBtn.Size = UDim2.new(0, 80, 0, 36)
	JoinBtn.Position = UDim2.new(1, -90, 0.5, -18)
	JoinBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 220)
	JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	JoinBtn.Text = "Join"
	JoinBtn.TextSize = 14
	JoinBtn.Font = Enum.Font.GothamBold
	JoinBtn.BorderSizePixel = 0
	JoinBtn.AutoButtonColor = false
	JoinBtn.Parent = Entry

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 8)
	BtnCorner.Parent = JoinBtn

	JoinBtn.MouseEnter:Connect(function()
		JoinBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 240)
	end)

	JoinBtn.MouseLeave:Connect(function()
		JoinBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 220)
	end)

	JoinBtn.MouseButton1Click:Connect(function()
		JoinBtn.Text = "..."
		JoinBtn.BackgroundColor3 = Color3.fromRGB(60, 45, 140)
		JoinBtn.Active = false

		local options = Instance.new("TeleportOptions")
		options:SetTeleportData({ brainrot = brainrotName })

		local success, err = pcall(function()
			TeleportService:TeleportAsync(placeId, { player }, options)
		end)

		if not success then
			warn(err)
			JoinBtn.Text = "Join"
			JoinBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 220)
			JoinBtn.Active = true
		end
	end)
end

local BrainrotsFolder = ReplicatedStorage:WaitForChild("Brainrots", 10)

if BrainrotsFolder then
	local children = BrainrotsFolder:GetChildren()
	for i, folder in ipairs(children) do
		if folder:IsA("Folder") then
			createEntry(folder.Name, i)
		end
	end

	BrainrotsFolder.ChildAdded:Connect(function(child)
		if child:IsA("Folder") then
			local count = #BrainrotsFolder:GetChildren()
			createEntry(child.Name, count)
		end
	end)
end

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)
