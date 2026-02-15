-- Tải OrionLib với tham số thời gian để tránh cache
local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Khanhdzaii/orionlib/refs/heads/main/orionlib?t="..tostring(os.time())), true))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

getgenv().AutoSummon = false
getgenv().AutoRandom = false
getgenv().AutoStore = false
getgenv().NoDelay = false

local DelayTime = 1

-- ========== KIỂM TRA VÀ TẠO HÀM THÔNG BÁO ==========
local function notify(message, duration)
    duration = duration or 3
    pcall(function()
        OrionLib:MakeNotification({
            Name = "System Control",
            Content = message,
            Image = "rbxassetid://4483345998",
            Time = duration
        })
    end)
end

-- ========== HÀM TẠO MÀU GALAXY CHUYỂN SẮC ==========
local function createGalaxyColor()
    local hue = (tick() % 5) / 5
    local galaxyHue = (math.sin(hue * math.pi * 2) * 0.1) + 0.7
    return Color3.fromHSV(galaxyHue, 0.9, 1)
end

-- Hàm áp dụng màu chữ galaxy
local function applyGalaxyTextColor()
    pcall(function()
        if gethui() and gethui():FindFirstChild("Orion") then
            for _, i in pairs(gethui():GetChildren()) do
                if i.Name == "Orion" then
                    for _, v in pairs(i:GetDescendants()) do
                        if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                                            v.TextColor3 = createGalaxyColor()
                        end
                        if v.ClassName == "Frame" and v.BorderSizePixel > 0 then
                            v.BorderColor3 = createGalaxyColor()
                        end
                    end
                end
            end
        end
    end)
end

-- ========== HÀM ÁP DỤNG HÌNH NỀN ==========
local function setBackgroundFromUrl(imageUrl, transparency)
    transparency = transparency or 0.3
    local success = false
    
    pcall(function()
        if gethui() and gethui():FindFirstChild("Orion") then
            for _, gui in pairs(gethui():GetChildren()) do
                if gui.Name == "Orion" then
                    -- Tìm frame lớn nhất (thường là MainFrame)
                    local targetFrame = nil
                    
                    -- Ưu tiên tìm frame có tên MainFrame
                    for _, frame in pairs(gui:GetDescendants()) do
                        if frame.Name == "MainFrame" and frame:IsA("Frame") then
                            targetFrame = frame
                            break
                        end
                    end
                    
                    -- Nếu không tìm thấy MainFrame, tìm frame lớn nhất
                    if not targetFrame then
                        local maxSize = 0
                        for _, frame in pairs(gui:GetDescendants()) do
                            if frame:IsA("Frame") and frame.BackgroundTransparency < 1 and frame.AbsoluteSize.X > 100 then
                                local size = frame.AbsoluteSize.X * frame.AbsoluteSize.Y
                                if size > maxSize then
                                    maxSize = size
                                    targetFrame = frame
                                end
                            end
                        end
                    end
                    
                    if targetFrame then
                        -- Xóa background cũ
                        if targetFrame:FindFirstChild("HubBackground") then
                            targetFrame.HubBackground:Destroy()
                        end
                        
                        -- Tạo background mới
                        local bg = Instance.new("ImageLabel")
                        bg.Name = "HubBackground"
                        bg.Parent = targetFrame
                        bg.Size = UDim2.new(1, 0, 1, 0)
                        bg.Position = UDim2.new(0, 0, 0, 0)
                        bg.BackgroundTransparency = 1
                        bg.Image = imageUrl
                        bg.ImageTransparency = transparency
                        bg.ScaleType = Enum.ScaleType.Stretch
                        bg.ZIndex = 0
                        
                        -- Đưa các element khác lên trên
                        for _, child in pairs(targetFrame:GetChildren()) do
                            if child ~= bg and child:IsA("Frame") then
                                child.ZIndex = 1
                            end
                        end
                        
                        success = true
                    end
                end
            end
        end
    end)
    
    return success
end

-- Hàm xóa hình nền
local function resetBackground()
    pcall(function()
        if gethui() and gethui():FindFirstChild("Orion") then
            for _, gui in pairs(gethui():GetChildren()) do
                if gui.Name == "Orion" then
                    for _, frame in pairs(gui:GetDescendants()) do
                        if frame:IsA("Frame") and frame:FindFirstChild("HubBackground") then
                            frame.HubBackground:Destroy()
                        end
                    end
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

-- Thêm section để dễ nhìn
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

-- ========== TAB DISCORD BACKGROUND ==========
local DiscordTab = Window:MakeTab({
    Name = "Discord BG",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

DiscordTab:AddParagraph({
    Title = "Hướng Dẫn",
    Content = "Dán link Discord (cdn.discordapp.com) vào ô bên dưới\nLink sẽ tự động qua proxy CORS"
})

local discordTransparency = 0.3
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
                
                local success = setBackgroundFromUrl(proxyUrl, discordTransparency)
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
            setBackgroundFromUrl(proxyUrl, discordTransparency)
            notify("✅ Đã cập nhật lại hình nền!", 2)
            _G.currentBgType = "discord"
        end
    })
end

DiscordTab:AddSlider({
    Name = "Độ Mờ",
    Min = 0,
    Max = 0.9,
    Default = discordTransparency,
    Increment = 0.1,
    Callback = function(value)
        discordTransparency = value
        if _G.currentBgType == "discord" then
            pcall(function()
                if gethui() and gethui():FindFirstChild("Orion") then
                    for _, gui in pairs(gethui():GetChildren()) do
                        if gui.Name == "Orion" then
                            for _, frame in pairs(gui:GetDescendants()) do
                                if frame:IsA("Frame") and frame:FindFirstChild("HubBackground") then
                                    frame.HubBackground.ImageTransparency = value
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- ========== TAB GITHUB BACKGROUND ==========
local GitHubTab = Window:MakeTab({
    Name = "GitHub BG",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

GitHubTab:AddParagraph({
    Title = "Hướng Dẫn",
    Content = "Dùng link raw.githubusercontent.com\nHoặc link blob, script sẽ tự chuyển đổi"
})

local githubTransparency = 0.3
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
            
            local success = setBackgroundFromUrl(finalLink, githubTransparency)
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
            setBackgroundFromUrl(_G.lastGitHubBg, githubTransparency)
            notify("✅ Đã cập nhật lại hình nền!", 2)
            _G.currentBgType = "github"
        end
    })
end

GitHubTab:AddSlider({
    Name = "Độ Mờ",
    Min = 0,
    Max = 0.9,
    Default = githubTransparency,
    Increment = 0.1,
    Callback = function(value)
        githubTransparency = value
        if _G.currentBgType == "github" then
            pcall(function()
                if gethui() and gethui():FindFirstChild("Orion") then
                    for _, gui in pairs(gethui():GetChildren()) do
                        if gui.Name == "Orion" then
                            for _, frame in pairs(gui:GetDescendants()) do
                                if frame:IsA("Frame") and frame:FindFirstChild("HubBackground") then
                                    frame.HubBackground.ImageTransparency = value
                                end
                            end
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

-- ========== HÌNH NỀN KIỂU CŨ ==========
SettingsTab:AddSection({
    Name = "Hình Nền Cổ Điển"
})

-- Danh sách ID ảnh kiểu cũ
local OldStyleImages = {
    ["18273888587"] = "Ảnh 1 - Thiên Nhiên",
    ["18275995451"] = "Ảnh 2 - Anime", 
    ["18277860491"] = "Ảnh 3 - Phong Cảnh",
    ["72316572273088"] = "Ảnh 4 - Galaxy",
    ["6031094686"] = "Icon Mặc Định",
    ["4483345998"] = "Icon Hub"
}

local selectedOldImage = "18273888587"
local oldStyleTransparency = 0.3

SettingsTab:AddDropdown({
    Name = "Chọn Ảnh",
    Options = {
        "18273888587 - Ảnh 1 - Thiên Nhiên",
        "18275995451 - Ảnh 2 - Anime",
        "18277860491 - Ảnh 3 - Phong Cảnh", 
        "72316572273088 - Ảnh 4 - Galaxy",
        "6031094686 - Icon Mặc Định",
        "4483345998 - Icon Hub"
    },
    Default = "18273888587 - Ảnh 1 - Thiên Nhiên",
    Callback = function(value)
        selectedOldImage = value:match("(%d+)")
        notify("✅ Đã chọn: " .. (OldStyleImages[selectedOldImage] or selectedOldImage), 2)
    end
})

SettingsTab:AddButton({
    Name = "Áp Dụng Hình Nền",
    Callback = function()
        local imageUrl = "rbxassetid://" .. selectedOldImage
        local success = setBackgroundFromUrl(imageUrl, oldStyleTransparency)
        
        if success then
            notify("✅ Đã áp dụng hình nền: " .. selectedOldImage, 3)
            _G.currentBgType = "oldstyle"
            _G.currentBgId = selectedOldImage
        else
            notify("❌ Không thể áp dụng hình nền", 3)
        end
    end
})

SettingsTab:AddButton({
    Name = "🎲 Random Ảnh",
    Callback = function()
        local imageIds = {"18273888587", "18275995451", "18277860491", "72316572273088", "6031094686", "4483345998"}
        local randomId = imageIds[math.random(#imageIds)]
        
        local imageUrl = "rbxassetid://" .. randomId
        local success = setBackgroundFromUrl(imageUrl, oldStyleTransparency)
        
        if success then
            notify("🎲 Random: " .. (OldStyleImages[randomId] or randomId), 3)
            _G.currentBgType = "oldstyle"
            _G.currentBgId = randomId
        end
    end
})

SettingsTab:AddSlider({
    Name = "Độ Mờ",
    Min = 0,
    Max = 0.9,
    Default = oldStyleTransparency,
    Increment = 0.1,
    Callback = function(value)
        oldStyleTransparency = value
        if _G.currentBgType == "oldstyle" then
            pcall(function()
                if gethui() and gethui():FindFirstChild("Orion") then
                    for _, gui in pairs(gethui():GetChildren()) do
                        if gui.Name == "Orion" then
                            for _, frame in pairs(gui:GetDescendants()) do
                                if frame:IsA("Frame") and frame:FindFirstChild("HubBackground") then
                                    frame.HubBackground.ImageTransparency = value
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

SettingsTab:AddLabel("💡 Ảnh cổ điển load nhanh hơn vì dùng trực tiếp từ Roblox")

SettingsTab:AddButton({
    Name = "🔄 Reset Tất Cả",
    Callback = function()
        resetBackground()
        _G.currentBgType = nil
        _G.lastDiscordBg = nil
        _G.lastGitHubBg = nil
        notify("✅ Đã reset tất cả cài đặt", 3)
    end
})

-- ========== HIỆU ỨNG GALAXY CHO CHỮ ==========
task.spawn(function()
    while true do
        pcall(applyGalaxyTextColor)
        task.wait(0.1)
    end
end)

-- Áp dụng màu ban đầu
task.wait(1)
pcall(applyGalaxyTextColor)

-- ========== KIỂM TRA VÀ THÔNG BÁO ==========
notify("✅ Script loaded successfully!", 3)

-- ========== KHỞI TẠO ORIONLIB ==========
OrionLib:Init()