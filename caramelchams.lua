while do true
    wait(2)

local Players = game:GetService("Players")

local function highlightPlayer(player)
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
end

for _, player in ipairs(Players:GetPlayers()) do
    highlightPlayer(player)
end
end
