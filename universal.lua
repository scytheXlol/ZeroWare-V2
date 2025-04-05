--[[ Lib ]]--
local bu1nnri9jfn = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--[[ Variables & Services ]]--
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local execname = identifyexecutor()
local ttl = string.format('ZeroWare | V2 BETA | %s | Universal', execname)

--[[ Window ]]--
local Window = bu1nnri9jfn:CreateWindow({
    Name = ttl,
    Icon = 'atom',
    LoadingTitle = "ZeroWare V2 - BETA",
    LoadingSubtitle = "Loading...",
    Theme = "Serenity",
 
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
 
    ConfigurationSaving = {
       Enabled = false,
       FolderName = 'ZeroWare V2',
       FileName = "ConfigAutoSave"
    },
 
    Discord = {
       Enabled = false,
       Invite = "DPCKQRJmdF",
       RememberJoins = true
    },
 
    KeySystem = false, -- keyless for next 48h 😎
    KeySettings = {
       Title = "Key System",
       Subtitle = "",
       Note = "The link to get the key has been copied!",
       FileName = "KeyData",
       SaveKey = false,
       GrabKeyFromSite = false,
       Key = {'444'}
    }
})

--[[ Home Tab ]]--
local Home = Window:CreateTab("Home", 'home')
local Script = Home:CreateSection("Script")

local versionlabel = Home:CreateLabel("Version 2.0.3")
local buildlabel = Home:CreateLabel('Build: B2H0 Beta')

local Devs = Home:CreateSection("Developers")

local Samuraa1 = Home:CreateLabel("CEO | ScriptBlox & Discord: samuraa1")
local n1x = Home:CreateLabel("Developer | ScriptBlox & Discord: n1x_its_me")

--[[ Combat Tab ]]--
local CombatTab = Window:CreateTab("Combat", 'swords')
local Aimbot = CombatTab:CreateSection("Aimbot")

--[[ Aimbot Settings ]]--
local AimbotSettings = {
    AimbotEnabled = false,
    TeamCheck = false,
    AimPart = "Head",
    Sensitivity = 0.001,
    FOV = 60,
    AimOffset = Vector3.new(0, 0.1, 0),
    CheckWalls = false
}

--[[ Aimbot Handler ]]--
local function IsPointVisible(startPosition, endPosition, targetPlayer)
    local direction = (endPosition - startPosition).unit
    local distance = (endPosition - startPosition).magnitude
    local ray = Ray.new(startPosition, direction * distance)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(ray.Origin, ray.Direction, raycastParams)
    return not result
end

local function GetClosestPlayer()
    local MaximumDistance = math.huge
    local ClosestPlayer = nil

    local CameraDirection = Camera.CFrame.LookVector
    local CameraPosition = Camera.CFrame.Position

    for _, v in next, Players:GetPlayers() do
        if v.Name ~= LocalPlayer.Name then
            if AimbotSettings.TeamCheck == true then
                if v.Team ~= LocalPlayer.Team then
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        local TargetPosition = v.Character.HumanoidRootPart.Position + AimbotSettings.AimOffset
                        local DirectionToTarget = (TargetPosition - CameraPosition).unit
                        local DotProduct = CameraDirection:Dot(DirectionToTarget)
                        local Angle = math.acos(DotProduct) * (180 / math.pi)

                        if Angle <= AimbotSettings.FOV / 2 then
                            local ScreenPoint = Camera:WorldToScreenPoint(TargetPosition)
                            local MousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                            local VectorDistance = (MousePosition - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                        
                            if VectorDistance < MaximumDistance then
                                if AimbotSettings.CheckWalls then
                                    if IsPointVisible(CameraPosition, TargetPosition, v) then
                                        ClosestPlayer = v
                                        MaximumDistance = VectorDistance
                                    end
                                else
                                    ClosestPlayer = v
                                    MaximumDistance = VectorDistance
                                end
                            end
                        end
                    end
                end
            else
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local TargetPosition = v.Character.HumanoidRootPart.Position + AimbotSettings.AimOffset
                    local DirectionToTarget = (TargetPosition - CameraPosition).unit
                    local DotProduct = CameraDirection:Dot(DirectionToTarget)
                    local Angle = math.acos(DotProduct) * (180 / math.pi)

                    if Angle <= AimbotSettings.FOV / 2 then
                        local ScreenPoint = Camera:WorldToScreenPoint(TargetPosition)
                        local MousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        local VectorDistance = (MousePosition - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                        
                        if VectorDistance < MaximumDistance then
                            if AimbotSettings.CheckWalls then
                                if IsPointVisible(CameraPosition, TargetPosition, v) then
                                    ClosestPlayer = v
                                    MaximumDistance = VectorDistance
                                end
                            else
                                ClosestPlayer = v
                                MaximumDistance = VectorDistance
                            end
                        end
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
        Target = nil
    end
end)

--[[ Aimbot Custom Settings ]]--
local Aimbot_Enabled = CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabledValue",
    Callback = function(Value)
        AimbotSettings.AimbotEnabled = Value
    end,
})

local Aimbot_TeamCheck = CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "AimbotTeamCheckValue",
    Callback = function(Value)
        AimbotSettings.TeamCheck = Value
    end,
})

local Aimbot_AimPart = CombatTab:CreateInput({
    Name = "Aim Part",
    CurrentValue = "Head",
    PlaceholderText = "Head",
    RemoveTextAfterFocusLost = false,
    Flag = "AimbotAimPartText",
    Callback = function(Text)
        AimbotSettings.AimPart = Text
    end,
})

--[[local Aimbot_Sensitivity = CombatTab:CreateSlider({
    Name = "Sensitivity",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.2,
    Flag = "AimbotSensitivityValue",
    Callback = function(Value)
        AimbotSettings.Sensitivity = Value
    end,
})]]-- broken:(

local Aimbot_FOV = CombatTab:CreateSlider({
    Name = "FOV",
    Range = {8, 360},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 60,
    Flag = "AimbotFOVValue",
    Callback = function(Value)
        AimbotSettings.FOV = Value
    end,
})

local Aimbot_CheckWalls = CombatTab:CreateToggle({
    Name = "Check Walls",
    CurrentValue = false,
    Flag = "AimbotCheckWallsValue",
    Callback = function(Value)
        AimbotSettings.CheckWalls = Value
    end,
})

RunService.RenderStepped:Connect(function()
    if Holding and AimbotSettings.AimbotEnabled then
        if not Target or not Target.Character or not Target.Character:FindFirstChild(AimbotSettings.AimPart) or Target.Character.Humanoid.Health <= 0 then
            Target = GetClosestPlayer()
        end
        if Target and Target.Character and Target.Character:FindFirstChild(AimbotSettings.AimPart) then
            local targetPos = Target.Character[AimbotSettings.AimPart].Position + AimbotSettings.AimOffset
            local smoothedPos = Camera.CFrame.Position:Lerp(targetPos, AimbotSettings.Sensitivity)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, smoothedPos)
        end
    end
end)

--[[ Visuals Tab ]]--
local Visuals = Window:CreateTab("Visuals", 'sun')
local ESP = Visuals:CreateSection("Chams")

--[[ Chams Settings ]]--
local ChamSettings = {
    PlayerChams = false,
    RainbowLine = false,
    PlayerText = false,
    RainbowText = false,
    FillColor = Color3.fromRGB(154, 215, 255),
    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
    FillTransparency = 0.5,
    OutlineColor = Color3.fromRGB(0, 0, 0),
    OutlineTransparency = 0.4
}

--[[ Chams ]]--
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Storage = CoreGui:FindFirstChild("OmniShieldChams") or Instance.new("Folder", CoreGui)
Storage.Name = "Random"

local playerHighlights = {}
local connections = {} 

local function updateHighlight(plr)
    local highlight = playerHighlights[plr.UserId]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.FillColor = ChamSettings.FillColor
        highlight.DepthMode = ChamSettings.DepthMode
        highlight.FillTransparency = ChamSettings.FillTransparency
        highlight.OutlineColor = ChamSettings.OutlineColor
        highlight.OutlineTransparency = ChamSettings.OutlineTransparency
        highlight.Parent = Storage
        playerHighlights[plr.UserId] = highlight
    end

    local function updateHighlightLoop()
        while highlight and highlight.Parent do
            local char = plr.Character
            if char then
                highlight.Adornee = char
            end
            task.wait(0.5)
        end
    end

    task.spawn(updateHighlightLoop)
end

local function onPlayerRespawn(plr)
    if ChamSettings.PlayerChams then
        updateHighlight(plr)
    end
end

local function onLocalPlayerRespawn()
    local localPlayerHighlight = playerHighlights[lp.UserId]
    if localPlayerHighlight then
        localPlayerHighlight:Destroy()
        playerHighlights[lp.UserId] = nil
    end
    if ChamSettings.PlayerChams then
        updateHighlight(lp)
    end
end

local function toggleESP(enabled)
    if enabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and not playerHighlights[plr.UserId] then
                updateHighlight(plr)
            end
        end
        if not connections["PlayerAdded"] then
            connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(plr)
                if plr ~= lp then
                    updateHighlight(plr)
                end
            end)
        end
    else
        for _, highlight in pairs(playerHighlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        playerHighlights = {}
        
        if connections["PlayerAdded"] then
            connections["PlayerAdded"]:Disconnect()
            connections["PlayerAdded"] = nil
        end
    end
end

local function refreshESP()
    toggleESP(ChamSettings.PlayerChams)
end

Players.PlayerAdded:Connect(onPlayerRespawn)
Players.PlayerRemoving:Connect(function(plr)
    local existingHighlight = playerHighlights[plr.UserId]
    if existingHighlight then
        existingHighlight:Destroy()
        playerHighlights[plr.UserId] = nil
    end
end)

lp.CharacterAdded:Connect(onLocalPlayerRespawn)
task.spawn(function()
    while true do
        refreshESP()
        task.wait(0.001)
    end
end)
task.spawn(function()
    while true do
        if ChamSettings.PlayerChams then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and not playerHighlights[plr.UserId] then
                    updateHighlight(plr)
                end
            end
        end
        task.wait(0.001)
    end
end)
task.spawn(function()
    while true do
        if ChamSettings.PlayerText then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and not playerTexts[plr.UserId] then
                    updateTextLabel(plr)
                end
            end
        end
        task.wait(0.001)
    end
end)

local Chams_Enabled = Visuals:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Flag = "ChamsEnabledValue",
    Callback = function(Value)
    ChamSettings.PlayerChams = Value
    end,
})
local Chams_FillColor = Visuals:CreateColorPicker({
    Name = "Fill Color",
    Color = Color3.fromRGB(154, 215, 255),
    Flag = "ChamsFillColor3RGB",
    Callback = function(Value)
        ChamSettings.FillColor = Value
        if ChamSettings.PlayerChams == true then
            ChamSettings.PlayerChams = false
            wait(0.006)
            refreshESP()
            wait(0.003)
            ChamSettings.PlayerChams = true
        end
    end
})
local Chams_FillTransparency = Visuals:CreateSlider({
    Name = "Fill Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ChamsFillTransparencyValue",
    Callback = function(Value)
        ChamSettings.FillTransparency = Value
        if ChamSettings.PlayerChams == true then
            ChamSettings.PlayerChams = false
            wait(0.006)
            refreshESP()
            wait(0.003)
            ChamSettings.PlayerChams = true
        end
    end,
})
local Chams_OutlineColor = Visuals:CreateColorPicker({
    Name = "Outline Color",
    Color = Color3.fromRGB(0, 0, 0),
    Flag = "ChamsOutlineColor3RGB",
    Callback = function(Value)
        ChamSettings.OutlineColor = Value
        if ChamSettings.PlayerChams == true then
            ChamSettings.PlayerChams = false
            wait(0.006)
            refreshESP()
            wait(0.003)
            ChamSettings.PlayerChams = true
        end
    end
})
local Chams_OutlineTransparency = Visuals:CreateSlider({
    Name = "Outline Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.4,
    Flag = "ChamsOutlineTransparencyValue",
    Callback = function(Value)
        ChamSettings.OutlineTransparency = Value
        if ChamSettings.PlayerChams == true then
            ChamSettings.PlayerChams = false
            wait(0.006)
            refreshESP()
            wait(0.003)
            ChamSettings.PlayerChams = true
        end
    end,
})

local ESPSec = Visuals:CreateSection("Another ESP's")

local BoxEnabled = false
local BoxColor = Color3.fromRGB(255, 255, 255)
local BoxTransparency = 1
local BoxThickness = 2
local BoxFilled = false

local players = game:GetService("Players")
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer

local espBoxes = {}

local function createESP(player)
    if player == localPlayer then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = BoxColor
    box.Transparency = BoxTransparency
    box.Thickness = BoxThickness
    box.Filled = BoxFilled
    espBoxes[player] = {box = box}
end

local function updateESP()
    if not BoxEnabled then
        for player, data in pairs(espBoxes) do
            data.box.Visible = false
            data.box.Color = BoxColor
            data.box.Transparency = BoxTransparency
            data.box.Thickness = BoxThickness
            data.box.Filled = BoxFilled
            data.box.FilledTransparency = FilledTransparency
        end
        return
    end
    
    for player, data in pairs(espBoxes) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local rootPart = character.HumanoidRootPart
            local screenPosition, onScreen = camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                local headPosition = camera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 1, 0))
                local legPosition = camera:WorldToViewportPoint(character.HumanoidRootPart.Position - Vector3.new(0, 3.5, 0))

                local boxHeight = math.abs(headPosition.Y - legPosition.Y)
                local boxWidth = boxHeight / 2.2

                data.box.Size = Vector2.new(boxWidth, boxHeight)
                data.box.Position = Vector2.new(screenPosition.X - boxWidth / 2, screenPosition.Y - boxHeight / 2)
                data.box.Visible = true
            else
                data.box.Visible = false
            end
        else
            data.box.Visible = false
        end
    end
end

for _, player in pairs(players:GetPlayers()) do
    createESP(player)
end
players.PlayerAdded:Connect(createESP)
runService.RenderStepped:Connect(updateESP)

local function toggleESP()
    BoxEnabled = not BoxEnabled
end

local Box_Enabled = Visuals:CreateToggle({
    Name = "Boxes",
    CurrentValue = false,
    Flag = "ESPBoxEnabledValue",
    Callback = function(Value)
        BoxEnabled = Value
    end,
})
local Box_Color = Visuals:CreateColorPicker({
    Name = "Box Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPBoxColor3RGB",
    Callback = function(Value)
        BoxColor = Value
        if BoxEnabled == true then
            BoxEnabled = false
            updateESP()
            BoxEnabled = true
        end
    end
})
local Box_Transparency = Visuals:CreateSlider({
    Name = "Box Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 1,
    Flag = "ESPBoxTransparencyValue",
    Callback = function(Value)
    BoxTransparency = Value
    if BoxEnabled == true then
        BoxEnabled = false
        updateESP()
        BoxEnabled = true
    end
    end,
})
local Box_Thickness = Visuals:CreateSlider({
    Name = "Box Thickness",
    Range = {1, 6},
    Increment = 1,
    Suffix = "",
    CurrentValue = 2,
    Flag = "ESPBoxThicknessValue",
    Callback = function(Value)
    BoxThickness = Value
    if BoxEnabled == true then
        BoxEnabled = false
        updateESP()
        BoxEnabled = true
    end
    end,
})
local Box_Filled = Visuals:CreateToggle({
    Name = "Box Filled",
    CurrentValue = false,
    Flag = "ESPBoxFilledValue",
    Callback = function(Value)
        BoxFilled = Value
        if BoxEnabled == true then
            BoxEnabled = false
            updateESP()
            BoxEnabled = true
        end
    end,
})

local HealthEnabled = false
local HealthTransparency = 1

local Health_Enabled = Visuals:CreateToggle({
    Name = "Health",
    CurrentValue = false,
    Flag = "ESPHealthEnabledValue",
    Callback = function(Value)
        HealthEnabled = Value
    end,
})

local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = HealthTransparency
    return line
end

local function Visibility(state, lib)
    for _, x in pairs(lib) do
        x.Visible = state
    end
end

local function ESP(plr)
    local library = {
        healthbar = NewLine(3, Color3.fromRGB(0, 0, 0)),
        greenhealth = NewLine(1.5, Color3.fromRGB(0, 255, 0))
    }

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not HealthEnabled then
                Visibility(false, library)
                return
            end

            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
                    local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY * 2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY * 2)).magnitude 
                    local healthoffset = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * d

                    library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                    library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2 - healthoffset)
                    
                    library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                    library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY * 2)
                    
                    local green = Color3.fromRGB(0, 255, 0)
                    local red = Color3.fromRGB(255, 0, 0)
                    
                    library.greenhealth.Color = red:lerp(green, plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
                    
                    Visibility(true, library)
                else
                    Visibility(false, library)
                end
            else
                Visibility(false, library)
                if not game.Players:FindFirstChild(plr.Name) then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end
game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)
local function toggleHealthESP()
    HealthEnabled = not HealthEnabled
end

local TracersEnabled = false
local TracersThickness = 2
local TracersTransparency = 1
local TracersColor = Color3.fromRGB(255, 255, 255)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ViewportSize = Camera.ViewportSize

local Tracers = {}

local function createTracer(player)
    if player ~= LocalPlayer and not Tracers[player] then
        local line = Drawing.new("Line")
        line.Thickness = TracersThickness
        line.Transparency = TracersTransparency
        line.Color = TracersColor
        line.Visible = false
        Tracers[player] = line
    end
end

local function updateTracers()
    if not TracersEnabled then
        for _, tracer in pairs(Tracers) do
            tracer.Visible = false
            tracer.Thickness = TracersThickness
            tracer.Transparency = TracersTransparency
            tracer.Color = TracersColor
            tracer.Visible = false
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        local tracer = Tracers[player]
        if player ~= LocalPlayer and tracer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                tracer.From = Vector2.new(ViewportSize.X / 2, ViewportSize.Y)
                tracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        elseif tracer then
            tracer.Visible = false
        end
    end
end

local function onPlayerRemoving(player)
    if Tracers[player] then
        Tracers[player]:Remove()
        Tracers[player] = nil
    end
end

Players.PlayerAdded:Connect(createTracer)
Players.PlayerRemoving:Connect(onPlayerRemoving)
for _, player in pairs(Players:GetPlayers()) do
    createTracer(player)
end
RunService.RenderStepped:Connect(updateTracers)

local Tracers_Enabled = Visuals:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "ESPTracersEnabledValue",
    Callback = function(Value)
        TracersEnabled = Value
    end,
})
local Tracers_Thickness = Visuals:CreateSlider({
    Name = "Tracers Thickness",
    Range = {1, 4},
    Increment = 1,
    Suffix = "",
    CurrentValue = 2,
    Flag = "ESPTracersThicknessValue",
    Callback = function(Value)
    TracersThickness = Value
    if TracersEnabled == true then
        TracersEnabled = false
        updateTracers()
        TracersEnabled = true
    end
    updateTracers()
    end,
})
local Tracers_Transparency = Visuals:CreateSlider({
    Name = "Tracers Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 1,
    Flag = "ESPTracersTransparencyValue",
    Callback = function(Value)
    TracersTransparency = Value
        if TracersEnabled == true then
        TracersEnabled = false
        updateTracers()
        TracersEnabled = true
    end
    updateTracers()
    end,
})
local Tracers_Color = Visuals:CreateColorPicker({
    Name = "Tracers Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPTracersColor3RGB",
    Callback = function(Value)
        TracersColor = Value
        if TracersEnabled == true then
            TracersEnabled = false
            updateTracers()
            TracersEnabled = true
        end
        updateTracers()
    end
})

--[[local NameEnabled = false

local Camera = workspace.CurrentCamera
local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer
local RunService = game:GetService("RunService")

local ESPTexts = {}

local function createESP(player, character)
    local Humanoid = character:FindFirstChildOfClass("Humanoid")
    local Head = character:FindFirstChild("Head")

    if not Humanoid or not Head then return end

    local ESPText = Drawing.new("Text")
    ESPText.Visible = false
    ESPText.Center = true
    ESPText.Outline = false
    ESPText.Font = 3
    ESPText.Size = 20
    ESPText.Color = Color3.fromRGB(255, 255, 255)

    ESPTexts[player] = ESPText

    local function removeESP()
        if ESPTexts[player] then
            ESPTexts[player].Visible = false
            ESPTexts[player]:Remove()
            ESPTexts[player] = nil
        end
    end

    character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            removeESP()
        end
    end)

    Humanoid.HealthChanged:Connect(function(health)
        if health <= 0 or Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            removeESP()
        end
    end)

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not NameEnabled or not ESPTexts[player] or not Head.Parent then
            removeESP()
            connection:Disconnect()
            return
        end

        local HeadPosition, OnScreen = Camera:WorldToViewportPoint(Head.Position)
        if OnScreen then
            ESPText.Position = Vector2.new(HeadPosition.X, HeadPosition.Y - 27)
            ESPText.Text = player.Name
            ESPText.Visible = true
        else
            ESPText.Visible = false
        end
    end)
end

local function onPlayerAdded(player)
    if player.Character then
        createESP(player, player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        createESP(player, character)
    end)
end

for _, player in ipairs(PlayersService:GetPlayers()) do
    if player ~= LocalPlayer then
        onPlayerAdded(player)
    end
end
PlayersService.PlayerAdded:Connect(onPlayerAdded)

local Name_Enabled = Visuals:CreateToggle({
    Name = "Names",
    CurrentValue = false,
    Flag = "ESPNameEnabledValue",
    Callback = function(Value)
        NameEnabled = Value
    end,
})]]--

local XraySec = Visuals:CreateSection("X-Ray")

--! Settings
local xrayenabled = false
local transparency = 0.5

--[[ X-RAY Handler ]]--
local function xray()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = transparency
        end
    end
end
local function refreshxray()
    if xrayenabled == true then
        xray()
    else
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

--[[ Xray ]]--

local Xray_Enabled = Visuals:CreateToggle({
    Name = "X-Ray",
    CurrentValue = false,
    Flag = "XRAYEnabledValue",
    Callback = function(Value)
    xrayenabled = Value
    refreshxray()
    end,
})
local Xray_Transparency = Visuals:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "XRAYTransparencyValue",
    Callback = function(Value)
    transparency = Value
    refreshxray()
    end,
})

local FullbrightSec = Visuals:CreateSection("Fullbright")

local Fullbright = false
local Lighting = game:GetService("Lighting")
local OriginalBrightness = Lighting.Brightness
local OriginalGlobalShadows = Lighting.GlobalShadows
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local Brightness = 5

local Toggle = Visuals:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "FullbrightEnabledValue",
    Callback = function(Value)
        Fullbright = Value
        if Fullbright then
            Lighting.Brightness = Brightness
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            Lighting.Brightness = OriginalBrightness
            Lighting.GlobalShadows = OriginalGlobalShadows
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end,
})

local Slider = Visuals:CreateSlider({
    Name = "Brightness Changer",
    Range = {2, 100},
    Increment = 1,
    Suffix = "Brightness",
    CurrentValue = Brightness,
    Flag = "BrightnessSlider",
    Callback = function(Value)
        Brightness = Value
        if Fullbright then
            Lighting.Brightness = Brightness
        end
    end,
})

--[[ Misc Tab ]]--
local Misc = Window:CreateTab("Miscellaneous", "component")

local FlySec = Misc:CreateSection("Fly")

local FlyEnabled = false
local FlySpeed = 30
local VerticalSpeed = 0
local MaxVerticalSpeed = 30
local MinVerticalSpeed = -15
local VerticalAcceleration = 2
local DecelerationRate = 0.9

local Fly_Enabled = Misc:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyEnabledValue",
    Callback = function(Value)
        FlyEnabled = Value
        if not FlyEnabled then
            VerticalSpeed = 0
        end
    end
})
local Fly_Speed = Misc:CreateSlider({
    Name = "Speed",
    Range = {16, 120},
    Increment = 1,
    Suffix = "",
    CurrentValue = 30,
    Flag = "FlySpeedValue",
    Callback = function(Value)
    FlySpeed = Value
    end,
})

local function Fly()
    if not FlyEnabled or not HumanoidRootPart then return end

    local MoveDirection = game.Players.LocalPlayer.Character.Humanoid.MoveDirection
    local MoveVelocity = Vector3.new(MoveDirection.X * FlySpeed, 0, MoveDirection.Z * FlySpeed)

    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
        VerticalSpeed = math.min(VerticalSpeed + VerticalAcceleration, MaxVerticalSpeed) 
    elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        VerticalSpeed = math.max(VerticalSpeed - VerticalAcceleration, MinVerticalSpeed)
    else
        VerticalSpeed = VerticalSpeed * DecelerationRate
    end

    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(MoveVelocity.X, VerticalSpeed, MoveVelocity.Z)
end

game:GetService("RunService").Stepped:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
        Fly()
    end
end)
game:GetService("RunService").Stepped:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        HumanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
        Speedhack()
    end
end)

local Keybind = Misc:CreateKeybind({
    Name = "Fly Keybind",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Flag = "FlyKeybind1",
    Callback = function(Keybind)
        FlyEnabled = not FlyEnabled
        Fly_Enabled:Set(FlyEnabled)
    end,
 })

local FOVSec = Misc:CreateSection("Field Of View (FOV) Changer")

local FOVChanger = Misc:CreateSlider({
    Name = "FOV Changer",
    Range = {50, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOVValue",
    Callback = function(Value)
        local camera = game.Workspace.CurrentCamera
        if camera then
            camera.FieldOfView = Value
        end
    end,
})

local ct = Window:CreateTab("Custom Theme", "pencil")
local ctsec = ct:CreateSection("SOON")
--[[local customtheme = {
    TextColor = Color3.fromRGB(240, 240, 240),

    Background = Color3.fromRGB(25, 25, 25),
    Topbar = Color3.fromRGB(34, 34, 34),
    Shadow = Color3.fromRGB(20, 20, 20),

    NotificationBackground = Color3.fromRGB(20, 20, 20),
    NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

    TabBackground = Color3.fromRGB(80, 80, 80),
    TabStroke = Color3.fromRGB(85, 85, 85),
    TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
    TabTextColor = Color3.fromRGB(240, 240, 240),
    SelectedTabTextColor = Color3.fromRGB(50, 50, 50),

    ElementBackground = Color3.fromRGB(35, 35, 35),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
    SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
    ElementStroke = Color3.fromRGB(50, 50, 50),
    SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
            
    SliderBackground = Color3.fromRGB(50, 138, 220),
    SliderProgress = Color3.fromRGB(50, 138, 220),
    SliderStroke = Color3.fromRGB(58, 163, 255),

    ToggleBackground = Color3.fromRGB(30, 30, 30),
    ToggleEnabled = Color3.fromRGB(0, 146, 214),
    ToggleDisabled = Color3.fromRGB(100, 100, 100),
    ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
    ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
    ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
    ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

    DropdownSelected = Color3.fromRGB(40, 40, 40),
    DropdownUnselected = Color3.fromRGB(30, 30, 30),

    InputBackground = Color3.fromRGB(30, 30, 30),
    InputStroke = Color3.fromRGB(65, 65, 65),
    PlaceholderColor = Color3.fromRGB(178, 178, 178)
}
local ColorPicker = ct:CreateColorPicker({
    Name = "Text Color",
    Color = customtheme.TextColor,
    Flag = "TextColor",
    Callback = function(Value)
    customtheme.TextColor = Value
    end
})
local ColorPicker = ct:CreateColorPicker({
    Name = "Background",
    Color = customtheme.Background,
    Flag = "Background",
    Callback = function(Value)
    customtheme.Background = Value
    end
})
local ColorPicker = ct:CreateColorPicker({
    Name = "Top Bar",
    Color = customtheme.Topbar,
    Flag = "Topbar",
    Callback = function(Value)
    customtheme.Topbar
    end
})]]--
