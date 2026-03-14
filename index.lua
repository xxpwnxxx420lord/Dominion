local tools = loadstring(game:HttpGet('https://github.com/xxpwnxxx420lord/Dominion/blob/main/Modules/tools.lua?raw=true', true))()
local PlaceId = game.PlaceId
local baseurl = 'https://raw.githubusercontent.com/xxpwnxxx420lord/Dominion/refs/heads/main/'

local response = request({
    Url = baseurl.."games/"..PlaceId,
    Method = "GET"
})

if response.StatusCode == 404 then
    setclipboard('https://discord.gg/3fPEtASDsg')
    loadstring(game:HttpGet('https://github.com/xxpwnxxx420lord/Dominion/blob/main/Universal.lua?raw=true', true))()
    else
    loadstring(game:HttpGet(baseurl.."games/"..PlaceId, true))()
end
