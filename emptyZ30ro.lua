local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI:AddTheme({
    Name = "Purple Premium Elegant",
    Accent = Color3.fromHex("#9d4edd"),
    Background = Color3.fromHex("#0a0015"),
    BackgroundTransparency = 0,
    Outline = Color3.fromHex("#c77dff"),
    Text = Color3.fromHex("#f8f9fa"),
    Placeholder = Color3.fromHex("#5a189a"),
    Button = Color3.fromHex("#5a189a"),
    Icon = Color3.fromHex("#b5a3ff"),
    Hover = Color3.fromHex("#c77dff"),
    BackgroundTransparency = 0,
    WindowBackground = Color3.fromHex("#0a0015"),
    WindowShadow = Color3.fromHex("#000000"),
    DialogBackground = Color3.fromHex("#16213e"),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromHex("#f8f9fa"),
    DialogContent = Color3.fromHex("#e0aaff"),
    DialogIcon = Color3.fromHex("#c77dff"),
    WindowTopbarButtonIcon = Color3.fromHex("#c77dff"),
    WindowTopbarTitle = Color3.fromHex("#f8f9fa"),
    WindowTopbarAuthor = Color3.fromHex("#b5a3ff"),
    WindowTopbarIcon = Color3.fromHex("#e0aaff"),
    TabBackground = Color3.fromHex("#3c096c"),
    TabTitle = Color3.fromHex("#f8f9fa"),
    TabIcon = Color3.fromHex("#c77dff"),
    ElementBackground = Color3.fromHex("#16213e"),
    ElementTitle = Color3.fromHex("#f8f9fa"),
    ElementDesc = Color3.fromHex("#c77dff"),
    ElementIcon = Color3.fromHex("#b5a3ff"),
    PopupBackground = Color3.fromHex("#0a0015"),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromHex("#f8f9fa"),
    PopupContent = Color3.fromHex("#e0aaff"),
    PopupIcon = Color3.fromHex("#c77dff"),
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local AirJumpEnabled = false
local NoclipEnabled = false
local AntiAFKEnabled = false
local GodModeEnabled = false
local WalkSpeedEnabled = false
local JumpPowerEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50
local RecordingData = {}
local IsRecording = false
local IsReplaying = false
local RecordingName = ""
local RecordingStartTime = 0
local ReplayConnection = nil
local RecordConnection = nil
local SavedRecordings = {}
local CurrentRecordingIndex = 1
local targetFPS = 240
local recordInterval = 1 / targetFPS
local replayTargetFPS = 240
local replayInterval = 1 / replayTargetFPS
local useAdvancedInterpolation = true
local useBezierCurve = true
local smoothnessLevel = 5
local anticipationFactor = 0.15

local Window = WindUI:CreateWindow({
    Title = "Movement Script Pro",
    Author = "Script Creator By emptyzo0ne",
    Size = UDim2.fromOffset(480, 420),
    ToggleKey = Enum.KeyCode.RightControl,
    Transparent = true,
    Theme = "Purple Premium Elegant",
    DisableMobile = false,
    SaveFolder = "MovementScript_Config"
})

local MovementTab = Window:Tab({
    Title = "Movement",
    Icon = "gauge"
})

local RecorderTab = Window:Tab({
    Title = "Ultra Smooth Recorder",
    Icon = "video"
})

local SaveLoadTab = Window:Tab({
    Title = "Save/Load",
    Icon = "save"
})

local WalkSpeedSection = MovementTab:Section({
    Title = "WalkSpeed Control"
})

WalkSpeedSection:Toggle({
    Title = "Enable WalkSpeed",
    Description = "Toggle custom walk speed",
    Default = false,
    Callback = function(value)
        WalkSpeedEnabled = value
        if not value and Humanoid then
            Humanoid.WalkSpeed = 16
        elseif value and Humanoid then
            Humanoid.WalkSpeed = WalkSpeedValue
        end

        WindUI:Notify({
            Title = "WalkSpeed",
            Content = value and "WalkSpeed Enabled" or "WalkSpeed Disabled",
            Icon = "gauge",
            Duration = 2
        })
    end
})

WalkSpeedSection:Input({
    Title = "WalkSpeed Value",
    Description = "Enter speed value (0-1000)",
    Default = "16",
    Placeholder = "Enter speed...",
    Callback = function(text)
        local value = tonumber(text)
        if value and value >= 0 and value <= 1000 then
            WalkSpeedValue = value
            if WalkSpeedEnabled and Humanoid then
                Humanoid.WalkSpeed = value
            end

            WindUI:Notify({
                Title = "WalkSpeed Updated",
                Content = "Speed set to " .. value,
                Icon = "check",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Try Input",
                Content = "Enter a number between 0-1000",
                Icon = "alert-circle",
                Duration = 3
            })
        end
    end
})

local JumpPowerSection = MovementTab:Section({
    Title = "JumpPower Control"
})

JumpPowerSection:Toggle({
    Title = "Enable JumpPower",
    Description = "Toggle custom jump power",
    Default = false,
    Callback = function(value)
        JumpPowerEnabled = value
        if not value and Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = 50
        elseif value and Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = JumpPowerValue
        end

        WindUI:Notify({
            Title = "JumpPower",
            Content = value and "JumpPower Enabled" or "JumpPower Disabled",
            Icon = "arrow-up",
            Duration = 2
        })
    end
})

JumpPowerSection:Input({
    Title = "JumpPower Value",
    Description = "Enter power value (0-1000)",
    Default = "50",
    Placeholder = "Enter power...",
    Callback = function(text)
        local value = tonumber(text)
        if value and value >= 0 and value <= 1000 then
            JumpPowerValue = value
            if JumpPowerEnabled and Humanoid then
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = value
            end

            WindUI:Notify({
                Title = "JumpPower Updated",
                Content = "Power set to " .. value,
                Icon = "check",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Try Input",
                Content = "Enter a number between 0-1000",
                Icon = "alert-circle",
                Duration = 3
            })
        end
    end
})

local FeaturesSection = MovementTab:Section({
    Title = "Special Features"
})

FeaturesSection:Toggle({
    Title = "Air Jump",
    Description = "Infinite jump in the air",
    Icon = "wind",
    Default = false,
    Callback = function(value)
        AirJumpEnabled = value
        WindUI:Notify({
            Title = "Air Jump",
            Content = value and "Enabled" or "Disabled",
            Icon = "wind",
            Duration = 2
        })
    end
})

FeaturesSection:Toggle({
    Title = "Noclip",
    Description = "Walk through walls",
    Icon = "shield-off",
    Default = false,
    Callback = function(value)
        NoclipEnabled = value
        WindUI:Notify({
            Title = "Noclip",
            Content = value and "Enabled" or "Disabled",
            Icon = "shield-off",
            Duration = 2
        })
    end
})

FeaturesSection:Toggle({
    Title = "Anti AFK",
    Description = "Prevent AFK kick",
    Icon = "clock",
    Default = false,
    Callback = function(value)
        AntiAFKEnabled = value
        WindUI:Notify({
            Title = "Anti AFK",
            Content = value and "You won't be kicked" or "AFK detection active",
            Icon = "clock",
            Duration = 3
        })
    end
})

FeaturesSection:Toggle({
    Title = "God Mode",
    Description = "Immortal character",
    Icon = "shield",
    Default = false,
    Callback = function(value)
        GodModeEnabled = value
        if value then
            EnableGodMode()
        else
            DisableGodMode()
        end

        WindUI:Notify({
            Title = "God Mode",
            Content = value and "You are now immortal!" or "You can take damage now",
            Icon = "shield",
            Duration = 3
        })
    end
})

FeaturesSection:Divider()

FeaturesSection:Button({
    Title = "Reset Character",
    Description = "Respawn your character",
    Icon = "refresh-cw",
    Callback = function()
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.Health = 0
            WindUI:Notify({
                Title = "Character Reset",
                Content = "Respawning...",
                Icon = "refresh-cw",
                Duration = 2
            })
        end
    end
})

local RecorderControlSection = RecorderTab:Section({
    Title = "Recording Controls (240 FPS)"
})

RecorderControlSection:Input({
    Title = "Recording Name",
    Description = "Enter name for this recording",
    Default = "Recording_1",
    Placeholder = "Enter name...",
    Callback = function(text)
        RecordingName = text
    end
})

RecorderControlSection:Button({
    Title = "Start Ultra Smooth Recording",
    Description = "Record at 240 FPS with all animations",
    Icon = "circle",
    Callback = function()
        if IsRecording then
            WindUI:Notify({
                Title = "Recording Error",
                Content = "Already recording!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if IsReplaying then
            WindUI:Notify({
                Title = "Recording Error",
                Content = "Stop replay first!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if RecordingName == "" then
            RecordingName = "Recording_" .. CurrentRecordingIndex
            CurrentRecordingIndex = CurrentRecordingIndex + 1
        end

        StartRecording()
    end
})

RecorderControlSection:Button({
    Title = "Stop Recording",
    Description = "Stop and save recording",
    Icon = "square",
    Callback = function()
        if not IsRecording then
            WindUI:Notify({
                Title = "Recording Error",
                Content = "Not recording!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        StopRecording()
    end
})

local ReplaySection = RecorderTab:Section({
    Title = "Replay Controls (Ultra Smooth)"
})

local RecordingDropdownOptions = { "No recordings yet" }
local SelectedRecording = nil

local RecordingDropdown = ReplaySection:Dropdown({
    Title = "Select Recording",
    Description = "Choose recording to replay",
    Options = RecordingDropdownOptions,
    Default = RecordingDropdownOptions[1],
    Callback = function(option)
        if SavedRecordings[option] then
            SelectedRecording = option
            WindUI:Notify({
                Title = "Recording Selected",
                Content = option .. " selected",
                Icon = "check",
                Duration = 2
            })
        end
    end
})

ReplaySection:Button({
    Title = "Play Ultra Smooth Replay",
    Description = "Replay with advanced interpolation",
    Icon = "play",
    Callback = function()
        if IsReplaying then
            WindUI:Notify({
                Title = "Replay Error",
                Content = "Already replaying!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if IsRecording then
            WindUI:Notify({
                Title = "Replay Error",
                Content = "Stop recording first!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if not SelectedRecording or not SavedRecordings[SelectedRecording] then
            WindUI:Notify({
                Title = "Replay Error",
                Content = "No recording selected!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        StartReplay(SelectedRecording)
    end
})

ReplaySection:Button({
    Title = "Stop Replay",
    Description = "Stop current replay",
    Icon = "square",
    Callback = function()
        if not IsReplaying then
            WindUI:Notify({
                Title = "Replay Error",
                Content = "Not replaying!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        StopReplay()
    end
})

local ManagementSection = RecorderTab:Section({
    Title = "Recording Management"
})

ManagementSection:Button({
    Title = "Delete Selected Recording",
    Description = "Delete the selected recording",
    Icon = "trash-2",
    Callback = function()
        if not SelectedRecording or not SavedRecordings[SelectedRecording] then
            WindUI:Notify({
                Title = "Delete Error",
                Content = "No recording selected!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        SavedRecordings[SelectedRecording] = nil
        UpdateRecordingDropdown()
        SelectedRecording = nil

        WindUI:Notify({
            Title = "Recording Deleted",
            Content = "Recording deleted successfully",
            Icon = "trash-2",
            Duration = 2
        })
    end
})

ManagementSection:Button({
    Title = "Clear All Recordings",
    Description = "Delete all saved recordings",
    Icon = "x-circle",
    Callback = function()
        SavedRecordings = {}
        UpdateRecordingDropdown()
        SelectedRecording = nil

        WindUI:Notify({
            Title = "All Cleared",
            Content = "All recordings deleted",
            Icon = "x-circle",
            Duration = 2
        })
    end
})

local function GetAnimationState()
    local state = Humanoid:GetState()
    local velocity = RootPart.AssemblyLinearVelocity
    local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    local verticalVelocity = velocity.Y

    if state == Enum.HumanoidStateType.Climbing then
        return "Climbing"
    elseif state == Enum.HumanoidStateType.Swimming then
        return "Swimming"
    elseif state == Enum.HumanoidStateType.Jumping and verticalVelocity > 10 then
        return "Jumping"
    elseif state == Enum.HumanoidStateType.Freefall or (verticalVelocity < -10 and state ~= Enum.HumanoidStateType.Running) then
        return "Falling"
    elseif state == Enum.HumanoidStateType.Running then
        if speed > 16 then
            return "Running"
        elseif speed > 0.5 then
            return "Walking"
        else
            return "Idle"
        end
    else
        return "Idle"
    end
end

local function EaseInOutCubic(t)
    return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
end

local function EaseOutQuart(t)
    return 1 - math.pow(1 - t, 4)
end

local function CubicBezier(t, p0, p1, p2, p3)
    local mt = 1 - t
    return mt * mt * mt * p0 + 3 * mt * mt * t * p1 + 3 * mt * t * t * p2 + t * t * t * p3
end

local function BezierCFrame(t, cf0, cf1, cf2, cf3)
    local pos = Vector3.new(
        CubicBezier(t, cf0.Position.X, cf1.Position.X, cf2.Position.X, cf3.Position.X),
        CubicBezier(t, cf0.Position.Y, cf1.Position.Y, cf2.Position.Y, cf3.Position.Y),
        CubicBezier(t, cf0.Position.Z, cf1.Position.Z, cf2.Position.Z, cf3.Position.Z)
    )

    local rot = cf0.Rotation:Lerp(cf3.Rotation, EaseInOutCubic(t))
    return CFrame.new(pos) * rot
end

local function SmoothLerp(a, b, t, easingFunc)
    easingFunc = easingFunc or EaseInOutCubic
    local smoothT = easingFunc(t)
    return a:Lerp(b, smoothT)
end

function StartRecording()
    IsRecording = true
    IsPaused = false
    TotalPausedTime = 0
    RecordingData = {}
    RecordingStartTime = tick()

    WindUI:Notify({
        Title = "Recording Started",
        Content = "Recording at 240 FPS: " .. RecordingName,
        Icon = "circle",
        Duration = 3
    })

    local lastRecordTime = tick()
    local accumulatedDelta = 0
    local frameCount = 0

    RecordConnection = RunService.Heartbeat:Connect(function()
        if not IsRecording then return end
        if IsPaused then return end

        local currentTick = tick()
        local deltaTime = currentTick - lastRecordTime
        accumulatedDelta = accumulatedDelta + deltaTime

        while accumulatedDelta >= recordInterval do
            local currentTime = currentTick - RecordingStartTime - TotalPausedTime
            local animState = GetAnimationState()

            table.insert(RecordingData, {
                time = currentTime,
                deltaTime = recordInterval,
                position = RootPart.Position,
                cframe = RootPart.CFrame,
                velocity = RootPart.AssemblyLinearVelocity,
                rotation = RootPart.CFrame.Rotation,
                lookVector = RootPart.CFrame.LookVector,
                animationState = animState,
                humanoidState = Humanoid:GetState(),
                isJumping = Humanoid.Jump,
                jumpPower = Humanoid.JumpPower,
                moveDirection = Humanoid.MoveDirection,
                moveSpeed = RootPart.AssemblyLinearVelocity.Magnitude,
                verticalVelocity = RootPart.AssemblyLinearVelocity.Y
            })

            frameCount = frameCount + 1
            accumulatedDelta = accumulatedDelta - recordInterval
        end

        lastRecordTime = currentTick
    end)
end

function StopRecording()
    IsRecording = false
    IsPaused = false
    TotalPausedTime = 0

    if RecordConnection then
        RecordConnection:Disconnect()
        RecordConnection = nil
    end

    if #RecordingData > 0 then
        SavedRecordings[RecordingName] = {
            Data = RecordingData,
            Duration = tick() - RecordingStartTime - TotalPausedTime,
            FrameCount = #RecordingData,
            CreatedAt = os.date("%X %x")
        }

        UpdateRecordingDropdown()

        WindUI:Notify({
            Title = "Recording Saved",
            Content = string.format("%s saved! (%d frames, %.2fs)", RecordingName, #RecordingData,
                tick() - RecordingStartTime - TotalPausedTime),
            Icon = "save",
            Duration = 4
        })

        RecordingName = ""
    else
        WindUI:Notify({
            Title = "Recording Error",
            Content = "No data recorded!",
            Icon = "alert-circle",
            Duration = 3
        })
    end

    RecordingData = {}
end

local function SetAnimationState(state, moveDir, speed, humanoidState, verticalVel)
    if state == "Walking" or state == "Running" then
        if Humanoid:GetState() ~= Enum.HumanoidStateType.Running then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        local moveForce = moveDir * (speed / math.max(Humanoid.WalkSpeed, 1))
        Humanoid:Move(moveForce, true)
    elseif state == "Idle" then
        Humanoid:Move(Vector3.new(0, 0, 0), false)
        if Humanoid:GetState() == Enum.HumanoidStateType.Jumping or Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        elseif Humanoid:GetState() ~= Enum.HumanoidStateType.Running then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    elseif state == "Jumping" then
        if verticalVel and verticalVel > 10 then
            if Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            RootPart.AssemblyLinearVelocity = Vector3.new(
                RootPart.AssemblyLinearVelocity.X,
                verticalVel,
                RootPart.AssemblyLinearVelocity.Z
            )
        end
    elseif state == "Falling" then
        if Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    elseif state == "Swimming" then
        Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        Humanoid:Move(moveDir, true)
    elseif state == "Climbing" then
        Humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
        Humanoid:Move(moveDir, true)
    end
end

local function GetInterpolatedFrame(currentTime, smoothLevel)
    if #RecordingData < 4 then return RecordingData[1] end

    local frameIndex = 1
    for i = 1, #RecordingData do
        if RecordingData[i].time > currentTime then
            frameIndex = i - 1
            break
        end
        frameIndex = i
    end

    frameIndex = math.max(2, math.min(frameIndex, #RecordingData - 2))

    local f0 = RecordingData[frameIndex - 1]
    local f1 = RecordingData[frameIndex]
    local f2 = RecordingData[frameIndex + 1]
    local f3 = RecordingData[frameIndex + 2]

    if not (f0 and f1 and f2 and f3) then return f1 end

    local timeDiff = f2.time - f1.time
    if timeDiff <= 0 then return f1 end

    local t = math.clamp((currentTime - f1.time) / timeDiff, 0, 1)

    local smoothFactor = smoothnessLevel / 10
    t = EaseInOutCubic(t * (1 - smoothFactor) + smoothFactor * t)

    if anticipationFactor > 0 and t < 0.5 then
        t = t * (1 + anticipationFactor)
    end

    local result = {}

    if useBezierCurve then
        result.cframe = BezierCFrame(t, f0.cframe, f1.cframe, f2.cframe, f3.cframe)
    else
        result.cframe = SmoothLerp(f1.cframe, f2.cframe, t, EaseInOutCubic)
    end

    local v1 = f1.velocity
    local v2 = f2.velocity
    local acceleration = (v2 - v1) / timeDiff
    result.velocity = v1 + acceleration * (currentTime - f1.time) * t

    result.animationState = f1.animationState
    result.humanoidState = f1.humanoidState
    result.moveDirection = f1.moveDirection:Lerp(f2.moveDirection, t)
    result.moveSpeed = f1.moveSpeed + (f2.moveSpeed - f1.moveSpeed) * EaseInOutCubic(t)
    result.verticalVelocity = f1.verticalVelocity + (f2.verticalVelocity - f1.verticalVelocity) * t
    result.jumpPower = f1.jumpPower

    return result
end

function StartReplay(recordingName)
    local recording = SavedRecordings[recordingName]
    if not recording or not recording.Data then return end

    IsReplaying = true
    IsPaused = false
    TotalPausedTime = 0
    RecordingData = recording.Data

    WindUI:Notify({
        Title = "Replay Started",
        Content = "Playing: " .. recordingName .. " (Ultra Smooth)",
        Icon = "play",
        Duration = 3
    })

    local startTime = tick()
    local lastFrame = nil
    local lastUpdateTime = tick()
    local pausedPosition = nil

    ReplayConnection = RunService.Heartbeat:Connect(function()
        if not IsReplaying or not RootPart then
            StopReplay()
            return
        end

        if IsPaused then
            if not pausedPosition then
                pausedPosition = RootPart.CFrame
            end
            RootPart.CFrame = pausedPosition
            RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            return
        else
            pausedPosition = nil
        end

        local currentTick = tick()
        local deltaTime = currentTick - lastUpdateTime
        lastUpdateTime = currentTick

        local currentTime = currentTick - startTime - TotalPausedTime
        local totalDuration = RecordingData[#RecordingData].time

        if currentTime >= totalDuration then
            StopReplay()
            WindUI:Notify({
                Title = "Replay Completed",
                Content = recordingName .. " finished!",
                Icon = "check-circle",
                Duration = 3
            })
            return
        end

        local frame = GetInterpolatedFrame(currentTime, smoothnessLevel)

        if frame then
            if lastFrame then
                local blendFactor = math.clamp(deltaTime * replayTargetFPS * (smoothnessLevel / 5), 0, 1)
                RootPart.CFrame = RootPart.CFrame:Lerp(frame.cframe, blendFactor)
            else
                RootPart.CFrame = frame.cframe
            end

            if frame.animationState == "Walking" or frame.animationState == "Running" or frame.animationState == "Idle" then
                RootPart.AssemblyLinearVelocity = Vector3.new(
                    frame.velocity.X,
                    RootPart.AssemblyLinearVelocity.Y,
                    frame.velocity.Z
                )
            else
                RootPart.AssemblyLinearVelocity = frame.velocity
            end

            SetAnimationState(frame.animationState, frame.moveDirection, frame.moveSpeed, frame.humanoidState,
                frame.verticalVelocity)

            lastFrame = frame
        end
    end)
end

function StopReplay()
    IsReplaying = false
    IsPaused = false
    TotalPausedTime = 0

    if ReplayConnection then
        ReplayConnection:Disconnect()
        ReplayConnection = nil
    end

    Humanoid:Move(Vector3.new(0, 0, 0), false)
    RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    WindUI:Notify({
        Title = "Replay Stopped",
        Content = "Replay stopped",
        Icon = "square",
        Duration = 2
    })
end

function UpdateRecordingDropdown()
    RecordingDropdownOptions = {}

    for name, _ in pairs(SavedRecordings) do
        table.insert(RecordingDropdownOptions, name)
    end

    if #RecordingDropdownOptions == 0 then
        RecordingDropdownOptions = { "No recordings yet" }
    end

    RecordingDropdown:Refresh(RecordingDropdownOptions)
end

local SaveSection = SaveLoadTab:Section({
    Title = "Save Recordings to File"
})

local SaveFileName = ""

SaveSection:Input({
    Title = "File Name",
    Description = "Enter name for save file",
    Default = "MyRecordings",
    Placeholder = "Enter filename...",
    Callback = function(text)
        SaveFileName = text
    end
})

SaveSection:Button({
    Title = "Save All Recordings",
    Description = "Export all recordings to file",
    Icon = "download",
    Callback = function()
        if SaveFileName == "" then
            SaveFileName = "RecordingData_" .. os.date("%Y%m%d_%H%M%S")
        end

        if next(SavedRecordings) == nil then
            WindUI:Notify({
                Title = "Save Error",
                Content = "No recordings to save!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        SaveRecordingsToFile(SaveFileName)
    end
})

SaveSection:Button({
    Title = "Save Selected Recording",
    Description = "Export only selected recording",
    Icon = "file-down",
    Callback = function()
        if not SelectedRecording or not SavedRecordings[SelectedRecording] then
            WindUI:Notify({
                Title = "Save Error",
                Content = "No recording selected!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if SaveFileName == "" then
            SaveFileName = SelectedRecording
        end

        SaveSingleRecording(SaveFileName, SelectedRecording)
    end
})

local LoadSection = SaveLoadTab:Section({
    Title = "Load Recordings from File"
})

local LoadFileName = ""

LoadSection:Input({
    Title = "File Name to Load",
    Description = "Enter name of file to load",
    Default = "",
    Placeholder = "Enter filename...",
    Callback = function(text)
        LoadFileName = text
    end
})

LoadSection:Button({
    Title = "Load Recordings",
    Description = "Import recordings from file",
    Icon = "upload",
    Callback = function()
        if LoadFileName == "" then
            WindUI:Notify({
                Title = "Load Error",
                Content = "Please enter a filename!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        LoadRecordingsFromFile(LoadFileName)
    end
})

LoadSection:Button({
    Title = "Merge with Current",
    Description = "Load and merge with existing recordings",
    Icon = "git-merge",
    Callback = function()
        if LoadFileName == "" then
            WindUI:Notify({
                Title = "Load Error",
                Content = "Please enter a filename!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        LoadRecordingsFromFile(LoadFileName, true)
    end
})

local InfoSection = SaveLoadTab:Section({
    Title = "File Information"
})

InfoSection:Button({
    Title = "Show Saved Files",
    Description = "List all saved recording files",
    Icon = "list",
    Callback = function()
        ShowSavedFiles()
    end
})

InfoSection:Button({
    Title = "Export to Clipboard",
    Description = "Copy recording data as text",
    Icon = "clipboard",
    Callback = function()
        if not SelectedRecording or not SavedRecordings[SelectedRecording] then
            WindUI:Notify({
                Title = "Export Error",
                Content = "No recording selected!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        ExportToClipboard(SelectedRecording)
    end
})

InfoSection:Button({
    Title = "Import from Clipboard",
    Description = "Load recording from clipboard text",
    Icon = "clipboard-paste",
    Callback = function()
        ImportFromClipboard()
    end
})

local HttpService = game:GetService("HttpService")

function SaveRecordingsToFile(filename)
    local success, result = pcall(function()
        local dataToSave = {
            Version = "1.0",
            SaveDate = os.date("%Y-%m-%d %H:%M:%S"),
            RecordingCount = 0,
            Recordings = {}
        }

        local count = 0
        for name, recording in pairs(SavedRecordings) do
            count = count + 1

            local serializedData = {}
            for i, frame in ipairs(recording.Data) do
                table.insert(serializedData, {
                    time = frame.time,
                    deltaTime = frame.deltaTime,
                    position = { frame.position.X, frame.position.Y, frame.position.Z },
                    cframe = { frame.cframe:GetComponents() },
                    velocity = { frame.velocity.X, frame.velocity.Y, frame.velocity.Z },
                    rotation = { frame.rotation:ToEulerAnglesXYZ() },
                    lookVector = { frame.lookVector.X, frame.lookVector.Y, frame.lookVector.Z },
                    animationState = frame.animationState,
                    humanoidState = tostring(frame.humanoidState),
                    isJumping = frame.isJumping,
                    jumpPower = frame.jumpPower,
                    moveDirection = { frame.moveDirection.X, frame.moveDirection.Y, frame.moveDirection.Z },
                    moveSpeed = frame.moveSpeed,
                    verticalVelocity = frame.verticalVelocity
                })
            end

            dataToSave.Recordings[name] = {
                Duration = recording.Duration,
                FrameCount = recording.FrameCount,
                CreatedAt = recording.CreatedAt,
                Data = serializedData
            }
        end

        dataToSave.RecordingCount = count

        local jsonData = HttpService:JSONEncode(dataToSave)

        writefile(filename .. ".json", jsonData)

        return true, count
    end)

    if success and result then
        WindUI:Notify({
            Title = "Save Successful",
            Content = string.format("Saved %d recordings to %s.json", result, filename),
            Icon = "check-circle",
            Duration = 4
        })
    else
        WindUI:Notify({
            Title = "Save Failed",
            Content = "Error: " .. tostring(result),
            Icon = "x-circle",
            Duration = 4
        })
    end
end

function SaveSingleRecording(filename, recordingName)
    local success, result = pcall(function()
        local recording = SavedRecordings[recordingName]

        local serializedData = {}
        for i, frame in ipairs(recording.Data) do
            table.insert(serializedData, {
                time = frame.time,
                deltaTime = frame.deltaTime,
                position = { frame.position.X, frame.position.Y, frame.position.Z },
                cframe = { frame.cframe:GetComponents() },
                velocity = { frame.velocity.X, frame.velocity.Y, frame.velocity.Z },
                rotation = { frame.rotation:ToEulerAnglesXYZ() },
                lookVector = { frame.lookVector.X, frame.lookVector.Y, frame.lookVector.Z },
                animationState = frame.animationState,
                humanoidState = tostring(frame.humanoidState),
                isJumping = frame.isJumping,
                jumpPower = frame.jumpPower,
                moveDirection = { frame.moveDirection.X, frame.moveDirection.Y, frame.moveDirection.Z },
                moveSpeed = frame.moveSpeed,
                verticalVelocity = frame.verticalVelocity
            })
        end

        local dataToSave = {
            Version = "1.0",
            SaveDate = os.date("%Y-%m-%d %H:%M:%S"),
            RecordingName = recordingName,
            Duration = recording.Duration,
            FrameCount = recording.FrameCount,
            CreatedAt = recording.CreatedAt,
            Data = serializedData
        }

        local jsonData = HttpService:JSONEncode(dataToSave)
        writefile(filename .. ".json", jsonData)

        return true
    end)

    if success then
        WindUI:Notify({
            Title = "Save Successful",
            Content = string.format("Saved '%s' to %s.json", recordingName, filename),
            Icon = "check-circle",
            Duration = 4
        })
    else
        WindUI:Notify({
            Title = "Save Failed",
            Content = "Error: " .. tostring(result),
            Icon = "x-circle",
            Duration = 4
        })
    end
end

function LoadRecordingsFromFile(filename, merge)
    local success, result = pcall(function()
        if not isfile(filename .. ".json") then
            return false, "File not found"
        end

        local jsonData = readfile(filename .. ".json")
        local loadedData = HttpService:JSONDecode(jsonData)

        if not merge then
            SavedRecordings = {}
        end

        local count = 0

        local function convertFrame(frame)
            if not frame then return nil end

            local function toVector3(data)
                if type(data) == "table" then
                    return Vector3.new(data[1] or 0, data[2] or 0, data[3] or 0)
                end
                return Vector3.new(0, 0, 0)
            end

            local function toCFrame(data)
                if type(data) == "table" and #data >= 12 then
                    return CFrame.new(
                        data[1], data[2], data[3],
                        data[4], data[5], data[6],
                        data[7], data[8], data[9],
                        data[10], data[11], data[12]
                    )
                end
                return CFrame.new(0, 0, 0)
            end

            return {
                time = frame.time or 0,
                deltaTime = frame.deltaTime or 0,
                position = toVector3(frame.position),
                cframe = toCFrame(frame.cframe),
                velocity = toVector3(frame.velocity),
                rotation = CFrame.Angles(
                    frame.rotation and frame.rotation[1] or 0,
                    frame.rotation and frame.rotation[2] or 0,
                    frame.rotation and frame.rotation[3] or 0
                ),
                lookVector = toVector3(frame.lookVector),
                animationState = frame.animationState or "Idle",
                humanoidState = frame.humanoidState or Enum.HumanoidStateType.Running,
                isJumping = frame.isJumping or false,
                jumpPower = frame.jumpPower or 50,
                moveDirection = toVector3(frame.moveDirection),
                moveSpeed = frame.moveSpeed or 0,
                verticalVelocity = frame.verticalVelocity or 0
            }
        end

        if loadedData.RecordingName then
            local name = loadedData.RecordingName

            local convertedData = {}
            for i, frame in ipairs(loadedData.Data) do
                local converted = convertFrame(frame)
                if converted then
                    table.insert(convertedData, converted)
                end
            end

            if #convertedData > 0 then
                SavedRecordings[name] = {
                    Duration = loadedData.Duration,
                    FrameCount = loadedData.FrameCount,
                    CreatedAt = loadedData.CreatedAt,
                    Data = convertedData
                }
                count = 1
            end
        elseif loadedData.Recordings then
            for name, recording in pairs(loadedData.Recordings) do
                local convertedData = {}
                for i, frame in ipairs(recording.Data) do
                    local converted = convertFrame(frame)
                    if converted then
                        table.insert(convertedData, converted)
                    end
                end

                if #convertedData > 0 then
                    SavedRecordings[name] = {
                        Duration = recording.Duration,
                        FrameCount = recording.FrameCount,
                        CreatedAt = recording.CreatedAt,
                        Data = convertedData
                    }
                    count = count + 1
                end
            end
        end

        UpdateRecordingDropdown()

        return true, count
    end)

    if success and result then
        WindUI:Notify({
            Title = "Load Successful",
            Content = string.format("Loaded %d recordings from %s.json", result, filename),
            Icon = "check-circle",
            Duration = 4
        })
    else
        WindUI:Notify({
            Title = "Load Failed",
            Content = "Error: " .. tostring(result),
            Icon = "x-circle",
            Duration = 4
        })
    end
end

function ShowSavedFiles()
    local success, result = pcall(function()
        local files = listfiles("")
        local recordingFiles = {}

        for _, file in ipairs(files) do
            if file:match("%.json$") then
                table.insert(recordingFiles, file)
            end
        end

        if #recordingFiles == 0 then
            return false, "No saved files found"
        end

        local fileList = "Saved recording files:\n"
        for i, file in ipairs(recordingFiles) do
            fileList = fileList .. "\n" .. i .. ". " .. file
        end

        return true, fileList, #recordingFiles
    end)

    if success and result then
        WindUI:Notify({
            Title = "Saved Files (" .. tostring(select(3, result)) .. ")",
            Content = select(2, result),
            Icon = "folder",
            Duration = 8
        })
    else
        WindUI:Notify({
            Title = "Error",
            Content = tostring(result),
            Icon = "alert-circle",
            Duration = 4
        })
    end
end

function ExportToClipboard(recordingName)
    local success, result = pcall(function()
        local recording = SavedRecordings[recordingName]

        local serializedData = {}
        for i, frame in ipairs(recording.Data) do
            table.insert(serializedData, {
                time = frame.time,
                deltaTime = frame.deltaTime,
                position = { frame.position.X, frame.position.Y, frame.position.Z },
                cframe = { frame.cframe:GetComponents() },
                velocity = { frame.velocity.X, frame.velocity.Y, frame.velocity.Z },
                rotation = { frame.rotation:ToEulerAnglesXYZ() },
                lookVector = { frame.lookVector.X, frame.lookVector.Y, frame.lookVector.Z },
                animationState = frame.animationState,
                humanoidState = tostring(frame.humanoidState),
                isJumping = frame.isJumping,
                jumpPower = frame.jumpPower,
                moveDirection = { frame.moveDirection.X, frame.moveDirection.Y, frame.moveDirection.Z },
                moveSpeed = frame.moveSpeed,
                verticalVelocity = frame.verticalVelocity
            })
        end

        local dataToExport = {
            Version = "1.0",
            RecordingName = recordingName,
            Duration = recording.Duration,
            FrameCount = recording.FrameCount,
            CreatedAt = recording.CreatedAt,
            Data = serializedData
        }

        local jsonData = HttpService:JSONEncode(dataToExport)
        setclipboard(jsonData)

        return true
    end)

    if success then
        WindUI:Notify({
            Title = "Exported to Clipboard",
            Content = "Recording '" .. recordingName .. "' copied!",
            Icon = "clipboard-check",
            Duration = 3
        })
    else
        WindUI:Notify({
            Title = "Export Failed",
            Content = "Error: " .. tostring(result),
            Icon = "x-circle",
            Duration = 4
        })
    end
end

function ImportFromClipboard()
    local success, result = pcall(function()
        local clipboardData = getclipboard()

        if not clipboardData or clipboardData == "" then
            return false, "Clipboard is empty"
        end

        local loadedData = HttpService:JSONDecode(clipboardData)

        if not loadedData.RecordingName or not loadedData.Data then
            return false, "Invalid recording format"
        end

        local function toVector3(data)
            if type(data) == "table" then
                return Vector3.new(data[1] or 0, data[2] or 0, data[3] or 0)
            end
            return Vector3.new(0, 0, 0)
        end

        local function toCFrame(data)
            if type(data) == "table" and #data >= 12 then
                return CFrame.new(
                    data[1], data[2], data[3],
                    data[4], data[5], data[6],
                    data[7], data[8], data[9],
                    data[10], data[11], data[12]
                )
            end
            return CFrame.new(0, 0, 0)
        end

        local convertedData = {}
        for i, frame in ipairs(loadedData.Data) do
            table.insert(convertedData, {
                time = frame.time or 0,
                deltaTime = frame.deltaTime or 0,
                position = toVector3(frame.position),
                cframe = toCFrame(frame.cframe),
                velocity = toVector3(frame.velocity),
                rotation = CFrame.Angles(
                    frame.rotation and frame.rotation[1] or 0,
                    frame.rotation and frame.rotation[2] or 0,
                    frame.rotation and frame.rotation[3] or 0
                ),
                lookVector = toVector3(frame.lookVector),
                animationState = frame.animationState or "Idle",
                humanoidState = frame.humanoidState or Enum.HumanoidStateType.Running,
                isJumping = frame.isJumping or false,
                jumpPower = frame.jumpPower or 50,
                moveDirection = toVector3(frame.moveDirection),
                moveSpeed = frame.moveSpeed or 0,
                verticalVelocity = frame.verticalVelocity or 0
            })
        end

        local name = loadedData.RecordingName
        SavedRecordings[name] = {
            Duration = loadedData.Duration,
            FrameCount = loadedData.FrameCount,
            CreatedAt = loadedData.CreatedAt,
            Data = convertedData
        }

        UpdateRecordingDropdown()

        return true, name
    end)

    if success and result then
        WindUI:Notify({
            Title = "Import Successful",
            Content = "Imported '" .. result .. "' from clipboard!",
            Icon = "clipboard-check",
            Duration = 4
        })
    else
        WindUI:Notify({
            Title = "Import Failed",
            Content = "Error: " .. tostring(result),
            Icon = "x-circle",
            Duration = 4
        })
    end
end

UserInputService.JumpRequest:Connect(function()
    if AirJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Player.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

local OriginalHealth = nil
local HealthConnection = nil

function EnableGodMode()
    if Humanoid and GodModeEnabled then
        OriginalHealth = Humanoid.MaxHealth
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge

        if HealthConnection then
            HealthConnection:Disconnect()
        end

        HealthConnection = Humanoid.HealthChanged:Connect(function(health)
            if GodModeEnabled and health < math.huge then
                Humanoid.Health = math.huge
            end
        end)
    end
end

function DisableGodMode()
    if Humanoid then
        if HealthConnection then
            HealthConnection:Disconnect()
            HealthConnection = nil
        end

        if OriginalHealth then
            Humanoid.MaxHealth = OriginalHealth
            Humanoid.Health = OriginalHealth
        else
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
        end
    end
end

RunService.Heartbeat:Connect(function()
    if GodModeEnabled then
        if Humanoid and Humanoid.Health ~= math.huge then
            EnableGodMode()
        end
    end
end)

local function ProtectSpeed()
    if Humanoid then
        if WalkSpeedEnabled then
            Humanoid.WalkSpeed = WalkSpeedValue
        end

        if JumpPowerEnabled then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = JumpPowerValue
        end

        if GodModeEnabled and Humanoid.Health ~= math.huge then
            Humanoid.Health = math.huge
        end
    end
end

RunService.Heartbeat:Connect(function()
    ProtectSpeed()
end)

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")

    wait(0.1)

    Humanoid.UseJumpPower = true
    ProtectSpeed()

    if GodModeEnabled then
        EnableGodMode()
    end

    if IsRecording then
        StopRecording()
    end
    if IsReplaying then
        StopReplay()
    end
end)

if Humanoid then
    Humanoid.UseJumpPower = true
end

local PerformanceTab = Window:Tab({
    Title = "Performance",
    Icon = "zap"
})

local PotatoGraphicsEnabled = false
local OriginalProperties = {}

local GraphicsSection = PerformanceTab:Section({
    Title = "Graphics Optimization"
})

GraphicsSection:Toggle({
    Title = "Potato Graphics Mode",
    Description = "Convert all textures to gray plastic for better FPS",
    Icon = "zap",
    Default = false,
    Callback = function(value)
        PotatoGraphicsEnabled = value
        if value then
            EnablePotatoGraphics()
        else
            DisablePotatoGraphics()
        end

        WindUI:Notify({
            Title = "Potato Graphics",
            Content = value and "Potato Mode Enabled - FPS Boost!" or "Graphics Restored",
            Icon = "zap",
            Duration = 3
        })
    end
})

GraphicsSection:Button({
    Title = "Quick FPS Boost",
    Description = "Optimize rendering settings instantly",
    Icon = "trending-up",
    Callback = function()
        ApplyQuickFPSBoost()

        WindUI:Notify({
            Title = "FPS Boost Applied",
            Content = "Rendering optimized for performance",
            Icon = "check-circle",
            Duration = 3
        })
    end
})

GraphicsSection:Button({
    Title = "Remove All Effects",
    Description = "Delete all visual effects (particles, lights, etc)",
    Icon = "x-circle",
    Callback = function()
        RemoveAllEffects()

        WindUI:Notify({
            Title = "Effects Removed",
            Content = "All visual effects deleted",
            Icon = "check-circle",
            Duration = 3
        })
    end
})

local InfoSection = PerformanceTab:Section({
    Title = "Performance Info"
})

InfoSection:Button({
    Title = "Show Current FPS",
    Description = "Display your current frame rate",
    Icon = "activity",
    Callback = function()
        local fps = math.floor(1 / RunService.Heartbeat:Wait())

        WindUI:Notify({
            Title = "Current FPS",
            Content = "FPS: " .. fps,
            Icon = "activity",
            Duration = 3
        })
    end
})

InfoSection:Button({
    Title = "Restore All Graphics",
    Description = "Reset all graphics to original state",
    Icon = "rotate-ccw",
    Callback = function()
        DisablePotatoGraphics()

        WindUI:Notify({
            Title = "Graphics Restored",
            Content = "All graphics reset to original",
            Icon = "check-circle",
            Duration = 3
        })
    end
})

function EnablePotatoGraphics()
    OriginalProperties = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if not OriginalProperties[obj] then
                OriginalProperties[obj] = {
                    Material = obj.Material,
                    Color = obj.Color,
                    Reflectance = obj.Reflectance,
                    Transparency = obj.Transparency
                }
            end

            obj.Material = Enum.Material.Plastic
            obj.Color = Color3.fromRGB(128, 128, 128)
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if not OriginalProperties[obj] then
                OriginalProperties[obj] = {
                    Transparency = obj.Transparency
                }
            end
            obj.Transparency = 1
        elseif obj:IsA("SurfaceAppearance") then
            if not OriginalProperties[obj] then
                OriginalProperties[obj] = {
                    Parent = obj.Parent
                }
            end
            obj.Parent = nil
        end
    end

    local Lighting = game:GetService("Lighting")
    if not OriginalProperties["Lighting"] then
        OriginalProperties["Lighting"] = {
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Ambient = Lighting.Ambient
        }
    end

    Lighting.GlobalShadows = false
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.Ambient = Color3.fromRGB(178, 178, 178)

    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") or effect:IsA("Clouds") then
            if not OriginalProperties[effect] then
                OriginalProperties[effect] = {
                    Enabled = effect.Enabled or true
                }
            end
            if effect:IsA("PostEffect") or effect:IsA("Atmosphere") then
                effect.Enabled = false
            elseif effect:IsA("Sky") or effect:IsA("Clouds") then
                effect.Parent = nil
                OriginalProperties[effect].Parent = Lighting
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        if not PotatoGraphicsEnabled then return end

        if obj:IsA("BasePart") then
            wait(0.1)
            obj.Material = Enum.Material.Plastic
            obj.Color = Color3.fromRGB(128, 128, 128)
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("SurfaceAppearance") then
            obj.Parent = nil
        end
    end)
end

function DisablePotatoGraphics()
    PotatoGraphicsEnabled = false

    for obj, props in pairs(OriginalProperties) do
        if obj == "Lighting" then
            local Lighting = game:GetService("Lighting")
            Lighting.Brightness = props.Brightness
            Lighting.GlobalShadows = props.GlobalShadows
            Lighting.OutdoorAmbient = props.OutdoorAmbient
            Lighting.Ambient = props.Ambient
        elseif typeof(obj) == "Instance" and obj:IsA("BasePart") then
            pcall(function()
                obj.Material = props.Material
                obj.Color = props.Color
                obj.Reflectance = props.Reflectance
                obj.Transparency = props.Transparency
            end)
        elseif typeof(obj) == "Instance" and (obj:IsA("Decal") or obj:IsA("Texture")) then
            pcall(function()
                obj.Transparency = props.Transparency
            end)
        elseif typeof(obj) == "Instance" and obj:IsA("SurfaceAppearance") then
            pcall(function()
                if props.Parent then
                    obj.Parent = props.Parent
                end
            end)
        elseif typeof(obj) == "Instance" and (obj:IsA("PostEffect") or obj:IsA("Atmosphere")) then
            pcall(function()
                obj.Enabled = props.Enabled
            end)
        elseif typeof(obj) == "Instance" and (obj:IsA("Sky") or obj:IsA("Clouds")) then
            pcall(function()
                if props.Parent then
                    obj.Parent = props.Parent
                end
            end)
        end
    end

    OriginalProperties = {}
end

function ApplyQuickFPSBoost()
    local Lighting = game:GetService("Lighting")

    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    Lighting.GlobalShadows = false

    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("BloomEffect") or
            effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") or
            effect:IsA("ColorCorrectionEffect") then
            effect.Enabled = false
        end
    end

    workspace.Terrain.Decoration = false
end

function RemoveAllEffects()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or
            obj:IsA("Beam") or obj:IsA("Fire") or
            obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj:Destroy()
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or
            obj:IsA("SurfaceLight") then
            obj.Enabled = false
        end
    end

    local Lighting = game:GetService("Lighting")
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
end

local IsPaused = false
local PauseStartTime = 0
local TotalPausedTime = 0

RecorderControlSection:Button({
    Title = "Pause/Resume Recording",
    Description = "Pause or resume current recording",
    Icon = "pause-circle",
    Callback = function()
        if not IsRecording then
            WindUI:Notify({
                Title = "Pause Error",
                Content = "Not recording!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if IsPaused then
            ResumeRecording()
        else
            PauseRecording()
        end
    end
})

ReplaySection:Button({
    Title = "Pause/Resume Replay",
    Description = "Pause or resume current replay",
    Icon = "pause-circle",
    Callback = function()
        if not IsReplaying then
            WindUI:Notify({
                Title = "Pause Error",
                Content = "Not replaying!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if IsPaused then
            ResumeReplay()
        else
            PauseReplay()
        end
    end
})

function PauseRecording()
    if not IsRecording or IsPaused then return end

    IsPaused = true
    PauseStartTime = tick()

    WindUI:Notify({
        Title = "Recording Paused",
        Content = "Recording paused at " .. string.format("%.2f", tick() - RecordingStartTime) .. "s",
        Icon = "pause-circle",
        Duration = 3
    })
end

function ResumeRecording()
    if not IsRecording or not IsPaused then return end

    local pauseDuration = tick() - PauseStartTime
    TotalPausedTime = TotalPausedTime + pauseDuration
    IsPaused = false

    WindUI:Notify({
        Title = "Recording Resumed",
        Content = "Recording resumed (paused for " .. string.format("%.2f", pauseDuration) .. "s)",
        Icon = "play-circle",
        Duration = 3
    })
end

function PauseReplay()
    if not IsReplaying or IsPaused then return end

    IsPaused = true
    PauseStartTime = tick()

    if Humanoid then
        Humanoid:Move(Vector3.new(0, 0, 0), false)
    end

    WindUI:Notify({
        Title = "Replay Paused",
        Content = "Replay paused",
        Icon = "pause-circle",
        Duration = 2
    })
end

function ResumeReplay()
    if not IsReplaying or not IsPaused then return end

    local pauseDuration = tick() - PauseStartTime
    TotalPausedTime = TotalPausedTime + pauseDuration
    IsPaused = false

    WindUI:Notify({
        Title = "Replay Resumed",
        Content = "Replay resumed",
        Icon = "play-circle",
        Duration = 2
    })
end

StartRecording = StartRecording
StopRecording = StopRecording
StartReplay = StartReplay
StopReplay = StopReplay

local MergeSection = RecorderTab:Section({
    Title = "Merge Multiple Recordings"
})

local SelectedRecordingsForMerge = {}
local MergedRecordingName = ""

MergeSection:Input({
    Title = "Merged Recording Name",
    Description = "Enter name for merged recording",
    Default = "Merged_Recording",
    Placeholder = "Enter name...",
    Callback = function(text)
        MergedRecordingName = text
    end
})

local MergeDropdown = nil

local function UpdateMergeDropdown()
    local options = {}
    for name, _ in pairs(SavedRecordings) do
        table.insert(options, name)
    end
    
    if #options == 0 then
        options = { "No recordings yet" }
    end
    
    if MergeDropdown then
        MergeDropdown:Refresh(options)
    end
    
    return options
end

local MergeDropdownOptions = UpdateMergeDropdown()

MergeDropdown = MergeSection:Dropdown({
    Title = "Select Recordings to Merge",
    Description = "Choose recordings (select multiple)",
    Options = MergeDropdownOptions,
    Default = MergeDropdownOptions[1],
    Callback = function(option)
        if option == "No recordings yet" then
            WindUI:Notify({
                Title = "No Recordings",
                Content = "Please create recordings first",
                Icon = "alert-circle",
                Duration = 2
            })
            return
        end
        
        if SavedRecordings[option] then
            if not table.find(SelectedRecordingsForMerge, option) then
                table.insert(SelectedRecordingsForMerge, option)
                WindUI:Notify({
                    Title = "Recording Added",
                    Content = option .. " added to merge list (" .. #SelectedRecordingsForMerge .. " total)",
                    Icon = "plus",
                    Duration = 2
                })
            else
                WindUI:Notify({
                    Title = "Already Added",
                    Content = option .. " is already in merge list",
                    Icon = "alert-circle",
                    Duration = 2
                })
            end
        end
    end
})

MergeSection:Button({
    Title = "Refresh Recording List",
    Description = "Update available recordings",
    Icon = "refresh-cw",
    Callback = function()
        UpdateMergeDropdown()
        
        local count = 0
        for _ in pairs(SavedRecordings) do
            count = count + 1
        end
        
        WindUI:Notify({
            Title = "List Refreshed",
            Content = count .. " recordings available",
            Icon = "refresh-cw",
            Duration = 2
        })
    end
})

MergeSection:Button({
    Title = "Show Selected Recordings",
    Description = "Display recordings selected for merge",
    Icon = "list",
    Callback = function()
        if #SelectedRecordingsForMerge == 0 then
            WindUI:Notify({
                Title = "No Recordings Selected",
                Content = "Please select recordings to merge",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        local list = "Selected recordings (" .. #SelectedRecordingsForMerge .. "):\n"
        for i, name in ipairs(SelectedRecordingsForMerge) do
            local recording = SavedRecordings[name]
            if recording then
                list = list .. "\n" .. i .. ". " .. name .. " (" .. recording.FrameCount .. " frames, " .. 
                       string.format("%.2fs", recording.Duration) .. ")"
            end
        end

        WindUI:Notify({
            Title = "Merge List",
            Content = list,
            Icon = "list",
            Duration = 6
        })
    end
})

MergeSection:Button({
    Title = "Remove Last from List",
    Description = "Remove last selected recording",
    Icon = "minus",
    Callback = function()
        if #SelectedRecordingsForMerge == 0 then
            WindUI:Notify({
                Title = "List Empty",
                Content = "No recordings to remove",
                Icon = "alert-circle",
                Duration = 2
            })
            return
        end

        local removed = table.remove(SelectedRecordingsForMerge, #SelectedRecordingsForMerge)
        WindUI:Notify({
            Title = "Recording Removed",
            Content = removed .. " removed from list",
            Icon = "minus",
            Duration = 2
        })
    end
})

MergeSection:Button({
    Title = "Clear Merge List",
    Description = "Clear all selected recordings",
    Icon = "x",
    Callback = function()
        SelectedRecordingsForMerge = {}
        WindUI:Notify({
            Title = "List Cleared",
            Content = "All selections cleared",
            Icon = "x",
            Duration = 2
        })
    end
})

MergeSection:Divider()

MergeSection:Button({
    Title = "Merge Recordings (Sequential)",
    Description = "Combine recordings one after another",
    Icon = "git-merge",
    Callback = function()
        if #SelectedRecordingsForMerge < 2 then
            WindUI:Notify({
                Title = "Merge Error",
                Content = "Select at least 2 recordings to merge!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if MergedRecordingName == "" then
            MergedRecordingName = "Merged_" .. os.date("%H%M%S")
        end

        MergeRecordingsSequential(SelectedRecordingsForMerge, MergedRecordingName)
    end
})

MergeSection:Button({
    Title = "Merge with Smooth Transition",
    Description = "Blend recordings with smooth interpolation",
    Icon = "trending-up",
    Callback = function()
        if #SelectedRecordingsForMerge < 2 then
            WindUI:Notify({
                Title = "Merge Error",
                Content = "Select at least 2 recordings to merge!",
                Icon = "alert-circle",
                Duration = 3
            })
            return
        end

        if MergedRecordingName == "" then
            MergedRecordingName = "Merged_Smooth_" .. os.date("%H%M%S")
        end

        MergeRecordingsSmooth(SelectedRecordingsForMerge, MergedRecordingName)
    end
})

function MergeRecordingsSequential(recordingNames, newName)
    local success, result = pcall(function()
        local mergedData = {}
        local totalDuration = 0
        local totalFrames = 0
        local currentTimeOffset = 0

        for index, name in ipairs(recordingNames) do
            local recording = SavedRecordings[name]
            if not recording then
                return false, "Recording '" .. name .. "' not found"
            end

            for i, frame in ipairs(recording.Data) do
                local newFrame = {
                    time = frame.time + currentTimeOffset,
                    deltaTime = frame.deltaTime,
                    position = frame.position,
                    cframe = frame.cframe,
                    velocity = frame.velocity,
                    rotation = frame.rotation,
                    lookVector = frame.lookVector,
                    animationState = frame.animationState,
                    humanoidState = frame.humanoidState,
                    isJumping = frame.isJumping,
                    jumpPower = frame.jumpPower,
                    moveDirection = frame.moveDirection,
                    moveSpeed = frame.moveSpeed,
                    verticalVelocity = frame.verticalVelocity
                }
                table.insert(mergedData, newFrame)
                totalFrames = totalFrames + 1
            end

            currentTimeOffset = currentTimeOffset + recording.Duration
            totalDuration = totalDuration + recording.Duration
        end

        SavedRecordings[newName] = {
            Data = mergedData,
            Duration = totalDuration,
            FrameCount = totalFrames,
            CreatedAt = os.date("%X %x"),
            IsMerged = true,
            MergedFrom = recordingNames
        }

        UpdateRecordingDropdown()
        UpdateMergeDropdown()
        SelectedRecordingsForMerge = {}

        return true, totalFrames, totalDuration
    end)

    if success and result then
        local frames, duration = select(2, result), select(3, result)
        WindUI:Notify({
            Title = "Merge Successful",
            Content = string.format("Created '%s'\n%d recordings merged\n%d frames, %.2fs total", 
                newName, #recordingNames, frames, duration),
            Icon = "check-circle",
            Duration = 5
        })
    else
        WindUI:Notify({
            Title = "Merge Failed",
            Content = "Error: " .. tostring(result),
            Icon = "x-circle",
            Duration = 4
        })
    end
end

function MergeRecordingsSmooth(recordingNames, newName)
    local success, result = pcall(function()
        local mergedData = {}
        local totalDuration = 0
        local totalFrames = 0
        local currentTimeOffset = 0
        local transitionFrames = 30

        for index, name in ipairs(recordingNames) do
            local recording = SavedRecordings[name]
            if not recording then
                return false, "Recording '" .. name .. "' not found"
            end

            local isLastRecording = (index == #recordingNames)

            for i, frame in ipairs(recording.Data) do
                local newFrame = {
                    time = frame.time + currentTimeOffset,
                    deltaTime = frame.deltaTime,
                    position = frame.position,
                    cframe = frame.cframe,
                    velocity = frame.velocity,
                    rotation = frame.rotation,
                    lookVector = frame.lookVector,
                    animationState = frame.animationState,
                    humanoidState = frame.humanoidState,
                    isJumping = frame.isJumping,
                    jumpPower = frame.jumpPower,
                    moveDirection = frame.moveDirection,
                    moveSpeed = frame.moveSpeed,
                    verticalVelocity = frame.verticalVelocity
                }
                table.insert(mergedData, newFrame)
                totalFrames = totalFrames + 1
            end

            if not isLastRecording and index < #recordingNames then
                local nextRecording = SavedRecordings[recordingNames[index + 1]]
                if nextRecording and #nextRecording.Data > 0 then
                    local lastFrame = recording.Data[#recording.Data]
                    local firstNextFrame = nextRecording.Data[1]

                    for t = 1, transitionFrames do
                        local alpha = t / transitionFrames
                        local smoothAlpha = EaseInOutCubic(alpha)

                        local transitionTime = currentTimeOffset + recording.Duration + (t * recordInterval)

                        local transitionFrame = {
                            time = transitionTime,
                            deltaTime = recordInterval,
                            position = lastFrame.position:Lerp(firstNextFrame.position, smoothAlpha),
                            cframe = lastFrame.cframe:Lerp(firstNextFrame.cframe, smoothAlpha),
                            velocity = lastFrame.velocity:Lerp(firstNextFrame.velocity, smoothAlpha),
                            rotation = lastFrame.rotation:Lerp(firstNextFrame.rotation, smoothAlpha),
                            lookVector = lastFrame.lookVector:Lerp(firstNextFrame.lookVector, smoothAlpha),
                            animationState = alpha < 0.5 and lastFrame.animationState or firstNextFrame.animationState,
                            humanoidState = alpha < 0.5 and lastFrame.humanoidState or firstNextFrame.humanoidState,
                            isJumping = alpha < 0.5 and lastFrame.isJumping or firstNextFrame.isJumping,
                            jumpPower = lastFrame.jumpPower + (firstNextFrame.jumpPower - lastFrame.jumpPower) * smoothAlpha,
                            moveDirection = lastFrame.moveDirection:Lerp(firstNextFrame.moveDirection, smoothAlpha),
                            moveSpeed = lastFrame.moveSpeed + (firstNextFrame.moveSpeed - lastFrame.moveSpeed) * smoothAlpha,
                            verticalVelocity = lastFrame.verticalVelocity + (firstNextFrame.verticalVelocity - lastFrame.verticalVelocity) * smoothAlpha
                        }

                        table.insert(mergedData, transitionFrame)
                        totalFrames = totalFrames + 1
                    end

                    totalDuration = totalDuration + (transitionFrames * recordInterval)
                end
            end

            currentTimeOffset = currentTimeOffset + recording.Duration + (isLastRecording and 0 or (transitionFrames * recordInterval))
            totalDuration = totalDuration + recording.Duration
        end

        SavedRecordings[newName] = {
            Data = mergedData,
            Duration = totalDuration,
            FrameCount = totalFrames,
            CreatedAt = os.date("%X %x"),
            IsMerged = true,
            IsSmooth = true,
            MergedFrom = recordingNames
        }

        UpdateRecordingDropdown()
        UpdateMergeDropdown()
        SelectedRecordingsForMerge = {}

        return true, totalFrames, totalDuration
    end)

    if success and result then
        local frames, duration = select(2, result), select(3, result)
        WindUI:Notify({
            Title = "Smooth Merge Successful",
            Content = string.format("Created '%s' (Smooth)\n%d recordings merged\n%d frames, %.2fs total", 
                newName, #recordingNames, frames, duration),
            Icon = "check-circle",
            Duration = 5
        })
    else
        WindUI:Notify({
            Title = "Merge Failed",
            Content = "Error: " .. tostring(result),
            Icon = "x-circle",
            Duration = 4
        })
    end
end

WindUI:Notify({
    Title = "Movement Script Pro Loaded",
    Content = "Ultra Smooth Recorder at 240 FPS Ready!",
    Icon = "check-circle",
    Duration = 5
})
