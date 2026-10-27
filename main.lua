-- MOYA DUELS V2 | full-body animations, FRHUB playlist and Aimbot Me Down
local BG         = Color3.fromRGB(8, 0, 0)
local SIDEBAR_BG = Color3.fromRGB(14, 0, 0)
local CARD_BG    = Color3.fromRGB(28, 0, 0)
local CARD_HOV   = Color3.fromRGB(70, 8, 8)
local KB_BG      = Color3.fromRGB(180, 0, 0)

local WHITE      = Color3.fromRGB(255, 55, 55)
local DIM        = Color3.fromRGB(220, 70, 70)
local DIM2       = Color3.fromRGB(18, 0, 0)

local BORDER     = Color3.fromRGB(120, 10, 10)
local BORDER2    = Color3.fromRGB(180, 25, 25)
local OPTION_TRANSPARENCY = 0.42
local OPTION_HOVER_TRANSPARENCY = 0.22
local TAB_TRANSPARENCY = 0.35
local TAB_HOVER_TRANSPARENCY = 0.16
local INPUT_TRANSPARENCY = 0.24

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

task.spawn(function()
    local env = (getgenv and getgenv()) or _G
    env.__MVP_HIGH_PING_RUN = (env.__MVP_HIGH_PING_RUN or 0) + 1
    local thisRun = env.__MVP_HIGH_PING_RUN
    env.__MVP_INTRO_FINISHED_RUN = 0
    local shown = false

    local function getPingMilliseconds()
        local ok, value = pcall(function()
            local stats = game:GetService("Stats")
            local network = stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
            if not pingItem then
                return nil
            end

            local numericValue
            pcall(function()
                numericValue = pingItem:GetValue()
            end)
            if type(numericValue) == "number" then
                return numericValue
            end

            local valueString = pingItem:GetValueString()
            return tonumber(tostring(valueString):match("[%d%.]+"))
        end)
        return ok and tonumber(value) or nil
    end

    local function showHighPingAlert()
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")

        pcall(function()
            local old = CoreGui:FindFirstChild("MVPHighPingAlert")
            if old then old:Destroy() end
        end)
        pcall(function()
            local old = playerGui and playerGui:FindFirstChild("MVPHighPingAlert")
            if old then old:Destroy() end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "MVPHighPingAlert"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = false
        gui.DisplayOrder = 10000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local parented = pcall(function()
            gui.Parent = CoreGui
        end)
        if not parented or not gui.Parent then
            gui.Parent = playerGui
        end
        if not gui.Parent then
            gui:Destroy()
            return
        end

        local bar = Instance.new("Frame")
        bar.Name = "AlertBar"
        bar.AnchorPoint = Vector2.new(0.5, 0)
        bar.Position = UDim2.new(0.5, 0, 0, -44)
        bar.Size = UDim2.new(0, 310, 0, 32)
        bar.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        bar.BackgroundTransparency = 0.06
        bar.BorderSizePixel = 0
        bar.ClipsDescendants = true
        bar.ZIndex = 100
        bar.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 11)
        corner.Parent = bar

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 30, 30)
        stroke.Transparency = 0.2
        stroke.Thickness = 1
        stroke.Parent = bar

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0)),
        })
        gradient.Parent = bar

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = "high ping! Your ping is more than 150."
        label.TextColor3 = Color3.fromRGB(255, 55, 55)
        label.TextSize = 13
        label.TextStrokeColor3 = Color3.fromRGB(50, 0, 0)
        label.TextStrokeTransparency = 0.55
        label.TextWrapped = false
        label.TextScaled = false
        label.ZIndex = 102
        label.Parent = bar

        local slideIn = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 10)}
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        task.wait(2)

        local slideOut = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -44)}
        )
        slideOut:Play()
        slideOut.Completed:Wait()
        gui:Destroy()
    end

    while env.__MVP_HIGH_PING_RUN == thisRun and env.__MVP_INTRO_FINISHED_RUN ~= thisRun do
        task.wait(0.1)
    end

    while env.__MVP_HIGH_PING_RUN == thisRun and not shown do
        local ping = getPingMilliseconds()
        if ping and ping > 150 then
            shown = true
            showHighPingAlert()
            break
        end
        task.wait(1)
    end
end)

do
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local SoundService = game:GetService("SoundService")
    local HttpService = game:GetService("HttpService")

    local noIntroSaved = false
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile("CRYON_DUELS_V8_CONFIG.json") then
            local decoded = HttpService:JSONDecode(readfile("CRYON_DUELS_V8_CONFIG.json"))
            if type(decoded) == "table" then
                if decoded.noIntro ~= nil then
                    noIntroSaved = decoded.noIntro == true
                elseif decoded.introEnabled ~= nil then
                    noIntroSaved = decoded.introEnabled ~= true
                end
            end
        end
    end)
    local sharedEnv = (getgenv and getgenv()) or _G
    sharedEnv.__MVP_NO_INTRO_SAVED = noIntroSaved

    for _, n in ipairs({"MVPIntro", "CryonHoneypotGui", "AdaptIntro", "AdaptHoneypotGui"}) do
        pcall(function()
            local old = CoreGui:FindFirstChild(n)
            if old then old:Destroy() end
        end)
    end

    if noIntroSaved then
        -- skip intro: unblock high-ping watcher
        sharedEnv.__MVP_INTRO_FINISHED_RUN = sharedEnv.__MVP_HIGH_PING_RUN or 0
    end

    if not noIntroSaved then
        local introDone = Instance.new("BindableEvent")
        local introScreenGui = Instance.new("ScreenGui")
        introScreenGui.Name = "MVPIntro"
        introScreenGui.ResetOnSpawn = false
        introScreenGui.IgnoreGuiInset = true
        introScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        introScreenGui.DisplayOrder = 999999
        pcall(function() introScreenGui.Parent = game:GetService("CoreGui") end)
        if not introScreenGui.Parent then
            local lp = game:GetService("Players").LocalPlayer
            if lp then introScreenGui.Parent = lp:WaitForChild("PlayerGui") end
        end
        local screenGui = introScreenGui
        local introFinished = false
        local introSound
        local introLayer

        local function finishIntro()
            if introFinished then return end
            introFinished = true
            -- Intro music must stop on both timeout and SKIP INTRO.
            -- The separate menu ambient track is loaded and started later.
            pcall(function()
                if introSound then
                    introSound:Stop()
                    introSound:Destroy()
                    introSound = nil
                end
            end)
            pcall(function()
                if introLayer then
                    introLayer:Destroy()
                    introLayer = nil
                end
            end)
            pcall(function() introDone:Fire() end)
            -- 🔥 ESTA ES LA LÍNEA CLAVE QUE FALTABA:
            local env = (getgenv and getgenv()) or _G
            env.__MVP_INTRO_FINISHED_RUN = env.__MVP_HIGH_PING_RUN
        end

        task.delay(110.0, finishIntro)

        -- Intro music: BIA - WE ON GO
        introSound = Instance.new("Sound")
        introSound.Name = "MOYADuelsIntroMusic"
        introSound.Volume = 0.22
        introSound.Looped = true
        introSound.Parent = game:GetService("SoundService")

        local function startIntroMusic()
            if not introSound or not introSound.Parent then return end
            task.spawn(function()
                local fileName = "mvp_intro_weongo.mp3"
                local urls = {
                    "https://files.catbox.moe/y85mq4.mp3",
                }
                local assetFn = getcustomasset or getsynasset

                local function isValidMp3(data)
                    if type(data) ~= "string" or #data < 10000 then return false end
                    local h = data:sub(1, 64):lower()
                    if h:find("<html", 1, true) or h:find("<!doctype", 1, true) then return false end
                    return data:sub(1, 3) == "ID3" or data:byte(1) == 0xFF or #data > 100000
                end

                local function fetch(url)
                    local data
                    pcall(function()
                        local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
                        if type(req) == "function" then
                            local res = req({
                                Url = url,
                                Method = "GET",
                                Headers = {["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,*/*"},
                            })
                            if type(res) == "table" then
                                data = res.Body or res.body
                            end
                        end
                    end)
                    if not isValidMp3(data) then
                        pcall(function()
                            data = game:HttpGet(url, true)
                        end)
                    end
                    return isValidMp3(data) and data or nil
                end

                local assetId = nil
                pcall(function()
                    if type(isfile) == "function" and isfile(fileName) and type(assetFn) == "function" then
                        local ok, a = pcall(assetFn, fileName)
                        if ok and a then assetId = a end
                    end
                end)

                if not assetId then
                    for _, url in ipairs(urls) do
                        local data = fetch(url)
                        if data then
                            pcall(function()
                                if type(writefile) == "function" then
                                    writefile(fileName, data)
                                end
                            end)
                            if type(assetFn) == "function" then
                                local ok, a = pcall(assetFn, fileName)
                                if ok and a then
                                    assetId = a
                                    break
                                end
                            end
                        end
                    end
                end

                if not assetId then
                    warn("[MOYA DUELS V2] Could not load background music")
                    return
                end

                pcall(function()
                    introSound.SoundId = assetId
                    introSound.Volume = 0.22
                    introSound:Play()
                    local t0 = os.clock()
                    while not introSound.IsLoaded and os.clock() - t0 < 4 do
                        task.wait()
                    end
                    introSound.TimePosition = 0
                end)
            end)
        end
        -- Arranca la música en cuanto se arma la intro
        startIntroMusic()

        introLayer = Instance.new("Frame")
        introLayer.Name = "MVPIntro"
        introLayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introLayer.BackgroundTransparency = 1
        introLayer.BorderSizePixel = 0
        introLayer.Size = UDim2.fromScale(1, 1)
        introLayer.Position = UDim2.fromScale(0, 0)
        introLayer.ClipsDescendants = true
        introLayer.ZIndex = 1000
        introLayer.Parent = screenGui

        -- Botón OMITIR (abajo a la derecha)
        local skipBtn = Instance.new("TextButton")
        skipBtn.Name = "SkipIntroBtn"
        skipBtn.AnchorPoint = Vector2.new(1, 1)
        skipBtn.Position = UDim2.new(1, -18, 1, -18)
        skipBtn.Size = UDim2.new(0, 112, 0, 32)
        skipBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        skipBtn.BackgroundTransparency = 0.2
        skipBtn.BorderSizePixel = 0
        skipBtn.Text = "SKIP INTRO"
        skipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        skipBtn.Font = Enum.Font.GothamBold
        skipBtn.TextSize = 13
        skipBtn.ZIndex = 1100
        skipBtn.AutoButtonColor = false
        skipBtn.Parent = introLayer
        local skipCorner = Instance.new("UICorner")
        skipCorner.CornerRadius = UDim.new(0, 8)
        skipCorner.Parent = skipBtn
        local skipStroke = Instance.new("UIStroke")
        skipStroke.Color = Color3.fromRGB(255, 40, 40)
        skipStroke.Thickness = 1.2
        skipStroke.Transparency = 0.35
        skipStroke.Parent = skipBtn
        skipBtn.MouseEnter:Connect(function()
            TweenService:Create(skipBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.08,
                BackgroundColor3 = Color3.fromRGB(160, 0, 0)
            }):Play()
        end)
        skipBtn.MouseLeave:Connect(function()
            TweenService:Create(skipBtn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.25,
                BackgroundColor3 = Color3.fromRGB(120, 0, 0)
            }):Play()
        end)
        skipBtn.MouseButton1Click:Connect(function()
            finishIntro()
        end)

        local introImage = Instance.new("ImageLabel")
        introImage.Name = "IntroBackground"
        introImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introImage.BackgroundTransparency = 1
        introImage.BorderSizePixel = 0
        introImage.AnchorPoint = Vector2.new(0.5, 0.5)
        introImage.Position = UDim2.fromScale(0.5, 0.5)
        introImage.Size = UDim2.fromScale(1.08, 1.08)
        introImage.Image = ""
        introImage.ScaleType = Enum.ScaleType.Crop

        -- Load the supplied Catbox background when the runtime supports local custom assets.
        task.spawn(function()
            local imageFile = "moya_duels_background.jpg"
            local assetFn = getcustomasset or getsynasset
            local function validImage(data)
                return type(data) == "string"
                    and #data > 1000
                    and (
                        (data:byte(1) == 255 and data:byte(2) == 216)
                        or data:sub(1, 4) == string.char(137) .. "PNG"
                        or data:sub(1, 4) == "RIFF"
                    )
            end

            local imageAsset
            pcall(function()
                if type(isfile) == "function" and isfile(imageFile) and type(assetFn) == "function" then
                    imageAsset = assetFn(imageFile)
                end
            end)

            if not imageAsset then
                local data
                pcall(function()
                    local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
                    if type(req) == "function" then
                        local response = req({
                            Url = "https://files.catbox.moe/lmxj8b.jpg",
                            Method = "GET",
                            Headers = {["User-Agent"] = "Mozilla/5.0", ["Accept"] = "image/jpeg,*/*"},
                        })
                        if type(response) == "table" then
                            data = response.Body or response.body
                        end
                    end
                end)
                if not validImage(data) then
                    pcall(function()
                        data = game:HttpGet("https://files.catbox.moe/lmxj8b.jpg", true)
                    end)
                end
                if validImage(data) then
                    pcall(function()
                        if type(writefile) == "function" then writefile(imageFile, data) end
                    end)
                    if type(assetFn) == "function" then
                        pcall(function() imageAsset = assetFn(imageFile) end)
                    end
                end
            end

            if imageAsset and introImage then
                local waitStarted = os.clock()
                while introImage.Parent == nil and os.clock() - waitStarted < 5 do
                    task.wait(0.05)
                end
                if introImage.Parent then
                    introImage.Image = imageAsset
                    introImage.ImageTransparency = 0.40
                end
            end
        end)
        introImage.ImageColor3 = Color3.fromRGB(160, 160, 160)
        introImage.ImageTransparency = 0.58
        introImage.ZIndex = 1001
        introImage.Parent = introLayer

        local introShade = Instance.new("Frame")
        introShade.Name = "DarkShade"
        introShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introShade.BackgroundTransparency = 0.55
        introShade.BorderSizePixel = 0
        introShade.Size = UDim2.fromScale(1, 1)
        introShade.ZIndex = 1002
        introShade.Parent = introLayer

        local introVignette = Instance.new("ImageLabel")
        introVignette.Name = "Vignette"
        introVignette.BackgroundTransparency = 1
        introVignette.Size = UDim2.fromScale(1, 1)
        introVignette.Image = "rbxassetid://4576475446"
        introVignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
        introVignette.ImageTransparency = 0.72
        introVignette.ScaleType = Enum.ScaleType.Stretch
        introVignette.ZIndex = 1003
        introVignette.Parent = introLayer

        local scanlineHolder = Instance.new("Frame")
        scanlineHolder.Name = "Scanlines"
        scanlineHolder.BackgroundTransparency = 1
        scanlineHolder.Size = UDim2.fromScale(1, 1)
        scanlineHolder.ZIndex = 1004
        scanlineHolder.Parent = introLayer

        -- Lightweight animated rain overlay for the full intro.
        local rainHolder = Instance.new("Frame")
        rainHolder.Name = "RainOverlay"
        rainHolder.BackgroundTransparency = 1
        rainHolder.Size = UDim2.fromScale(1, 1)
        rainHolder.ClipsDescendants = true
        rainHolder.ZIndex = 1004
        rainHolder.Parent = introLayer

        for i = 1, 72 do
            local drop = Instance.new("Frame")
            drop.Name = "RainDrop_" .. i
            drop.AnchorPoint = Vector2.new(0.5, 0.5)
            drop.BorderSizePixel = 0
            drop.BackgroundColor3 = Color3.fromRGB(205, 220, 235)
            drop.BackgroundTransparency = 0.48 + math.random() * 0.34
            drop.Rotation = 12
            drop.Size = UDim2.new(0, 1, 0, math.random(8, 19))
            drop.Position = UDim2.fromScale(math.random(), math.random())
            drop.ZIndex = 1004
            drop.Parent = rainHolder

            task.spawn(function()
                while drop.Parent and introLayer and introLayer.Parent do
                    local duration = 0.55 + math.random() * 0.75
                    drop.Position = UDim2.fromScale(math.random(), -0.05)
                    drop.BackgroundTransparency = 0.48 + math.random() * 0.34
                    local fall = TweenService:Create(
                        drop,
                        TweenInfo.new(duration, Enum.EasingStyle.Linear),
                        {
                            Position = UDim2.fromScale(
                                math.clamp(drop.Position.X.Scale + 0.06, 0, 1),
                                1.05
                            ),
                            BackgroundTransparency = 0.82
                        }
                    )
                    fall:Play()
                    fall.Completed:Wait()
                end
            end)
        end

        for y = 0, 1, 0.085 do
            local line = Instance.new("Frame")
            line.BorderSizePixel = 0
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 0.99
            line.Position = UDim2.fromScale(0, y)
            line.Size = UDim2.new(1, 0, 0, 1)
            line.ZIndex = 1004
            line.Parent = scanlineHolder
        end

        local introContent = Instance.new("Frame")
        introContent.Name = "IntroContent"
        introContent.AnchorPoint = Vector2.new(0.5, 0.5)
        introContent.BackgroundTransparency = 1
        introContent.Position = UDim2.fromScale(0.5, 0.5)
        introContent.Size = UDim2.new(0.96, 0, 0, 180)
        introContent.ZIndex = 1005
        introContent.Parent = introLayer

        local function makeIntroText(name, color, transparency, zindex)
            local label = Instance.new("TextLabel")
            label.Name = name
            label.BackgroundTransparency = 1
            label.AnchorPoint = Vector2.new(0.5, 0.5)
            label.Position = UDim2.fromScale(0.5, 0.5)
            label.Size = UDim2.new(1, -12, 0, 110)
            label.Font = Enum.Font.GothamBlack
            label.Text = "MOYA DUELS V2"
            label.TextColor3 = color
            label.TextSize = 58
            label.TextTransparency = transparency
            label.TextStrokeColor3 = Color3.fromRGB(45, 0, 0)
            label.TextStrokeTransparency = 0.18
            label.ZIndex = zindex
            label.Parent = introContent
            return label
        end

        local introGlitchDark = makeIntroText("GlitchDark", Color3.fromRGB(20, 20, 20), 1, 1005)
        local introGlitchBright = makeIntroText("GlitchBright", Color3.fromRGB(230, 230, 230), 1, 1006)
        local introTitleGlow = makeIntroText("IntroTitleGlow", Color3.fromRGB(0, 0, 0), 1, 1007)
        introTitleGlow.TextSize = 42
        introTitleGlow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        introTitleGlow.TextStrokeTransparency = 0.35

        local introTitle = makeIntroText("IntroTitle", Color3.fromRGB(255, 255, 255), 1, 1008)
        introTitle.TextSize = 42
        introGlitchBright.TextSize = 42
        introGlitchDark.TextSize = 42
        local introTitleGradient = Instance.new("UIGradient")
        introTitleGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.56, Color3.fromRGB(245, 245, 245)),
            ColorSequenceKeypoint.new(0.76, Color3.fromRGB(220, 220, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        })
        introTitleGradient.Offset = Vector2.new(-1, 0)
        introTitleGradient.Parent = introTitle

        local introVsGlow = Instance.new("TextLabel")
        introVsGlow.Name = "IntroVsGlow"
        introVsGlow.BackgroundTransparency = 1
        introVsGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        introVsGlow.Position = UDim2.new(0.5, 0, 0.72, -70)
        introVsGlow.Size = UDim2.new(0.62, 0, 0, 76)
        introVsGlow.Font = Enum.Font.GothamBlack
        introVsGlow.Text = "VS"
        introVsGlow.TextColor3 = Color3.fromRGB(0, 0, 0)
        introVsGlow.TextSize = 58
        introVsGlow.TextTransparency = 1
        introVsGlow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        introVsGlow.TextStrokeTransparency = 1
        introVsGlow.ZIndex = 1007
        introVsGlow.Parent = introContent

        local introVs = introVsGlow:Clone()
        introVs.Name = "IntroVs"
        introVs.TextColor3 = Color3.fromRGB(255, 255, 255)
        introVs.TextSize = 54
        introVs.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        introVs.ZIndex = 1010
        introVs.Parent = introContent

        local introVsGhost = introVs:Clone()
        introVsGhost.Name = "IntroVsGhost"
        introVsGhost.TextColor3 = Color3.fromRGB(40, 40, 40)
        introVsGhost.ZIndex = 1009
        introVsGhost.Parent = introContent

        local function titleEntrance()
            local finalPos = UDim2.fromScale(0.5, 0.5)
            introTitle.Position = UDim2.new(0.5, -95, 0.5, 0)
            introTitleGlow.Position = UDim2.new(0.5, 85, 0.5, 0)
            introGlitchBright.Position = UDim2.new(0.5, 125, 0.5, -7)
            introGlitchDark.Position = UDim2.new(0.5, -125, 0.5, 7)
            introTitle.Rotation = -5
            introTitleGlow.Rotation = 5
            introTitle.TextTransparency = 1
            introTitleGlow.TextTransparency = 1
            introGlitchBright.TextTransparency = 0.3
            introGlitchDark.TextTransparency = 0.42

            TweenService:Create(introTitle, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0
            }):Play()
            TweenService:Create(introTitleGlow, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = finalPos, Rotation = 0, TextTransparency = 0.58
            }):Play()
            TweenService:Create(introGlitchBright, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 8, 0.5, -2)
            }):Play()
            TweenService:Create(introGlitchDark, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -8, 0.5, 2)
            }):Play()

            for _ = 1, 9 do
                local dx = math.random(-16, 16)
                local dy = math.random(-4, 4)
                introTitle.Position = UDim2.new(0.5, dx, 0.5, dy)
                introTitleGlow.Position = UDim2.new(0.5, -dx * 0.35, 0.5, -dy)
                introGlitchBright.Position = UDim2.new(0.5, dx + 8, 0.5, dy - 2)
                introGlitchDark.Position = UDim2.new(0.5, dx - 8, 0.5, -dy + 2)
                task.wait(0.025)
            end

            introTitle.Position = finalPos
            introTitleGlow.Position = finalPos
            introGlitchBright.TextTransparency = 1
            introGlitchDark.TextTransparency = 1
        end

        local function vsImpactGlitch()
            introVs.Position = UDim2.new(0.5, 0, 0.72, -68)
            introVsGlow.Position = introVs.Position
            introVsGhost.Position = UDim2.new(0.5, -8, 0.72, -62)
            introVs.TextTransparency = 0
            introVsGlow.TextTransparency = 0.58
            introVsGlow.TextStrokeTransparency = 0.48
            introVsGhost.TextTransparency = 0.42
            introVs.Rotation = -8
            introVsGlow.Rotation = 7
            introVsGhost.Rotation = -12

            local impactPos = UDim2.new(0.5, 0, 0.72, 18)
            TweenService:Create(introVs, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGlow, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = impactPos, Rotation = 0
            }):Play()
            TweenService:Create(introVsGhost, TweenInfo.new(0.31, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -10, 0.72, 24), Rotation = 0
            }):Play()
            task.wait(0.30)

            for _ = 1, 13 do
                local dx = math.random(-12, 12)
                local dy = math.random(-5, 5)
                introVs.Position = UDim2.new(0.5, dx, 0.72, 18 + dy)
                introVsGlow.Position = UDim2.new(0.5, -dx * 0.45, 0.72, 18 - dy)
                introVsGhost.Position = UDim2.new(0.5, dx - 7, 0.72, 18 - dy)
                introVs.TextTransparency = math.random(0, 10) / 100
                introVsGlow.TextTransparency = math.random(40, 68) / 100
                introVsGhost.TextTransparency = math.random(25, 58) / 100
                task.wait(math.random(2, 4) / 100)
            end
            introVs.Position = impactPos
            introVsGlow.Position = impactPos
            introVsGhost.Position = impactPos
            introVs.TextTransparency = 0
            introVsGlow.TextTransparency = 0.60
            introVsGhost.TextTransparency = 1
        end

        local glitchSlices = {}
        for i = 1, 12 do
            local slice = Instance.new("Frame")
            slice.Name = "GlitchSlice_" .. i
            slice.BorderSizePixel = 0
            slice.BackgroundColor3 = i % 3 == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            slice.BackgroundTransparency = 1
            slice.AnchorPoint = Vector2.new(0.5, 0.5)
            slice.Position = UDim2.fromScale(0.5, 0.5)
            slice.Size = UDim2.new(0.5, 0, 0, 2)
            slice.ZIndex = 1009
            slice.Parent = introLayer
            table.insert(glitchSlices, slice)
        end

        for i = 1, 22 do
            local spark = Instance.new("Frame")
            spark.Name = "IntroSpark_" .. i
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            spark.BackgroundTransparency = 1
            spark.BorderSizePixel = 0
            spark.Size = UDim2.new(0, 1 + (i % 3), 0, 1 + (i % 3))
            spark.Position = UDim2.fromScale((i * 0.173) % 1, 1.04)
            spark.ZIndex = 1004
            spark.Parent = introLayer
            local sparkCorner = Instance.new("UICorner")
            sparkCorner.CornerRadius = UDim.new(1, 0)
            sparkCorner.Parent = spark
            task.spawn(function()
                while spark.Parent do
                    spark.Position = UDim2.fromScale(math.random(), 1.04)
                    spark.BackgroundTransparency = 0.62 + math.random() * 0.20
                    local rise = TweenService:Create(spark, TweenInfo.new(2.4 + math.random() * 2.5, Enum.EasingStyle.Linear), {
                        Position = UDim2.fromScale(math.clamp(spark.Position.X.Scale + (math.random() - 0.5) * 0.18, 0, 1), -0.04),
                        BackgroundTransparency = 1
                    })
                    rise:Play()
                    rise.Completed:Wait()
                end
            end)
        end

        local function glitchBurst(strength, duration)
            local started = os.clock()
            while introLayer.Parent and os.clock() - started < duration do
                local x = math.random(-strength, strength)
                local y = math.random(-math.max(1, math.floor(strength * 0.35)), math.max(1, math.floor(strength * 0.35)))
                introTitle.Position = UDim2.new(0.5, x, 0.5, y)
                introTitleGlow.Position = UDim2.new(0.5, -x * 0.35, 0.5, -y)
                introGlitchBright.Position = UDim2.new(0.5, x + math.random(2, 7), 0.5, y)
                introGlitchDark.Position = UDim2.new(0.5, x - math.random(3, 9), 0.5, -y)
                introGlitchBright.TextTransparency = math.random(15, 48) / 100
                introGlitchDark.TextTransparency = math.random(30, 62) / 100
                introTitle.TextTransparency = math.random(0, 12) / 100
                introTitleGlow.TextTransparency = math.random(38, 68) / 100

                if math.random() > 0.35 then
                    local slice = glitchSlices[math.random(1, #glitchSlices)]
                    slice.Position = UDim2.new(0.5, math.random(-45, 45), 0.5, math.random(-42, 42))
                    slice.Size = UDim2.new(math.random(24, 88) / 100, 0, 0, math.random(1, 4))
                    slice.BackgroundTransparency = math.random(8, 45) / 100
                end
                task.wait(math.random(2, 5) / 100)
                for _, slice in ipairs(glitchSlices) do
                    slice.BackgroundTransparency = 1
                end
            end
            introTitle.Position = UDim2.fromScale(0.5, 0.5)
            introTitleGlow.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchBright.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchDark.Position = UDim2.fromScale(0.5, 0.5)
            introGlitchBright.TextTransparency = 1
            introGlitchDark.TextTransparency = 1
            introTitle.TextTransparency = 0
            introTitleGlow.TextTransparency = 0.58
        end

        task.spawn(function()
            local ok, err = xpcall(function()
            -- 1) Todo negro + música al ejecutar
            introLayer.BackgroundTransparency = 0
            introLayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            introImage.ImageTransparency = 1
            introShade.BackgroundTransparency = 1
            introVignette.ImageTransparency = 1
            for _, label in ipairs({introTitle, introTitleGlow, introGlitchBright, introGlitchDark, introVs, introVsGlow, introVsGhost}) do
                pcall(function()
                    label.TextTransparency = 1
                    label.TextStrokeTransparency = 1
                end)
            end
            startIntroMusic()
            task.wait(0.25)

            -- 2) Negro → transparente (se va abriendo)
            TweenService:Create(introLayer, TweenInfo.new(0.95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.55
            }):Play()
            TweenService:Create(introImage, TweenInfo.new(0.95, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.62,
                Size = UDim2.fromScale(1.0, 1.0)
            }):Play()
            task.wait(0.80)

            -- 3) (Sonido de motosierra eliminado)

            -- 4) MVP vs entra por los costados + sonido de espada (libera la espada)
            introTitle.Text = "MOYA DUELS V2"
            introTitleGlow.Text = "MOYA DUELS V2"
            introGlitchBright.Text = "MOYA DUELS V2"
            introGlitchDark.Text = "MOYA DUELS V2"
            introVs.Text = "vs"
            introVsGlow.Text = "vs"
            introVsGhost.Text = "vs"

            -- Sonido de espada eliminado

            -- MVP desde la izquierda
            for _, label in ipairs({introTitle, introTitleGlow, introGlitchBright, introGlitchDark}) do
                label.Position = UDim2.new(0.5, -220, 0.5, 0)
                label.TextTransparency = 1
                label.TextStrokeTransparency = 1
            end
            -- vs desde la derecha
            for _, label in ipairs({introVs, introVsGlow, introVsGhost}) do
                label.Position = UDim2.new(0.5, 220, 0.5, 40)
                label.TextTransparency = 1
                label.TextStrokeTransparency = 1
            end

            for _, label in ipairs({introTitle, introTitleGlow}) do
                TweenService:Create(label, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.fromScale(0.5, 0.5),
                    TextTransparency = (label == introTitleGlow) and 0.55 or 0,
                    TextStrokeTransparency = (label == introTitleGlow) and 0.4 or 0.15
                }):Play()
            end
            for _, label in ipairs({introVs, introVsGlow}) do
                TweenService:Create(label, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0.5, 40),
                    TextTransparency = (label == introVsGlow) and 0.55 or 0,
                    TextStrokeTransparency = (label == introVsGlow) and 0.4 or 0.15
                }):Play()
            end
            task.wait(0.50)

            -- Fondo de portada más visible
            TweenService:Create(introLayer, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(8, 0, 0),
                BackgroundTransparency = 0.28
            }):Play()
            TweenService:Create(introImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.40
            }):Play()
            TweenService:Create(introShade, TweenInfo.new(0.4), {BackgroundTransparency = 0.88}):Play()

            titleEntrance()
            glitchBurst(9, 0.18)
            task.wait(0.06)
            vsImpactGlitch()

            task.spawn(function()
                local offset = -1
                for _ = 1, 50 do
                    offset = offset + 0.035
                    if offset > 1 then offset = -1 end
                    introTitleGradient.Offset = Vector2.new(offset, 0)
                    task.wait(0.016)
                end
            end)

            TweenService:Create(introContent, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(1.02, 0, 0, 198)
            }):Play()
            task.wait(0.10)
            glitchBurst(10, 0.16)
            task.wait(0.08)

            -- Keep the finished intro visible with slow background motion until Skip or 1:50.
            task.spawn(function()
                while introLayer and introLayer.Parent and not introFinished do
                    local zoomIn = TweenService:Create(
                        introImage,
                        TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                        {Size = UDim2.fromScale(1.08, 1.08), Position = UDim2.fromScale(0.51, 0.49)}
                    )
                    zoomIn:Play()
                    zoomIn.Completed:Wait()
                    if not introLayer or not introLayer.Parent or introFinished then break end
                    local zoomOut = TweenService:Create(
                        introImage,
                        TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                        {Size = UDim2.fromScale(1.0, 1.0), Position = UDim2.fromScale(0.49, 0.51)}
                    )
                    zoomOut:Play()
                    zoomOut.Completed:Wait()
                end
            end)
            end, debug.traceback)
            if not ok then
                warn("[MVP Intro] Animation error: " .. tostring(err))
                finishIntro()
            end
        end)
        introDone.Event:Wait()
        introDone:Destroy()
        pcall(function()
            if introScreenGui and introScreenGui.Parent then introScreenGui:Destroy() end
        end)

    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

;(function()
local NS, CS, LS, LS2 = 31, 60, 15, 24.5

local laggerPhase = 0 -- 0=off, 1=lagger, 2=lagger carry

local State = {
	speedToggled = false, laggerToggled = false, autoBatToggled = false,
	speedProfile = "Normal",
	profileLaggerNormalSpeed = 40,
	profileLaggerCarrySpeed = 20,
	hittingCooldown = false, infJumpEnabled = false,
	antiRagdollEnabled = false, fpsBoostEnabled = false,
	antiLagEnabled = false,
	hitboxFollowerEnabled = false,
	guiVisible = true,
	noIntro = (((getgenv and getgenv()) or _G).__MVP_NO_INTRO_SAVED == true),
	introEnabled = (((getgenv and getgenv()) or _G).__MVP_NO_INTRO_SAVED ~= true), selectedIntroMusic = 1,
	isStealing = false, stealStartTime = nil, lastStealTick = 0,
	lastKnownHealth = 100,
	dropActive = false,
	dropBrainrotActive = false,
	autoLeftEnabled = false, autoRightEnabled = false,
	tpBatEnabled = false,
	unwalkEnabled = false,
	stretchRezEnabled = false, removeAccessoriesEnabled = false,
	darkModeEnabled = false, skyStyle = "Off",
	backgroundAssetId = "https://files.catbox.moe/lmxj8b.jpg",
	backgroundAssetIds = {
		"https://files.catbox.moe/lmxj8b.jpg",
		"https://files.catbox.moe/wdp55o.jpg",
	},
	imageChoiceVisuals = {},
}

local _anyKeyListening, uiLocked = false, false
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local autoSavePositions = function() end  -- no-op, MobilePanel removed
local mobilePanelStyle = "darkhub"
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local mobileButtonsByName = {}
local mobileButtonDefaultPositions = {}
local BTN_POSITIONS_DH = {
	Drop       = UDim2.new(1, -298, 1, -334),
	AutoLeft   = UDim2.new(1, -144, 1, -334),
	AutoBat    = UDim2.new(1, -298, 1, -270),
	AutoRight  = UDim2.new(1, -144, 1, -270),
	TPDown     = UDim2.new(1, -298, 1, -206),
	Speed      = UDim2.new(1, -144, 1, -206),
	Lagger     = UDim2.new(1, -144, 1, -142),
}

local KB = {
	AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
	AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
	Drop      = {kb = Enum.KeyCode.X,           gp = nil},
	TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
	AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
	AutoBatV2 = {kb = nil,                      gp = nil},
	TPBat     = {kb = nil,                      gp = nil},
	Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
	Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
	Lagger2   = {kb = nil,                      gp = nil},
	InstaReset= {kb = nil,                      gp = nil},
	GuiHide   = {kb = Enum.KeyCode.LeftControl, gp = nil},
}

State.kbMatch = function(entry, kc)
	return kc == entry.kb or (entry.gp and kc == entry.gp)
end

State.getProfileNormalSpeed = function()
	return State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS
end

State.getProfileCarrySpeed = function()
	return State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS
end

local AP = {
	L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
	R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

local Steal = {
	AutoStealEnabled = false, StealRadius = 10, StealDuration = 1.3,
	Data = {}, plotCache = {}, plotCacheTime = {},
	cachedPrompts = {}, promptCacheTime = 0,
}

local Conns = {
	autoSteal = nil, antiRag = nil,
	anchor = {}, progress = nil,
}

local safetyPositionIsValid
local startBatAimbot, stopBatAimbot
State.findAnyToolMob = function()
	local c=LP.Character
	if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
	local bp=LP:FindFirstChildOfClass("Backpack")
	if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
	return nil
end
State.getClosestPlayerMob2 = function()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil,math.huge end
	local cp,cd=nil,math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local tr=p.Character:FindFirstChild("HumanoidRootPart")
			local ph=p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health>0 then
				local d=(root.Position-tr.Position).Magnitude
				if d<cd then cd=d; cp=p end
			end
		end
	end
	return cp,cd
end
local MOB_SWING_COOLDOWN=0.08
State.tryHitBatMob = function()
	if State.hittingCooldown then return end; State.hittingCooldown=true
	pcall(function()
		local c=LP.Character; if not c then return end
		local hum2=c:FindFirstChildOfClass("Humanoid"); local tool=State.findAnyToolMob()
		if tool then
			if tool.Parent~=c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
			local remote=tool:FindFirstChildOfClass("RemoteEvent")
			if remote then pcall(function() remote:FireServer() end)
			else pcall(function() tool:Activate() end) end
		end
	end)
	task.delay(MOB_SWING_COOLDOWN,function() State.hittingCooldown=false end)
end
local _aimbotTarget = nil

State.findBat = function()
	local char = LP.Character; if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end

State.getClosestTarget = function()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then minDist = dist; closest = tRoot end
			end
		end
	end
	return closest
end

stopBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
	_aimbotTarget = nil
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
	State.hittingCooldown = false
	_autoBatTarget = nil
	_autoBatEquippedThisRun = false

	if State._hitboxFollower and State._hitboxFollower.pausedByBatAim then
		State._hitboxFollower.pausedByBatAim = false
		if State.hitboxFollowerEnabled and not State.tpBatEnabled then
			State._hitboxFollower.start()
		end
	end
end

startBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect() end
	_autoBatEquippedThisRun = false

	if State._hitboxFollower and State.hitboxFollowerEnabled then
		State._hitboxFollower.pausedByBatAim = true
		State._hitboxFollower.stop()
	end

	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end

	Conns.aimbot = RunService.RenderStepped:Connect(function(dt)
		if not State.autoBatToggled then return end
		local char = LP.Character; if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

		if not char:FindFirstChildOfClass("Tool") then
			local bat = State.findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local target = State.getClosestTarget()
		if not target then
			hum.AutoRotate = true
			return
		end
		_aimbotTarget = target

		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position

		local predictPos = targetPos + targetVel * 0.14
		predictPos = predictPos + target.CFrame.LookVector * 0.3

		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
		local chaseSpeed = 60 -- Velocidad fija requerida en 60

		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then
			yVel = math.max(yVel, 13)
		end
		yVel = math.clamp(yVel, -70, 110)

		local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

		local speed3 = targetVel.Magnitude
		local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local curCF  = root.CFrame
			local diffCF = curCF:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			local tiltSpeed = 42
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
				Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
			)
		end

		if State.autoSwingEnabled then
			local bat = char:FindFirstChildOfClass("Tool")
			if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
				pcall(function() bat:Activate() end)
			end
		end
	end)
end

State._hitboxFollower = State._hitboxFollower or {
    LOCK_RANGE = 150,
    enabled = false,
    conn = nil,
    pausedByBatAim = false,
}
State._hitboxFollower.pausedByBatAim = State._hitboxFollower.pausedByBatAim == true

function State._hitboxFollower.getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function State._hitboxFollower.tick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local target = State._hitboxFollower.getClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    local dist = (target.Position - root.Position).Magnitude
    if dist > State._hitboxFollower.LOCK_RANGE then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    if hum.AutoRotate then hum.AutoRotate = false end

    local targetVel = target.AssemblyLinearVelocity
    local speed = targetVel.Magnitude
    local predictTime = math.clamp(speed / 150, 0.05, 0.2)
    local predictedPos = target.Position + targetVel * predictTime

    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y, predictedPos.Z)
    local toPredict = flatTarget - root.Position

    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function State._hitboxFollower.start()
    State._hitboxFollower.enabled = true
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect()
    end
    State._hitboxFollower.conn = RunService.RenderStepped:Connect(function()
        if State._hitboxFollower.enabled and not State.autoBatToggled and not State.tpBatEnabled then
            State._hitboxFollower.tick()
        end
    end)
end

function State._hitboxFollower.stop()
    State._hitboxFollower.enabled = false
    if State._hitboxFollower.conn then
        State._hitboxFollower.conn:Disconnect()
        State._hitboxFollower.conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.hitboxFollowerEnabled and not State.autoBatToggled and not State.tpBatEnabled then
        State._hitboxFollower.stop()
        task.wait(0.2)
        State._hitboxFollower.start()
    elseif State.hitboxFollowerEnabled and (State.autoBatToggled or State.tpBatEnabled) then
        State._hitboxFollower.pausedByBatAim = State.autoBatToggled == true
        State._hitboxFollower.stop()
    end
end)
local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1

local h, hrp, speedLbl
local setAutoGrab, setAutoBat, setInfJump, setSuperJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual, setIntroToggle, setNoIntroToggle
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode, setSkyStyle, setSkySelectorVisual
local setMedusaCounter, setBatCounter, setInstaGrab, setAutoSwingVisual
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost, startAutoSteal, stopAutoSteal
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil

State._configLoading = false
State._configLoaded = false
State._saveAfterLoad = false
State._saveRequestId = 0
State._lastSaveError = nil
State._configDirty = false
State._positionDirty = false

State._resolveFileFunction = function(name)
	local direct = nil
	if name == "writefile" then direct = writefile
	elseif name == "readfile" then direct = readfile
	elseif name == "isfile" then direct = isfile
	elseif name == "delfile" then direct = delfile
	elseif name == "makefolder" then direct = makefolder
	elseif name == "isfolder" then direct = isfolder end
	if type(direct) == "function" then return direct end

	local environments = {}
	pcall(function()
		if getgenv then table.insert(environments, getgenv()) end
	end)
	pcall(function()
		if getrenv then table.insert(environments, getrenv()) end
	end)
	table.insert(environments, _G)

	for _, environment in ipairs(environments) do
		if type(environment) == "table" then
			local candidate = rawget(environment, name)
			if type(candidate) == "function" then return candidate end
			local synEnvironment = rawget(environment, "syn")
			if type(synEnvironment) == "table" then
				local synCandidate = rawget(synEnvironment, name)
				if type(synCandidate) == "function" then return synCandidate end
			end
		end
	end

	if type(syn) == "table" and type(syn[name]) == "function" then
		return syn[name]
	end
	return nil
end

State._safeWriteFile = function(path, data)
	local writer = State._resolveFileFunction("writefile")
	if type(writer) ~= "function" then
		return false, "writefile no disponible en este ejecutor"
	end
	local ok, err = pcall(writer, path, data)
	if not ok then return false, tostring(err) end
	return true
end

State._safeReadFile = function(path)
	local reader = State._resolveFileFunction("readfile")
	if type(reader) ~= "function" then
		return nil, "readfile no disponible en este ejecutor"
	end
	local ok, result = pcall(reader, path)
	if not ok or type(result) ~= "string" or result == "" then
		return nil, ok and "archivo vacío" or tostring(result)
	end
	return result
end

State._safeDeleteFile = function(path)
	local deleter = State._resolveFileFunction("delfile")
	if type(deleter) ~= "function" then return false end
	local ok = pcall(deleter, path)
	return ok
end

State._readValidJsonFile = function(path)
	local raw = State._safeReadFile(path)
	if type(raw) ~= "string" then return nil, nil end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok or type(decoded) ~= "table" then return nil, raw end
	return decoded, raw
end

State._writeVerifiedJson = function(path, encoded)
	local writeOk, writeErr = State._safeWriteFile(path, encoded)
	if not writeOk then return false, writeErr end
	local decoded, raw = State._readValidJsonFile(path)
	if type(decoded) ~= "table" or raw ~= encoded then
		return false, "la verificación del archivo falló: " .. tostring(path)
	end
	return true
end

State._atomicJsonSave = function(mainPath, backupPath, tempPath, encoded)
	local jsonOk, decoded = pcall(function() return HttpService:JSONDecode(encoded) end)
	if not jsonOk or type(decoded) ~= "table" then
		return false, "JSON inválido antes de guardar"
	end

	local currentData, currentRaw = State._readValidJsonFile(mainPath)

	if type(currentData) == "table" and currentRaw == encoded then
		return true
	end

	if type(currentData) == "table" and type(currentRaw) == "string" then
		local backupOk, backupErr = State._safeWriteFile(backupPath, currentRaw)
		if not backupOk then return false, backupErr end
	end

	local tempOk, tempErr = State._safeWriteFile(tempPath, encoded)
	if not tempOk then return false, tempErr end

	local mainOk, mainErr = State._safeWriteFile(mainPath, encoded)
	if not mainOk then return false, mainErr end

	if type(currentData) ~= "table" then
		State._safeWriteFile(backupPath, encoded)
	end

	return true
end

State.requestConfigSave = function()
	if State._configLoading or not State._configLoaded then
		State._saveAfterLoad = true
		State._configDirty = true
		return
	end
	if State._configLoadFailed then
		return
	end

	State._configDirty = true
	State._saveRequestId = State._saveRequestId + 1
	local requestId = State._saveRequestId

	task.delay(0.75, function()
		if requestId ~= State._saveRequestId or State._configLoading then return end
		if not State._configDirty then return end
		if saveConfig then
			local ok, result = pcall(saveConfig)
			if not ok then State._lastSaveError = tostring(result) end
		end
	end)
end
local normalBox, carryBox, laggerBox, laggerBox2, durValBtn, uiScaleBox
local modeValLbl, progressFill, progressPct, progressRadLbl
local radValBtn
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local autoTPDownEnabled, autoTPDownConn, autoTPDownHeight = false, nil, 20

local startBatAimbotV2, stopBatAimbotV2
local _autoBatLastScan = 0
local _autoBatTarget = nil
local _autoBatEquippedThisRun = false

local autoBatV2SetVisual, setAutoBatV2, setHideButtonsVisual, setAutoTPDownVisual

local btnInstaReset = nil

State.buttonsSizeValue = State.buttonsSizeValue or 50
State.buttonsShape = State.buttonsShape or "Normal"

function getMobileButtonPixels(value)
	value = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	return math.floor(36 + (value * 0.48) + 0.5)
end

function normalizeMobileButtonsShape(shape)
	shape = tostring(shape or "Normal")
	if shape == "Circle" or shape == "Normal" or shape == "Square" or shape == "Rectangle" then
		return shape
	end
	return "Normal"
end

function applyShapeToMobileButton(button)
	if not button or not button.Parent then return end

	local pixels = getMobileButtonPixels(State.buttonsSizeValue)
	local textPixels = math.clamp(math.floor(8 + State.buttonsSizeValue * 0.07 + 0.5), 8, 15)
	local shape = normalizeMobileButtonsShape(State.buttonsShape)
	local width, height = pixels, pixels
	local radius = UDim.new(0, math.clamp(math.floor(pixels * 0.30 + 0.5), 8, math.floor(pixels / 2)))

	if shape == "Circle" then
		radius = UDim.new(1, 0)
	elseif shape == "Square" then
		radius = UDim.new(0, 0)
	elseif shape == "Rectangle" then
		width = math.floor(pixels * 1.55 + 0.5)
		height = math.max(28, math.floor(pixels * 0.75 + 0.5))
		radius = UDim.new(0, math.max(5, math.floor(height * 0.18 + 0.5)))
	end

	button.Size = UDim2.new(0, width, 0, height)
	button.TextSize = textPixels

	local corner = button:FindFirstChild("ButtonShapeCorner")
	if not corner or not corner:IsA("UICorner") then
		corner = button:FindFirstChildOfClass("UICorner")
	end
	if not corner then
		corner = Instance.new("UICorner")
		corner.Parent = button
	end
	corner.Name = "ButtonShapeCorner"
	corner.CornerRadius = radius
end

function applyMobileButtonsShape(shape)
	State.buttonsShape = normalizeMobileButtonsShape(shape)
	for _, mobileBtn in pairs(mobileButtonsByName) do
		applyShapeToMobileButton(mobileBtn)
	end
	for _, specialBtn in ipairs({btnBatV2, btnInstaReset}) do
		applyShapeToMobileButton(specialBtn)
	end
	return State.buttonsShape
end

function applyMobileButtonsSize(value)
	State.buttonsSizeValue = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	applyMobileButtonsShape(State.buttonsShape)
end

local MedusaConfig = {
	Enabled = false,
	Radius = 15,
	Delay = 0.15,
	LastUsed = 0,
	RadiusPart = nil
}

local SAFETY_VOID_MARGIN = 18
local SAFETY_MAX_FLOOR_RAY = 4000
local safetyLastGroundedCFrame = nil
local safetyRestoring = false

State.safetyVoidY = function()
	local ok, value = pcall(function() return workspace.FallenPartsDestroyHeight end)
	if ok and type(value) == "number" then return value end
	return -500
end

State.safetyFiniteNumber = function(value)
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

safetyPositionIsValid = function(position)
	return typeof(position) == "Vector3"
		and State.safetyFiniteNumber(position.X)
		and State.safetyFiniteNumber(position.Y)
		and State.safetyFiniteNumber(position.Z)
		and position.Y > State.safetyVoidY() + SAFETY_VOID_MARGIN
end

State.safetyCharacterParts = function()
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or humanoid.Health <= 0 or not root then
		return nil, nil, nil
	end
	return character, humanoid, root
end

State.safetyFloorPosition = function(root, character)
	if not root or not character or not safetyPositionIsValid(root.Position) then return nil end

	local ignore = {character}
	if MedusaConfig and MedusaConfig.RadiusPart then
		table.insert(ignore, MedusaConfig.RadiusPart)
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local offset = (humanoid and humanoid.HipHeight or 2) + (root.Size.Y / 2) + 0.05
	local origin = root.Position + Vector3.new(0, 5, 0)
	local distanceToVoid = math.max(100, origin.Y - State.safetyVoidY() + 50)
	local rayDistance = math.min(SAFETY_MAX_FLOOR_RAY, distanceToVoid)
	local hitPosition = nil

	pcall(function()
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = ignore
		params.FilterType = Enum.RaycastFilterType.Exclude
		pcall(function() params.RespectCanCollide = true end)
		local result = workspace:Raycast(origin, Vector3.new(0, -rayDistance, 0), params)
		if result and result.Instance and result.Position then
			hitPosition = result.Position
		end
	end)

	if not hitPosition then
		pcall(function()
			local ray = Ray.new(origin, Vector3.new(0, -rayDistance, 0))
			local part, position = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
			if part and position then hitPosition = position end
		end)
	end

	if not hitPosition then return nil end
	local landing = Vector3.new(root.Position.X, hitPosition.Y + offset, root.Position.Z)
	if not safetyPositionIsValid(landing) then return nil end
	return landing
end

State.safetyTeleport = function(root, humanoid, destination, preserveYaw)
	if not root or not root.Parent or not humanoid or humanoid.Health <= 0 then return false end
	if not safetyPositionIsValid(destination) then return false end

	local yaw = 0
	if preserveYaw ~= false then
		local _, currentYaw, _ = root.CFrame:ToOrientation()
		yaw = currentYaw
	end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.CFrame = CFrame.new(destination) * CFrame.Angles(0, yaw, 0)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	pcall(function() humanoid.PlatformStand = false end)
	return true
end

State.safetyTeleportToFloor = function(character, humanoid, root)
	local landing = State.safetyFloorPosition(root, character)
	if not landing then
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		return false
	end
	return State.safetyTeleport(root, humanoid, landing, true)
end

RunService.Heartbeat:Connect(function()
	local character, humanoid, root = State.safetyCharacterParts()
	if not character then return end

	if safetyPositionIsValid(root.Position)
		and humanoid.FloorMaterial ~= Enum.Material.Air
		and root.AssemblyLinearVelocity.Magnitude < 180 then
		safetyLastGroundedCFrame = root.CFrame
	end

	local riskyMovement = State.dropActive
		or State.dropBrainrotActive
		or autoTPDownEnabled
		or State.tpBatEnabled
		or State.autoBatToggled
		or State.autoBatV2Enabled

	if riskyMovement and not safetyPositionIsValid(root.Position) and not safetyRestoring then
		safetyRestoring = true
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		if safetyLastGroundedCFrame and safetyPositionIsValid(safetyLastGroundedCFrame.Position) then
			root.CFrame = safetyLastGroundedCFrame + Vector3.new(0, 2, 0)
		end
		task.defer(function() safetyRestoring = false end)
	end
end)

State.showDiscordInProgressBar = function()
	if not progressPct or not progressFill then return end

	local originalText = progressPct.Text
	local originalColor = progressPct.TextColor3
	local originalSize = progressPct.TextSize
	local originalAlign = progressPct.TextXAlignment

	progressPct.Text = "MOYA DUELS V2"
	progressPct.TextColor3 = Color3.fromRGB(200, 0, 0) -- Cambiado a Rosa
	progressPct.TextSize = 13
	progressPct.TextXAlignment = Enum.TextXAlignment.Center
	progressPct.ZIndex = 12

	if progressRadLbl then progressRadLbl.Visible = false end

	task.delay(4, function()
		if progressPct then
			progressPct.Text = originalText or "0%"
			progressPct.TextColor3 = originalColor or Color3.fromRGB(170, 0, 0) -- Sigue siendo Rosa
			progressPct.TextSize = originalSize or 11
			progressPct.TextXAlignment = originalAlign or Enum.TextXAlignment.Left
			progressPct.ZIndex = 5
		end
		if progressRadLbl then progressRadLbl.Visible = true end
	end)
end

State.stopAutoLeft = function()
	if alConn then alConn:Disconnect(); alConn = nil end
	alPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

State.stopAutoRight = function()
	if arConn then arConn:Disconnect(); arConn = nil end
	arPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

State.startAutoLeft = function()
	if alConn then alConn:Disconnect() end
	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not State.autoLeftEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = State.getProfileNormalSpeed()
		if alPhase == 1 then
			local tgt = Vector3.new(AP.L1.X, hrp2.Position.Y, AP.L1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.L1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP.L2.X, hrp2.Position.Y, AP.L2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoLeftEnabled = false
				if alConn then alConn:Disconnect(); alConn = nil end
				alPhase = 1
				if autoLeftSetVisual then autoLeftSetVisual(false) end
				if (AP.L_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.L_FACE.X, hrp2.Position.Y, AP.L_FACE.Z))
				end
				return
			end
			local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

State.startAutoRight = function()
	if arConn then arConn:Disconnect() end
	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not State.autoRightEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = State.getProfileNormalSpeed()
		if arPhase == 1 then
			local tgt = Vector3.new(AP.R1.X, hrp2.Position.Y, AP.R1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.R1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP.R2.X, hrp2.Position.Y, AP.R2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoRightEnabled = false
				if arConn then arConn:Disconnect(); arConn = nil end
				arPhase = 1
				if autoRightSetVisual then autoRightSetVisual(false) end
				if (AP.R_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.R_FACE.X, hrp2.Position.Y, AP.R_FACE.Z))
				end
				return
			end
			local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

local DROP_ASCEND_DURATION = 0.25
local DROP_ASCEND_SPEED = 240

State.runDrop = function()
        if State.dropActive then return end
        local char, hum, root = State.safetyCharacterParts()
        if not char then return end
        State.dropActive = true; local t0 = tick(); local dc
        dc = RunService.Heartbeat:Connect(function()
                local currentChar = LP.Character
                local r = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not r or not currentHum or currentHum.Health <= 0 then
                        if dc then dc:Disconnect() end
                        State.dropActive = false
                        return
                end
                if tick() - t0 >= DROP_ASCEND_DURATION then
                        if dc then dc:Disconnect() end
                        r.AssemblyLinearVelocity = Vector3.zero
                        r.AssemblyAngularVelocity = Vector3.zero
                        State.safetyTeleportToFloor(currentChar, currentHum, r)
                        State.dropActive = false
                        return
                end
                r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
        end)
end
local _tpDownActive = false
State.runTPDown = function()
	if _tpDownActive then return end
	_tpDownActive = true
	pcall(function()
		local character, humanoid, root = State.safetyCharacterParts()
		if character then State.safetyTeleportToFloor(character, humanoid, root) end
	end)
	_tpDownActive = false
end

State._tpBatHittingCooldown = false
State._tpBatHRP = nil
State._tpBatH = nil

State._tpBatGetTool = function()
	local char = LP.Character
	if not char then return nil end

	local bat = char:FindFirstChild("Bat")
	if bat then return bat end

	local backpack = LP:FindFirstChild("Backpack")
	if backpack then
		bat = backpack:FindFirstChild("Bat")
		if bat then
			bat.Parent = char
			return bat
		end
	end

	return nil
end

State._tpBatTryHit = function()
	if State._tpBatHittingCooldown then return end
	State._tpBatHittingCooldown = true

	pcall(function()
		local bat = State._tpBatGetTool()
		if bat then
			bat:Activate()

			local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
			if remoteEvent then
				remoteEvent:FireServer()
			end

			local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")
			if remoteFunction then
				pcall(function()
					remoteFunction:InvokeServer()
				end)
			end
		end
	end)

	task.delay(0.08, function()
		State._tpBatHittingCooldown = false
	end)
end

State._tpBatClosest = function()
	if not State._tpBatHRP then return nil, math.huge end

	local closest, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LP and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local distance = (State._tpBatHRP.Position - targetRoot.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closest = player
				end
			end
		end
	end

	return closest, closestDistance
end

RunService.Heartbeat:Connect(function()
	if not State.tpBatEnabled then return end

	if not State._tpBatH or not State._tpBatHRP
		or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
		local char = LP.Character
		if char then
			State._tpBatH = char:FindFirstChildOfClass("Humanoid")
			State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
		end
		if not State._tpBatH or not State._tpBatHRP then return end
	end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
				end)
			end

			local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
			if (State._tpBatHRP.Position - targetPosition).Magnitude > 5 then
				State._tpBatHRP.CFrame = CFrame.new(targetPosition)
			end

			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end

			State._tpBatTryHit()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if not State.tpBatEnabled then return end
	if not State._tpBatH or not State._tpBatHRP then return end
	if not State._tpBatH.Parent or not State._tpBatHRP.Parent then return end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end
			State._tpBatTryHit()
		end
	end
end)

LP.CharacterAdded:Connect(function(character)
	task.wait(0.2)
	State._tpBatH = character:FindFirstChildOfClass("Humanoid")
	State._tpBatHRP = character:FindFirstChild("HumanoidRootPart")
end)

if LP.Character then
	task.spawn(function()
		task.wait(0.2)
		State._tpBatH = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		State._tpBatHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	end)
end

State.startAutoTPDown = function()
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
	autoTPDownConn = task.spawn(function()
		while autoTPDownEnabled do
			task.wait(0.1)
			pcall(function()
				local char = LP.Character; if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
				local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
				if hum.FloorMaterial ~= Enum.Material.Air then return end
				if root.Position.Y < autoTPDownHeight then return end
				State.safetyTeleportToFloor(char, hum, root)
			end)
		end
	end)
end

State.stopAutoTPDown = function()
	autoTPDownEnabled = false
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end

-- Use the normal character reset path instead of repeatedly firing a custom game RemoteEvent.
State.cursedInstaReset = function()
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function() humanoid.Health = 0 end)
end

for _, name in pairs({"MOYADUELS_V2_GUI", "FEARV2GUI"}) do
	local old = game:GetService("CoreGui"):FindFirstChild(name)
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
end

State.makeDraggable = function(frame)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	local moved = false
	frame.Active = true

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	frame.InputBegan:Connect(function(inp)
		if uiLocked then return end
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragInput = inp.UserInputType == Enum.UserInputType.Touch and inp or nil
			dragStart = inp.Position
			startPos = frame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then finishDrag() end
			end)
		end
	end)

	frame.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)

	UIS.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = inp.Position - dragStart
			if math.abs(d.X) > 1 or math.abs(d.Y) > 1 then moved = true end
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
		end
	end)

	UIS.InputEnded:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "MOYADUELS_V2_GUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
	gui.Parent = LP:WaitForChild("PlayerGui")
end

local _C={
	[1]=Color3.fromRGB(8, 0, 0),
	[2]=Color3.fromRGB(14, 0, 0),
	[3]=Color3.fromRGB(28, 0, 0),
	[4]=Color3.fromRGB(70, 8, 8),
	[5]=Color3.fromRGB(50, 130, 220),   -- BORDER azul (líneas de opciones)
	[6]=Color3.fromRGB(80, 165, 255),   -- BORDER2 azul
	[7]=Color3.fromRGB(255, 255, 255),  -- WHITE real (textos en blanco)
	[8]=Color3.fromRGB(235, 235, 235), -- DIM texto secundario blanco
	[9]=Color3.fromRGB(18, 0, 0),
	[10]=Color3.fromRGB(12, 0, 0),
}
local BG=_C[1];local SIDEBAR_BG=_C[2];local CARD_BG=_C[3];local CARD_HOV=_C[4]
local BORDER=_C[5];local BORDER2=_C[6];local WHITE=_C[7];local DIM=_C[8]
local DIM2=_C[9];local KB_BG=_C[10];local INPUT_BG=_C[10]
local LABEL_TEXT = Color3.fromRGB(255, 255, 255)  -- Blanco textos de opciones
local LABEL_SUB  = Color3.fromRGB(230, 230, 230) -- Blanco suave subtítulos


State.makeDraggableY = function(guiObject)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    guiObject.Active = true

    local function finishDrag()
        if not dragging then return end
        dragging = false
        if moved then
            moved = false
            if State.requestPositionSave then State.requestPositionSave() end
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then finishDrag() end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.Y) > 1 then moved = true end
            local newY = startPos.Y.Offset + delta.Y
            local visibleOffset = 375

            local frameHeight = guiObject.AbsoluteSize.Y
            local screenHeight = guiObject.Parent.AbsoluteSize.Y

            local minY = visibleOffset - frameHeight
            local maxY = screenHeight - visibleOffset
            local clampedY = math.clamp(newY, minY, maxY)

            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, clampedY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            finishDrag()
        end
    end)
end

local W, H, SW = 520, 410, 0
local CORNER = 18

local uiScaleValue = 80
local mainUIScale = nil
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 56, 0, 12)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Visible = false
main.BackgroundTransparency = 0 -- MODIFICADO: Removida transparencia para que se mantenga sólido tal cual

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, CORNER)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(174, 92, 255) -- animated purple premium frame
mainStroke.Thickness = 1.6
mainStroke.Transparency = 0.08

local premiumInnerBorder = Instance.new("Frame", main)
premiumInnerBorder.Name = "PremiumInnerBorder"
premiumInnerBorder.Size = UDim2.new(1, -8, 1, -8)
premiumInnerBorder.Position = UDim2.new(0, 4, 0, 4)
premiumInnerBorder.BackgroundTransparency = 1
premiumInnerBorder.BorderSizePixel = 0
premiumInnerBorder.ZIndex = 2
local premiumInnerCorner = Instance.new("UICorner", premiumInnerBorder)
premiumInnerCorner.CornerRadius = UDim.new(0, math.max(CORNER - 4, 0))
local premiumInnerStroke = Instance.new("UIStroke", premiumInnerBorder)
premiumInnerStroke.Color = Color3.fromRGB(115, 65, 220)
premiumInnerStroke.Thickness = 1
premiumInnerStroke.Transparency = 0.48

mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = 0.86

State.menuBackgroundAsset = nil
State.menuBackgroundThumbs = {}
State.fullUIBackground = Instance.new("ImageLabel", main)
State.fullUIBackground.Name = "FullUIBackground"
State.fullUIBackground.Size = UDim2.new(1, -2, 1, -2)
State.fullUIBackground.Position = UDim2.new(0, 1, 0, 1)
State.fullUIBackground.BackgroundTransparency = 1
State.fullUIBackground.BorderSizePixel = 0
-- Do not show the old background image while the requested Catbox image loads.
State.fullUIBackground.Image = ""
State.fullUIBackground.ImageTransparency = 0
State.fullUIBackground.ScaleType = Enum.ScaleType.Crop
State.fullUIBackground.ImageColor3 = Color3.fromRGB(255, 255, 255)
State.fullUIBackground.ZIndex = 1
Instance.new("UICorner", State.fullUIBackground).CornerRadius = UDim.new(0, math.max(CORNER - 1, 0))

-- Download both selectable Catbox menu backgrounds independently. If one fails,
-- the menu continues normally and the other image can still be selected.
State.menuBackgroundAssets = State.menuBackgroundAssets or {}
task.spawn(function()
    local imageOptions = {
        {url = "https://files.catbox.moe/lmxj8b.jpg", file = "moya_duels_menu_background_1.jpg"},
        {url = "https://files.catbox.moe/wdp55o.jpg", file = "moya_duels_menu_background_2.jpg"},
    }
    local function validImage(data)
        return type(data) == "string" and #data > 1000 and (
            (data:byte(1) == 255 and data:byte(2) == 216)
            or data:sub(1, 4) == string.char(137) .. "PNG"
            or data:sub(1, 4) == "RIFF"
        )
    end
    for index, option in ipairs(imageOptions) do
        local assetId
        local assetFn = getcustomasset or getsynasset
        if type(assetFn) ~= "function" and State._resolveFileFunction then
            assetFn = State._resolveFileFunction("getcustomasset") or State._resolveFileFunction("getsynasset")
        end
        for attempt = 1, 3 do
            pcall(function()
                local fileCheck = State._resolveFileFunction and State._resolveFileFunction("isfile") or isfile
                if type(fileCheck) == "function" and fileCheck(option.file) and type(assetFn) == "function" then
                    assetId = assetFn(option.file)
                end
            end)
            if type(assetId) == "string" and assetId ~= "" then break end
            local data
            pcall(function()
                local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
                if type(req) ~= "function" and State._resolveFileFunction then
                    req = State._resolveFileFunction("request") or State._resolveFileFunction("http_request")
                end
                if type(req) == "function" then
                    local response = req({Url = option.url, Method = "GET", Headers = {
                        ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "image/jpeg,*/*"
                    }})
                    if type(response) == "table" and (response.StatusCode == nil or response.StatusCode == 200) then
                        data = response.Body or response.body
                    end
                end
            end)
            if not validImage(data) then pcall(function() data = game:HttpGet(option.url, true) end) end
            if validImage(data) then
                pcall(function()
                    local writer = State._resolveFileFunction and State._resolveFileFunction("writefile") or writefile
                    if type(writer) == "function" then writer(option.file, data) end
                end)
                if type(assetFn) == "function" then pcall(function() assetId = assetFn(option.file) end) end
            end
            if type(assetId) == "string" and assetId ~= "" then break end
            task.wait(attempt)
        end
        if type(assetId) == "string" and assetId ~= "" then
            State.menuBackgroundAssets[option.url] = assetId
            if State.menuBackgroundThumbs[index] and State.menuBackgroundThumbs[index].Parent then
                State.menuBackgroundThumbs[index].Image = assetId
            end
        else
            warn("[MOYA DUELS V2] Could not load menu background option " .. tostring(index) .. "; continuing")
        end
    end
    if State.applyBackgroundImage then State.applyBackgroundImage(State.backgroundAssetId, false) end
end)

-- Load and play the menu background track independently of the intro track.
-- Any download/playback failure is isolated and must never stop the script.
task.spawn(function()
    task.wait(1)
    local soundService = game:GetService("SoundService")
    local existingSound = soundService:FindFirstChild("MOYADuelsAmbientMusic")
    if existingSound and existingSound.IsPlaying then return end
    if existingSound then pcall(function() existingSound:Destroy() end) end
    local fileName = "moya_duels_ambient.mp3"
    local url = "https://files.catbox.moe/y85mq4.mp3"
    local assetFn = getcustomasset or getsynasset
    local function validMp3(data)
        if type(data) ~= "string" or #data < 10000 then return false end
        local header = data:sub(1, 64):lower()
        return not header:find("<html", 1, true)
            and not header:find("<!doctype", 1, true)
            and (data:sub(1, 3) == "ID3" or data:byte(1) == 0xFF or #data > 100000)
    end
    local assetId
    pcall(function()
        if type(isfile) == "function" and isfile(fileName) and type(assetFn) == "function" then
            assetId = assetFn(fileName)
        end
    end)
    if not assetId then
        local data
        pcall(function()
            local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
            if type(req) == "function" then
                local response = req({Url = url, Method = "GET", Headers = {
                    ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,*/*"
                }})
                if type(response) == "table" then data = response.Body or response.body end
            end
        end)
        if not validMp3(data) then pcall(function() data = game:HttpGet(url, true) end) end
        if validMp3(data) then
            pcall(function() if type(writefile) == "function" then writefile(fileName, data) end end)
            if type(assetFn) == "function" then pcall(function() assetId = assetFn(fileName) end) end
        end
    end
    if type(assetId) == "string" and assetId ~= "" and not soundService:FindFirstChild("MOYADuelsAmbientMusic") then
        local ambient = Instance.new("Sound")
        ambient.Name = "MOYADuelsAmbientMusic"
        ambient.SoundId = assetId
        ambient.Volume = 0.22
        ambient.Looped = true
        ambient.Parent = soundService
        pcall(function() ambient:Play() end)
    elseif not assetId then
        warn("[MOYA DUELS V2] Could not download background music")
    end
end)

-- Animated rain overlay for the main menu, separate from the intro rain.
do
local menuRain = Instance.new("Frame", main)
menuRain.Name = "MenuRainOverlay"
menuRain.BackgroundTransparency = 1
menuRain.BorderSizePixel = 0
menuRain.Size = UDim2.fromScale(1, 1)
menuRain.ClipsDescendants = true
menuRain.ZIndex = 3
for i = 1, 34 do
    local drop = Instance.new("Frame", menuRain)
    drop.Name = "MenuRainDrop" .. i
    drop.AnchorPoint = Vector2.new(0.5, 0.5)
    drop.Size = UDim2.new(0, 1, 0, math.random(9, 20))
    drop.Position = UDim2.new(math.random(), 0, math.random(), 0)
    drop.Rotation = 9
    drop.BackgroundColor3 = Color3.fromRGB(205, 220, 235)
    drop.BackgroundTransparency = 0.60 + math.random() * 0.25
    drop.BorderSizePixel = 0
    drop.ZIndex = 3
    task.spawn(function()
        while drop.Parent do
            local duration = 0.65 + math.random() * 0.85
            drop.Position = UDim2.new(math.random(), 0, -0.08, 0)
            TweenService:Create(drop, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(drop.Position.X.Scale, 0, 1.08, 0)
            }):Play()
            task.wait(duration)
        end
    end)
end
end -- menu rain local scope

State.applyBackgroundImage = function(assetId, shouldSave)
	assetId = tostring(assetId or "")
	local valid = false
	for _, id in ipairs(State.backgroundAssetIds) do
		if id == assetId then valid = true; break end
	end
	if not valid then assetId = State.backgroundAssetIds[1] end

	State.backgroundAssetId = assetId
	local chosenAsset = (State.menuBackgroundAssets and State.menuBackgroundAssets[assetId]) or ""
	if State.fullUIBackground and State.fullUIBackground.Parent then
		State.fullUIBackground.Image = chosenAsset
	end

	for id, visual in pairs(State.imageChoiceVisuals) do
		local selected = id == assetId
		if visual.stroke then
			visual.stroke.Color = selected and WHITE or BORDER
			visual.stroke.Thickness = selected and 2.2 or 1
		end
		if visual.badge then
			visual.badge.Text = selected and ("✓ " .. tostring(visual.index)) or tostring(visual.index)
			visual.badge.BackgroundColor3 = selected and WHITE or Color3.fromRGB(16, 0, 0)
			visual.badge.TextColor3 = selected and BG or WHITE
		end
	end

	if shouldSave and State.requestConfigSave then
		State.requestConfigSave()
	end
end

local topbar = Instance.new("Frame", main)
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = SIDEBAR_BG
topbar.BackgroundTransparency = 0.15
topbar.BorderSizePixel = 0
topbar.ZIndex = 10
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, CORNER)
local topPatch = Instance.new("Frame", topbar)
topPatch.Size = UDim2.new(1, 0, 0, CORNER)
topPatch.Position = UDim2.new(0, 0, 1, -CORNER)
topPatch.BackgroundColor3 = SIDEBAR_BG
topPatch.BackgroundTransparency = 0.15
topPatch.BorderSizePixel = 0
topPatch.ZIndex = 9
local topDiv = Instance.new("Frame", topbar)
topDiv.Size = UDim2.new(1, 0, 0, 1)
topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = BORDER
topDiv.BorderSizePixel = 0
topDiv.ZIndex = 11

local premiumTopLine = Instance.new("Frame", topbar)
premiumTopLine.Name = "PremiumTopLine"
premiumTopLine.Size = UDim2.new(1, -28, 0, 2)
premiumTopLine.Position = UDim2.new(0, 14, 0, 3)
premiumTopLine.BackgroundColor3 = WHITE
premiumTopLine.BorderSizePixel = 0
premiumTopLine.ZIndex = 14
local premiumTopCorner = Instance.new("UICorner", premiumTopLine)
premiumTopCorner.CornerRadius = UDim.new(1, 0)
local premiumTopGradient = Instance.new("UIGradient", premiumTopLine)
premiumTopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 45, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 0, 0))
})
premiumTopGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.55)
})

local titleLbl = Instance.new("TextLabel", topbar)
titleLbl.Size = UDim2.new(0, 190, 1, 0)
titleLbl.Position = UDim2.new(0, 17, 0, -3)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "MOYA DUELS V2"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12

local verLbl = Instance.new("TextLabel", topbar)
verLbl.Size = UDim2.new(0, 240, 0, 14)
verLbl.Position = UDim2.new(0, 18, 0, 28)
verLbl.BackgroundTransparency = 1
verLbl.Text = "MOYA DUELS PLUS Script"
verLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 8
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 12

task.spawn(function()
	local badge = Instance.new("Frame")
	badge.Name = "UserBadge"
	badge.Size = UDim2.new(0, 150, 0, 34)
	badge.Position = UDim2.new(1, -200, 0.5, -17)
	badge.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	badge.BackgroundTransparency = 0.25
	badge.BorderSizePixel = 0
	badge.ZIndex = 13
	badge.Parent = topbar
	Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", badge)
	st.Color = Color3.fromRGB(255, 255, 255)
	st.Thickness = 1
	st.Transparency = 0.55

	local av = Instance.new("ImageLabel", badge)
	av.Name = "Avatar"
	av.Size = UDim2.new(0, 28, 0, 28)
	av.Position = UDim2.new(0, 3, 0.5, -14)
	av.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	av.BorderSizePixel = 0
	av.ZIndex = 14
	av.ScaleType = Enum.ScaleType.Crop
	Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
	local avs = Instance.new("UIStroke", av)
	avs.Color = Color3.fromRGB(255, 255, 255)
	avs.Thickness = 1
	avs.Transparency = 0.4

	local nm = Instance.new("TextLabel", badge)
	nm.Name = "UserName"
	nm.Size = UDim2.new(1, -38, 1, 0)
	nm.Position = UDim2.new(0, 34, 0, 0)
	nm.BackgroundTransparency = 1
	nm.Text = tostring(LP.DisplayName or LP.Name or "Player")
	nm.TextColor3 = Color3.fromRGB(255, 255, 255)
	nm.Font = Enum.Font.GothamBold
	nm.TextSize = 11
	nm.TextXAlignment = Enum.TextXAlignment.Left
	nm.TextTruncate = Enum.TextTruncate.AtEnd
	nm.ZIndex = 14

	local uid = LP.UserId
	local pls = game:GetService("Players")
	local ok, url = pcall(function()
		return pls:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end)
	if ok and type(url) == "string" and url ~= "" then
		av.Image = url
	else
		av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=150&h=150"
	end
end)

local minBtn = Instance.new("TextButton", topbar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = KB_BG
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = WHITE -- Rojo
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.ZIndex = 13
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", minBtn).Color = BORDER
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

do
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	local moved = false

	local dragZone = Instance.new("TextButton", topbar)
	dragZone.Name = "TopbarDragZone"
	dragZone.Size = UDim2.new(1, -210, 1, 0)
	dragZone.Position = UDim2.new(0, 0, 0, 0)
	dragZone.BackgroundTransparency = 1
	dragZone.BorderSizePixel = 0
	dragZone.Text = ""
	dragZone.AutoButtonColor = false
	dragZone.Active = true
	dragZone.ZIndex = 13

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	dragZone.InputBegan:Connect(function(input)
		if uiLocked then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end

		dragging = true
		moved = false
		dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				finishDrag()
			end
		end)
	end)

	dragZone.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if uiLocked then finishDrag(); return end
		if not dragging then return end
		if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

		local delta = input.Position - dragStart

		if math.abs(delta.X) > 1 or math.abs(delta.Y) > 1 then moved = true end
		main.Position = UDim2.new(
			startPosition.X.Scale, startPosition.X.Offset + delta.X,
			startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
		)
	end)

	UIS.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end

local TAB_BAR_H = 46
local SIDEBAR_W = 126
local sidebar = Instance.new("Frame", main)
sidebar.Name = "TabBar"
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -58)
sidebar.Position = UDim2.new(0, 8, 0, 52)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BackgroundTransparency = 0.12
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5
sidebar.ClipsDescendants = false
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
local sidebarStroke = Instance.new("UIStroke", sidebar)
sidebarStroke.Color = Color3.fromRGB(170, 90, 245)
sidebarStroke.Thickness = 1
sidebarStroke.Transparency = 0.18

local content = Instance.new("Frame", main)
content.Name = "ContentArea"
content.Size = UDim2.new(1, -(SIDEBAR_W + 20), 1, -58)
content.Position = UDim2.new(0, SIDEBAR_W + 14, 0, 52)
content.BackgroundColor3 = BG
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 100

local mini = Instance.new("TextButton", gui)
mini.Name = "MOYADUELS_V2_Mini"
mini.Size = UDim2.new(0, 150, 0, 32)
mini.Position = UDim2.new(0, 20, 0, 70)
mini.BackgroundColor3 = BG
mini.BorderSizePixel = 0
mini.Text = "MOYA DUELS V2"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.Font = Enum.Font.GothamBold
mini.TextSize = 11
mini.TextXAlignment = Enum.TextXAlignment.Center
mini.ZIndex = 20
mini.Visible = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 16)
local miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = Color3.fromRGB(185, 105, 255)
miniStroke.Thickness = 1.5
miniStroke.Transparency = 0.25

State.makeDraggable(mini)
mini.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

State.showGui = function()
    main.Visible = true
    mini.Visible = false
    State.guiVisible = true

    main.BackgroundTransparency = 0 -- MODIFICADO: Mantenido en 0 sólido
    mainUIScale.Scale = 0.85

    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = uiScaleValue / 100}):Play()
end

State.hideGui = function()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85}):Play()

    task.delay(0.2, function()
        main.Visible = false
        mini.Visible = true
        State.guiVisible = false
    end)
end

minBtn.MouseButton1Click:Connect(State.hideGui)
mini.MouseButton1Click:Connect(State.showGui)
mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=CARD_HOV}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=BG}):Play() end)

local tabs = {}
local tabPages = {}
local activeTabName = nil
local tabDefs = {
	{name="speed y aimbot"},
	{name="mechanics y movement"},
	{name="performance y settings"},
	{name="musica"},
}
local switchTab
local pageLOs = {}

local tabListFrame = Instance.new("Frame", sidebar)
tabListFrame.Size = UDim2.new(1, 0, 1, 0)
tabListFrame.Position = UDim2.new(0, 0, 0, 0)
tabListFrame.BackgroundTransparency = 1
tabListFrame.BorderSizePixel = 0
tabListFrame.ZIndex = 6

local tabLL = Instance.new("UIListLayout", tabListFrame)
tabLL.FillDirection = Enum.FillDirection.Vertical
tabLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLL.VerticalAlignment = Enum.VerticalAlignment.Top
tabLL.SortOrder = Enum.SortOrder.LayoutOrder
tabLL.Padding = UDim.new(0, 7)
local tabPad = Instance.new("UIPadding", tabListFrame)
tabPad.PaddingTop = UDim.new(0, 10)
tabPad.PaddingLeft = UDim.new(0, 5)
tabPad.PaddingRight = UDim.new(0, 5)

local TAB_ACCENTS = {
    ["speed y aimbot"] = Color3.fromRGB(185, 95, 255),
    ["mechanics y movement"] = Color3.fromRGB(160, 80, 245),
    ["performance y settings"] = Color3.fromRGB(205, 125, 255),
    ["musica"] = Color3.fromRGB(140, 75, 235),
}
local ACTIVE_TAB_BG  = CARD_HOV
local ACTIVE_TAB_TXT = WHITE
local IDLE_TAB_BG    = CARD_BG
local IDLE_TAB_TXT   = WHITE

switchTab = function(name)
	activeTabName = name
	for _, td in ipairs(tabDefs) do
		local t = tabs[td.name]
		local isA = td.name == name
        local accent = TAB_ACCENTS[td.name] or BORDER2
        TweenService:Create(t.frame, TweenInfo.new(0.16), {
            BackgroundColor3 = isA and accent or Color3.fromRGB(20, 10, 12),
            BackgroundTransparency = isA and 0.02 or 0.22
        }):Play()
        if t.stroke then
            TweenService:Create(t.stroke, TweenInfo.new(0.16), {
                Color = isA and accent or BORDER,
                Transparency = isA and 0.02 or 0.4,
                Thickness = isA and 1.8 or 1
            }):Play()
        end
        if t.gradient then
            t.gradient.Enabled = isA
        end
		TweenService:Create(t.lbl, TweenInfo.new(0.14), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
		if t.mark then
			TweenService:Create(t.mark, TweenInfo.new(0.14), {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = isA and 0 or 0.55
			}):Play()
		end
		tabPages[td.name].Visible = isA
	end
end

for i, td in ipairs(tabDefs) do
	local btn = Instance.new("TextButton", tabListFrame)
    btn.Size = UDim2.new(1, -8, 0, 38)
    local accent = TAB_ACCENTS[td.name] or BORDER2
    btn.BackgroundColor3 = Color3.fromRGB(20, 10, 12)
    btn.BackgroundTransparency = 0.2
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.LayoutOrder = i
	btn.ZIndex = 7
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local bSt = Instance.new("UIStroke", btn)
    bSt.Color = accent
    bSt.Thickness = 1
    bSt.Transparency = 0.35
    local purpleGlow = Instance.new("UIStroke", btn)
    purpleGlow.Name = "PurplePulseOutline"
    purpleGlow.Color = Color3.fromRGB(190, 95, 255)
    purpleGlow.Thickness = 2.4
    purpleGlow.Transparency = 0.42
    purpleGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    task.spawn(function()
        while btn.Parent do
            local up = TweenService:Create(purpleGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.08, Thickness = 3
            })
            up:Play(); up.Completed:Wait()
            if not btn.Parent then break end
            local down = TweenService:Create(purpleGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.48, Thickness = 1.7
            })
            down:Play(); down.Completed:Wait()
        end
    end)
    local bGradient = Instance.new("UIGradient", btn)
    bGradient.Enabled = false
    bGradient.Rotation = 0
    bGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accent:Lerp(Color3.fromRGB(12, 8, 12), 0.38)),
        ColorSequenceKeypoint.new(0.5, accent:Lerp(Color3.fromRGB(255, 255, 255), 0.18)),
        ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(12, 8, 12), 0.38))
    })

    local pin = Instance.new("Frame", btn)
    pin.Name = "Pin"
    pin.Size = UDim2.new(0, 7, 0, 7)
    pin.Position = UDim2.new(1, -12, 0.5, -3)
    pin.BackgroundColor3 = accent
	pin.BorderSizePixel = 0
	pin.Rotation = 45
	pin.ZIndex = 6
	Instance.new("UICorner", pin).CornerRadius = UDim.new(0, 2)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = td.name
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.ZIndex = 9
    local activeMark = Instance.new("Frame", btn)
    activeMark.Name = "ActiveMark"
    activeMark.Size = UDim2.new(0, 3, 1, -12)
    activeMark.Position = UDim2.new(0, 2, 0, 6)
    activeMark.BackgroundColor3 = accent
	activeMark.BackgroundTransparency = 0.2
	activeMark.BorderSizePixel = 0
	Instance.new("UICorner", activeMark).CornerRadius = UDim.new(1, 0)
	activeMark.ZIndex = 10

    tabs[td.name] = {frame=btn, lbl=lbl, mark=activeMark, stroke=bSt, gradient=bGradient}
    btn.MouseEnter:Connect(function()
        if activeTabName ~= td.name then
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = accent:Lerp(Color3.fromRGB(25, 10, 14), 0.4), BackgroundTransparency = 0.05}):Play()
            TweenService:Create(bSt, TweenInfo.new(0.12), {Color = accent, Transparency = 0.05}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTabName ~= td.name then
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(20, 10, 12), BackgroundTransparency = 0.22}):Play()
            TweenService:Create(bSt, TweenInfo.new(0.12), {Color = BORDER, Transparency = 0.4}):Play()
        end
    end)

	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundColor3 = BG
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = BORDER
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.ZIndex = 3
	local pll = Instance.new("UIListLayout", page)
	pll.SortOrder = Enum.SortOrder.LayoutOrder
	pll.Padding = UDim.new(0, 7)
	local pp = Instance.new("UIPadding", page)
	pp.PaddingLeft = UDim.new(0, 13)
	pp.PaddingRight = UDim.new(0, 13)
	pp.PaddingTop = UDim.new(0, 12)
	pp.PaddingBottom = UDim.new(0, 12)
	tabPages[td.name] = page
	pageLOs[td.name] = 0
	btn.Activated:Connect(function() switchTab(td.name) end)
	btn.MouseEnter:Connect(function()
		if activeTabName ~= td.name then
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(200, 30, 30), BackgroundTransparency=0.05}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if activeTabName ~= td.name then
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(120, 15, 15), BackgroundTransparency=0.25}):Play()
		end
	end)
end

State.lo = function(tabName) pageLOs[tabName] = pageLOs[tabName] + 1; return pageLOs[tabName] end
State.pg = function(tabName) return tabPages[tabName] end

State.makeSecHeader = function(tabName, text)
	local f = Instance.new("Frame", State.pg(tabName))
	f.Size = UDim2.new(1, 0, 0, 24)
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0
	f.LayoutOrder = State.lo(tabName)
	f.ZIndex = 4

	local accent = Instance.new("Frame", f)
	accent.Size = UDim2.new(0, 3, 0, 12)
	accent.Position = UDim2.new(0, 0, 0.5, -6)
	accent.BackgroundColor3 = LABEL_TEXT
	accent.BorderSizePixel = 0
	accent.ZIndex = 5
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local t = Instance.new("TextLabel", f)
	t.Size = UDim2.new(1, -12, 0, 16)
	t.Position = UDim2.new(0, 9, 0, 1)
	t.BackgroundTransparency = 1
	t.Text = text:upper()
	t.TextColor3 = WHITE -- Rojo
	t.Font = Enum.Font.GothamBold
	t.TextSize = 8
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextWrapped = false
	t.TextTruncate = Enum.TextTruncate.AtEnd
	t.ZIndex = 5

	local line = Instance.new("Frame", f)
	line.Size = UDim2.new(1, -9, 0, 1)
	line.Position = UDim2.new(0, 9, 1, -2)
	line.BackgroundColor3 = BORDER
	line.BackgroundTransparency = 0.25
	line.BorderSizePixel = 0
	line.ZIndex = 4
end

local _unwalkSavedAnimate = nil
State.startUnwalk = function()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
    local anim = c:FindFirstChild("Animate")
    if anim then _unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end
State.stopUnwalk = function()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif _unwalkSavedAnimate then _unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    _unwalkSavedAnimate = nil
end


-- Cosmetic animation pack borrowed from FR HUB; no server remotes are used.
local _moyaAnimPack = {
    idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563",
    walk="rbxassetid://707897309", run="rbxassetid://707861613",
    jump="rbxassetid://116936326516985", fall="rbxassetid://116936326516985",
    climb="rbxassetid://116936326516985", swim="rbxassetid://116936326516985",
    swimidle="rbxassetid://116936326516985"
}
local _moyaOriginalAnims = setmetatable({}, {__mode="k"})
local function _moyaAnimSlots(char)
    local an = char and char:FindFirstChild("Animate")
    if not an then return nil end
    return an, {
        idle1=an:FindFirstChild("idle") and an.idle:FindFirstChild("Animation1"),
        idle2=an:FindFirstChild("idle") and an.idle:FindFirstChild("Animation2"),
        walk=an:FindFirstChild("walk") and (an.walk:FindFirstChild("WalkAnim") or an.walk:FindFirstChildWhichIsA("Animation")),
        run=an:FindFirstChild("run") and (an.run:FindFirstChild("RunAnim") or an.run:FindFirstChildWhichIsA("Animation")),
        jump=an:FindFirstChild("jump") and (an.jump:FindFirstChild("JumpAnim") or an.jump:FindFirstChildWhichIsA("Animation")),
        fall=an:FindFirstChild("fall") and (an.fall:FindFirstChild("FallAnim") or an.fall:FindFirstChildWhichIsA("Animation")),
        climb=an:FindFirstChild("climb") and (an.climb:FindFirstChild("ClimbAnim") or an.climb:FindFirstChildWhichIsA("Animation")),
        swim=an:FindFirstChild("swim") and (an.swim:FindFirstChild("Swim") or an.swim:FindFirstChildWhichIsA("Animation")),
        swimidle=an:FindFirstChild("swimidle") and (an.swimidle:FindFirstChild("SwimIdle") or an.swimidle:FindFirstChildWhichIsA("Animation")),
    }
end
local function _moyaApplyAnimPack(char)
    local _, slots = _moyaAnimSlots(char)
    if not slots then return end
    if not _moyaOriginalAnims[char] then
        local original = {}
        for key, obj in pairs(slots) do if obj then original[key] = obj.AnimationId end end
        _moyaOriginalAnims[char] = original
    end
    for key, obj in pairs(slots) do if obj and _moyaAnimPack[key] then obj.AnimationId = _moyaAnimPack[key] end end
end
local function _moyaRestoreAnimPack(char)
    local _, slots = _moyaAnimSlots(char)
    local original = char and _moyaOriginalAnims[char]
    if not slots or not original then return end
    for key, obj in pairs(slots) do if obj and original[key] then obj.AnimationId = original[key] end end
    _moyaOriginalAnims[char] = nil
end
local function _moyaSetBodyPartVisibility(char, key, hide)
    if not char then return end
    State._moyaHiddenParts = State._moyaHiddenParts or setmetatable({}, {__mode="k"})
    local saved = State._moyaHiddenParts[char] or {}
    State._moyaHiddenParts[char] = saved
    local names = key == "head" and {"Head"} or {"Left Leg","Right Leg","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}
    for _, name in ipairs(names) do
        local part = char:FindFirstChild(name, true)
        if part and part:IsA("BasePart") then
            if hide then
                if saved[part] == nil then saved[part] = part.LocalTransparencyModifier end
                part.LocalTransparencyModifier = 1
            elseif saved[part] ~= nil then
                part.LocalTransparencyModifier = saved[part]
                saved[part] = nil
            end
        end
    end
end
local _moyaWalkStyles, _moyaWalkIndex, _moyaApplyWalkStyle
local function _moyaApplyCosmetics(char)
    if State.moyaAnimPackEnabled then _moyaApplyAnimPack(char) end
    _moyaSetBodyPartVisibility(char, "head", State.moyaHideHeadEnabled == true)
    _moyaSetBodyPartVisibility(char, "legs", State.moyaHideLegsEnabled == true)
end
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function() _moyaApplyCosmetics(char) end)
    task.wait(0.25)
    local style = _moyaWalkStyles and _moyaWalkStyles[_moyaWalkIndex or 1]
    if style then pcall(_moyaApplyWalkStyle, char, style) end
end)

State.baseCard = function(tabName, h2)
	local c = Instance.new("Frame", State.pg(tabName))
	c.Size = UDim2.new(1, 0, 0, h2 or 38)
	c.BackgroundColor3 = CARD_BG
	c.BackgroundTransparency = OPTION_TRANSPARENCY
	c.BorderSizePixel = 0
	c.LayoutOrder = State.lo(tabName)
	c.ZIndex = 4
	Instance.new("UICorner", c).CornerRadius = UDim.new(0, 12)
	local cSt = Instance.new("UIStroke", c)
	cSt.Color = BORDER -- Rojo
	cSt.Thickness = 1
	cSt.Transparency = 0.18

	local sideAccent = Instance.new("Frame", c)
	sideAccent.Name = "VisualAccent"
	sideAccent.Size = UDim2.new(0, 2, 0.54, 0)
	sideAccent.Position = UDim2.new(0, 1, 0.23, 0)
	sideAccent.BackgroundColor3 = BORDER
	sideAccent.BackgroundTransparency = 0.2
	sideAccent.BorderSizePixel = 0
	sideAccent.ZIndex = 5
	Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(1, 0)

	local bottomDetail = Instance.new("Frame", c)
	bottomDetail.Name = "BottomDetail"
	bottomDetail.Size = UDim2.new(1, -24, 0, 1)
	bottomDetail.Position = UDim2.new(0, 12, 1, -1)
	bottomDetail.BackgroundColor3 = Color3.fromRGB(8, 5, 110)
	bottomDetail.BackgroundTransparency = 0.58
	bottomDetail.BorderSizePixel = 0
	bottomDetail.ZIndex = 5

	c.MouseEnter:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	c.MouseLeave:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return c
end

State.cLabel = function(p, text, x, w, sz, col, font, xa)
	local l = Instance.new("TextLabel", p)
	l.Size = UDim2.new(0, w or 140, 1, 0)
	l.Position = UDim2.new(0, x or 10, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = col or LABEL_TEXT -- Azul labels
	l.Font = font or Enum.Font.GothamBold
	l.TextSize = sz or 11
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.ZIndex = 10
	return l
end

State.makePillToggle = function(parent, defOn, onToggle)
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", parent)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER -- Rojo o Rosa
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", parent)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV
end

State.makeKB = function(parent, kbEntry, onChange)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, 44, 0, 20)
	b.BackgroundColor3 = KB_BG
	b.BackgroundTransparency = INPUT_TRANSPARENCY
	b.BorderSizePixel = 0
	local function getDisplayText()
		if kbEntry.gp then return "GP:"..kbEntry.gp.Name
		elseif kbEntry.kb then return kbEntry.kb.Name
		else return "None" end
	end
	b.Text = getDisplayText()
	State._bindButtons = State._bindButtons or {}
	State._bindButtons[kbEntry] = b
	b.TextColor3 = WHITE -- Rojo
	b.Font = Enum.Font.GothamBold
	b.TextSize = 8
	b.ZIndex = 11
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local bs = Instance.new("UIStroke", b); bs.Color = BORDER; bs.Thickness = 1
	local li = false; local lc; local pv = b.Text
	b.MouseButton1Click:Connect(function()
		if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; b.Text=pv; b.TextColor3=WHITE; return end
		pv=b.Text; li=true; _anyKeyListening=true; b.Text="···"; b.TextColor3=DIM
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play()
		lc = UIS.InputBegan:Connect(function(inp)
			if not li then return end
			local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
			local isGp = string.sub(inp.UserInputType.Name, 1, 7) == "Gamepad"
			if not isKb and not isGp then return end
			if inp.KeyCode == Enum.KeyCode.Escape then
				li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
				b.Text=pv; b.TextColor3=WHITE; TweenService:Create(bs,TweenInfo.new(0.1),{Color=BORDER}):Play(); return
			end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
				b.Text = "GP:"..inp.KeyCode.Name; pv = b.Text
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
				b.Text = inp.KeyCode.Name; pv = b.Text
			end
			b.TextColor3=WHITE
			li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
			TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
			if onChange then onChange(inp.KeyCode) end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)
	end)
	return b
end

State.rowToggle = function(tabName, label, sub, defOn, onToggle)
	local c = State.baseCard(tabName, sub and 58 or 38)
	local titleLabel = State.cLabel(c, label, 10, 160, 11, LABEL_TEXT, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = State.cLabel(c, sub, 10, 170, 9, LABEL_SUB, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	return State.makePillToggle(c, defOn, onToggle)
end

State.rowToggleKB = function(tabName, label, sub, kbEntry, defOn, onToggle, onKeyChange)
	local c = State.baseCard(tabName, sub and 58 or 38)
	local titleLabel = State.cLabel(c, label, 10, 120, 11, LABEL_TEXT, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 120, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = State.cLabel(c, sub, 10, 150, 9, LABEL_SUB, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 150, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = State.makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10+36+8+19), 0.5, -10)
	kb.ZIndex = 11
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", c)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV, kb
end

State.rowKBOnly = function(tabName, label, sub, kbEntry, onKeyChange)
	local c = State.baseCard(tabName, sub and 58 or 38)
	local titleLabel = State.cLabel(c, label, 10, 160, 11, LABEL_TEXT, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = State.cLabel(c, sub, 10, 170, 9, LABEL_SUB, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = State.makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	return kb
end

State.rowInput = function(tabName, label, sub, default, onChange)
	local c = State.baseCard(tabName, sub and 58 or 38)
	local titleLabel = State.cLabel(c, label, 10, 130, 11, LABEL_TEXT, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 130, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = State.cLabel(c, sub, 10, 160, 9, LABEL_SUB, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 160, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local box = Instance.new("TextBox", c)
	box.Size = UDim2.new(0, 64, 0, 24)
	box.Position = UDim2.new(1, -74, 0.5, -12)
	box.BackgroundColor3 = INPUT_BG
	box.BackgroundTransparency = INPUT_TRANSPARENCY
	box.BorderSizePixel = 0
	box.Text = tostring(default)
	box.TextColor3 = WHITE -- Rojo
	box.Font = Enum.Font.GothamBold
	box.TextSize = 11
	box.ClearTextOnFocus = false
	box.ZIndex = 11
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
	local bs = Instance.new("UIStroke", box); bs.Color = BORDER; bs.Thickness = 1; bs.ZIndex = 12
	box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play() end)
	box.FocusLost:Connect(function()
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
		if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return box
end

State.rowActionBtn = function(tabName, label, onClick)
	local b = Instance.new("TextButton", State.pg(tabName))
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = CARD_BG
	b.BackgroundTransparency = OPTION_TRANSPARENCY
	b.BorderSizePixel = 0
	b.Text = label
	b.TextColor3 = WHITE -- Rojo
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.LayoutOrder = State.lo(tabName)
	b.ZIndex = 5
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
	local bSt = Instance.new("UIStroke", b)
	bSt.Color = BORDER
	bSt.Thickness = 1.2

	local pressScale = Instance.new("UIScale", b)
	pressScale.Scale = 1

	b.MouseButton1Click:Connect(function()
		TweenService:Create(pressScale, TweenInfo.new(0.06), {Scale=0.975}):Play()
		TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play()
		task.delay(0.08, function()
			if pressScale and pressScale.Parent then
				TweenService:Create(pressScale, TweenInfo.new(0.09, Enum.EasingStyle.Back), {Scale=1}):Play()
			end
		end)
		task.delay(0.15, function()
			if b and b.Parent then
				TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play()
			end
		end)
		if onClick then pcall(onClick) end
	end)
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return b
end

State.rowCycleSelector = function(tabName, label, options, defaultValue, onChange)
	local c = State.baseCard(tabName, 40)
	State.cLabel(c, label, 10, 110, 11, LABEL_TEXT, Enum.Font.GothamBold)

	local left = Instance.new("TextButton", c)
	left.Size = UDim2.new(0, 26, 0, 24)
	left.Position = UDim2.new(1, -142, 0.5, -12)
	left.BackgroundColor3 = INPUT_BG
	left.BackgroundTransparency = INPUT_TRANSPARENCY
	left.BorderSizePixel = 0
	left.Text = "←"
	left.TextColor3 = WHITE
	left.Font = Enum.Font.GothamBlack
	left.TextSize = 15
	left.ZIndex = 12
	Instance.new("UICorner", left).CornerRadius = UDim.new(0, 12)
	local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = BORDER; leftStroke.Thickness = 1

	local valueLabel = Instance.new("TextLabel", c)
	valueLabel.Size = UDim2.new(0, 78, 0, 24)
	valueLabel.Position = UDim2.new(1, -112, 0.5, -12)
	valueLabel.BackgroundColor3 = INPUT_BG
	valueLabel.BackgroundTransparency = INPUT_TRANSPARENCY
	valueLabel.BorderSizePixel = 0
	valueLabel.TextColor3 = LABEL_TEXT
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 9
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
	valueLabel.ZIndex = 11
	Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(0, 12)
	local valueStroke = Instance.new("UIStroke", valueLabel); valueStroke.Color = BORDER; valueStroke.Thickness = 1

	local right = Instance.new("TextButton", c)
	right.Size = UDim2.new(0, 26, 0, 24)
	right.Position = UDim2.new(1, -30, 0.5, -12)
	right.BackgroundColor3 = INPUT_BG
	right.BackgroundTransparency = INPUT_TRANSPARENCY
	right.BorderSizePixel = 0
	right.Text = "→"
	right.TextColor3 = WHITE
	right.Font = Enum.Font.GothamBlack
	right.TextSize = 15
	right.ZIndex = 12
	Instance.new("UICorner", right).CornerRadius = UDim.new(0, 12)
	local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = BORDER; rightStroke.Thickness = 1

	local index = 1
	for i, option in ipairs(options) do
		if option == defaultValue then index = i; break end
	end

	local function setValue(value, fireCallback)
		if type(value) == "number" then
			index = ((math.floor(value) - 1) % #options) + 1
		else
			for i, option in ipairs(options) do
				if option == value then index = i; break end
			end
		end
		valueLabel.Text = options[index]
		if fireCallback and onChange then pcall(onChange, options[index], index) end
		return options[index]
	end

	local function move(direction)
		setValue(index + direction, true)
		if State.requestConfigSave then State.requestConfigSave() end
	end

	left.Activated:Connect(function() move(-1) end)
	right.Activated:Connect(function() move(1) end)
	left.MouseEnter:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	left.MouseLeave:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
	right.MouseEnter:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	right.MouseLeave:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)

	setValue(defaultValue, false)
	return setValue, function() return options[index] end
end

do
State.makeSecHeader("speed y aimbot", "Speed Configuration")

do
	local c = State.baseCard("speed y aimbot", 48)
	State.cLabel(c, "Speed Profile", 10, 92, 11, LABEL_TEXT, Enum.Font.GothamBold)

	local holder = Instance.new("Frame", c)
	holder.Name = "SpeedProfileSelector"
	holder.Size = UDim2.new(0, 150, 0, 28)
	holder.Position = UDim2.new(1, -160, 0.5, -14)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.ZIndex = 12

	local layout = Instance.new("UIListLayout", holder)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 6)

	local function makeProfileButton(label)
		local b = Instance.new("TextButton", holder)
		b.Name = label .. "Profile"
		b.Size = UDim2.new(0, 72, 0, 28)
		b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		b.BackgroundTransparency = 0.12
		b.BorderSizePixel = 0
		b.Text = string.upper(label)
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.TextSize = 10
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.ZIndex = 13
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", b)
		stroke.Color = Color3.fromRGB(40, 40, 40)
		stroke.Thickness = 1
		stroke.Transparency = 0.25
		return b, stroke
	end

	local normalProfileBtn, normalProfileStroke = makeProfileButton("Normal")
	local laggerProfileBtn, laggerProfileStroke = makeProfileButton("Lagger")

	local function refreshProfileVisual()
		local normalActive = State.speedProfile ~= "Lagger"
		TweenService:Create(normalProfileBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = normalActive and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(20, 20, 20),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = normalActive and 0 or 0.2
		}):Play()
		TweenService:Create(laggerProfileBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = not normalActive and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(20, 20, 20),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = not normalActive and 0 or 0.2
		}):Play()
		normalProfileStroke.Color = normalActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
		laggerProfileStroke.Color = not normalActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
	end

	local function selectProfile(profile)
		State.speedProfile = profile == "Lagger" and "Lagger" or "Normal"
		refreshProfileVisual()
		if normalBox then
			normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS)
		end
		if carryBox then
			carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS)
		end
		if modeValLbl then
			if State.laggerToggled then
				modeValLbl.Text = laggerPhase == 2 and "Lagger 2" or "Lagger 1"
			elseif State.speedToggled then
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"
			else
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"
			end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	normalProfileBtn.Activated:Connect(function() selectProfile("Normal") end)
	laggerProfileBtn.Activated:Connect(function() selectProfile("Lagger") end)

	State._refreshSpeedProfileVisual = refreshProfileVisual
	State._selectSpeedProfile = selectProfile
	refreshProfileVisual()
end

normalBox = State.rowInput("speed y aimbot", "Normal Speed", nil, NS, function(v)
	if type(v) == "number" and v > 0 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerNormalSpeed = v
		else
			NS = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
carryBox = State.rowInput("speed y aimbot", "Carry Speed", nil, CS, function(v)
	if type(v) == "number" and v > 0 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerCarrySpeed = v
		else
			CS = v
			_G.CarrySpeedValue = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
laggerBox = State.rowInput("speed y aimbot", "Lagger 1", nil, LS, function(v) if type(v) == "number" and v > 0 then LS = v end end)
laggerBox2 = State.rowInput("speed y aimbot", "Lagger 2", nil, LS2, function(v) if type(v) == "number" and v > 0 then LS2 = v end end)

do
	local c = State.baseCard("speed y aimbot", 38)
	State.cLabel(c, "Mode", 10, 80, 11, LABEL_TEXT, Enum.Font.GothamBold)
	modeValLbl = State.cLabel(c, "Normal", 88, 80, 10, LABEL_SUB, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	local kb = State.makeKB(c, KB.Speed, function(k) end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.speedToggled = not State.speedToggled
		if State.speedToggled then
			State.laggerToggled = false
			if mobileLaggerSetActive then mobileLaggerSetActive(false) end
		end
		if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

do
	State._setLaggerPhase = State._setLaggerPhase or function(phase)
		laggerPhase = phase
		State.laggerToggled = phase ~= 0
		if phase ~= 0 then
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
		end
		if mobileLaggerSetActive then mobileLaggerSetActive(phase == 1) end
		if mobileLaggerCarrySetActive then mobileLaggerCarrySetActive(phase == 2) end
		if modeValLbl then
			modeValLbl.Text = phase == 1 and "Lagger 1" or (phase == 2 and "Lagger 2" or (State.speedToggled and "Carry" or "Normal"))
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	do
		local c = State.baseCard("speed y aimbot", 38)
		State.cLabel(c, "Lagger 1", 10, 120, 11, LABEL_TEXT, Enum.Font.GothamBold)
		local kb = State.makeKB(c, KB.Lagger, function(k) KB.Lagger.kb = k end)
		kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
		kb.ZIndex = 11
		local clk = Instance.new("TextButton", c)
		clk.Size = UDim2.new(0.65, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 6
		clk.Active = true
		clk.Activated:Connect(function()
			if _anyKeyListening then return end
			State._setLaggerPhase(laggerPhase == 1 and 0 or 1)
		end)
	end

	do
		local c = State.baseCard("speed y aimbot", 38)
		State.cLabel(c, "Lagger 2", 10, 120, 11, LABEL_TEXT, Enum.Font.GothamBold)
		local kb = State.makeKB(c, KB.Lagger2, function(k) KB.Lagger2.kb = k end)
		kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
		kb.ZIndex = 11
		local clk = Instance.new("TextButton", c)
		clk.Size = UDim2.new(0.65, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 6
		clk.Active = true
		clk.Activated:Connect(function()
			if _anyKeyListening then return end
			State._setLaggerPhase(laggerPhase == 2 and 0 or 2)
		end)
	end
end

State.makeSecHeader("speed y aimbot", "Bat Combat V1 & V2")
do
	local sv
	sv, _ = State.rowToggleKB("speed y aimbot", "Auto Bat V1", "Modo predictivo", KB.AutoBat, false,
	function(on)
		State.autoBatToggled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; State.stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; State.stopAutoRight() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			startBatAimbot()
		else
			stopBatAimbot()
		end
		if mobileBatV1SetActive then mobileBatV1SetActive(on) end
	end,
	function(k) KB.AutoBat.kb = k end)
	autoBatSetVisual = sv
	setAutoBat = sv
end

do
	local sv
	sv, _ = State.rowToggleKB("speed y aimbot", "bat v2", "Versión avanzada ", KB.AutoBatV2, false,
	function(on)
		State.autoBatV2Enabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; State.stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; State.stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if startBatAimbotV2 then startBatAimbotV2() end
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if mobileBatV2SetActive then mobileBatV2SetActive(on) end
	end,
	function() end)
	autoBatV2SetVisual = sv
	setAutoBatV2 = sv
end

State._setTPBatEnabled = function(on)
	State.tpBatEnabled = on == true

	if State._hitboxFollower then
		if State.tpBatEnabled then
			if State.hitboxFollowerEnabled then
				State._hitboxFollower.stop()
			end
		elseif State.hitboxFollowerEnabled and not State.autoBatToggled then
			State._hitboxFollower.start()
		end
	end
end

State._tpBatConfigSetVisual = State.rowToggleKB("speed y aimbot", "Anti-Desync", "Teleport y golpe automático (anti-desync)", KB.TPBat, false,
function(on)
	State._setTPBatEnabled(on)
	if State._tpBatSetter then State._tpBatSetter(on) end
end,
function() end)

State.makeSecHeader("mechanics y movement", "Game Mechanics")

if not KB.InstaReset then KB.InstaReset = {kb=nil, gp=nil} end

local cInsta = State.baseCard("mechanics y movement", 48)
cInsta.LayoutOrder = State.lo("mechanics y movement")
State.cLabel(cInsta, "Insta Reset", 10, 120, 11, LABEL_TEXT, Enum.Font.GothamBold)
local slInsta = State.cLabel(cInsta, "Reset Instantáneo", 10, 150, 9, LABEL_SUB, Enum.Font.Gotham)
slInsta.Size = UDim2.new(0, 150, 0, 13); slInsta.Position = UDim2.new(0, 10, 0, 24)

local plusBtn = Instance.new("TextButton", cInsta)
plusBtn.Size = UDim2.new(0, 20, 0, 20)
plusBtn.Position = UDim2.new(1, -(44+10+36+8+20+4), 0.5, -10)
plusBtn.BackgroundColor3 = KB_BG
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = WHITE -- Rojo
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 14
plusBtn.ZIndex = 11
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)
local pbs = Instance.new("UIStroke", plusBtn); pbs.Color = BORDER; pbs.Thickness = 1
plusBtn.MouseButton1Click:Connect(function()
	TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play()
	task.delay(0.1, function() TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

	if btnInstaReset then
		btnInstaReset.Visible = not btnInstaReset.Visible
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

local kbInsta = State.makeKB(cInsta, KB.InstaReset, function() end)
kbInsta.Position = UDim2.new(1, -(44+10+36+8), 0.5, -10)
kbInsta.ZIndex = 11

local setInstaToggleVisual
setInstaToggleVisual = State.makePillToggle(cInsta, false, function(on)
	State.instaResetEnabled = on
	if on then
		if btnInstaReset then
			TweenService:Create(btnInstaReset, TweenInfo.new(0.08), {BackgroundColor3=WHITE, TextColor3=BG}):Play()
			task.delay(0.22, function()
				TweenService:Create(btnInstaReset, TweenInfo.new(0.15), {BackgroundColor3=BG, TextColor3=WHITE}):Play()
			end)
		end

		task.spawn(State.cursedInstaReset)

		task.wait(0.2)
		if setInstaToggleVisual then setInstaToggleVisual(false) end
	end
end)

setInfJump       = State.rowToggle("mechanics y movement", "Infinite Jump",  nil, false, function(on) State.infJumpEnabled = on end)
setSuperJump     = State.rowToggle("mechanics y movement", "Infinite Jump Hold",     nil, false, function(on) State.superJumpEnabled = on end)
setLinieVisual   = State.rowToggle("mechanics y movement", "Linia ESP", nil, false, function(on) State.linieEnabled = on end)
setAntiRag       = State.rowToggle("mechanics y movement", "Anti Ragdoll",   nil, false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setUnwalkToggle  = State.rowToggle("mechanics y movement", "Unwalk",         nil, false, function(on) State.unwalkEnabled=on; if on then State.startUnwalk() else State.stopUnwalk() end end)
-- Removed FR HUB TP DOWN AIMBOT / input-down feature at user request.

-- Full-body animation selector adapted from FR HUB animation packs.
-- Applies idle, walk, run, jump, fall, climb, swim and swim-idle locally.
_moyaWalkStyles = {
    {name="Default"},
    {name="Adidas Sports", walk=18537392113, run=18537384940, jump=18537380791, fall=18537367238, swimidle=18537387180, swim=18537389531, idle1=18537376492, idle2=18537371272, climb=18537363391},
    {name="Adidas Community", walk=122150855457006, run=82598234841035, jump=75290611992385, fall=98600215928904, swimidle=109346520324160, swim=133308483266208, idle1=122257458498464, idle2=102357151005774, climb=88763136693023},
    {name="Adidas Aura", walk=83842218823011, run=118320322718866, jump=109996626521204, fall=95603166884636, swimidle=94922130551805, swim=134530128383903, idle1=110211186840347, idle2=114191137265065, climb=97824616490448},
    {name="Wicked Popular", walk=92072849924640, run=72301599441680, jump=104325245285198, fall=121152442762481, idle1=118832222982049, idle2=76049494037641, climb=131326830509784, swimidle=113199415118199, swim=99384245425157},
    {name="Elder", walk=10921111375, run=10921104374, jump=10921107367, fall=10921105765, swimidle=10921110146, swim=10921108971, climb=10921100400, idle1=10921101664, idle2=10921102574},
    {name="Zombie", walk=10921355261, run=616163682, jump=10921351278, fall=10921350320, swimidle=10921353442, swim=10921352344, idle1=10921344533, idle2=10921345304, climb=10921343576},
    {name="Mage", walk=10921152678, run=10921148209, jump=10921149743, fall=10921148939, swimidle=10921151661, swim=10921150788, climb=10921143404, idle1=10921144709, idle2=10921145797},
    {name="Catwalk Glam", walk=109168724482748, run=81024476153754, jump=116936326516985, fall=92294537340807, swimidle=98854111361360, swim=134591743181628, climb=119377220967554, idle1=133806214992291, idle2=94970088341563},
    {name="Astronaut", walk=10921046031, run=10921039308, jump=10921042494, fall=10921040576, swimidle=10921045006, swim=10921044000, climb=10921032124, idle1=10921034824, idle2=10921036806},
    {name="Wicked Dancing Through Life", walk=73718308412641, run=135515454877967, jump=78508480717326, fall=78147885297412, swimidle=129183123083281, swim=110657013921774, climb=129447497744818, idle1=92849173543269, idle2=132238900951109},
    {name="Werewolf", walk=10921342074, run=10921336997, fall=10921337907, swimidle=10921341319, swim=10921340419, climb=10921329322, idle1=10921330408, idle2=10921333667},
    {name="Superhero", walk=10921298616, run=10921291831, jump=10921294559, fall=10921293373, swimidle=10921297391, swim=10921295495, climb=10921286911, idle1=10921288909, idle2=10921290167},
    {name="Toy", walk=10921312010, run=10921306285, jump=10921308158, fall=10921307241, swimidle=10921310341, swim=10921309319, climb=10921300839, idle1=10921301576},
    {name="No Boundaries", walk=18747074203, run=18747070484, jump=18747069148, fall=18747062535, swimidle=18747071682, swim=18747073181, climb=18747060903, idle1=18747067405, idle2=18747063918},
    {name="NFL", walk=110358958299415, run=117333533048078, jump=119846112151352, fall=129773241321032, swimidle=79090109939093, swim=132697394189921, climb=134630013742019, idle1=92080889861410, idle2=74451233229259},
    {name="Amazon Unboxed", walk=90478085024465, run=134824450619865, jump=121454505477205, fall=94788218468396, swimidle=129126268464847, swim=105962919001086, climb=121145883950231, idle1=98281136301627},
    {name="Vampire", walk=10921326949, run=10921320299, jump=10921322186, fall=10921321317, swimidle=10921325443, swim=10921324408, climb=10921314188, idle1=10921315373},
    {name="Ninja", walk=656121766, run=656118852, jump=656117878, fall=656115606, swim=656119721, swimidle=656121397, climb=656114359, idle1=656117400, idle2=656118341},
    {name="Robot", walk=616095330, run=616091570, jump=616090535, fall=616087089, swim=616092998, swimidle=616094091, climb=616086039, idle1=616088211, idle2=616089559},
    {name="Levitation", walk=616013216, run=616010382, jump=616008936, fall=616005863, swim=616011509, swimidle=616012453, climb=616003713, idle1=616006778, idle2=616008087},
    {name="Stylish", walk=616146177, run=616140816, jump=616139451, fall=616134815, swim=616143378, swimidle=616144772, climb=616133594, idle1=616136790, idle2=616138447},
    {name="Bubbly", walk=910034870, run=910025107, jump=910016857, fall=910001910, swim=910028158, swimidle=910030921, climb=909997997, idle1=910004836, idle2=910009958},
    {name="Cartoon", walk=742640026, run=742638842, jump=742637942, fall=742637151, swim=742639220, swimidle=742639812, climb=742636889, idle1=742637544, idle2=742638445},
}
_moyaWalkIndex = tonumber(State.moyaWalkStyleIndex) or 1
_moyaWalkIndex = math.clamp(_moyaWalkIndex, 1, #_moyaWalkStyles)
local _moyaFullAnimOriginal = setmetatable({}, {__mode="k"})
local _moyaAnimSlotNames = {
    idle1={"idle","Animation1"}, idle2={"idle","Animation2"},
    walk={"walk","WalkAnim"}, run={"run","RunAnim"}, jump={"jump","JumpAnim"},
    fall={"fall","FallAnim"}, climb={"climb","ClimbAnim"}, swim={"swim","Swim"}, swimidle={"swimidle","SwimIdle"},
}
local function _moyaGetAnimSlots(char)
    local animate = char and char:FindFirstChild("Animate")
    if not animate then return nil end
    local slots = {}
    for key, path in pairs(_moyaAnimSlotNames) do
        local folder = animate:FindFirstChild(path[1])
        local obj = folder and folder:FindFirstChild(path[2])
        if obj and obj:IsA("Animation") then slots[key] = obj end
    end
    return slots
end
_moyaApplyWalkStyle = function(char, style)
    if not char or not style then return end
    local slots = _moyaGetAnimSlots(char)
    if not slots then return end
    if not _moyaFullAnimOriginal[char] then
        local original = {}
        for key, obj in pairs(slots) do original[key] = obj.AnimationId end
        _moyaFullAnimOriginal[char] = original
    end
    local original = _moyaFullAnimOriginal[char]
    for key, obj in pairs(slots) do
        local id = style[key]
        if id then
            obj.AnimationId = "rbxassetid://" .. tostring(id)
        elseif style.name == "Default" and original[key] then
            obj.AnimationId = original[key]
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end
local animSelector = Instance.new("Frame", State.pg("mechanics y movement"))
animSelector.Name = "FullBodyAnimationSelector"
animSelector.Size = UDim2.new(1, 0, 0, 42)
animSelector.BackgroundColor3 = CARD_BG
animSelector.BackgroundTransparency = OPTION_TRANSPARENCY
animSelector.BorderSizePixel = 0
animSelector.LayoutOrder = State.lo("mechanics y movement")
animSelector.ZIndex = 4
Instance.new("UICorner", animSelector).CornerRadius = UDim.new(0, 6)
local animTitle = Instance.new("TextLabel", animSelector)
animTitle.BackgroundTransparency = 1
animTitle.Position = UDim2.new(0, 10, 0, 0)
animTitle.Size = UDim2.new(0.30, 0, 1, 0)
animTitle.Text = "Animation"
animTitle.Font = Enum.Font.GothamBold
animTitle.TextSize = 10
animTitle.TextColor3 = WHITE
animTitle.TextXAlignment = Enum.TextXAlignment.Left
animTitle.ZIndex = 5
local animName = Instance.new("TextLabel", animSelector)
animName.BackgroundTransparency = 1
animName.Position = UDim2.new(0.30, 0, 0, 0)
animName.Size = UDim2.new(0.46, 0, 1, 0)
animName.Text = _moyaWalkStyles[_moyaWalkIndex].name
animName.Font = Enum.Font.Gotham
animName.TextSize = 9
animName.TextColor3 = DIM
animName.TextTruncate = Enum.TextTruncate.AtEnd
animName.ZIndex = 5
local function _moyaArrow(text, xScale)
    local b = Instance.new("TextButton", animSelector)
    b.Size = UDim2.new(0, 25, 0, 25)
    b.Position = UDim2.new(xScale, 0, 0.5, -12)
    b.BackgroundColor3 = CARD_HOV
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.ZIndex = 6
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end
local animLeft = _moyaArrow("‹", 0.78)
local animRight = _moyaArrow("›", 0.89)
local function _moyaChangeWalkStyle(delta)
    _moyaWalkIndex = ((_moyaWalkIndex - 1 + delta) % #_moyaWalkStyles) + 1
    local style = _moyaWalkStyles[_moyaWalkIndex]
    animName.Text = style.name
    local char = LP.Character
    if char then pcall(_moyaApplyWalkStyle, char, style) end
    State.moyaWalkStyleIndex = _moyaWalkIndex
    if State.requestConfigSave then State.requestConfigSave() end
end
animLeft.MouseButton1Click:Connect(function() _moyaChangeWalkStyle(-1) end)
animRight.MouseButton1Click:Connect(function() _moyaChangeWalkStyle(1) end)
if LP.Character and _moyaWalkStyles[_moyaWalkIndex].name ~= "Default" then
    task.defer(function() pcall(_moyaApplyWalkStyle, LP.Character, _moyaWalkStyles[_moyaWalkIndex]) end)
end
State.rowToggle("mechanics y movement", "Hide Head", "Local visual only", false, function(on)
    State.moyaHideHeadEnabled = on
    pcall(_moyaSetBodyPartVisibility, LP.Character, "head", on)
    if State.requestConfigSave then State.requestConfigSave() end
end)
State.rowToggle("mechanics y movement", "Hide Legs", "R6 and R15 supported where parts exist", false, function(on)
    State.moyaHideLegsEnabled = on
    pcall(_moyaSetBodyPartVisibility, LP.Character, "legs", on)
    if State.requestConfigSave then State.requestConfigSave() end
end)
setMedusaCounter = State.rowToggle("mechanics y movement", "Medusa Counter", nil, false, function(on) State.medusaCounterEnabled=on; if on then State.setupMedusaCounter(LP.Character) else State.stopMedusaCounter() end end)
setBatCounter = State.rowToggle("mechanics y movement", "Bat Counter",    nil, false, function(on) State.batCounterEnabled=on; if on then State.startBatCounter() else State.stopBatCounter() end end)

setAutoGrab = State.rowToggle("mechanics y movement", "Auto Grab", "Roba automáticamente más rápido", true, function(on)
	Steal.AutoStealEnabled = on == true
	if State._stealConfig then State._stealConfig.AUTO_STEAL_ENABLED = on == true end
	if on then pcall(startAutoSteal) else pcall(stopAutoSteal) end
	if State._autoStealBar and State._autoStealBar.frame then
		State._autoStealBar.frame.Visible = on == true
		if State._autoStealBar.toggleBtn then
			State._autoStealBar.toggleBtn.Text = on and "STOP" or "START"
		end
		if State._autoStealBar.statusLabel then
			State._autoStealBar.statusLabel.Text = on and "READY" or "IDLE"
		end
	end
end)

setAutoMedusaVisual = State.rowToggle("mechanics y movement", "Auto Medusa", "Uso automático y predictivo", false, function(on)
	MedusaConfig.Enabled = on
end)

State.rowInput("mechanics y movement", "Medusa Radius", "Rango de detección", MedusaConfig.Radius, function(v)
	MedusaConfig.Radius = v
	if MedusaConfig.RadiusPart then
		MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
	end
end)

State.rowInput("mechanics y movement", "Medusa Delay", "Spam Delay", MedusaConfig.Delay, function(v)
	MedusaConfig.Delay = v
end)

RunService.Heartbeat:Connect(function()
    if not State.superJumpEnabled then return end
    local c = LP.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root and hum and hum.Jump then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

State.makeSecHeader("mechanics y movement", "Movement & Teleport")
State.rowKBOnly("mechanics y movement", "TP Down", "Teleport to floor", KB.TPDown, function(k) KB.TPDown.kb=k end)
do
	local sv
	sv, _ = State.rowToggleKB("mechanics y movement", "Auto Left", nil, KB.AutoLeft, false,
	function(on)
		State.autoLeftEnabled = on
		if on then
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; State.stopAutoRight() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			local char = LP.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				State.startAutoLeft()
			end
		else State.stopAutoLeft() end
		if mobileAutoLeftSetActive then mobileAutoLeftSetActive(on) end
	end, function(k) KB.AutoLeft.kb=k end)
	autoLeftSetVisual = sv
end
do
	local sv
	sv, _ = State.rowToggleKB("mechanics y movement", "Auto Right", nil, KB.AutoRight, false,
	function(on)
		State.autoRightEnabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; State.stopAutoLeft() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then State.autoBatV2Enabled=false; if autoBatV2SetVisual then autoBatV2SetVisual(false) end; stopBatAimbotV2() end
			local char = LP.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				State.startAutoRight()
			end
		else State.stopAutoRight() end
		if mobileAutoRightSetActive then mobileAutoRightSetActive(on) end
	end, function(k) KB.AutoRight.kb=k end)
	autoRightSetVisual = sv
end
State.rowKBOnly("mechanics y movement", "Drop",    nil, KB.Drop,   function(k) KB.Drop.kb=k end)

do
	setAutoTPDownVisual = State.rowToggle("mechanics y movement", "Auto TP Down", nil, false, function(on)
		autoTPDownEnabled = on
		if mobileAutoTPSetActive then mobileAutoTPSetActive(on) end
		if on then State.startAutoTPDown() else State.stopAutoTPDown() end
	end)
	State.rowInput("mechanics y movement", "TP Down Height", nil, autoTPDownHeight, function(v)
		autoTPDownHeight = math.clamp(v, 0, 500)
	end)
end

State.makeSecHeader("performance y settings", "Performance")

State._setHitboxFollower = State.rowToggle("performance y settings",
    "Hitbox Follower",
    "Sigue con la mirada la hitbox más cercana",
    false,
    function(on)
        State.hitboxFollowerEnabled = on == true
        if State.hitboxFollowerEnabled then
            if State.autoBatToggled or State.tpBatEnabled then
                State._hitboxFollower.pausedByBatAim = State.autoBatToggled == true
                State._hitboxFollower.stop()
            else
                State._hitboxFollower.pausedByBatAim = false
                State._hitboxFollower.start()
            end
        else
            State._hitboxFollower.pausedByBatAim = false
            State._hitboxFollower.stop()
        end
    end
)

do
	local _Lighting = game:GetService("Lighting")
	local _antiLagConn = nil

	local function applyAntiLag(instance)
		if instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		elseif instance:IsA("Decal") then
			instance.Transparency = 1
		elseif instance:IsA("BasePart") then
			instance.Material = Enum.Material.Plastic
			instance.Reflectance = 0
			instance.CastShadow = false
		end
	end

	local function optimizeLighting()
		_Lighting.GlobalShadows = false
		_Lighting.FogEnd = 9e9
		_Lighting.Brightness = 1
		_Lighting.EnvironmentDiffuseScale = 0
		_Lighting.EnvironmentSpecularScale = 0
		for _, child in pairs(_Lighting:GetChildren()) do
			if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then
				child.Enabled = false
			end
		end
	end

	local function enableAntiLag()
		optimizeLighting()
		for _, desc in pairs(workspace:GetDescendants()) do
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end
		if _antiLagConn then _antiLagConn:Disconnect() end
		_antiLagConn = workspace.DescendantAdded:Connect(function(desc)
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end)
	end

	local function disableAntiLag()
		if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
	end

	setAntiLag = function(on)
		State.antiLagEnabled = on
		if on then enableAntiLag() else disableAntiLag() end
	end
	local setAntiLagVisual = State.rowToggle("performance y settings", "Anti Lag", nil, false, function(on) setAntiLag(on) end)
	local rawSetAntiLag = setAntiLag
	setAntiLag = function(on) setAntiLagVisual(on); rawSetAntiLag(on) end
end

do
	local connection = nil
	local function rawSet(on)
		State.stretchRezEnabled = on
		if on then
			workspace.CurrentCamera.FieldOfView = 120
			if connection then connection:Disconnect() end
			connection = RunService.RenderStepped:Connect(function()
				if not State.stretchRezEnabled then
					if connection then connection:Disconnect(); connection = nil end
					return
				end
				workspace.CurrentCamera.FieldOfView = 120
			end)
		else
			if connection then connection:Disconnect(); connection = nil end
			workspace.CurrentCamera.FieldOfView = 70
		end
	end
	local visual = State.rowToggle("performance y settings", "Stretch Rez", nil, false, function(on) rawSet(on) end)
	setStretchRez = function(on) visual(on); rawSet(on) end
end

do
	local connection = nil
	local function removeFromCharacter(character)
		if not character then return end
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("Accessory") or obj:IsA("Hat") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	local function rawSet(on)
		State.removeAccessoriesEnabled = on
		if on then
			for _, player in pairs(Players:GetPlayers()) do
				removeFromCharacter(player.Character)
			end
			if not connection then
				connection = Players.PlayerAdded:Connect(function(player)
					player.CharacterAdded:Connect(function(character)
						task.wait(0.5)
						if State.removeAccessoriesEnabled then removeFromCharacter(character) end
					end)
				end)
			end
		else
			if connection then connection:Disconnect(); connection = nil end
		end
	end
	local visual = State.rowToggle("performance y settings", "Remove Accessories", nil, false, function(on) rawSet(on) end)
	setRemoveAccessories = function(on) visual(on); rawSet(on) end
end

do
	local Lighting = game:GetService("Lighting")
	local defaults = {
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		ExposureCompensation = Lighting.ExposureCompensation,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Ambient = Lighting.Ambient,
		FogColor = Lighting.FogColor,
	}
	local styles = {
		{name="Off"},
		{name="Galaxy", tint=Color3.fromRGB(68, 125, 255), ambient=Color3.fromRGB(48, 24, 88), atmosphere=Color3.fromRGB(40, 68, 195), decay=Color3.fromRGB(18, 8, 42)},
		{name="Aurora", tint=Color3.fromRGB(175, 255, 225), ambient=Color3.fromRGB(28, 82, 68), atmosphere=Color3.fromRGB(75, 225, 170), decay=Color3.fromRGB(42, 22, 92)},
		{name="Green", tint=Color3.fromRGB(165, 255, 165), ambient=Color3.fromRGB(35, 92, 42), atmosphere=Color3.fromRGB(78, 232, 98), decay=Color3.fromRGB(14, 48, 20)},
		{name="Blue", tint=Color3.fromRGB(57, 198, 255), ambient=Color3.fromRGB(12, 58, 118), atmosphere=Color3.fromRGB(27, 148, 255), decay=Color3.fromRGB(15, 30, 76)},
		{name="Red", tint=Color3.fromRGB(49, 128, 255), ambient=Color3.fromRGB(11, 28, 125), atmosphere=Color3.fromRGB(27, 72, 255), decay=Color3.fromRGB(10, 10, 68)},
		{name="Pink", tint=Color3.fromRGB(255, 175, 228), ambient=Color3.fromRGB(120, 38, 90), atmosphere=Color3.fromRGB(255, 98, 195), decay=Color3.fromRGB(62, 14, 48)},
		{name="Orange", tint=Color3.fromRGB(255, 195, 125), ambient=Color3.fromRGB(18, 58, 130), atmosphere=Color3.fromRGB(18, 135, 255), decay=Color3.fromRGB(6, 28, 68)},
		{name="Cyan", tint=Color3.fromRGB(145, 255, 255), ambient=Color3.fromRGB(8, 95, 105), atmosphere=Color3.fromRGB(20, 225, 240), decay=Color3.fromRGB(8, 48, 58)},
	}
	local function findStyle(name)
		for _, style in ipairs(styles) do
			if style.name == name then return style end
		end
		return styles[1]
	end
	local function clearSky()
		for _, name in ipairs({"GalaxySky", "CryonColorSky", "CryonSkyTint", "CryonSkyAtmosphere", "CryonSkyBloom"}) do
			local object = Lighting:FindFirstChild(name)
			if object then object:Destroy() end
		end
	end
	local function apply(styleName)
		local style = findStyle(styleName)
		clearSky()
		State.skyStyle = style.name
		State.darkModeEnabled = style.name ~= "Off"
		if style.name == "Off" then
			Lighting.Brightness = defaults.Brightness
			Lighting.ClockTime = defaults.ClockTime
			Lighting.ExposureCompensation = defaults.ExposureCompensation
			Lighting.OutdoorAmbient = defaults.OutdoorAmbient
			Lighting.Ambient = defaults.Ambient
			Lighting.FogColor = defaults.FogColor
			return style.name
		end
		local sky = Instance.new("Sky")
		sky.Name = "CryonColorSky"
		sky.SkyboxBk = "rbxassetid://159454299"
		sky.SkyboxDn = "rbxassetid://159454296"
		sky.SkyboxFt = "rbxassetid://159454293"
		sky.SkyboxLf = "rbxassetid://159454286"
		sky.SkyboxRt = "rbxassetid://159454289"
		sky.SkyboxUp = "rbxassetid://159454291"
		sky.StarCount = 3000
		sky.Parent = Lighting
		local correction = Instance.new("ColorCorrectionEffect")
		correction.Name = "CryonSkyTint"
		correction.TintColor = style.tint
		correction.Brightness = 0.05
		correction.Contrast = 0.16
		correction.Saturation = 0.12
		correction.Parent = Lighting
		local atmosphere = Instance.new("Atmosphere")
		atmosphere.Name = "CryonSkyAtmosphere"
		atmosphere.Color = style.atmosphere
		atmosphere.Decay = style.decay
		atmosphere.Density = 0.20
		atmosphere.Offset = 0.05
		atmosphere.Glare = style.name == "Aurora" and 0.42 or 0.2
		atmosphere.Haze = style.name == "Aurora" and 1.55 or 0.85
		atmosphere.Parent = Lighting
		local bloom = Instance.new("BloomEffect")
		bloom.Name = "CryonSkyBloom"
		bloom.Intensity = style.name == "Aurora" and 0.62 or 0.42
		bloom.Size = 28
		bloom.Threshold = 1.05
		bloom.Parent = Lighting
		Lighting.Brightness = 1.45
		Lighting.ClockTime = 0
		Lighting.ExposureCompensation = 0.10
		Lighting.OutdoorAmbient = style.ambient
		Lighting.Ambient = style.ambient:Lerp(Color3.fromRGB(12, 12, 12), 0.16)
		Lighting.FogColor = style.atmosphere:Lerp(Color3.fromRGB(8, 8, 8), 0.05)
		return style.name
	end
	local names = {}
	for _, style in ipairs(styles) do table.insert(names, style.name) end
	setSkySelectorVisual = State.rowCycleSelector("performance y settings", "Sky Color", names, State.skyStyle or "Off", function(styleName)
		apply(styleName)
	end)
	setSkyStyle = function(styleName)
		local applied = apply(styleName)
		if setSkySelectorVisual then setSkySelectorVisual(applied, false) end
		return applied
	end
	setDarkMode = function(on)
		return setSkyStyle(on and ((State.skyStyle and State.skyStyle ~= "Off") and State.skyStyle or "Galaxy") or "Off")
	end
end

setNoIntroToggle = State.rowToggle("performance y settings", "No Intro", "Desactiva la intro al volver a ejecutar", State.noIntro == true, function(on)
    State.noIntro = on == true
    State.introEnabled = not State.noIntro
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

State.makeSecHeader("performance y settings", "Interface & Binds")

uiScaleBox = State.rowInput("performance y settings", "UI Scale", nil, uiScaleValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 50, 150)
	uiScaleValue = n
	if mainUIScale then mainUIScale.Scale = n / 100 end
	if uiScaleBox then uiScaleBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

buttonsSizeBox = State.rowInput("performance y settings", "Buttons Size", "0 = mínimo • 100 = máximo", State.buttonsSizeValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 0, 100)
	applyMobileButtonsSize(n)
	if buttonsSizeBox then buttonsSizeBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

State._buttonsShapeSelectorVisual = State.rowCycleSelector(
	"performance y settings",
	"Buttons Shape",
	{"Circle", "Normal", "Square", "Rectangle"},
	State.buttonsShape,
	function(shapeName)
		applyMobileButtonsShape(shapeName)
	end
)

State.rowKBOnly("performance y settings", "Hide / Show GUI", nil, KB.GuiHide, function(k) KB.GuiHide.kb=k end)

setHideButtonsVisual = State.rowToggle("performance y settings", "Hide Buttons", "Oculta todos los botones flotantes", false, function(on)
	State.hideButtonsEnabled = on
	local visible = not on

	if MobilePanel then MobilePanel.Visible = visible end
	for _, mobileBtn in pairs(mobileButtonsByName) do
		if mobileBtn and mobileBtn.Parent then
			mobileBtn.Visible = visible
		end
	end

	if btnBatV2 then btnBatV2.Visible = visible end
	if btnInstaReset then btnInstaReset.Visible = visible end
	if pbFrame then pbFrame.Visible = visible end

	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

setLockUIVisual = State.rowToggle("performance y settings", "Lock UI", nil, false, function(on)
	uiLocked = on
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

local saveBtn; saveBtn = State.rowActionBtn("performance y settings", "Save Config", function()
	if saveConfig then
		local ok, saved = pcall(saveConfig, saveBtn)
		if (not ok or saved ~= true) and State._lastSaveError then
			warn("[CRYON AUTO SAVE] " .. tostring(State._lastSaveError))
		end
	elseif State.savePositionBackup then
		local saved = State.savePositionBackup()
		if saveBtn and saveBtn.Parent then
			local previous = saveBtn.Text
			saveBtn.Text = saved and "Positions Saved!" or "Save Failed!"
			task.delay(1.5, function()
				if saveBtn and saveBtn.Parent then saveBtn.Text = previous end
			end)
		end
	end
end)
State.rowActionBtn("performance y settings", "Reset Mobile Buttons", function()
    if resetMobileButtons then
        resetMobileButtons()
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5,-190,1,-58)
    end
    if setAutoGrab then
        setAutoGrab(false)
    end
end)

end

State.buildBackgroundPage = function()
	State.makeSecHeader("performance y settings", "Background Images")

	local infoCard = State.baseCard("performance y settings", 46)
	State.cLabel(infoCard, "Choose a background", 10, 250, 11, LABEL_TEXT, Enum.Font.GothamBold)
	local infoSub = State.cLabel(infoCard, "Tap an image to apply and save it", 10, 280, 9, LABEL_SUB, Enum.Font.Gotham)
	infoSub.Size = UDim2.new(1, -20, 0, 14)
	infoSub.Position = UDim2.new(0, 10, 0, 25)

	local grid = Instance.new("Frame", State.pg("performance y settings"))
	grid.Name = "BackgroundImageGrid"
	grid.Size = UDim2.new(1, -4, 0, 266)
	grid.BackgroundTransparency = 1
	grid.BorderSizePixel = 0
	grid.ClipsDescendants = true
	grid.LayoutOrder = State.lo("performance y settings")
	grid.ZIndex = 4

	local layout = Instance.new("UIGridLayout", grid)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.FillDirectionMaxCells = 2
	layout.CellSize = UDim2.new(0.5, -5, 0, 80)
	layout.CellPadding = UDim2.new(0, 8, 0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top

	for index, assetId in ipairs(State.backgroundAssetIds) do
		local thumb = Instance.new("ImageButton", grid)
		thumb.Name = "BackgroundImage" .. tostring(index)
		thumb.LayoutOrder = index
		thumb.BackgroundColor3 = Color3.fromRGB(16, 0, 0)
		thumb.BackgroundTransparency = 0.05
		thumb.BorderSizePixel = 0
		thumb.AutoButtonColor = false
		thumb.ClipsDescendants = true
		thumb.Image = (State.menuBackgroundAssets and State.menuBackgroundAssets[assetId]) or ""
        State.menuBackgroundThumbs[index] = thumb
		thumb.ImageTransparency = 0.08
		thumb.ScaleType = Enum.ScaleType.Crop
		thumb.ZIndex = 6
		Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 12)

		local thumbStroke = Instance.new("UIStroke", thumb)
		thumbStroke.Color = BORDER
		thumbStroke.Thickness = 1

		local badge = Instance.new("TextLabel", thumb)
		badge.AnchorPoint = Vector2.new(1, 1)
		badge.Size = UDim2.new(0, 28, 0, 18)
		badge.Position = UDim2.new(1, -5, 1, -5)
		badge.BackgroundColor3 = Color3.fromRGB(16, 0, 0)
		badge.BackgroundTransparency = 0.08
		badge.BorderSizePixel = 0
		badge.Text = tostring(index)
		badge.TextColor3 = WHITE
		badge.Font = Enum.Font.GothamBlack
		badge.TextSize = 9
		badge.ZIndex = 8
		Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)

		State.imageChoiceVisuals[assetId] = {stroke=thumbStroke, badge=badge, index=index}
		thumb.Activated:Connect(function()
			State.applyBackgroundImage(assetId, true)
		end)
	end

	State.applyBackgroundImage(State.backgroundAssetId, false)
end
State.buildBackgroundPage()
State.buildBackgroundPage = nil

State.makeSecHeader("musica", "Songs")

do
	local songParent = game:GetService("CoreGui")
	local starterGui = game:GetService("StarterGui")
	local assetFunction = getcustomasset or getsynasset

	local function notifySong(title, message)
		warn("[CRYON " .. string.upper(title) .. "] " .. tostring(message))
		pcall(function()
			starterGui:SetCore("SendNotification", {
				Title = title,
				Text = tostring(message),
				Duration = 6
			})
		end)
	end

	local function fileExists(path)
		if type(isfile) ~= "function" then
			return false
		end
		local ok, exists = pcall(isfile, path)
		return ok and exists == true
	end

	local function validAudio(data)
		if type(data) ~= "string" or #data < 2048 then
			return false
		end
		local header = data:sub(1, 256):lower()
		return not (
			header:find("<html", 1, true)
			or header:find("<!doctype", 1, true)
			or header:find("access denied", 1, true)
			or header:find("not found", 1, true)
			or header:find("error", 1, true)
		)
	end

	local function downloadAudio(url, path)
		if type(writefile) ~= "function" then
			return false, "writefile no está disponible"
		end

		local data, lastError
		local requestFunction = request
			or http_request
			or (syn and syn.request)
			or (fluxus and fluxus.request)

		if type(requestFunction) == "function" then
			local ok, response = pcall(requestFunction, {
				Url = url,
				Method = "GET",
				Headers = {
					["User-Agent"] = "Mozilla/5.0",
					["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8"
				}
			})
			if ok and type(response) == "table" then
				local code = tonumber(response.StatusCode or response.Status or response.status_code) or 0
				local body = response.Body or response.body
				if (code == 0 or (code >= 200 and code < 300)) and validAudio(body) then
					data = body
				else
					lastError = "respuesta HTTP inválida (" .. tostring(code) .. ")"
				end
			elseif not ok then
				lastError = tostring(response)
			end
		end

		if not data then
			local ok, result = pcall(function()
				return game:HttpGet(url, true)
			end)
			if ok and validAudio(result) then
				data = result
			elseif not ok then
				lastError = tostring(result)
			elseif not lastError then
				lastError = "el enlace no devolvió un MP3 válido"
			end
		end

		if not data then
			return false, lastError or "no se pudo descargar el audio"
		end

		local folder = path:match("^(.*)/[^/]+$")
		if folder and type(isfolder) == "function" and type(makefolder) == "function" then
			local folderOk, exists = pcall(isfolder, folder)
			if not folderOk or not exists then pcall(makefolder, folder) end
		end
		local ok, err = pcall(writefile, path, data)
		if not ok then
			return false, tostring(err)
		end
		return true
	end

	local function addSong(config)
		local sound
		local wantedOn = false
		local preparing = false
		local started = false
		local loadedConnection

		local function destroySound()
			if loadedConnection then
				loadedConnection:Disconnect()
				loadedConnection = nil
			end
			if sound then
				pcall(function() sound:Destroy() end)
				sound = nil
			end
			started = false
		end

		local function createSound()
			if type(assetFunction) ~= "function" then
				return false, "getcustomasset/getsynasset no está disponible"
			end

			local ok, assetId = pcall(assetFunction, config.file)
			if not ok or type(assetId) ~= "string" or assetId == "" then
				return false, "el archivo local todavía no está disponible"
			end

			destroySound()
			sound = Instance.new("Sound")
			sound.Name = config.soundName
			sound.SoundId = assetId
			sound.Volume = config.volume
			sound.Looped = true
			sound.Parent = songParent

			if config.startAt and config.startAt > 0 then
				pcall(function() sound.TimePosition = config.startAt end)
				loadedConnection = sound.Loaded:Connect(function()
					if loadedConnection then
						loadedConnection:Disconnect()
						loadedConnection = nil
					end
					if sound and sound.Parent then
						pcall(function() sound.TimePosition = config.startAt end)
					end
				end)
			end
			return true
		end

		local function playNow()
			if not sound or not sound.Parent then
				return
			end
			if started then
				local ok = pcall(function() sound:Resume() end)
				if not ok then
					pcall(function() sound:Play() end)
				end
			else
				if config.startAt and config.startAt > 0 then
					pcall(function() sound.TimePosition = config.startAt end)
				end
				pcall(function() sound:Play() end)
				started = true
			end
		end

		local function prepare()
			if sound and sound.Parent then
				if wantedOn then playNow() end
				return
			end
			if preparing then return end
			preparing = true

			local folder = config.file:match("^(.*)/[^/]+$")
			if folder and type(isfolder) == "function" and type(makefolder) == "function" then
				local folderOk, exists = pcall(isfolder, folder)
				if not folderOk or not exists then pcall(makefolder, folder) end
			end
			local alreadyDownloaded = fileExists(config.file)
			local created = select(1, createSound())

			if not created then
				if not alreadyDownloaded then
					notifySong(config.title, "Descargando " .. config.title .. " por primera vez...")
				end
				local downloaded, downloadError = downloadAudio(config.url, config.file)
				if not downloaded then
					preparing = false
					if config.notifications then
						notifySong(config.title, "No se pudo descargar: " .. tostring(downloadError))
					else
						warn("[CRYON SONGS] " .. config.title .. ": " .. tostring(downloadError))
					end
					return
				end
				local okCreate, createError = createSound()
				if not okCreate then
					preparing = false
					if config.notifications then
						notifySong(config.title, tostring(createError))
					else
						warn("[CRYON SONGS] " .. config.title .. ": " .. tostring(createError))
					end
					return
				end
			end

			preparing = false
			if wantedOn then playNow() end
		end

		if fileExists(config.file) then
			task.defer(function()
				if not sound then
					createSound()
				end
			end)
		end

		State.rowToggle("musica", config.title, nil, false, function(on)
			wantedOn = on
			if on then
				if sound and sound.Parent then
					playNow()
				else
					task.spawn(prepare)
				end
			elseif sound then
				pcall(function() sound:Pause() end)
			end
		end)
	end

	local songs = {
		{
			title = "Tuff Song",
			url = "https://files.catbox.moe/rvf2vy.mp3",
			file = "tuffsong.mp3",
			soundName = "CRYON_TuffSong",
			volume = 0.75
		},
		{
			title = "orula",
			url = "https://files.catbox.moe/v20ko9.mp3",
			file = "friosong.mp3",
			soundName = "CRYON_Orula",
			volume = 0.85
		},
		{
			title = "to the O",
			url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3",
			file = "overseer_to_the_o_filegarden.mp3",
			soundName = "CRYON_ToTheO",
			volume = 0.75,
			notifications = true
		},
		{
			title = "LAJA",
			url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3",
			file = "overseer_laja_nadie_ta_frio_filegarden.mp3",
			soundName = "CRYON_LAJA",
			volume = 0.75,
			notifications = true
		},
		{
			title = "Lucid Dreams",
			url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3",
			file = "overseer_lucid_dreams_filegarden.mp3",
			soundName = "CRYON_LucidDreams",
			volume = 0.75,
			notifications = true
		},
		{
			title = "NUTS",
			url = "https://archive.org/download/li-l-peep-nuts-feat.-lil-skil-extended_202011/LiL%20PEEP%20-%20nuts%20%28feat.%20lil%20skil%29%20%28Extended%29.mp3",
			file = "mvp_nuts_lilpeep.mp3",
			soundName = "MVP_NUTS",
			volume = 0.75,
			notifications = true
		},
		{
			title = "Cinderella",
			url = "https://ia801000.us.archive.org/29/items/macmiller_202012/Cinderella.mp3",
			file = "mvp_cinderella_macmiller_v3.mp3",
			soundName = "MVP_Cinderella",
			volume = 1,
			startAt = 125,
			notifications = true
		},
		{ title = 'MUSIC 1', url = 'https://files.catbox.moe/1gnx94', file = 'MOYA_FRHUBV2_music1.mp3', soundName = 'MOYA_FRHUB_MUSIC1', volume = 0.8 },
		{ title = 'MUSIC 2', url = 'https://files.catbox.moe/deh4xy', file = 'MOYA_FRHUBV2_music2.mp3', soundName = 'MOYA_FRHUB_MUSIC2', volume = 0.8 },
		{ title = 'MUSIC 3', url = 'https://files.catbox.moe/e7vb4x', file = 'MOYA_FRHUBV2_music3.mp3', soundName = 'MOYA_FRHUB_MUSIC3', volume = 0.8 },
		{ title = 'MUSIC 4', url = 'https://files.catbox.moe/htn746.mp3', file = 'MOYA_FRHUBV2_music9999.mp3', soundName = 'MOYA_FRHUB_MUSIC4', volume = 0.8 },
		{ title = 'MUSIC 5', url = 'https://files.catbox.moe/licyuc', file = 'MOYA_FRHUBV2_music5.mp3', soundName = 'MOYA_FRHUB_MUSIC5', volume = 0.8 },
		{ title = 'MUSIC 6', url = 'https://files.catbox.moe/inw6gz', file = 'MOYA_FRHUBV2_music6.mp3', soundName = 'MOYA_FRHUB_MUSIC6', volume = 0.8 },
		{ title = 'MUSIC 7', url = 'https://files.catbox.moe/acr8rq.mp3', file = 'MOYA_FRHUBV2_music77.mp3', soundName = 'MOYA_FRHUB_MUSIC7', volume = 0.8 },
		{ title = 'MUSIC 8', url = 'https://files.catbox.moe/o2catb.mp3', file = 'MOYA_FRHUBV2_music88.mp3', soundName = 'MOYA_FRHUB_MUSIC8', volume = 0.8 },
		{ title = 'MUSIC 9', url = 'https://files.catbox.moe/ho6ckb.mp3', file = 'MOYA_FRHUBV2_music012.mp3', soundName = 'MOYA_FRHUB_MUSIC9', volume = 0.8 },
		{ title = 'MUSIC 10', url = 'https://files.catbox.moe/unxh2x.mp3', file = 'MOYA_FRHUBV2_music10.mp3', soundName = 'MOYA_FRHUB_MUSIC10', volume = 0.8 },
		{ title = 'MUSIC 11', url = 'https://files.catbox.moe/2spai8.mp3', file = 'MOYA_FRHUBV2_music11.mp3', soundName = 'MOYA_FRHUB_MUSIC11', volume = 0.8 },
		{ title = 'MUSIC 12', url = 'https://files.catbox.moe/jqwicu.mp3', file = 'MOYA_FRHUBV2_music12.mp3', soundName = 'MOYA_FRHUB_MUSIC12', volume = 0.8 },
		{ title = 'MUSIC 13', url = 'https://files.catbox.moe/b5w9ij.mp3', file = 'MOYA_FRHUBV2_music13.mp3', soundName = 'MOYA_FRHUB_MUSIC13', volume = 0.8 },
		{ title = 'MUSIC 14', url = 'https://files.catbox.moe/le430v.mp3', file = 'MOYA_FRHUBV2_music14.mp3', soundName = 'MOYA_FRHUB_MUSIC14', volume = 0.8 },
		{ title = 'MUSIC 15', url = 'https://files.catbox.moe/og1t30.mp3', file = 'MOYA_FRHUBV2_music011.mp3', soundName = 'MOYA_FRHUB_MUSIC15', volume = 0.8 },
		{ title = 'MUSIC 16', url = 'https://files.catbox.moe/9xv9k3.mp3', file = 'MOYA_FRHUBV2_music16.mp3', soundName = 'MOYA_FRHUB_MUSIC16', volume = 0.8 },
		{ title = 'MUSIC 17', url = 'https://files.catbox.moe/239it7.mp3', file = 'MOYA_FRHUBV2_music010.mp3', soundName = 'MOYA_FRHUB_MUSIC17', volume = 0.8 },
		{ title = 'MUSIC 18', url = 'https://files.catbox.moe/z54fyk.mp3', file = 'MOYA_FRHUBV2_music18.mp3', soundName = 'MOYA_FRHUB_MUSIC18', volume = 0.8 },
		{ title = 'MUSIC 19', url = 'https://files.catbox.moe/n4bcdp.mp3', file = 'MOYA_FRHUBV2_music190.mp3', soundName = 'MOYA_FRHUB_MUSIC19', volume = 0.8 },
		{ title = 'MUSIC 20', url = 'https://files.catbox.moe/ksnctq.mp3', file = 'MOYA_FRHUBV2_music201.mp3', soundName = 'MOYA_FRHUB_MUSIC20', volume = 0.8 },
		{ title = 'MUSIC 21', url = 'https://files.catbox.moe/az9duq.mp3', file = 'MOYA_FRHUBV2_music21.mp3', soundName = 'MOYA_FRHUB_MUSIC21', volume = 0.8 },
		{ title = 'MUSIC 22', url = 'https://files.catbox.moe/0ftuu3.mp3', file = 'MOYA_FRHUBV2_music22.mp3', soundName = 'MOYA_FRHUB_MUSIC22', volume = 0.8 },
		{ title = 'MUSIC 23', url = 'https://files.catbox.moe/018oqx.mp3', file = 'MOYA_FRHUBV2_music23.mp3', soundName = 'MOYA_FRHUB_MUSIC23', volume = 0.8 },
		{ title = 'MUSIC 24', url = 'https://files.catbox.moe/mxc7hc.mp3', file = 'MOYA_FRHUBV2_music223.mp3', soundName = 'MOYA_FRHUB_MUSIC24', volume = 0.8 },
		{ title = 'MUSIC 25', url = 'https://file.garden/amIulMQeMk0LFM1n/ssstik.io_1788396946727.mp3', file = 'MOYA_FRHUBV2_music890.mp3', soundName = 'MOYA_FRHUB_MUSIC25', volume = 0.8 },
		{ title = 'MUSIC 26', url = 'https://file.garden/amIulMQeMk0LFM1n/ssstik.io_1788396968661.mp3', file = 'MOYA_FRHUBV2_music891.mp3', soundName = 'MOYA_FRHUB_MUSIC26', volume = 0.8 },
		{ title = 'MUSIC 27', url = 'https://file.garden/amIulMQeMk0LFM1n/ssstik.io_1788397021355.mp3', file = 'MOYA_FRHUBV2_music892.mp3', soundName = 'MOYA_FRHUB_MUSIC27', volume = 0.8 },
		{ title = 'MUSIC 28', url = 'https://litter.catbox.moe/qld6f8.mp3', file = 'MOYA_FRHUBV2_music28_ggqvwz_fixed.mp3', soundName = 'MOYA_FRHUB_MUSIC28', volume = 0.8 },
		{ title = 'MUSIC 29', url = 'https://litter.catbox.moe/fqfg1t.mp3', file = 'MOYA_FRHUBV2_music29_aeiqz5_fixed.mp3', soundName = 'MOYA_FRHUB_MUSIC29', volume = 0.8 },
		{ title = 'MUSIC 30', url = 'https://litter.catbox.moe/2jp1d0.mp3', file = 'MOYA_FRHUBV2_music30_7rikvc_fixed.mp3', soundName = 'MOYA_FRHUB_MUSIC30', volume = 0.8 },
		{ title = 'MUSIC 31', url = 'https://litter.catbox.moe/rwhyq4.mp3', file = 'MOYA_FRHUBV2_music31_29k9ju_fixed.mp3', soundName = 'MOYA_FRHUB_MUSIC31', volume = 0.8 },
		{ title = 'MUSIC 32', url = 'https://files.catbox.moe/3r1cvd.mp4', file = 'MOYA_FRHUBV2_music331_29k9ju_fixed.mp3', soundName = 'MOYA_FRHUB_MUSIC32', volume = 0.8 },
		{ title = 'MUSIC 33', url = 'https://files.catbox.moe/5p7by7.mp4', file = 'MOYA_FRHUBV2_music316767_29k9ju_fixed.mp3', soundName = 'MOYA_FRHUB_MUSIC33', volume = 0.8 }
	}

	for _, config in ipairs(songs) do
		addSong(config)
	end
end

do
	local BTN_SIZE = 60
	local BTN_GAP  = 12
	local PADDING  = 6
	MobilePanel = Instance.new("Frame")
	MobilePanel.Name = "MobileButtonsPanel"
	MobilePanel.Size = UDim2.new(0, PADDING * 2 + 3 * BTN_SIZE + 2 * BTN_GAP, 0, PADDING * 2 + 4 * BTN_SIZE + 3 * BTN_GAP)
	MobilePanel.Position = UDim2.new(1, -140, 0, 10)
	MobilePanel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	MobilePanel.BackgroundTransparency = 1
	MobilePanel.BorderSizePixel = 0
	MobilePanel.ZIndex = 95
	MobilePanel.Parent = gui

	local Q_OFF      = Color3.fromRGB(0, 0, 0)
	local Q_ON       = Color3.fromRGB(95, 0, 150)   -- morado cuando está activo / tocado
	local Q_TEXT_OFF = Color3.fromRGB(180, 40, 255)
	local Q_TEXT_ON  = Color3.fromRGB(255, 220, 255) -- texto más claro sobre el fondo morado

	State._purpleAnimatedButtons = State._purpleAnimatedButtons or {}
	State._purpleAnimationPeriod = 5.5

	local purpleTextPalette = {
		Color3.fromRGB(180, 40, 255),
		Color3.fromRGB(160, 20, 240),
		Color3.fromRGB(210, 80, 255),
		Color3.fromRGB(140, 0, 220),
		Color3.fromRGB(200, 60, 255),
		Color3.fromRGB(180, 40, 255),
	}

	local function paletteColor(palette, progress)
		local count = #palette
		if count == 0 then return Color3.fromRGB(255, 55, 55) end
		if count == 1 then return palette[1] end
		progress = progress % 1
		local scaled = progress * count
		local index = math.floor(scaled) + 1
		local nextIndex = (index % count) + 1
		local alpha = scaled - math.floor(scaled)
		alpha = alpha * alpha * (3 - 2 * alpha)
		return palette[index]:Lerp(palette[nextIndex], alpha)
	end

	State._registerPurpleAnimatedButton = function(button)
		if not button then return end
		button:SetAttribute("PurpleActive", false)
		button:SetAttribute("PurpleFlash", false)
		button.BackgroundColor3 = Q_OFF
		button.TextColor3 = Q_TEXT_OFF
		State._purpleAnimatedButtons[button] = {
			background = button.BackgroundColor3,
			text = button.TextColor3,
		}
	end

	if not State._purpleAnimationStarted then
		State._purpleAnimationStarted = true
		task.spawn(function()
			local lastClock = os.clock()
			while gui and gui.Parent do
				local now = os.clock()
				local dt = math.min(now - lastClock, 0.1)
				lastClock = now
				local progress = (now / State._purpleAnimationPeriod) % 1
				local animatedRed = paletteColor(purpleTextPalette, progress)
				local blend = 1 - math.exp(-dt * 8)

				for button, visual in pairs(State._purpleAnimatedButtons) do
					if button and button.Parent then
						local active = button:GetAttribute("PurpleActive") == true
						local flash = button:GetAttribute("PurpleFlash") == true
						local targetBackground
						local targetText

						if active or flash then
							targetBackground = Q_ON
							targetText = Q_TEXT_ON
						else
							targetBackground = Q_OFF
							targetText = Q_TEXT_OFF
						end

						visual.background = visual.background:Lerp(targetBackground, blend)
						visual.text = visual.text:Lerp(targetText, blend)
						button.BackgroundColor3 = visual.background
						button.TextColor3 = visual.text
						local shine = State._redShineLabels and State._redShineLabels[button]
						if shine then shine.TextColor3 = visual.text end
					else
						State._purpleAnimatedButtons[button] = nil
					end
				end

				RunService.RenderStepped:Wait()
			end
		end)
	end


	State._redShineLabels = State._redShineLabels or {}
	State._redShineGradients = State._redShineGradients or {}

	local function attachRedTextShine(button)
		if not button or button:FindFirstChild("RedTextShine") then return end

		button.TextTransparency = 1

		local shineText = Instance.new("TextLabel")
		shineText.Name = "RedTextShine"
		shineText.BackgroundTransparency = 1
		shineText.BorderSizePixel = 0
		shineText.Size = UDim2.fromScale(1, 1)
		shineText.Position = UDim2.fromScale(0, 0)
		shineText.Text = button.Text
		shineText.TextColor3 = Color3.fromRGB(180, 40, 255)
		shineText.TextTransparency = 0
		shineText.TextScaled = button.TextScaled
		shineText.TextSize = button.TextSize
		shineText.Font = button.Font
		shineText.TextWrapped = button.TextWrapped
		shineText.LineHeight = button.LineHeight
		shineText.TextXAlignment = button.TextXAlignment
		shineText.TextYAlignment = button.TextYAlignment
		shineText.ZIndex = button.ZIndex + 1
		shineText.Active = false
		shineText.Selectable = false
		shineText.Parent = button

		local shineGradient = Instance.new("UIGradient")
		shineGradient.Name = "CleanPurpleShine"
		shineGradient.Rotation = 0
		shineGradient.Offset = Vector2.new(-1.25, 0)
		shineGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 0, 180)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(170, 30, 240)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(220, 100, 255)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(180, 50, 255)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(120, 0, 180)),
		})
		shineGradient.Parent = shineText

		State._redShineLabels[button] = shineText
		State._redShineGradients[button] = shineGradient

		-- Actualiza únicamente cuando cambia una propiedad; no revisa cada frame.
		button:GetPropertyChangedSignal("Text"):Connect(function()
			if shineText.Parent then shineText.Text = button.Text end
		end)
		button:GetPropertyChangedSignal("Visible"):Connect(function()
			if shineText.Parent then shineText.Visible = button.Visible end
		end)
		button:GetPropertyChangedSignal("TextSize"):Connect(function()
			if shineText.Parent then shineText.TextSize = button.TextSize end
		end)
		button:GetPropertyChangedSignal("ZIndex"):Connect(function()
			if shineText.Parent then shineText.ZIndex = button.ZIndex + 1 end
		end)
	end

	-- Un solo brillo activo a la vez. Evita múltiples tweens infinitos simultáneos.
	if not State._redShineSequenceStarted then
		State._redShineSequenceStarted = true
		task.spawn(function()
			while gui and gui.Parent do
				local animatedAny = false
				for button, gradient in pairs(State._redShineGradients) do
					if not (gui and gui.Parent) then break end
					if button and button.Parent and gradient and gradient.Parent and button.Visible then
						animatedAny = true
						gradient.Offset = Vector2.new(-1.25, 0)
						local tween = TweenService:Create(
							gradient,
							TweenInfo.new(1.45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
							{Offset = Vector2.new(1.25, 0)}
						)
						tween:Play()
						tween.Completed:Wait()
						task.wait(0.06)
					elseif button and not button.Parent then
						State._redShineLabels[button] = nil
						State._redShineGradients[button] = nil
					end
				end
				if not animatedAny then task.wait(0.5) else task.wait(0.8) end
			end
		end)
	end

	local function createMobileButton(name, displayText, col, row, isToggle, onAction)
		local xPos = PADDING + col * (BTN_SIZE + BTN_GAP)
		local yPos = PADDING + row * (BTN_SIZE + BTN_GAP)

		local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. name
		btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
		local defaultPos = UDim2.new(1, -140 + xPos, 0, 10 + yPos)
		btn.Position = defaultPos
		btn.BackgroundColor3 = Q_OFF
		btn.Text = displayText
		btn.TextColor3 = Q_TEXT_OFF
		btn.TextScaled = false; btn.TextSize = 11
		btn.Font = Enum.Font.GothamBold
		btn.TextWrapped = true; btn.LineHeight = 1.2
		btn.BorderSizePixel = 0; btn.AutoButtonColor = false
		btn.ZIndex = 99
		btn.Parent = gui
		State._registerPurpleAnimatedButton(btn)
		attachRedTextShine(btn)
		mobileButtonsByName[name] = btn
		mobileButtonDefaultPositions[name] = defaultPos
		State.makeDraggable(btn)
		btn.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if State.requestConfigSave then State.requestConfigSave() end
			end
		end)
		Instance.new("UICorner", btn).Name = "ButtonShapeCorner"

		local mobileStroke = Instance.new("UIStroke")
		mobileStroke.Name = "RedOuterStroke"
		mobileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		mobileStroke.Color = Color3.fromRGB(0, 0, 0)
		mobileStroke.Thickness = 1.1
		mobileStroke.Transparency = 0.15
		mobileStroke.LineJoinMode = Enum.LineJoinMode.Round
		mobileStroke.Parent = btn

		applyMobileButtonsSize(State.buttonsSizeValue)

		local isOn = false
		local function setter(s)
			isOn = s
			btn:SetAttribute("PurpleActive", s == true)
		end

		local function flash()
			btn:SetAttribute("PurpleFlash", true)
			task.delay(0.55, function()
				if btn and btn.Parent then
					btn:SetAttribute("PurpleFlash", false)
				end
			end)
		end

		btn.Activated:Connect(function()
			if isToggle then
				isOn = not isOn; setter(isOn)
				if onAction then onAction(isOn) end
			else
				flash()
				if onAction then onAction() end
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)

		return btn, setter
	end

	createMobileButton("Drop", "DROP\nBR", 0, 0, false, function() task.spawn(State.runDrop) end)

	btnBatV2 = Instance.new("TextButton")
	btnBatV2.Name = "Btn_BatnV2"
	btnBatV2.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	btnBatV2.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING)
	btnBatV2.BackgroundColor3 = Q_OFF
	btnBatV2.Text = "BAT V2"
	btnBatV2.TextColor3 = Q_TEXT_OFF
	btnBatV2.TextScaled = false; btnBatV2.TextSize = 11
	btnBatV2.Font = Enum.Font.GothamBold
	btnBatV2.TextWrapped = true; btnBatV2.LineHeight = 1.2
	btnBatV2.BorderSizePixel = 0; btnAutoButtonColor = false
	btnBatV2.ZIndex = 100
	btnBatV2.Parent = gui
	State._registerPurpleAnimatedButton(btnBatV2)
	attachRedTextShine(btnBatV2)
	Instance.new("UICorner", btnBatV2).Name = "ButtonShapeCorner"
	local batV2Stroke = Instance.new("UIStroke")
	batV2Stroke.Name = "RedOuterStroke"
	batV2Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	batV2Stroke.Color = Color3.fromRGB(0, 0, 0)
	batV2Stroke.Thickness = 1.1
	batV2Stroke.Transparency = 0.15
	batV2Stroke.LineJoinMode = Enum.LineJoinMode.Round
	batV2Stroke.Parent = btnBatV2
	applyMobileButtonsSize(State.buttonsSizeValue)

	State.makeDraggable(btnBatV2)
	btnBatV2.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)

	State._batV2On = false
	State._setBatV2Visual = function(s)
		State._batV2On = s
		btnBatV2:SetAttribute("PurpleActive", s == true)
		if autoBatV2SetVisual then autoBatV2SetVisual(s) end
	end

	btnBatV2.Activated:Connect(function()
		State._batV2On = not State._batV2On
		State._setBatV2Visual(State._batV2On)
		State.autoBatV2Enabled = State._batV2On
		if State._batV2On then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; State.stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; State.stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if startBatAimbotV2 then startBatAimbotV2() end
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	local oldAutoBatV2SetVisual = autoBatV2SetVisual
	autoBatV2SetVisual = function(on)
		State._batV2On = on
		btnBatV2:SetAttribute("PurpleActive", on == true)
		if oldAutoBatV2SetVisual then oldAutoBatV2SetVisual(on) end
	end
	mobileBatV2SetActive = function(on) autoBatV2SetVisual(on) end

	btnInstaReset = Instance.new("TextButton")
	btnInstaReset.Name = "Btn_InstaReset"
	btnInstaReset.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	btnInstaReset.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING + BTN_SIZE + BTN_GAP)
	btnInstaReset.BackgroundColor3 = Q_OFF
	btnInstaReset.Text = "INSTA\nRESET"
	btnInstaReset.TextColor3 = Q_TEXT_OFF
	btnInstaReset.TextScaled = false; btnInstaReset.TextSize = 11
	btnInstaReset.Font = Enum.Font.GothamBold
	btnInstaReset.TextWrapped = true; btnInstaReset.LineHeight = 1.2
	btnInstaReset.BorderSizePixel = 0; btnInstaReset.AutoButtonColor = false
	btnInstaReset.ZIndex = 100
	btnInstaReset.Parent = gui
	State._registerPurpleAnimatedButton(btnInstaReset)
	attachRedTextShine(btnInstaReset)
	Instance.new("UICorner", btnInstaReset).Name = "ButtonShapeCorner"
	local instaResetStroke = Instance.new("UIStroke")
	instaResetStroke.Name = "RedOuterStroke"
	instaResetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	instaResetStroke.Color = Color3.fromRGB(0, 0, 0)
	instaResetStroke.Thickness = 1.1
	instaResetStroke.Transparency = 0.15
	instaResetStroke.LineJoinMode = Enum.LineJoinMode.Round
	instaResetStroke.Parent = btnInstaReset
	applyMobileButtonsSize(State.buttonsSizeValue)

	State.makeDraggable(btnInstaReset)
	btnInstaReset.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)

	btnInstaReset.Activated:Connect(function()
		btnInstaReset:SetAttribute("PurpleFlash", true)
		task.delay(0.55, function()
			if btnInstaReset and btnInstaReset.Parent then
				btnInstaReset:SetAttribute("PurpleFlash", false)
			end
		end)

		if setInstaToggleVisual then
			setInstaToggleVisual(true)
			task.delay(0.2, function() setInstaToggleVisual(false) end)
		end

		task.spawn(State.cursedInstaReset)
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	resetMobileButtons = function()
		for name, btn in pairs(mobileButtonsByName) do
			local defaultPos = mobileButtonDefaultPositions[name]
			if btn and defaultPos then btn.Position = defaultPos end
		end
		btnBatV2.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING)
		btnInstaReset.Position = UDim2.new(1, -140 - BTN_SIZE - BTN_GAP, 0, 10 + PADDING + BTN_SIZE + BTN_GAP)
		if State.requestPositionSave then State.requestPositionSave() end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	do
		local setter = select(2, createMobileButton("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(on)
			State.autoLeftEnabled = on
			if on then
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; State.stopAutoRight() end
				if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
				end
				local char = LP.Character
				local hum = char and char:FindFirstChild("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then State.startAutoLeft() end
			else
				State.stopAutoLeft()
			end
		end))
		local previous = autoLeftSetVisual
		autoLeftSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoLeftSetActive = function(on) autoLeftSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoLeft = setter end
	end

	do
		local setter = select(2, createMobileButton("AutoBat", "BAT\nAIMBOT", 0, 1, true, function(on)
			State.autoBatToggled = on
			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; State.stopAutoLeft() end
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; State.stopAutoRight() end
				if State._batV2On then
					State._batV2On = false
					State._setBatV2Visual(false)
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if stopBatAimbotV2 then stopBatAimbotV2() end
				end
				startBatAimbot()
			else
				stopBatAimbot()
			end
		end))
		local previous = autoBatSetVisual
		autoBatSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileBatV1SetActive = function(on) autoBatSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoBat = setter end
	end

	do
		local setter = select(2, createMobileButton("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(on)
			State.autoRightEnabled = on
			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; State.stopAutoLeft() end
				if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
				end
				local char = LP.Character
				local hum = char and char:FindFirstChild("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then State.startAutoRight() end
			else
				State.stopAutoRight()
			end
		end))
		local previous = autoRightSetVisual
		autoRightSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoRightSetActive = function(on) autoRightSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoRight = setter end
	end

	createMobileButton("TPDown", "TP\nDOWN", 0, 2, false, function() task.spawn(State.runTPDown) end)

	State._tpBatButton, State._tpBatSetter = createMobileButton("TPBat", "ANTI\nDESYNC", 0, 4, true, function(on)
		State._setTPBatEnabled(on)
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end)
	State._tpBatSetVisual = function(on)
		State._setTPBatEnabled(on)
		if State._tpBatSetter then State._tpBatSetter(on) end
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end

	do
		local setter = select(2, createMobileButton("Speed", "CARRY\nSPD", 1, 2, true, function(on)
			State.speedToggled = on
			if on then
				State.laggerToggled = false
				laggerPhase = 0
				if mobileLaggerSetActive then mobileLaggerSetActive(false) end
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry" end
			else
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
			end
		end))
		mobileSpeedSetActive = function(on) setter(on) end
	end

	do
		local setter = select(2, createMobileButton("AutoTP", "AUTO\nTP", 1, 3, true, function(on)
			autoTPDownEnabled = on
			if on then
				if State.startAutoTPDown then task.spawn(startAutoTPDown) end
			else
				if State.stopAutoTPDown then State.stopAutoTPDown() end
			end
		end))
		local previous = setAutoTPDownVisual
		setAutoTPDownVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoTPSetActive = function(on) setAutoTPDownVisual(on) end
	end

	do
		local s1, s2
		State._setLaggerPhase = function(phase)
			laggerPhase = phase
			State.laggerToggled = phase ~= 0
			if phase ~= 0 then
				State.speedToggled = false
				if mobileSpeedSetActive then mobileSpeedSetActive(false) end
			end
			if s1 then s1(phase == 1) end
			if s2 then s2(phase == 2) end
			if modeValLbl then
				modeValLbl.Text = phase == 1 and "Lagger 1" or (phase == 2 and "Lagger 2" or (State.speedToggled and "Carry" or "Normal"))
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end
		_, s1 = createMobileButton("Lagger", "LAGGER\n1", 0, 3, true, function(on)
			State._setLaggerPhase(on and 1 or (laggerPhase == 1 and 0 or laggerPhase))
		end)
		_, s2 = createMobileButton("Lagger2", "LAGGER\n2", 1, 4, true, function(on)
			State._setLaggerPhase(on and 2 or (laggerPhase == 2 and 0 or laggerPhase))
		end)
		mobileLaggerSetActive = function(on)
			if on then State._setLaggerPhase(laggerPhase == 2 and 2 or 1) else State._setLaggerPhase(0) end
		end
		mobileLaggerCarrySetActive = function(on)
			if on then State._setLaggerPhase(2) elseif laggerPhase == 2 then State._setLaggerPhase(0) end
		end
	end

	do
		local wasFrozen = false

		RunService.Heartbeat:Connect(function()
		local char = LP.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChild("Humanoid")
		if not hrp or not hum then return end

		local isCurrentlyFrozen = hrp.Anchored or hum.WalkSpeed == 0

		if isCurrentlyFrozen then
			if State.autoBatV2Enabled or State._batV2On then
				State._batV2On = false
				State._setBatV2Visual(false)
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if stopBatAimbotV2 then stopBatAimbotV2() end
			end

			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end

			if not wasFrozen then
				wasFrozen = true
				if State.autoLeftEnabled then State.stopAutoLeft() end
				if State.autoRightEnabled then State.stopAutoRight() end
			end
		else
			if wasFrozen then
				wasFrozen = false
				if State.autoLeftEnabled then State.startAutoLeft() end
				if State.autoRightEnabled then State.startAutoRight() end
			end
		end
		end)
	end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESP = {}

State.CreateESP = function(player)
    if player == LocalPlayer then return end
    if ESP[player] then return end

    local Line = Drawing.new("Line")
    Line.Color = Color3.fromRGB(170, 0, 0) -- Se mantiene la línea azul
    Line.Thickness = 0.1 -- Ultra delgada
    Line.Transparency = 0.7 -- Sutil transparencia
    Line.Visible = false

    local Distance = Drawing.new("Text")
    Distance.Color = Color3.fromRGB(0, 0, 16)
    Distance.Size = 11
    Distance.Center = true
    Distance.Outline = true
    Distance.Visible = false

    ESP[player] = {Line, Distance}
end

for _, v in ipairs(Players:GetPlayers()) do
    State.CreateESP(v)
end

Players.PlayerAdded:Connect(State.CreateESP)

Players.PlayerRemoving:Connect(function(player)
    if ESP[player] then
        for _, obj in ipairs(ESP[player]) do
            obj:Remove()
        end
        ESP[player] = nil
    end
    if player.Character then
        local hl = player.Character:FindFirstChild("HologramRed")
        if hl then hl:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera

    for player, objs in pairs(ESP) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")

        if State.linieEnabled and hrp and hum and head and hum.Health > 0 then
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

            local holo = char:FindFirstChild("HologramRed")
            if not holo then
                holo = Instance.new("Highlight")
                holo.Name = "HologramRed"
                holo.FillColor = Color3.fromRGB(0, 0, 29)  -- Rojo para el cuerpo
                holo.FillTransparency = 0.5
                holo.OutlineColor = Color3.fromRGB(0, 0, 38)  -- Rojo brillante para el borde
                holo.OutlineTransparency = 0.2
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Siempre al frente
                holo.Parent = char
            else
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end

            if visible then
                local distance = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - feetPos.Y)

                objs[1].Visible = true
                objs[1].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                objs[1].To = Vector2.new(pos.X, pos.Y)

                objs[2].Visible = true
                objs[2].Position = Vector2.new(pos.X, pos.Y - height / 2 - 16)
                objs[2].Text = distance .. " Studs"

            else
                for _, obj in ipairs(objs) do
                    obj.Visible = false
                end
            end
        else
            if char then
                local hl = char:FindFirstChild("HologramRed")
                if hl then hl:Destroy() end
            end
            for _, obj in ipairs(objs) do
                obj.Visible = false
            end
        end
    end
end)

State._positionConfigFile = "CRYON_DUELS_V8_POSITIONS.json"
State._positionBackupFile = "CRYON_DUELS_V8_POSITIONS.backup.json"
State._positionTempFile = "CRYON_DUELS_V8_POSITIONS.tmp.json"
State._positionSaveRequestId = 0

State._positionSnapshot = function(guiObject)
    if not guiObject then return nil end
    local ok, position = pcall(function() return guiObject.Position end)
    if not ok or not position then return nil end
    return {xs=position.X.Scale, xo=position.X.Offset, ys=position.Y.Scale, yo=position.Y.Offset}
end

State._restoreSavedPosition = function(guiObject, data)
    if not guiObject or type(data) ~= "table" or data.xs == nil then return end
    pcall(function()
        guiObject.Position = UDim2.new(
            tonumber(data.xs) or 0,
            tonumber(data.xo) or 0,
            tonumber(data.ys) or 0,
            tonumber(data.yo) or 0
        )
    end)
end

State.savePositionBackup = function()
    local buttonPositions = {}
    for name, button in pairs(mobileButtonsByName) do
        buttonPositions[name] = State._positionSnapshot(button)
    end

    local payload = {
        version = 2,
        mainPos = State._positionSnapshot(main),
        miniPos = State._positionSnapshot(mini),
        panelPos = State._positionSnapshot(MobilePanel),
        pbPos = State._positionSnapshot(pbFrame),
        batV2Pos = State._positionSnapshot(btnBatV2),
        instaResetPos = State._positionSnapshot(btnInstaReset),
        autoStealBarPos = State._positionSnapshot(State.autoStealBarFrame),
        mobileButtonPositions = buttonPositions,
    }

    local encodedOk, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not encodedOk then return false end

    if encoded == State._lastPositionJson then
        State._positionDirty = false
        return true
    end

    local saved, err = State._atomicJsonSave(
        State._positionConfigFile,
        State._positionBackupFile,
        State._positionTempFile,
        encoded
    )
    if saved then
        State._lastPositionJson = encoded
        State._positionDirty = false
    else
        State._lastSaveError = err
    end
    return saved
end

State.loadPositionBackup = function()
    local mainData, mainRaw = State._readValidJsonFile(State._positionConfigFile)
    local tempData, tempRaw = State._readValidJsonFile(State._positionTempFile)
    local backupData, backupRaw = State._readValidJsonFile(State._positionBackupFile)

    local data, raw, recovered = nil, nil, false
    if type(tempData) == "table" and (type(mainData) ~= "table" or tempRaw ~= mainRaw) then
        data, raw, recovered = tempData, tempRaw, true
    elseif type(mainData) == "table" then
        data, raw = mainData, mainRaw
    elseif type(backupData) == "table" then
        data, raw, recovered = backupData, backupRaw, true
    end

    if type(data) ~= "table" then return false end
    State._lastPositionJson = raw
    State._positionDirty = false

    local function apply()
        State._restoreSavedPosition(main, data.mainPos)
        State._restoreSavedPosition(mini, data.miniPos)
        State._restoreSavedPosition(MobilePanel, data.panelPos)
        State._restoreSavedPosition(pbFrame, data.pbPos)
        State._restoreSavedPosition(btnBatV2, data.batV2Pos)
        State._restoreSavedPosition(btnInstaReset, data.instaResetPos)
        State._restoreSavedPosition(State.autoStealBarFrame, data.autoStealBarPos)
        if type(data.mobileButtonPositions) == "table" then
            for name, positionData in pairs(data.mobileButtonPositions) do
                State._restoreSavedPosition(mobileButtonsByName[name], positionData)
            end
        end
    end

    apply()
    task.delay(0.45, apply)
    task.delay(1.2, apply)

    if recovered and type(raw) == "string" then
        task.defer(function()
            State._atomicJsonSave(
                State._positionConfigFile,
                State._positionBackupFile,
                State._positionTempFile,
                raw
            )
        end)
    end
    return true
end

State.requestPositionSave = function()
    State._positionDirty = true
    State._positionSaveRequestId = State._positionSaveRequestId + 1
    local requestId = State._positionSaveRequestId

    task.delay(0.55, function()
        if requestId ~= State._positionSaveRequestId then return end
        if not State._positionDirty then return end
        local ok, result = pcall(State.savePositionBackup)
        if not ok then State._lastSaveError = tostring(result) end
    end)
end

task.spawn(function()
    task.wait(0.15)
    pcall(State.loadPositionBackup)
end)

State.getAutoBatTarget = function()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - _autoBatLastScan <= 0.1 and _autoBatTarget and _autoBatTarget.Parent then
        local hum = _autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        local char = _autoBatTarget.Parent
        local hasAntiBat = char:FindFirstChild("Anti-Bat") or char:FindFirstChild("AntiBat") or char:FindFirstChild("Shield")
        if hum and hum.Health > 0 and not hasAntiBat then return _autoBatTarget end
    end
    _autoBatLastScan = now
    _autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local tChar = plr.Character

            local hasAntiBat = tChar:FindFirstChild("Anti-Bat") or tChar:FindFirstChild("AntiBat") or tChar:FindFirstChild("Shield")

            if tRoot and hum and hum.Health > 0 and not hasAntiBat then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    _autoBatTarget = closest
    return _autoBatTarget
end

local LUST_BYPASS_AIMBOT_SPEED = 60
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5
local BAT_V2_SWING_COOLDOWN = 0.1

local bypassHittingCooldown = false

State.getClosestPlayerV2 = function()
    local char = LP.Character
    if not char then return nil, math.huge end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local closest, bestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < bestDistance then
                    bestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest, bestDistance
end

State.tryHitBypassBat = function()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true

    pcall(function()
        local char = LP.Character
        if not char then return end

        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatToolLust(currentTool) then
            bypassHittingCooldown = false
            return
        end

        local bat = State.findBat()
        if bat then
            if bat.Parent ~= char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
            end

            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() bat:Activate() end)
            end
        end
    end)

    task.delay(BAT_V2_SWING_COOLDOWN, function()
        bypassHittingCooldown = false
    end)
    task.delay(0.2, function()
        if bypassHittingCooldown then
            bypassHittingCooldown = false
        end
    end)
end

startBatAimbotV2 = function()
    if Conns.aimbotV2 then return end
    State.autoBatV2Enabled = true

    Conns.aimbotV2 = RunService.Heartbeat:Connect(function()
        if not State.autoBatV2Enabled then return end

        local char = LP.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        local humanoidState = humanoid:GetState()
        if humanoidState == Enum.HumanoidStateType.Physics
            or humanoidState == Enum.HumanoidStateType.Ragdoll
            or humanoidState == Enum.HumanoidStateType.FallingDown then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = State.findBat()
            if bat then
                pcall(function() humanoid:EquipTool(bat) end)
            end
        end

        local target = State.getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVelocity = targetRoot.AssemblyLinearVelocity
                local movementDirection = targetVelocity.Magnitude > 0.1
                    and targetVelocity.Unit
                    or targetRoot.CFrame.LookVector

                local offset = movementDirection * BAT_V2_FOLLOW_DIST
                    + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                local desiredPosition = targetRoot.Position + offset
                local directionToTarget = desiredPosition - root.Position

                if directionToTarget.Magnitude > 0.5 then
                    local movementVector = directionToTarget.Unit * LUST_BYPASS_AIMBOT_SPEED
                    root.AssemblyLinearVelocity = Vector3.new(
                        movementVector.X,
                        movementVector.Y,
                        movementVector.Z
                    )
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end

                if State.autoSwingEnabled
                    and (root.Position - targetRoot.Position).Magnitude <= BAT_V2_HIT_DIST then
                    State.tryHitBypassBat()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

stopBatAimbotV2 = function()
    State.autoBatV2Enabled = false

    if Conns.aimbotV2 then
        Conns.aimbotV2:Disconnect()
        Conns.aimbotV2 = nil
    end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(root, "PhysicsRepRootPart", nil)
            end
        end)
    end

    bypassHittingCooldown = false
    State.lastMoveDir = Vector3.zero
end

;(function()

State._isfile = function(path)
    local checker = State._resolveFileFunction("isfile")
    if type(checker) == "function" then
        local ok, exists = pcall(checker, path)
        if ok then return exists == true end
    end
    local raw = State._safeReadFile(path)
    return type(raw) == "string"
end
State._readfile = function(path)
    local raw, err = State._safeReadFile(path)
    if type(raw) ~= "string" then error(err or "readfile failed", 0) end
    return raw
end
State._writefile = function(path, data)
    local ok, err = State._safeWriteFile(path, data)
    if not ok then error(err or "writefile failed", 0) end
    return true
end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15
local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15
local CONFIG_FILE="CRYON_DUELS_V8_CONFIG.json"
State._configTempFile="CRYON_DUELS_V8_CONFIG.tmp.json"
State._legacyConfigFile="FEARV2Config.json"
State._configBackupFile="CRYON_DUELS_V8_CONFIG.backup.json"
State._legacyConfigBackupFile="FEARV2Config.backup.json"
State._legacyConfigTempFile="FEARV2Config.tmp.json"

State.autoLeftPhase=1; State.autoRightPhase=1
State.medusaLastUsed=0; State.medusaDebounce=false; State.medusaCounterEnabled=false
State.batAimbotToggled=false; State.autoSwingEnabled=false
State.hittingCooldown=false
State.batCounterEnabled=false; State.batCounterDebounce=false
State.dropEnabled=false; State._tpInProgress=false
State.lastMoveDir=Vector3.new(0,0,0)
State._prevCarry=CS; State._prevSpeed=false
State.laggerEnabled=false

Conns.autoLeft=nil; Conns.autoRight=nil; Conns.aimbot=nil
Conns.batCounter=nil; Conns.unwalk=nil

local Presets={}
local PRESET_FILE="FEARV2Presets.json"; local LAST_PRESET_FILE="FEARV2LastPreset.json"
State.buildPresetSnapshot = function()
    return {normalSpeed=NS,carrySpeed=CS,laggerSpeed=LS,stealRadius=Steal.StealRadius,
        infJump=State.infJumpEnabled,
        antiRagdoll=State.antiRagdollEnabled,fpsBoost=State.fpsBoostEnabled,
        medusaCounter=State.medusaCounterEnabled,batCounter=State.batCounterEnabled,
        autoSteal=Steal.AutoStealEnabled,uiScale=uiScaleValue}
end
State.savePresetsFile = function()
    local ok,enc=pcall(function() return HttpService:JSONEncode(Presets) end)
    if ok then pcall(function() State._writefile(PRESET_FILE,enc) end) end
end
State.loadPresetsFile = function()
    local hasFile=false; pcall(function() hasFile=State._isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=State._readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then Presets=dec end
end
State.saveLastPresetName = function(name)
    local ok,enc=pcall(function() return HttpService:JSONEncode({lastPreset=name}) end)
    if ok then pcall(function() State._writefile(LAST_PRESET_FILE,enc) end) end
end
State.loadLastPresetName = function()
    local hasFile=false; pcall(function() hasFile=State._isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw; pcall(function() raw=State._readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then return dec.lastPreset end; return nil
end

State.createRadiusPart = function()
	local p = Instance.new("Part")
	p.Name = "MedusaRadius"
	p.Anchored = true
	p.CanCollide = false
	pcall(function() p.CanQuery = false end)
	p.Transparency = 1
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(100, 0, 0)
	p.Shape = Enum.PartType.Cylinder
	p.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
	p.Parent = workspace
	MedusaConfig.RadiusPart = p
end

State.isMedusaEquipped = function()
	local char = LP.Character
	if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and tool.Name == "Medusa's Head" then
			return tool
		end
	end
	return nil
end

RunService.Heartbeat:Connect(function()
	if not MedusaConfig.Enabled then
		if MedusaConfig.RadiusPart then MedusaConfig.RadiusPart.Transparency = 1 end
		return
	end

	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if not MedusaConfig.RadiusPart then State.createRadiusPart() end
	MedusaConfig.RadiusPart.Transparency = 0.7
	MedusaConfig.RadiusPart.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.5, 0)) * CFrame.Angles(0, 0, math.rad(90))

	local tool = State.isMedusaEquipped()
	if tool and (tick() - MedusaConfig.LastUsed >= MedusaConfig.Delay) then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local pRoot = plr.Character.HumanoidRootPart
				if (pRoot.Position - root.Position).Magnitude <= MedusaConfig.Radius then
					tool:Activate()
					MedusaConfig.LastUsed = tick()
					break
				end
			end
		end
	end
end)

State.doTpDown = function()
    pcall(function()
        local character, humanoid, root = State.safetyCharacterParts()
        if character then State.safetyTeleportToFloor(character, humanoid, root) end
    end)
end

State.runDropBrainrot = function()
        if State.dropBrainrotActive then return end
        local char, hum, root = State.safetyCharacterParts()
        if not char then return end
        State.dropBrainrotActive=true; local t0=tick(); local dc
        dc=RunService.Heartbeat:Connect(function()
                local currentChar=LP.Character
                local r=currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum=currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not r or not currentHum or currentHum.Health<=0 then
                        if dc then dc:Disconnect() end
                        State.dropBrainrotActive=false
                        return
                end
                if tick()-t0>=DROP_ASCEND_DURATION then
                        if dc then dc:Disconnect() end
                        r.AssemblyLinearVelocity=Vector3.zero
                        r.AssemblyAngularVelocity=Vector3.zero
                        State.safetyTeleportToFloor(currentChar,currentHum,r)
                        State.dropBrainrotActive=false
                        return
                end
                r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
        end)
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
State.findBatForCounter = function()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
State.swingBatForCounter = function(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end
State.startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=State.findBatForCounter()
                if bat then State.swingBatForCounter(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
State.stopBatCounter = function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

State.findMedusa = function()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
State.useMedusaCounter = function()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end; State.medusaDebounce=true
    local med=State.findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
State.onAnchorChanged = function(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then State.useMedusaCounter() end end) end
State.setupMedusaCounter = function(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,State.onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,State.onAnchorChanged(part)) end end))
end
State.stopMedusaCounter = function() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

State.faceSouth = function() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end end) end
State.faceNorth = function() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end end) end

State.startAutoLeft = function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=State.getProfileNormalSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(AP.L1.X,root.Position.Y,AP.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(AP.L2.X,root.Position.Y,AP.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if autoLeftSetVisual then autoLeftSetVisual(false) end; State.faceSouth(); return end
            local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
State.stopAutoLeft = function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end
State.startAutoRight = function()
    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=State.getProfileNormalSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(AP.R1.X,root.Position.Y,AP.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(AP.R2.X,root.Position.Y,AP.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if autoRightSetVisual then autoRightSetVisual(false) end; State.faceNorth(); return end
            local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
State.stopAutoRight = function()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end

local antiRagdollConn = nil

State.resetAntiRagdollCharacter = function(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)

        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint")
                or obj:IsA("BallSocketConstraint")
                or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModule = playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local success, module = pcall(require, controlModule)
                if success and module and module.Enable then
                    module:Enable()
                end
            end
        end
    end)
end

startAntiRagdoll = function()
    if antiRagdollConn then return end

    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end

        local char = LP.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local state = hum:GetState()

        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then

            State.resetAntiRagdollCharacter(char)
        end
    end)
end

stopAntiRagdoll = function()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local ContentProvider = game:GetService("ContentProvider")
local Anims = {
    idle1 = "rbxassetid://133806214992291",
    idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309",
    run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985",
    fall = "rbxassetid://116936326516985",
    climb = "rbxassetid://116936326516985",
    swim = "rbxassetid://116936326516985",
    swimidle = "rbxassetid://116936326516985"
}

task.spawn(function() pcall(function() ContentProvider:PreloadAsync(Anims) end) end)

State.applyAnimPack = function(char)
    local a = char:FindFirstChild("Animate")
    if not a then return end
    local function s(o, id) if o then o.AnimationId = id end end

    s(a.idle and a.idle.Animation1, Anims.idle1)
    s(a.idle and a.idle.Animation2, Anims.idle2)
    s(a.walk and a.walk.WalkAnim, Anims.walk)
    s(a.run and a.run.RunAnim, Anims.run)
    s(a.jump and a.jump.JumpAnim, Anims.jump)
    s(a.fall and a.fall.FallAnim, Anims.fall)
    s(a.climb and a.climb.ClimbAnim, Anims.climb)
    s(a.swim and a.swim.Swim, Anims.swim)
    s(a.swimidle and a.swimidle.SwimIdle, Anims.swimidle)
end

local animHBConn
function startNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
    local char = LP.Character
    if char then
        State.applyAnimPack(char)
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            for _, t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop(0) end
            hum2:ChangeState(Enum.HumanoidStateType.Running)
        end
    end

    animHBConn = RunService.Heartbeat:Connect(function()
        if not State.nuevaAnimacionEnabled then return end
        local c = LP.Character
        if c then State.applyAnimPack(c) end
    end)
end

function stopNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
end

local applyFPSBoost
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function()
        if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
        elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
        elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("SpecialMesh") then v.TextureId=""
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
        elseif v:IsA("Attachment") then v.Visible=false end
    end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local plots = workspace:WaitForChild("Plots")

local CONFIG = {
	AUTO_STEAL_ENABLED = true,  -- SIEMPRE ACTIVADO
	HOLD_MIN = 1.3,
	HOLD_MAX = 2.6,
	ENTRY_DELAY = 0.3,
	COOLDOWN = 0.05,
	STEAL_RANGE = 9,
	PRIME_RANGE = 80
}
State._stealConfig = CONFIG

local AnimalsData = {}
local syncRemotes = nil
local plotAnimalSync = {caches = {}, connections = {}}
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local stealConnection = nil

local StealState = {
	active = false,
	startTime = 0,
	phase = "idle",
	label = "",
	lastResult = "",
	lastResultTime = 0,
	totalSteals = 0,
	failedSteals = 0
}

State.initializeAutoStealSync = function()
	local ok = pcall(function()
		local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
		local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
		if not Packages or not Datas then return end
		AnimalsData = require(Datas:WaitForChild("Animals"))
		local folder = Packages:WaitForChild("Synchronizer")
		syncRemotes = {
			channelFolder = folder:WaitForChild("Channel"),
			routeRemote = folder:WaitForChild("CommunicationRoute"),
			requestData = folder:FindFirstChild("RequestData")
		}
	end)
	return ok and syncRemotes ~= nil
end

State.splitSyncPath = function(path)
	if typeof(path) == "table" then return path end
	local out = {}
	for part in string.gmatch(tostring(path), "[^%.]+") do
		table.insert(out, tonumber(part) or part)
	end
	return out
end

State.resolveSyncPath = function(path, root)
	local current = root
	local parent = nil
	local key = nil
	for _, part in ipairs(State.splitSyncPath(path)) do
		parent = current
		key = part
		current = current and current[part] or nil
	end
	return current, parent, key
end

State.applyPlotSyncDiff = function(channelName, packet)
	local cache = plotAnimalSync.caches[channelName]
	if typeof(cache) ~= "table" then return end
	local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
	local current, parent, key = State.resolveSyncPath(path, cache)
	if action == "Changed" then
		if parent ~= nil then parent[key] = a end
	elseif action == "ArrayInsert" then
		if current ~= nil then table.insert(current, b, a) end
	elseif action == "ArrayRemoved" then
		if current ~= nil then table.remove(current, b) end
	elseif action == "DictionaryInsert" then
		if current ~= nil then current[b] = a end
	elseif action == "DictionaryRemoved" then
		if current ~= nil then current[b] = nil end
	end
end

State.attachPlotChannel = function(remote)
	if not syncRemotes or plotAnimalSync.connections[remote] then return end
	local channelName = tostring(remote.Name)
	if not plots:FindFirstChild(channelName) then return end
	if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
		local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
		plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
	elseif plotAnimalSync.caches[channelName] == nil then
		plotAnimalSync.caches[channelName] = {}
	end
	plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
		for _, packet in ipairs(queue) do
			State.applyPlotSyncDiff(channelName, packet)
		end
	end)
end

State.detachPlotChannel = function(channelName)
	for remote, conn in pairs(plotAnimalSync.connections) do
		if tostring(remote.Name) == tostring(channelName) then
			conn:Disconnect()
			plotAnimalSync.connections[remote] = nil
			plotAnimalSync.caches[tostring(channelName)] = nil
			break
		end
	end
end

State.startAutoStealSync = function()
	if not State.initializeAutoStealSync() then return false end
	for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
		if child:IsA("RemoteEvent") then State.attachPlotChannel(child) end
	end
	syncRemotes.channelFolder.ChildAdded:Connect(function(child)
		if child:IsA("RemoteEvent") then State.attachPlotChannel(child) end
	end)
	syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
		for _, action in ipairs(actions) do
			local kind, channelName = action[1], tostring(action[2])
			if not plots:FindFirstChild(channelName) then continue end
			if kind == "ListenerAdded" then
				local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
				if remote and remote:IsA("RemoteEvent") then State.attachPlotChannel(remote) end
			elseif kind == "ListenerRemoved" then
				State.detachPlotChannel(channelName)
			end
		end
	end)
	return true
end

State.getPlotChannelData = function(plotName)
	return plotAnimalSync.caches[plotName]
end

State.getPlotOwner = function(plot)
	local sign = plot:FindFirstChild("PlotSign")
	local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
	local label = frame and frame:FindFirstChild("TextLabel")
	if not label or label.Text == "Empty Base" then return nil end
	return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

State.isMyBaseAnimal = function(animalData)
	if not animalData or not animalData.plot then return false end
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return false end
	return State.getPlotOwner(plot) == LP.DisplayName
end

State.getAnimalPosition = function(animalData)
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return nil end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	if not podiums then return nil end
	local podium = podiums:FindFirstChild(animalData.slot)
	if not podium then return nil end
	return podium:GetPivot().Position
end

State.findProximityPromptForAnimal = function(animalData)
	if not animalData then return nil end
	local cached = PromptMemoryCache[animalData.uid]
	if cached and cached.Parent then return cached end
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return nil end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	if not podiums then return nil end
	local podium = podiums:FindFirstChild(animalData.slot)
	if not podium then return nil end
	local base = podium:FindFirstChild("Base")
	if not base then return nil end
	local spawn = base:FindFirstChild("Spawn")
	if not spawn then return nil end
	local attach = spawn:FindFirstChild("PromptAttachment")
	if not attach then return nil end
	for _, p in ipairs(attach:GetChildren()) do
		if p:IsA("ProximityPrompt") then
			PromptMemoryCache[animalData.uid] = p
			return p
		end
	end
	return nil
end

State.distToAnimal = function(animalData)
	local character = LP.Character
	if not character then return math.huge end
	local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
	if not hrp then return math.huge end
	local pos = State.getAnimalPosition(animalData)
	if not pos then return math.huge end
	return (hrp.Position - pos).Magnitude
end

State.pickClosest = function()
	local character = LP.Character
	if not character then return nil end
	local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
	if not hrp then return nil end
	local best, bestDist = nil, math.huge
	for _, animalData in ipairs(allAnimalsCache) do
		if State.isMyBaseAnimal(animalData) then continue end
		local pos = State.getAnimalPosition(animalData)
		if not pos then continue end
		local dist = (hrp.Position - pos).Magnitude
		if dist > CONFIG.PRIME_RANGE then continue end
		if dist < bestDist then
			bestDist = dist
			best = animalData
		end
	end
	return best
end

State.buildStealCallbacks = function(prompt)
	if InternalStealCache[prompt] then return end
	local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
	local ok1, conns1 = false, nil
	if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
	if ok1 and type(conns1) == "table" then
		for _, conn in ipairs(conns1) do
			if type(conn.Function) == "function" then
				table.insert(data.holdCallbacks, conn.Function)
			end
		end
	end
	local ok2, conns2 = false, nil
	if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
	if ok2 and type(conns2) == "table" then
		for _, conn in ipairs(conns2) do
			if type(conn.Function) == "function" then
				table.insert(data.triggerCallbacks, conn.Function)
			end
		end
	end
	if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
		InternalStealCache[prompt] = data
	end
end

State.executeStealAsync = function(prompt, animalData)
	local data = InternalStealCache[prompt]
	if not data or not data.ready then return false end
	data.ready = false
	local label = animalData.name or "Animal"
	StealState.active = true
	StealState.startTime = tick()
	StealState.phase = "holding"
	StealState.label = label
	task.spawn(function()
		for _, fn in ipairs(data.holdCallbacks) do
			task.spawn(fn)
		end
		task.wait(CONFIG.HOLD_MIN)
		StealState.phase = "waitingRange"
		local alreadyInRange = State.distToAnimal(animalData) <= CONFIG.STEAL_RANGE
		local fired = false
		while true do
			local elapsed = tick() - StealState.startTime
			if elapsed > CONFIG.HOLD_MAX then break end
			if not prompt.Parent then break end
			if State.distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
				if not alreadyInRange then task.wait(CONFIG.ENTRY_DELAY) end
				for _, fn in ipairs(data.triggerCallbacks) do
					task.spawn(fn)
				end
				fired = true
				break
			end
			task.wait()
		end
		if fired then
			StealState.totalSteals = StealState.totalSteals + 1
			StealState.lastResult = "Stole " .. label
			StealState.phase = "success"
		else
			StealState.failedSteals = StealState.failedSteals + 1
			StealState.lastResult = "Missed window: " .. label
			StealState.phase = "failed"
		end
		StealState.active = false
		StealState.lastResultTime = tick()
		task.wait(CONFIG.COOLDOWN)
		data.ready = true
	end)
	return true
end

State.attemptSteal = function(prompt, animalData)
	if not prompt or not prompt.Parent then return false end
	State.buildStealCallbacks(prompt)
	if not InternalStealCache[prompt] then return false end
	return State.executeStealAsync(prompt, animalData)
end

State.scanAllPlots = function()
	local newCache = {}
	for _, plot in ipairs(plots:GetChildren()) do
		local cache = State.getPlotChannelData(plot.Name)
		if not cache then continue end
		local animalList = cache.AnimalList
		if typeof(animalList) ~= "table" then continue end
		for slot, animalData in pairs(animalList) do
			if type(animalData) == "table" then
				local animalName = animalData.Index
				local animalInfo = AnimalsData[animalName]
				if not animalInfo then continue end
				table.insert(newCache, {
					name = animalInfo.DisplayName or animalName,
					plot = plot.Name,
					slot = tostring(slot),
					uid = plot.Name .. "_" .. tostring(slot)
				})
			end
		end
	end
	allAnimalsCache = newCache
	return #allAnimalsCache
end

function startAutoSteal()
	if stealConnection then return end
	stealConnection = RunService.Heartbeat:Connect(function()
		local enabled = true
		if State._stealConfig then enabled = State._stealConfig.AUTO_STEAL_ENABLED == true
		elseif CONFIG then enabled = CONFIG.AUTO_STEAL_ENABLED == true
		else enabled = Steal.AutoStealEnabled == true end
		if not enabled then return end
		if StealState.active then return end
		local target = State.pickClosest()
		if not target then return end
		local prompt = PromptMemoryCache[target.uid]
		if not prompt or not prompt.Parent then
			prompt = State.findProximityPromptForAnimal(target)
		end
		if prompt then
			State.attemptSteal(prompt, target)
		end
	end)
end

function stopAutoSteal()
	if not stealConnection then return end
	stealConnection:Disconnect()
	stealConnection = nil
	StealState.active = false
	StealState.phase = "idle"
end

local CoreGui = game:GetService("CoreGui")

local oldGui = CoreGui:FindFirstChild("CandyStealBar")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CandyStealBar"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
local UIS = game:GetService("UserInputService")
frame.Active = true

local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if State.requestPositionSave then State.requestPositionSave() end
                if State.requestConfigSave then State.requestConfigSave() end
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1) then
        dragging = false
        if State.requestPositionSave then State.requestPositionSave() end
        if State.requestConfigSave then State.requestConfigSave() end
    end
end)
frame.Size = UDim2.new(0, 300, 0, 42)
frame.Position = UDim2.new(0.5, -150, 1, -66)
State.autoStealBarFrame = frame
task.defer(function()
    if State.loadPositionBackup then pcall(State.loadPositionBackup) end
end)
frame.BackgroundColor3 = Color3.fromRGB(12, 0, 0)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local frameGradient = Instance.new("UIGradient", frame)
frameGradient.Rotation = 90
frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 0, 0))
})

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(220, 0, 0)
stroke.Thickness = 1.1
stroke.Transparency = 0.16

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(0, 70, 0, 16)
statusLabel.Position = UDim2.new(0, 11, 0, 5)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "READY"
statusLabel.TextColor3 = Color3.fromRGB(255, 55, 55)
statusLabel.Font = Enum.Font.GothamBlack
statusLabel.TextSize = 9
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local sep = Instance.new("Frame", frame)
sep.Size = UDim2.new(0, 1, 0, 15)
sep.Position = UDim2.new(0, 84, 0, 5)
sep.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
sep.BorderSizePixel = 0
sep.BackgroundTransparency = 0.45

local radTag = Instance.new("TextLabel", frame)
radTag.Size = UDim2.new(0, 40, 0, 15)
radTag.Position = UDim2.new(0, 92, 0, 5)
radTag.BackgroundTransparency = 1
radTag.Text = "RADIUS"
radTag.TextColor3 = Color3.fromRGB(255, 90, 90)
radTag.Font = Enum.Font.GothamBlack
radTag.TextSize = 8
radTag.TextXAlignment = Enum.TextXAlignment.Left

local radBox = Instance.new("TextBox", frame)
radBox.Size = UDim2.new(0, 38, 0, 18)
radBox.Position = UDim2.new(0, 137, 0, 4)
radBox.BackgroundColor3 = Color3.fromRGB(16, 0, 0)
radBox.BorderSizePixel = 0
radBox.Text = tostring(CONFIG.STEAL_RANGE)
radBox.TextColor3 = Color3.fromRGB(255, 55, 55)
radBox.Font = Enum.Font.GothamBlack
radBox.TextSize = 11
radBox.TextXAlignment = Enum.TextXAlignment.Center
radBox.ClearTextOnFocus = false
Instance.new("UICorner", radBox).CornerRadius = UDim.new(0, 12)
local radStroke = Instance.new("UIStroke", radBox)
radStroke.Color = Color3.fromRGB(220, 0, 0)
radStroke.Thickness = 1
radStroke.Transparency = 0.35

radBox.FocusLost:Connect(function()
	local v = tonumber(radBox.Text)
	if v and v >= 0.5 and v <= 300 then
		CONFIG.STEAL_RANGE = v
		Steal.StealRadius = v
		radBox.Text = tostring(v)
	else
		radBox.Text = tostring(CONFIG.STEAL_RANGE)
	end
	if State.requestConfigSave then State.requestConfigSave() end
end)

local barBg = Instance.new("Frame", frame)
barBg.Size = UDim2.new(1, -22, 0, 5)
barBg.Position = UDim2.new(0, 11, 1, -10)
barBg.BackgroundColor3 = Color3.fromRGB(28, 0, 0)
barBg.BorderSizePixel = 0
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local progressFill = Instance.new("Frame", barBg)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
progressFill.BorderSizePixel = 0
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 54, 0, 20)
toggleBtn.Position = UDim2.new(1, -65, 0, 4)
toggleBtn.BackgroundColor3 = Color3.fromRGB(185, 0, 0)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "STOP"
toggleBtn.TextColor3 = Color3.fromRGB(255, 55, 55)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 10
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(255, 55, 55)
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.35

State._autoStealBar = { frame = frame, toggleBtn = toggleBtn, toggleStroke = toggleStroke, statusLabel = statusLabel }
frame.Visible = Steal.AutoStealEnabled ~= false

toggleBtn.MouseButton1Click:Connect(function()
	CONFIG.AUTO_STEAL_ENABLED = not CONFIG.AUTO_STEAL_ENABLED
	if CONFIG.AUTO_STEAL_ENABLED then
		toggleBtn.Text = "STOP"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(185, 0, 0)
		toggleStroke.Color = Color3.fromRGB(255, 55, 55)
		startAutoSteal()
		statusLabel.Text = "READY"
	else
		toggleBtn.Text = "START"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
		toggleStroke.Color = Color3.fromRGB(115, 0, 0)
		stopAutoSteal()
		statusLabel.Text = "IDLE"
	end
	Steal.AutoStealEnabled = CONFIG.AUTO_STEAL_ENABLED
	if State.requestConfigSave then State.requestConfigSave() end
end)

local progressLastFill = 0

State.updateStealBar = function(dt)
	local recent = StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.4
	local targetPct = 0
	local targetColor = Color3.fromRGB(190, 0, 0)
	local status = CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE"

	if StealState.active then
		targetPct = math.clamp((tick() - StealState.startTime) / CONFIG.HOLD_MAX, 0, 1)
		if StealState.phase == "waitingRange" then
			status = "WAITING"
			targetColor = Color3.fromRGB(130, 0, 0)
		else
			status = "STEALING"
			targetColor = Color3.fromRGB(220, 0, 0)
		end
	elseif recent then
		local success = StealState.phase == "success" or string.find(StealState.lastResult, "Stole") ~= nil
		targetPct = 1
		status = success and "SUCCESS" or "FAILED"
		targetColor = success and Color3.fromRGB(255, 55, 55) or Color3.fromRGB(110, 0, 0)
	elseif CONFIG.AUTO_STEAL_ENABLED then
		local scan = math.sin(tick() * 2.2) * 0.5 + 0.5
		targetPct = scan * 0.75
		status = "SCAN"
		targetColor = Color3.fromRGB(180, 0, 0)
	end

	progressLastFill = progressLastFill + (targetPct - progressLastFill) * math.min((dt or 0.016) * 14, 1)
	progressFill.Size = UDim2.new(progressLastFill, 0, 1, 0)
	progressFill.BackgroundColor3 = progressFill.BackgroundColor3:Lerp(targetColor, math.min((dt or 0.016) * 8, 1))
	statusLabel.Text = status
	statusLabel.TextColor3 = targetColor
end

RunService.RenderStepped:Connect(State.updateStealBar)

task.spawn(function()
	if State.startAutoStealSync() then
		State.scanAllPlots()
		while task.wait(5) do
			State.scanAllPlots()
		end
	end
end)

CONFIG.AUTO_STEAL_ENABLED = true
Steal.AutoStealEnabled = true
startAutoSteal()
statusLabel.Text = "READY"

print("✅ Auto Steal ACTIVADO - Robando automáticamente!")
print("📌 Presiona el botón en la barra para pausar/reanudar")

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

saveConfig = function(btn)
    if State._configLoading or not State._configLoaded then
        State._saveAfterLoad = true
        return false
    end

    if State._configLoadFailed and not btn then
        return false
    end

    if State._saveInProgress then
        State._saveQueued = true
        return false
    end

    State._saveInProgress = true

    local function keySnapshot(entry)
        return {
            kb = entry and entry.kb and entry.kb.Name or nil,
            gp = entry and entry.gp and entry.gp.Name or nil,
        }
    end

    local function positionSnapshot(guiObject)
        if not guiObject then return nil end
        local ok, p = pcall(function() return guiObject.Position end)
        if not ok or not p then return nil end
        return {
            xs = p.X.Scale,
            xo = p.X.Offset,
            ys = p.Y.Scale,
            yo = p.Y.Offset,
        }
    end

    local savedStealRadius = Steal.StealRadius
    local savedAutoStealEnabled = Steal.AutoStealEnabled
    if CONFIG then
        if type(CONFIG.STEAL_RANGE) == "number" then
            savedStealRadius = CONFIG.STEAL_RANGE
        end
        if CONFIG.AUTO_STEAL_ENABLED ~= nil then
            savedAutoStealEnabled = CONFIG.AUTO_STEAL_ENABLED == true
        end
    end

    local cfg = {
        configVersion = 8,

        normalSpeed = NS,
        carrySpeed = CS,
        profileLaggerNormalSpeed = State.profileLaggerNormalSpeed,
        profileLaggerCarrySpeed = State.profileLaggerCarrySpeed,
        speedProfile = State.speedProfile,
        laggerSpeed = LS,
        laggerCarrySpeed = LS2,
        stealRadius = savedStealRadius,
        stealDuration = Steal.StealDuration,

        uiScale = uiScaleValue,
        backgroundAssetId = State.backgroundAssetId,
        buttonsSize = State.buttonsSizeValue,
        buttonsShape = State.buttonsShape,
        uiLocked = uiLocked,
        guiVisible = State.guiVisible,

        autoLeftKey = keySnapshot(KB.AutoLeft),
        autoRightKey = keySnapshot(KB.AutoRight),
        dropKey = keySnapshot(KB.Drop),
        tpDownKey = keySnapshot(KB.TPDown),
        autoBatKey = keySnapshot(KB.AutoBat),
        autoBatV2Key = keySnapshot(KB.AutoBatV2),
        instaResetKey = keySnapshot(KB.InstaReset),
        tpBatKey = keySnapshot(KB.TPBat),
        speedKey = keySnapshot(KB.Speed),
        laggerKey = keySnapshot(KB.Lagger),
        guiHideKey = keySnapshot(KB.GuiHide),

        infJump = State.infJumpEnabled,
        superJump = State.superJumpEnabled,
        antiRagdoll = State.antiRagdollEnabled,
        fpsBoost = State.fpsBoostEnabled,
        medusaCounter = State.medusaCounterEnabled,
        batCounter = State.batCounterEnabled,
        autoStealEnabled = savedAutoStealEnabled,
        unwalkEnabled = State.unwalkEnabled,
        desyncEnabled = State.desyncEnabled,
        autoSwing = State.autoSwingEnabled,
        autoBatToggled = State.autoBatToggled,
        autoBatV2Toggled = State.autoBatV2Enabled,
        tpBatEnabled = State.tpBatEnabled,
        stretchRez = State.stretchRezEnabled,
        removeAccessories = State.removeAccessoriesEnabled,
        antiLag = State.antiLagEnabled,
        hitboxFollower = State.hitboxFollowerEnabled,
        darkMode = State.darkModeEnabled,
        skyStyle = State.skyStyle,
        noIntro = State.noIntro == true,
        introEnabled = State.noIntro ~= true,
        selectedIntroMusic = State.selectedIntroMusic,
        autoTPDown = autoTPDownEnabled,
        autoTPDownHeight = autoTPDownHeight,

        speedToggled = State.speedToggled,
        laggerMode = State.laggerToggled,
        laggerPhase = laggerPhase,

        linieEnabled = State.linieEnabled,
        autoMedusaEnabled = MedusaConfig and MedusaConfig.Enabled or nil,
        medusaRadius = MedusaConfig and MedusaConfig.Radius or nil,
        medusaDelay = MedusaConfig and MedusaConfig.Delay or nil,
        nuevaAnimacion = State.nuevaAnimacionEnabled,
        instaReset = State.instaResetEnabled,
        instaResetVisible = btnInstaReset and btnInstaReset.Visible or nil,
        hideButtons = State.hideButtonsEnabled,

        panelPos = positionSnapshot(MobilePanel),
        mobileButtonPositions = (function()
            local positions = {}
            for name, mobileBtn in pairs(mobileButtonsByName) do
                positions[name] = positionSnapshot(mobileBtn)
            end
            return positions
        end)(),
        mainPos = positionSnapshot(main),
        miniPos = positionSnapshot(mini),
        pbPos = positionSnapshot(pbFrame),
        batV2Pos = positionSnapshot(btnBatV2),
        instaResetPos = positionSnapshot(btnInstaReset),
        autoStealBarPos = positionSnapshot(frame),
    }

    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(cfg)
    end)

    local saved = false
    if encodeOk and encoded then
        if not btn and encoded == State._lastConfigJson then
            State._configDirty = false
            State._saveInProgress = false
            State._saveQueued = false
            return true
        end

        local atomicOk, atomicResult, atomicErr = pcall(function()
            return State._atomicJsonSave(
                CONFIG_FILE,
                State._configBackupFile,
                State._configTempFile,
                encoded
            )
        end)

        saved = atomicOk and atomicResult == true
        if saved then
            State._lastConfigJson = encoded
            State._lastSaveError = nil
            State._configLoadFailed = false
            State._allowInitialConfigCreation = false

            if State.savePositionBackup then pcall(State.savePositionBackup) end

            State._configDirty = false
        else
            State._lastConfigJson = nil
            State._lastSaveError = tostring((atomicOk and atomicErr) or atomicResult or "No se pudo escribir la configuración")
            warn("[CRYON AUTO SAVE] " .. State._lastSaveError)
        end
    else
        State._lastSaveError = "No se pudo convertir la configuración a JSON"
    end

    State._saveInProgress = false

    if btn and btn.Parent then
        local previousText = btn.Text
        btn.Text = saved and "Saved!" or "Failed!"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = previousText end
        end)
    end

    if State._saveQueued then
        State._saveQueued = false
        if State.requestConfigSave then State.requestConfigSave() end
    end

    return saved
end

loadConfig = function()
    local function readConfigFile(path)
        local decoded, raw = State._readValidJsonFile(path)
        if type(decoded) ~= "table" then return nil, raw end
        return decoded, raw
    end

    local mainCfg, mainRaw = readConfigFile(CONFIG_FILE)
    local tempCfg, tempRaw = readConfigFile(State._configTempFile)
    local backupCfg, backupRaw = readConfigFile(State._configBackupFile)
    local legacyCfg, legacyRaw = readConfigFile(State._legacyConfigFile)
    local legacyTempCfg, legacyTempRaw = readConfigFile(State._legacyConfigTempFile)
    local legacyBackupCfg, legacyBackupRaw = readConfigFile(State._legacyConfigBackupFile)

    local cfg, raw = nil, nil
    local loadedFromBackup = false
    local loadedFromLegacy = false
    local loadedFromTemp = false

    if type(tempCfg) == "table" and (type(mainCfg) ~= "table" or tempRaw ~= mainRaw) then
        cfg, raw = tempCfg, tempRaw
        loadedFromTemp = true
    elseif type(mainCfg) == "table" then
        cfg, raw = mainCfg, mainRaw
    elseif type(backupCfg) == "table" then
        cfg, raw = backupCfg, backupRaw
        loadedFromBackup = true
    elseif type(legacyTempCfg) == "table" and (type(legacyCfg) ~= "table" or legacyTempRaw ~= legacyRaw) then
        cfg, raw = legacyTempCfg, legacyTempRaw
        loadedFromLegacy = true
        loadedFromTemp = true
    elseif type(legacyCfg) == "table" then
        cfg, raw = legacyCfg, legacyRaw
        loadedFromLegacy = true
    elseif type(legacyBackupCfg) == "table" then
        cfg, raw = legacyBackupCfg, legacyBackupRaw
        loadedFromLegacy = true
        loadedFromBackup = true
    end

    local hadAnyConfigFile = false
    for _, path in ipairs({
        CONFIG_FILE,
        State._configTempFile,
        State._configBackupFile,
        State._legacyConfigFile,
        State._legacyConfigTempFile,
        State._legacyConfigBackupFile,
    }) do
        local exists = false
        pcall(function() exists = State._isfile(path) end)
        if exists then hadAnyConfigFile = true break end
    end

    if not cfg then
        State._configLoaded = true
        State._configLoadFailed = hadAnyConfigFile
        State._allowInitialConfigCreation = not hadAnyConfigFile
        State._saveAfterLoad = false
        State._lastSaveError = hadAnyConfigFile and "Se encontraron configuraciones dañadas; no se sobrescribieron" or nil
        if State.loadPositionBackup then pcall(State.loadPositionBackup) end
        return false
    end

    State._configLoading = true
    State._configLoadFailed = false
    State._allowInitialConfigCreation = false

    local applyOk = pcall(function()
        if type(cfg.normalSpeed) == "number" then
            NS = cfg.normalSpeed
            if normalBox then normalBox.Text = tostring(NS) end
        end
        if type(cfg.carrySpeed) == "number" then
            CS = cfg.carrySpeed
            if carryBox then carryBox.Text = tostring(CS) end
        end
        if type(cfg.profileLaggerNormalSpeed) == "number" then
            State.profileLaggerNormalSpeed = cfg.profileLaggerNormalSpeed
        end
        if type(cfg.profileLaggerCarrySpeed) == "number" then
            State.profileLaggerCarrySpeed = cfg.profileLaggerCarrySpeed
        end
        if type(cfg.laggerSpeed) == "number" then
            LS = cfg.laggerSpeed
            if laggerBox then laggerBox.Text = tostring(LS) end
        end
        if type(cfg.laggerCarrySpeed) == "number" then
            LS2 = cfg.laggerCarrySpeed
            if laggerBox2 then laggerBox2.Text = tostring(LS2) end
        end

        if type(cfg.uiScale) == "number" then
            uiScaleValue = math.clamp(math.floor(cfg.uiScale + 0.5), 50, 150)
            if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
            if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
        end

        if cfg.backgroundAssetId and State.applyBackgroundImage then
            State.applyBackgroundImage(cfg.backgroundAssetId, false)
        elseif State.applyBackgroundImage then
            State.applyBackgroundImage(State.backgroundAssetId, false)
        end

        if type(cfg.buttonsSize) == "number" then
            State.buttonsSizeValue = math.clamp(math.floor(cfg.buttonsSize + 0.5), 0, 100)
        end
        if cfg.buttonsShape ~= nil then
            State.buttonsShape = normalizeMobileButtonsShape(cfg.buttonsShape)
        end
        applyMobileButtonsSize(State.buttonsSizeValue)
        if buttonsSizeBox then buttonsSizeBox.Text = tostring(State.buttonsSizeValue) end
        if State._buttonsShapeSelectorVisual then
            State._buttonsShapeSelectorVisual(State.buttonsShape, false)
        end

        if cfg.uiLocked ~= nil then
            uiLocked = cfg.uiLocked == true
            if setLockUIVisual then setLockUIVisual(uiLocked) end
        end

        if cfg.guiVisible ~= nil then
            State.guiVisible = cfg.guiVisible == true
            if main then main.Visible = State.guiVisible end
            if mini then mini.Visible = not State.guiVisible end
        end

        if cfg.selectedIntroMusic ~= nil then
            State.selectedIntroMusic = cfg.selectedIntroMusic
            if getgenv and getgenv().FEARV2MusicBtn then
                getgenv().FEARV2MusicBtn.Text = "Music " .. tostring(State.selectedIntroMusic)
            end
        end
        if cfg.noIntro ~= nil then
            State.noIntro = cfg.noIntro == true
        elseif cfg.introEnabled ~= nil then
            State.noIntro = cfg.introEnabled ~= true
        end
        State.introEnabled = not State.noIntro
        if setNoIntroToggle then setNoIntroToggle(State.noIntro, false) end
        if setIntroToggle then setIntroToggle(State.introEnabled, false) end

        if type(cfg.autoTPDownHeight) == "number" then
            autoTPDownHeight = math.clamp(cfg.autoTPDownHeight, 0, 500)
        end
        if cfg.autoTPDown ~= nil then
            autoTPDownEnabled = cfg.autoTPDown == true
            if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
            if autoTPDownEnabled then State.startAutoTPDown() else State.stopAutoTPDown() end
        end

        local savedRadius = cfg.stealRadius or cfg.grabRadius
        if savedRadius == 61 or savedRadius == 63 then
            savedRadius = 10
        end
        if type(savedRadius) == "number" then
            Steal.StealRadius = savedRadius
            if progressRadLbl then progressRadLbl.Text = "Radius: " .. tostring(savedRadius) end
            if radValBtn then radValBtn.Text = tostring(savedRadius) end
            if radBox then radBox.Text = tostring(savedRadius) end
            if CONFIG then CONFIG.STEAL_RANGE = savedRadius end
        end
        if type(cfg.stealDuration) == "number" then
            Steal.StealDuration = cfg.stealDuration
            if durValBtn then durValBtn.Text = tostring(Steal.StealDuration) end
        end

        if MedusaConfig then
            if type(cfg.medusaRadius) == "number" then
                MedusaConfig.Radius = cfg.medusaRadius
                if MedusaConfig.RadiusPart then
                    MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius * 2, MedusaConfig.Radius * 2)
                end
            end
            if type(cfg.medusaDelay) == "number" then
                MedusaConfig.Delay = cfg.medusaDelay
            end
        end

        local function loadKey(entry, data)
            if not entry or type(data) ~= "table" then return end
            entry.kb = nil
            entry.gp = nil
            if data.kb and Enum.KeyCode[data.kb] then entry.kb = Enum.KeyCode[data.kb] end
            if data.gp and Enum.KeyCode[data.gp] then entry.gp = Enum.KeyCode[data.gp] end

            if State._bindButtons and State._bindButtons[entry] then
                State._bindButtons[entry].Text =
                    entry.gp and ("GP:" .. entry.gp.Name)
                    or (entry.kb and entry.kb.Name or "None")
            end
        end

        loadKey(KB.AutoLeft, cfg.autoLeftKey)
        loadKey(KB.AutoRight, cfg.autoRightKey)
        loadKey(KB.Drop, cfg.dropKey)
        loadKey(KB.TPDown, cfg.tpDownKey)
        loadKey(KB.AutoBat, cfg.autoBatKey)
        loadKey(KB.AutoBatV2, cfg.autoBatV2Key)
        loadKey(KB.InstaReset, cfg.instaResetKey)
        loadKey(KB.TPBat, cfg.tpBatKey)
        loadKey(KB.Speed, cfg.speedKey)
        loadKey(KB.Lagger, cfg.laggerKey)
        loadKey(KB.GuiHide, cfg.guiHideKey)

        if cfg.infJump ~= nil then
            State.infJumpEnabled = cfg.infJump == true
            if setInfJump then setInfJump(State.infJumpEnabled) end
        end
        if cfg.superJump ~= nil then
            State.superJumpEnabled = cfg.superJump == true
            if setSuperJump then setSuperJump(State.superJumpEnabled) end
        end
        if cfg.antiRagdoll ~= nil then
            State.antiRagdollEnabled = cfg.antiRagdoll == true
            if setAntiRag then setAntiRag(State.antiRagdollEnabled) end
            if State.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        if cfg.fpsBoost ~= nil then
            State.fpsBoostEnabled = cfg.fpsBoost == true
            if setFps then setFps(State.fpsBoostEnabled) end
            if State.fpsBoostEnabled then pcall(applyFPSBoost) end
        end
        if cfg.medusaCounter ~= nil then
            State.medusaCounterEnabled = cfg.medusaCounter == true
            if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
            if State.medusaCounterEnabled then State.setupMedusaCounter(LP.Character) else State.stopMedusaCounter() end
        end
        if cfg.batCounter ~= nil then
            State.batCounterEnabled = cfg.batCounter == true
            if setBatCounter then setBatCounter(State.batCounterEnabled) end
            if State.batCounterEnabled then State.startBatCounter() else State.stopBatCounter() end
        end
        if cfg.autoStealEnabled ~= nil then
            local autoStealOn = cfg.autoStealEnabled == true
            Steal.AutoStealEnabled = autoStealOn
            if CONFIG then CONFIG.AUTO_STEAL_ENABLED = autoStealOn end
            if setAutoGrab then setAutoGrab(autoStealOn) end
            if State._autoStealBar then
                if State._autoStealBar.frame then State._autoStealBar.frame.Visible = autoStealOn end
                if State._autoStealBar.toggleBtn then
                    State._autoStealBar.toggleBtn.Text = autoStealOn and "STOP" or "START"
                end
                if State._autoStealBar.statusLabel then
                    State._autoStealBar.statusLabel.Text = autoStealOn and "READY" or "IDLE"
                end
            end
            if autoStealOn then pcall(startAutoSteal) else pcall(stopAutoSteal) end
        end
        if cfg.autoSwing ~= nil then
            State.autoSwingEnabled = cfg.autoSwing == true
            if setAutoSwingVisual then setAutoSwingVisual(State.autoSwingEnabled) end
        end
        if cfg.unwalkEnabled ~= nil then
            State.unwalkEnabled = cfg.unwalkEnabled == true
            if setUnwalkToggle then setUnwalkToggle(State.unwalkEnabled) end
            if State.unwalkEnabled then State.startUnwalk() else State.stopUnwalk() end
        end

        if cfg.stretchRez ~= nil and setStretchRez then
            State.stretchRezEnabled = cfg.stretchRez == true
            setStretchRez(State.stretchRezEnabled)
        end
        if cfg.removeAccessories ~= nil and setRemoveAccessories then
            State.removeAccessoriesEnabled = cfg.removeAccessories == true
            setRemoveAccessories(State.removeAccessoriesEnabled)
        end
        if cfg.antiLag ~= nil and setAntiLag then
            State.antiLagEnabled = cfg.antiLag == true
            setAntiLag(State.antiLagEnabled)
        end

        if cfg.hitboxFollower ~= nil or cfg.hitboxFollowerEnabled ~= nil then
            State.hitboxFollowerEnabled = (cfg.hitboxFollower ~= nil and cfg.hitboxFollower == true)
                or (cfg.hitboxFollower == nil and cfg.hitboxFollowerEnabled == true)
            if State._setHitboxFollower then
                State._setHitboxFollower(State.hitboxFollowerEnabled)
            end
            if State.hitboxFollowerEnabled then
                State._hitboxFollower.start()
            else
                State._hitboxFollower.stop()
            end
        end

        if cfg.skyStyle ~= nil and setSkyStyle then
            setSkyStyle(cfg.skyStyle)
        elseif cfg.darkMode ~= nil and setDarkMode then
            setDarkMode(cfg.darkMode == true)
        end

        if cfg.desyncEnabled ~= nil then
            State.desyncEnabled = cfg.desyncEnabled == true
            task.defer(function()
                if setDesync then setDesync(State.desyncEnabled) end
                if saDesync then saDesync(State.desyncEnabled) end
                if State.desyncEnabled and startDesyncSession then startDesyncSession() end
            end)
        end

        if cfg.linieEnabled ~= nil then
            State.linieEnabled = cfg.linieEnabled == true
            if setLinieVisual then setLinieVisual(State.linieEnabled) end
        end
        if cfg.autoMedusaEnabled ~= nil then
            if MedusaConfig then MedusaConfig.Enabled = cfg.autoMedusaEnabled == true end
            if setAutoMedusaVisual then setAutoMedusaVisual(cfg.autoMedusaEnabled == true) end
        end

        if cfg.nuevaAnimacion ~= nil then
            State.nuevaAnimacionEnabled = cfg.nuevaAnimacion == true
            if setNuevaAnimacionVisual then setNuevaAnimacionVisual(State.nuevaAnimacionEnabled) end
            if State.nuevaAnimacionEnabled then
                task.defer(startNuevaAnimacion)
            else
                task.defer(stopNuevaAnimacion)
            end
        end

        local savedInstaReset = cfg.instaReset
        if savedInstaReset == nil then savedInstaReset = cfg.instaResetEnabled end
        if savedInstaReset ~= nil then
            State.instaResetEnabled = savedInstaReset == true
            if setInstaToggleVisual then setInstaToggleVisual(State.instaResetEnabled) end
        end

        if cfg.hideButtons ~= nil then
            State.hideButtonsEnabled = cfg.hideButtons == true
            if setHideButtonsVisual then setHideButtonsVisual(State.hideButtonsEnabled) end

            local visible = not State.hideButtonsEnabled
            if MobilePanel then MobilePanel.Visible = visible end
            for _, mobileBtn in pairs(mobileButtonsByName) do
                if mobileBtn then mobileBtn.Visible = visible end
            end
            if btnBatV2 then btnBatV2.Visible = visible end
            if btnInstaReset then
                btnInstaReset.Visible = visible and (cfg.instaResetVisible ~= false)
            end
            if pbFrame then pbFrame.Visible = visible end
        elseif cfg.instaResetVisible ~= nil and btnInstaReset then
            btnInstaReset.Visible = cfg.instaResetVisible == true
        end

        State.speedProfile = cfg.speedProfile == "Lagger" and "Lagger" or "Normal"
        if State._refreshSpeedProfileVisual then State._refreshSpeedProfileVisual() end
        if normalBox then
            normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS)
        end
        if carryBox then
            carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS)
        end

        State.speedToggled = cfg.speedToggled == true
        State.laggerToggled = cfg.laggerMode == true
        laggerPhase = tonumber(cfg.laggerPhase) or (State.laggerToggled and 1 or 0)
        laggerPhase = math.clamp(math.floor(laggerPhase), 0, 2)

        if State.laggerToggled then
            State.speedToggled = false
        elseif laggerPhase ~= 0 then
            laggerPhase = 0
        end

        if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
        if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
        if modeValLbl then
            modeValLbl.Text =
                laggerPhase == 2 and "Lagger Carry"
                or (State.laggerToggled and "Lagger")
                or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"))
                or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal")
        end

        State._setTPBatEnabled(cfg.tpBatEnabled == true)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end

        local autoBatV1 = cfg.autoBatToggled == true
        local autoBatV2 = cfg.autoBatV2Toggled == true
        if autoBatV1 then autoBatV2 = false end

        State.autoBatToggled = autoBatV1
        State.autoBatV2Enabled = autoBatV2

        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
        if State.autoBatToggled then
            task.defer(startBatAimbot)
        elseif State.autoBatV2Enabled then
            task.defer(startBatAimbotV2)
        else
            pcall(stopBatAimbot)
            if stopBatAimbotV2 then pcall(stopBatAimbotV2) end
        end

        local function restorePosition(guiObject, data)
            if guiObject and type(data) == "table" and data.xs ~= nil then
                guiObject.Position = UDim2.new(
                    data.xs,
                    data.xo or 0,
                    data.ys or 0,
                    data.yo or 0
                )
            end
        end

        local function restoreSavedPositions()
            restorePosition(main, cfg.mainPos)
            restorePosition(mini, cfg.miniPos)
            restorePosition(MobilePanel, cfg.panelPos)

            if type(cfg.mobileButtonPositions) == "table" then
                for name, positionData in pairs(cfg.mobileButtonPositions) do
                    restorePosition(mobileButtonsByName[name], positionData)
                end
            end

            restorePosition(pbFrame, cfg.pbPos)
            restorePosition(btnBatV2, cfg.batV2Pos)
            restorePosition(btnInstaReset, cfg.instaResetPos)
            restorePosition(frame, cfg.autoStealBarPos)
        end

        restoreSavedPositions()
        task.delay(0.7, restoreSavedPositions)
        task.delay(1.35, function()
            restoreSavedPositions()
            task.defer(function()
                if State.loadPositionBackup and not State._positionDirty then
                    pcall(State.loadPositionBackup)
                end
            end)
        end)
    end)

    State._configLoading = false
    State._configLoaded = true
    State._configLoadFailed = not applyOk

    if applyOk then
        State._lastConfigJson = raw
        State._lastSaveError = nil
        State._configDirty = false
    else
        State._lastSaveError = "La configuración se leyó, pero no se pudo aplicar; no será sobrescrita"
    end

    local pendingSave = State._saveAfterLoad
    State._saveAfterLoad = false

    if applyOk and (loadedFromBackup or loadedFromLegacy or loadedFromTemp or pendingSave) then
        if loadedFromBackup or loadedFromLegacy or loadedFromTemp then State._lastConfigJson = nil end
        State.requestConfigSave()
    end

    return applyOk
end

State._otherSpeedLabels = State._otherSpeedLabels or {}
State._otherSpeedConnections = State._otherSpeedConnections or {}

State._attachOtherSpeedBillboard = function(player, character)
    if not player or player == LP or not character then return end

    task.spawn(function()
        local head = character:WaitForChild("Head", 8)
        local root = character:WaitForChild("HumanoidRootPart", 8)
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
        if not head or not root or not humanoid then return end

        local old = head:FindFirstChild("CRYONOtherSpeedBB")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Name = "CRYONOtherSpeedBB"
        bb.Adornee = head
        bb.Parent = head
        bb.Size = UDim2.new(0, 180, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 1000

        local label = Instance.new("TextLabel")
        label.Name = "OtherSpeedBillLbl"
        label.Parent = bb
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "0.0"
        label.TextColor3 = Color3.fromRGB(200, 0, 0)
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        State._otherSpeedLabels[player] = {
            label = label,
            root = root,
            humanoid = humanoid,
        }
    end)
end

State._setupOtherPlayerBillboard = function(player)
    if not player or player == LP then return end

    local previousConnection = State._otherSpeedConnections[player]
    if previousConnection then
        pcall(function() previousConnection:Disconnect() end)
    end

    State._otherSpeedConnections[player] = player.CharacterAdded:Connect(function(character)
        State._attachOtherSpeedBillboard(player, character)
    end)

    if player.Character then
        State._attachOtherSpeedBillboard(player, player.Character)
    end
end

task.spawn(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        State._setupOtherPlayerBillboard(otherPlayer)
    end
end)

Players.PlayerAdded:Connect(function(player)
    State._setupOtherPlayerBillboard(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local connection = State._otherSpeedConnections[player]
    if connection then pcall(function() connection:Disconnect() end) end
    State._otherSpeedConnections[player] = nil
    State._otherSpeedLabels[player] = nil
end)

task.spawn(function()
    while gui and gui.Parent do
        for player, data in pairs(State._otherSpeedLabels) do
            local label = data and data.label
            local root = data and data.root
            local humanoid = data and data.humanoid

            if player.Parent and label and label.Parent and root and root.Parent and humanoid and humanoid.Health > 0 then
                local velocity = root.AssemblyLinearVelocity
                local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                label.Text = string.format("%.1f", horizontalSpeed)
                label.Visible = true
            elseif label and label.Parent then
                label.Visible = false
            end
        end
        task.wait(0.08)
    end
end)

local h,hrp,speedLbl
State.setupChar = function(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5)
    hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end

    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("FEARV2MobileBB"); if oldBB then oldBB:Destroy() end
        local bb=Instance.new("BillboardGui",head); bb.Name="FEARV2MobileBB"
        bb.Size=UDim2.new(0,160,0,24); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
        speedLbl=Instance.new("TextLabel",bb); speedLbl.Name="SpeedBillLbl"
        speedLbl.Size=UDim2.new(1,0,0,24); speedLbl.Position=UDim2.new(0,0,0,0); speedLbl.BackgroundTransparency=1
        speedLbl.Text="0.0"; speedLbl.TextColor3=Color3.fromRGB(200, 0, 0)
        speedLbl.Font=Enum.Font.GothamBlack; speedLbl.TextScaled=true
        speedLbl.TextStrokeTransparency=0; speedLbl.TextStrokeColor3=Color3.fromRGB(0, 0, 0)
    end


    if State.unwalkEnabled then task.wait(0.3); State.startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end

    if State.medusaCounterEnabled then State.setupMedusaCounter(char) end

    if State.autoBatToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); State.startBatCounter() end
    if Steal.AutoStealEnabled then pcall(stopAutoSteal); task.wait(0.5); pcall(startAutoSteal) end
end

LP.CharacterAdded:Connect(State.setupChar)
if LP.Character then task.spawn(function() State.setupChar(LP.Character) end) end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

RunService.RenderStepped:Connect(function()
    if not (h and hrp) then return end; if State._tpInProgress then return end
    if not State.autoBatToggled and not State.autoLeftEnabled and not State.autoRightEnabled then
        local md = h.MoveDirection
        local spd = State.laggerToggled
			and (laggerPhase == 2 and LS2 or LS)
			or (State.speedToggled and State.getProfileCarrySpeed() or State.getProfileNormalSpeed())

        if type(spd) ~= "number" or spd < 0 then spd = 16 end

        -- Suavizado anti-kick: a 31 / 60 (y valores altos) no fuerza el velocity de golpe
        local function applySafeSpeed(dir, targetSpd)
            if not dir or dir.Magnitude < 0.01 then return end
            dir = dir.Unit
            pcall(function()
                h:Move(dir, false)
                local cur = hrp.AssemblyLinearVelocity
                local y = cur.Y
                local desired = Vector3.new(dir.X * targetSpd, y, dir.Z * targetSpd)
                -- Lerp más suave si el speed es alto (menos flags del anti-cheat)
                local alpha = 0.55
                if targetSpd >= 28 then alpha = 0.38 end
                if targetSpd >= 50 then alpha = 0.28 end
                if targetSpd >= 60 then alpha = 0.22 end
                hrp.AssemblyLinearVelocity = cur:Lerp(desired, alpha)
            end)
        end

        if spd == 0 then
            pcall(function()
                h:Move(Vector3.zero, false)
                local cur = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = Vector3.new(0, cur.Y, 0)
            end)
        elseif md.Magnitude > 0.05 then
            State.lastMoveDir = md.Unit
            applySafeSpeed(md, spd)
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true break end
            end
            if anyHeld then
                applySafeSpeed(State.lastMoveDir, spd)
            end
        end
    end
    pcall(function()
        if speedLbl then
            local vel = hrp.AssemblyLinearVelocity
            local hspd = Vector3.new(vel.X, 0, vel.Z).Magnitude
            speedLbl.Text = string.format("%.1f", hspd)
        end
    end)
end)

UIS.InputBegan:Connect(function(inp,gp)
    if _anyKeyListening then return end
    if gp and string.sub(inp.UserInputType.Name, 1, 7) ~= "Gamepad" then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end
    if State.kbMatch(KB.Speed,kc) then
        State.laggerToggled = false; laggerPhase = 0
        State.speedToggled = not State.speedToggled
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
    elseif State.kbMatch(KB.AutoLeft,kc) then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoLeftEnabled then State.startAutoLeft() else State.stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
    elseif State.kbMatch(KB.AutoRight,kc) then
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoRightEnabled then State.startAutoRight() else State.stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
    elseif State.kbMatch(KB.Drop,kc) then
        if not State.dropActive then task.spawn(State.runDrop) end
    elseif State.kbMatch(KB.TPDown,kc) then
        task.spawn(State.doTpDown)
    elseif State.kbMatch(KB.Lagger,kc) then
        if State._setLaggerPhase then State._setLaggerPhase(laggerPhase == 1 and 0 or 1)
        else
            laggerPhase = (laggerPhase == 1) and 0 or 1
            State.laggerToggled = laggerPhase ~= 0
            if State.laggerToggled then State.speedToggled = false end
            if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
            if modeValLbl then modeValLbl.Text = laggerPhase == 1 and "Lagger 1" or "Normal" end
        end
    elseif KB.Lagger2 and State.kbMatch(KB.Lagger2,kc) then
        if State._setLaggerPhase then State._setLaggerPhase(laggerPhase == 2 and 0 or 2) end
    elseif State.kbMatch(KB.AutoBat,kc) then
        State.autoBatToggled=not State.autoBatToggled
        if State.autoBatToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; State.stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; State.stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
    elseif State.kbMatch(KB.AutoBatV2,kc) then
        State.autoBatV2Enabled = not State.autoBatV2Enabled
        if State.autoBatV2Enabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; State.stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; State.stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
    elseif State.kbMatch(KB.TPBat,kc) then
        State._setTPBatEnabled(not State.tpBatEnabled)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
    elseif State.kbMatch(KB.InstaReset,kc) then
        task.spawn(State.cursedInstaReset)
        if btnInstaReset and btnInstaReset.Parent then
            btnInstaReset:SetAttribute("PurpleFlash", true)
            task.delay(0.55, function() if btnInstaReset and btnInstaReset.Parent then btnInstaReset:SetAttribute("PurpleFlash", false) end end)
        end
        if setInstaToggleVisual then
            setInstaToggleVisual(true)
            task.delay(0.2, function() if setInstaToggleVisual then setInstaToggleVisual(false) end end)
        end
    elseif State.kbMatch(KB.GuiHide,kc) then
        State.guiVisible=not State.guiVisible
        pcall(function() main.Visible=State.guiVisible end)
        pcall(function() mini.Visible=not State.guiVisible end)
    end

    if State.requestConfigSave then State.requestConfigSave() end
end)

State.loadPresetsFile()

task.spawn(function()
    local lastPresetName = State.loadLastPresetName()
    if lastPresetName and lastPresetName ~= "" then
        for _, preset in ipairs(Presets) do
            if preset.name == lastPresetName then
                pcall(function() applyPreset(preset.data) end)
                break
            end
        end
    end

    task.wait(0.2)
    local loaded = loadConfig()

    task.wait(0.5)
    if not loaded and State._allowInitialConfigCreation then
        pcall(saveConfig)
    end
end)

Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if parent == nil and State._configLoaded and not State._configLoadFailed then
        if State._configDirty then pcall(saveConfig) end
        if State._positionDirty and State.savePositionBackup then
            pcall(State.savePositionBackup)
        end
    end
end)

pcall(function()
    game:BindToClose(function()
        if State._configLoaded and not State._configLoadFailed then
            if State._configDirty then pcall(saveConfig) end
            if State._positionDirty and State.savePositionBackup then
                pcall(State.savePositionBackup)
            end
        end
    end)
end)

print("[MOYA DUELS V2] Loaded!")

end)()

end)()
