local fov = 110
local smoothness = 0.325  -- Adjust the smoothness factor (lower is smoother)
local maxAngleChange = 50  -- Maximum angle change per frame (in degrees)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(255, 255, 255) -- White color
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

local aiming = false

local function updateDrawings()
    local camViewportSize = Cam.ViewportSize
    FOVring.Position = camViewportSize / 2
end

local function onMouseButton2Down()
    aiming = true
end

local function onMouseButton2Up()
    aiming = false
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        onMouseButton2Down()
    elseif input.KeyCode == Enum.KeyCode.Delete then
        RunService:UnbindFromRenderStep("FOVUpdate")
        FOVring:Remove()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        onMouseButton2Up()
    end
end)

local function lookAt(target)
    local lookVector = (target - Cam.CFrame.Position).unit
    local currentCFrame = Cam.CFrame
    local targetCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)

    currentCFrame = currentCFrame:Lerp(targetCFrame, smoothness)

    Cam.CFrame = currentCFrame
end

local function isVisible(targetPosition)
    local ray = Ray.new(Cam.CFrame.Position, (targetPosition - Cam.CFrame.Position).unit * 1000)
    local part, position = workspace:FindPartOnRayWithIgnoreList(ray, {Players.LocalPlayer.Character, Cam})
    if part then
        return (position - targetPosition).magnitude < 5
    end
    return false
end

local function getClosestPlayerInFOV(mousePosition)
    local nearest = nil
    local last = math.huge

    local friendlyFire = Players.LocalPlayer:FindFirstChild("FriendlyFire")
    local enableFriendlyFire = friendlyFire and friendlyFire.Value

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and (enableFriendlyFire or player.Team ~= Players.LocalPlayer.Team) then
            local head = player.Character and player.Character:FindFirstChild("Head")
            local torso = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

            if head and torso then
                local headPos, headVisible = Cam:WorldToViewportPoint(head.Position)
                local torsoPos, torsoVisible = Cam:WorldToViewportPoint(torso.Position)

                local headDistance = (Vector2.new(headPos.x, headPos.y) - mousePosition).Magnitude
                local torsoDistance = (Vector2.new(torsoPos.x, torsoPos.y) - mousePosition).Magnitude

                if ((headDistance < last and headVisible and headDistance < fov) or
                    (torsoDistance < last and torsoVisible and torsoDistance < fov)) and
                    (isVisible(head.Position) or isVisible(torso.Position)) then
                    if headDistance <= torsoDistance then
                        last = headDistance
                        nearest = head.Position
                    else
                        last = torsoDistance
                        nearest = torso.Position
                    end
                end
            end
        end
    end

    return nearest
end

RunService.RenderStepped:Connect(function()
    updateDrawings()
    if aiming then
        local mousePos = UserInputService:GetMouseLocation()
        local closest = getClosestPlayerInFOV(mousePos)
        if closest then
            lookAt(closest)
        end
    end
end)
