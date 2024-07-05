-- Get TeleportService
local TeleportService = game:GetService("TeleportService")

-- Function to create the UI
local function createUI()
    -- Check if UI already exists and destroy it to recreate
    local existingGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("GameSwitchUI")
    if existingGui then
        existingGui:Destroy()
    end

    -- Create a ScreenGui for the UI
    local gui = Instance.new("ScreenGui")
    gui.Name = "GameSwitchUI"
    gui.IgnoreGuiInset = true  -- Ensures UI is not affected by Safe Zone Inset
    gui.Parent = game.Players.LocalPlayer.PlayerGui

    -- Create the UI elements
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 160)
    frame.Position = UDim2.new(1, -270, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "Game Switch"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame

    local idTextBox = Instance.new("TextBox")
    idTextBox.PlaceholderText = "Enter Place ID"
    idTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    idTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    idTextBox.BorderSizePixel = 0
    idTextBox.TextSize = 16
    idTextBox.Font = Enum.Font.Gotham
    idTextBox.Size = UDim2.new(1, -20, 0, 30)
    idTextBox.Position = UDim2.new(0, 10, 0, 35)
    idTextBox.Parent = frame

    local getCurrentGameIdButton = Instance.new("TextButton")
    getCurrentGameIdButton.Text = "Get Current Game ID"
    getCurrentGameIdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getCurrentGameIdButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    getCurrentGameIdButton.BorderSizePixel = 0
    getCurrentGameIdButton.TextSize = 14
    getCurrentGameIdButton.Font = Enum.Font.GothamSemibold
    getCurrentGameIdButton.Size = UDim2.new(1, -20, 0, 30)
    getCurrentGameIdButton.Position = UDim2.new(0, 10, 0, 80)
    getCurrentGameIdButton.Parent = frame

    local gameSwitchButton = Instance.new("TextButton")
    gameSwitchButton.Text = "Switch Game"
    gameSwitchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    gameSwitchButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    gameSwitchButton.BorderSizePixel = 0
    gameSwitchButton.TextSize = 16
    gameSwitchButton.Font = Enum.Font.GothamSemibold
    gameSwitchButton.Size = UDim2.new(1, -20, 0, 30)
    gameSwitchButton.Position = UDim2.new(0, 10, 0, 120)
    gameSwitchButton.Parent = frame

    -- Function to handle button click event to get current game ID
    local function getCurrentGameId()
        local currentPlaceId = game.PlaceId
        idTextBox.Text = tostring(currentPlaceId)
    end

    -- Function to handle button click event to switch game
    local function switchGame()
        local placeId = tonumber(idTextBox.Text)
        if placeId then
            -- Teleport the player to the specified place ID
            TeleportService:Teleport(placeId)
        else
            warn("Invalid Place ID entered.")
        end
    end

    -- Connect button click events
    getCurrentGameIdButton.MouseButton1Click:Connect(getCurrentGameId)
    gameSwitchButton.MouseButton1Click:Connect(switchGame)

    return gui  -- Return the ScreenGui instance
end

-- Create the UI initially
createUI()
