-- Tải OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Khanhdzaii/orionlib/refs/heads/main/orionlib"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

getgenv().AutoSummon = false
getgenv().AutoRandom = false
getgenv().AutoStore = false
getgenv().NoDelay = false

local DelayTime = 1

-- ========== HÀM THÔNG BÁO ==========
local function notify(msg, time)
    time = time or 3
    OrionLib:MakeNotification({
        Name = "System Control",
        Content = msg,
        Image = "rbxassetid://4483345998",
        Time = time
    })
end

-- ========== HÀM ÁP DỤNG MÀU GALAXY ==========
local function applyGalaxyColor()
    pcall(function()
        if gethui() and gethui():FindFirstChild("Orion") then
            local hue = (tick() % 5) / 5
            local color = Color3.fromHSV((math.sin(hue * math.pi * 2) * 0.1) + 0.7, 0.9, 1)
            
            for _, v in pairs(gethui().Orion:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                    v.TextColor3 = color
                end
                if v:IsA("Frame") and v.BorderSizePixel > 0 then
                    v.BorderColor3 = color
                end
            end
        end
    end)
end

-- ========== HÀM ÁP DỤNG HÌNH NỀN ==========
local function setBackground(url, trans)
    trans = trans or 0.3
    pcall(function()
        if gethui() and gethui():FindFirstChild("Orion") then
            -- Tìm MainFrame trong OrionLib
            local mainFrame = nil
            for _, v in pairs(gethui().Orion:GetDescendants()) do
                if v.Name == "MainFrame" and v:IsA("Frame") then
                    mainFrame = v
                    break
                end
            end
            
            if mainFrame then
                -- Xóa background cũ nếu có
                if mainFrame:FindFirstChild("HubBackground") then
                    mainFrame.HubBackground:Destroy()
                end
                
                -- Tạo background mới
                local bg = Instance.new("ImageLabel")
                bg.Name = "HubBackground"
                bg.Parent = mainFrame
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.Position = UDim2.new(0, 0, 0, 0)
                bg.BackgroundTransparency = 1
                bg.Image = url
                bg.ImageTransparency = trans
                bg.ScaleType = Enum.ScaleType.Stretch
                bg.ZIndex = 0
                
                -- Đưa các element khác lên trên
                for _, child in pairs(mainFrame:GetChildren()) do
                    if child ~= bg then
                        child.ZIndex = 1
                    end
                end
                
                return true
            end
        end
    end)
    return false
end

-- Hàm xóa hình nền
local function resetBackground()
    pcall(function()
        if gethui() and gethui():FindFirstChild("Orion") then
            for _, v in pairs(gethui().Orion:GetDescendants()) do
                if v:IsA("Frame") and v:FindFirstChild("HubBackground") then
                    v.HubBackground:Destroy()
                end
            end
        end
    end)
end

-- ========== TẠO WINDOW ==========
local Window = OrionLib:MakeWindow({
    Name = "System Control ✨ Galaxy Edition",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false,
    IntroText = "Loading..."
})

-- ========== TAB MAIN ==========
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSection({
    Name = "Auto Features"
})

MainTab:AddToggle({
    Name = "Auto Summon",
    Default = false,
    Callback = function(Value)
        getgenv().AutoSummon = Value
        notify("Auto Summon: " .. (Value and "Bật" or "Tắt"), 2)
    end
})

task.spawn(function()
    while true do
        if getgenv().AutoSummon then
            pcall(function()
                ReplicatedStorage.System.Summon:FireServer("Sukuna")
            end)
            task.wait(getgenv().NoDelay and 0 or DelayTime)
        else
            task.wait(0.2)
        end
    end
end)

MainTab:AddToggle({
    Name = "Auto Random",
    Default = false,
    Callback = function(Value)
        getgenv().AutoRandom = Value
        notify("Auto Random: " .. (Value and "Bật" or "Tắt"), 2)
    end
})

task.spawn(function()
    while true do
        if getgenv().AutoRandom then
            pcall(function()
                ReplicatedStorage.System.RandomItem:FireServer(5)
            end)
            task.wait(getgenv().NoDelay and 0 or DelayTime)
        else
            task.wait(0.2)
        end
    end
end)

MainTab:AddToggle({
    Name = "Auto Store",
    Default = false,
    Callback = function(Value)
        getgenv().AutoStore = Value
        notify("Auto Store: " .. (Value and "Bật" or "Tắt"), 2)
    end
})

task.spawn(function()
    while true do
        if getgenv().AutoStore then
            pcall(function()
                for _,tool in pairs(Player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        ReplicatedStorage.System.Inv.Inventory:InvokeServer("Add", tool.Name)
                        task.wait(0.1)
                    end
                end
            end)
            task.wait(getgenv().NoDelay and 0 or 2)
        else
            task.wait(0.5)
        end
    end
end)

MainTab:AddToggle({
    Name = "No Delay",
    Default = false,
    Callback = function(Value)
        getgenv().NoDelay = Value
        notify("No Delay: " .. (Value and "Bật" or "Tắt"), 2)
    end
})

-- ========== TAB DISCORD ==========
local DiscordTab = Window:MakeTab({
    Name = "Discord BG",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

DiscordTab:AddParagraph({
    Title = "Hướng Dẫn",
    Content = "Dán link Discord (cdn.discordapp.com) vào ô bên dưới\nLink sẽ tự động qua proxy CORS"
})

local discordTrans = 0.3
_G.lastDiscordBg = _G.lastDiscordBg or nil

DiscordTab:AddTextbox({
    Name = "Link Discord Image",
    Default = "",
    TextDisappear = true,
    PlaceholderText = "https://cdn.discordapp.com/...",
    Callback = function(link)
        if link and link ~= "" then
            if link:match("cdn%.discordapp%.com") or link:match("media%.discordapp%.net") then
                local proxyUrl = "https://corsproxy.io/?" .. link
                notify("🌐 Đang tải từ Discord...", 2)
                
                local success = setBackground(proxyUrl, discordTrans)
                if success then
                    notify("✅ Đã cập nhật hình nền Discord!", 3)
                    _G.lastDiscordBg = link
                    _G.currentBgType = "discord"
                else
                    notify("❌ Không thể tải ảnh", 3)
                end
            else
                notify("⚠️ Không phải link Discord", 2)
            end
        end
    end
})

if _G.lastDiscordBg then
    DiscordTab:AddButton({
        Name = "🔄 Dùng Lại Link Discord Cũ",
        Callback = function()
            local proxyUrl = "https://corsproxy.io/?" .. _G.lastDiscordBg
            setBackground(proxyUrl, discordTrans)
            notify("✅ Đã cập nhật lại hình nền!", 2)
            _G.currentBgType = "discord"
        end
    })
end

DiscordTab:AddSlider({
    Name = "Độ Mờ Discord",
    Min = 0,
    Max = 0.9,
    Default = discordTrans,
    Increment = 0.1,
    Callback = function(value)
        discordTrans = value
        if _G.currentBgType == "discord" then
            pcall(function()
                if gethui() and gethui():FindFirstChild("Orion") then
                    for _, frame in pairs(gethui().Orion:GetDescendants()) do
                        if frame:IsA("Frame") and frame:FindFirstChild("HubBackground") then
                            frame.HubBackground.ImageTransparency = value
                        end
                    end
                end
            end)
        end
    end
})

-- ========== TAB GITHUB ==========
local GitHubTab = Window:MakeTab({
    Name = "GitHub BG",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

GitHubTab:AddParagraph({
    Title = "Hướng Dẫn",
    Content = "Dùng link raw.githubusercontent.com\nHoặc link blob, script sẽ tự chuyển đổi"
})

local githubTrans = 0.3
_G.lastGitHubBg = _G.lastGitHubBg or nil

GitHubTab:AddTextbox({
    Name = "Link GitHub Image",
    Default = "",
    TextDisappear = true,
    PlaceholderText = "https://raw.githubusercontent.com/...",
    Callback = function(link)
        if link and link ~= "" then
            local finalLink = link
            
            if link:match("github%.com/.+/blob/") then
                finalLink = link:gsub("github%.com", "raw.githubusercontent.com"):gsub("/blob/", "/")
                notify("🔄 Đã chuyển sang link raw", 1.5)
            end
            
            if finalLink:match("%?raw=true") then
                finalLink = finalLink:gsub("%?raw=true", "")
            end
            
            notify("📥 Đang tải từ GitHub...", 2)
            
            local success = setBackground(finalLink, githubTrans)
            if success then
                notify("✅ Đã cập nhật hình nền GitHub!", 3)
                _G.lastGitHubBg = finalLink
                _G.currentBgType = "github"
            else
                notify("❌ Không thể tải ảnh", 3)
            end
        end
    end
})

if _G.lastGitHubBg then
    GitHubTab:AddButton({
        Name = "🔄 Dùng Lại Link GitHub Cũ",
        Callback = function()
            setBackground(_G.lastGitHubBg, githubTrans)
            notify("✅ Đã cập nhật lại hình nền!", 2)
            _G.currentBgType = "github"
        end
    })
end

GitHubTab:AddSlider({
    Name = "Độ Mờ GitHub",
    Min = 0,
    Max = 0.9,
    Default = githubTrans,
    Increment = 0.1,
    Callback = function(value)
        githubTrans = value
        if _G.currentBgType == "github" then
            pcall(function()
                if gethui() and gethui():FindFirstChild("Orion") then
                    for _, frame in pairs(gethui().Orion:GetDescendants()) do
                        if frame:IsA("Frame") and frame:FindFirstChild("HubBackground") then
                            frame.HubBackground.ImageTransparency = value
                        end
                    end
                end
            end)
        end
    end
})

-- ========== TAB SETTINGS ==========
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddButton({
    Name = "🗑️ Xóa Hình Nền",
    Callback = function()
        resetBackground()
        _G.currentBgType = nil
        notify("✅ Đã xóa hình nền", 2)
    end
})

-- Hình nền cổ điển
SettingsTab:AddSection({
    Name = "Hình Nền Cổ Điển"
})

local OldImages = {
    ["18273888587"] = "Ảnh 1 - Thiên Nhiên",
    ["18275995451"] = "Ảnh 2 - Anime", 
    ["18277860491"] = "Ảnh 3 - Phong Cảnh",
    ["72316572273088"] = "Ảnh 4 - Galaxy",
    ["6031094686"] = "Icon Mặc Định",
    ["4483345998"] = "Icon Hub"
}

local selectedOldImage = "18273888587"
local oldTrans = 0.3

SettingsTab:AddDropdown({
    Name = "Chọn Ảnh",
    Options = {
        "18273888587 - Ảnh 1 - Thiên Nhiên",
        "182