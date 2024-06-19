local function highlightPlayer(character, isLocalPlayer)
    -- Function to create or destroy highlights for a given character
    local highlight = character:FindFirstChild("Highlight")

    if not highlight and not isLocalPlayer then
        -- Create a highlight if it doesn't exist and it's not the local player's character
        highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)  -- Bright red
        highlight.FillTransparency = 0.75
        highlight.ZIndex = 10
    elseif highlight and isLocalPlayer then
        -- Destroy the highlight if it exists and it's the local player's character
        highlight:Destroy()
    end
end

local function updateHighlights()
    -- Function to update highlights for all players in the game
    local players = game.Players:GetPlayers()
    for _, player in ipairs(players) do
        local character = player.Character
        if character then
            -- Update highlights for each player's character
            highlightPlayer(character, player == game.Players.LocalPlayer)
        end
    end
end

local function onPlayerAdded(player)
    -- Event handler for when a new player joins the game
    player.CharacterAdded:Connect(function(character)
        -- Connect to the CharacterAdded event to handle highlighting
        highlightPlayer(character, player == game.Players.LocalPlayer)
    end)
end

local function onPlayerRemoving(player)
    -- Event handler for when a player leaves the game
    local character = player.Character
    if character then
        -- Check if the player's character exists
        local highlight = character:FindFirstChild("Highlight")
        if highlight then
            -- Destroy the highlight if it exists
            highlight:Destroy()
        end
    end
end

-- Connect events to update highlights when players join or leave
game.Players.PlayerAdded:Connect(onPlayerAdded)
game.Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Connect a heartbeat event to constantly update highlights
game:GetService("RunService").Heartbeat:Connect(updateHighlights)
