local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

function tween(position, duration)
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
    local startPosition = rootPart.CFrame
    local startTime = tick()

    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        local settle = 5
        local final = startPosition:Lerp(position, 1 - math.exp(-settle * progress))

        rootPart.CFrame = final

        if progress >= 1 then
            connection:Disconnect()
        end
    end)
end

