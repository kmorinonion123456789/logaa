local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"

local data = {
    ["embeds"] = {{
        ["title"] = "🚀 Deltaから送信成功！",
        ["description"] = "実行機からログが送られました。",
        ["color"] = 16776960, -- 黄色
        ["fields"] = {
            {
                ["name"] = "👤 実行者",
                ["value"] = game.Players.LocalPlayer.Name .. " (" .. game.Players.LocalPlayer.UserId .. ")",
                ["inline"] = false
            }
        },
        ["footer"] = {
            ["text"] = "時刻: " .. os.date("%X")
        }
    }}
}

-- 実行機専用の送信関数
local response = request({
    Url = url,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = game:GetService("HttpService"):JSONEncode(data)
})

if response.Success then
    print("送信完了！Discordを確認してね")
else
    print("送信失敗: " .. response.StatusCode)
end

