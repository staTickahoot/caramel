-- Refresh Camera
local function refreshCamera()
    local camera = game.Workspace.CurrentCamera
    if not camera then
        warn("CurrentCamera not found.")
        return
    end
    local originalCFrame = camera.CFrame
    camera.CFrame = originalCFrame * CFrame.new(0, 0, 0.1) -- Slightly move the camera
    wait(0.1)
    camera.CFrame = originalCFrame -- Move the camera back to the original position
end

-- Refresh All Parts
local function refreshParts()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = false
            wait(0.1) -- Introduce a delay to avoid performance issues
            obj.CanCollide = true
        end
    end
end

-- Recreate Parts
local function recreatePart(part)
    local parent = part.Parent
    local newPart = Instance.new("Part")
    newPart.Size = part.Size
    newPart.Position = part.Position
    newPart.Anchored = part.Anchored
    newPart.Parent = parent
    part:Destroy()
end

local function recreateAllParts()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") then
            recreatePart(obj)
        end
    end
end

-- Refresh GUI Elements
local function refreshGui()
    local player = game.Players.LocalPlayer
    if not player then
        warn("LocalPlayer not found.")
        return
    end

    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        for _, guiObject in pairs(playerGui:GetChildren()) do
            if guiObject:IsA("ScreenGui") then
                guiObject:Destroy() -- Remove existing ScreenGui instances
                local newGui = Instance.new("ScreenGui")
                newGui.Parent = playerGui
                -- Recreate or reload your GUI elements here
            end
        end
    end
end

-- Main Function to Run All Refresh Actions
local function fullRefresh()
    refreshCamera()
    refreshParts()
    recreateAllParts()
    refreshGui()
end

-- Run the full refresh function
fullRefresh()
