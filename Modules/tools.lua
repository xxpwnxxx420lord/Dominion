local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer

local m = {}

function m.tween(position, duration)
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

function m.loadUrl(url)
    local data = game:HttpGetAsync(url)
    local content, errorcode = loadstring(data)

    if content then
        return content
    else
        return errorcode
    end
end

function m.hasRequire()
    local theLocalPlayer = game:GetService("Players").LocalPlayer
    local thePlayerScripts = theLocalPlayer:WaitForChild("PlayerScripts")
    local thePlayerModule = thePlayerScripts:WaitForChild("PlayerModule")

    if not thePlayerModule or not thePlayerModule:IsA("ModuleScript") then
        return false
    end

    local success = pcall(function()
        require(thePlayerModule)
    end)

    return success
end

function m.chat(message)
    if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
        local folder = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        local chatEvent = folder and folder:FindFirstChild("SayMessageRequest")

        if chatEvent then
            chatEvent:FireServer(message, "All")
        end
    else
        local channels = TextChatService:FindFirstChild("TextChannels")
        local general = channels and channels:FindFirstChild("RBXGeneral")

        if general then
            general:SendAsync(message)
        end
    end
end

function m.serverHop(gameId)
    local serversUrl = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100"
    local server = nil
    local _next = nil

    local function listServers(cursor)
        local url = serversUrl .. (cursor and ("&cursor=" .. cursor) or "")
        return HttpService:JSONDecode(game:HttpGetAsync(url))
    end

    repeat
        local _servers = listServers(_next)

        if _servers.data and #_servers.data > 0 then
            server = _servers.data[math.floor(math.random() * #_servers.data) + 1]
        end

        _next = _servers.nextPageCursor
    until server

    if server and server.playing < server.maxPlayers and server.id ~= game.JobId then
        TeleportService:TeleportToPlaceInstance(gameId, server.id, localPlayer)
    end
end

function m.betterMobile(window, isMobile)
    for _, pair in CoreGui:GetDescendants() do
        if pair:IsA("TextButton") and pair.Position == UDim2.new(1, -80, 0, 4) then
            local _parent = pair.Parent
            local __parent = _parent and _parent.Parent

            pair.Name = "TextButton2"

            if _parent  then _parent.Name  = "Frame2" end
            if __parent then __parent.Name = "Frame3" end
        end
    end

    local function getButton()
        for _, pair in CoreGui:GetDescendants() do
            if pair.Name == "TextButton2" then
                return pair
            end
        end
    end

    local function getMobileButton()
        for _, Starry in CoreGui:GetDescendants() do
            if Starry.Name == "StarryMobileButton" then
                return Starry
            end
        end
    end

    local button = getButton()
    local mobileButton = getMobileButton()
    local mobileImageButton = mobileButton and mobileButton:FindFirstChild("ImageButton")

    if mobileImageButton then
        mobileImageButton.MouseButton1Down:Connect(function()
            mobileButton.Visible = false
            window:Minimize()
        end)
    end

    if button then
        button.MouseButton1Down:Connect(function()
            if isMobile() then
                mobileButton.Visible = true
            end
        end)
    end
end

return m
