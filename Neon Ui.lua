-- NeonUI Library v1.0
-- Modern Neon-themed UI Library for Roblox

local NeonUI = {}
NeonUI.__index = NeonUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Default Configuration
local defaultConfig = {
    Name = "NeonUI",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "NeonUIConfigs",
        FileName = "config"
    },
    Theme = {
        PrimaryColor = Color3.fromRGB(140, 70, 220),
        SecondaryColor = Color3.fromRGB(75, 0, 130),
        BackgroundColor = Color3.fromRGB(30, 30, 45),
        TextColor = Color3.fromRGB(220, 220, 255),
        AccentColor = Color3.fromRGB(180, 140, 255)
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter Key",
        Key = "NEON123",
        SaveKey = false
    }
}

-- Utility Functions
local function applyCorner(element, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = element
    return corner
end

local function applyStroke(element, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0.5
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = element
    return stroke
end

local function applyGradient(element, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    gradient.Parent = element
    return gradient
end

local function createTween(element, duration, properties)
    local tween = TweenService:Create(
        element,
        TweenInfo.new(duration, Enum.EasingStyle.Quad),
        properties
    )
    tween:Play()
    return tween
end

-- Main Library Constructor
function NeonUI:CreateWindow(config)
    config = config or {}
    setmetatable(config, {__index = defaultConfig})
    
    local window = {}
    window.Config = config
    window.Tabs = {}
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NeonUI_" .. config.Name
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 550, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    mainFrame.BackgroundColor3 = config.Theme.BackgroundColor
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    applyCorner(mainFrame, 16)
    applyStroke(mainFrame, config.Theme.PrimaryColor, 0.5, 1.5)
    applyGradient(mainFrame, config.Theme.SecondaryColor, 
        Color3.fromRGB(config.Theme.SecondaryColor.R - 30, 
                       config.Theme.SecondaryColor.G, 
                       config.Theme.SecondaryColor.B - 40))
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    titleBar.BackgroundTransparency = 0.05
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    applyCorner(titleBar, 16)
    applyGradient(titleBar, 
        Color3.fromRGB(config.Theme.SecondaryColor.R + 10, config.Theme.SecondaryColor.G + 10, config.Theme.SecondaryColor.B + 20),
        Color3.fromRGB(config.Theme.SecondaryColor.R - 20, config.Theme.SecondaryColor.G, config.Theme.SecondaryColor.B - 20))
    
    -- Title Text
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name
    title.TextColor3 = config.Theme.TextColor
    title.TextSize = 20
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Parent = titleBar
    
    applyCorner(closeBtn, 8)
    applyStroke(closeBtn, Color3.fromRGB(255, 100, 100), 0.6)
    
    closeBtn.MouseButton1Click:Connect(function()
        createTween(mainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
    minimizeBtn.Position = UDim2.new(1, -90, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    minimizeBtn.BackgroundTransparency = 0.2
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.SourceSansBold
    minimizeBtn.Parent = titleBar
    
    applyCorner(minimizeBtn, 8)
    applyStroke(minimizeBtn, Color3.fromRGB(255, 220, 100), 0.6)
    
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            createTween(mainFrame, 0.3, {Size = UDim2.new(0, 550, 0, 50)})
            minimizeBtn.Text = "□"
        else
            createTween(mainFrame, 0.3, {Size = UDim2.new(0, 550, 0, 400)})
            minimizeBtn.Text = "─"
        end
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -55)
    tabContainer.Position = UDim2.new(0, 5, 0, 55)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -165, 1, -55)
    contentContainer.Position = UDim2.new(0, 160, 0, 55)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame
    
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentContainer = contentContainer
    
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Notification System
    function window:Notify(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 3
        
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = content,
            Duration = duration
        })
    end
    
    -- Create Tab Function
    function window:CreateTab(name, icon)
        local tab = {}
        tab.Name = name
        tab.Elements = {}
        
        -- Tab Button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name
        tabBtn.Size = UDim2.new(1, 0, 0, 40)
        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        tabBtn.BackgroundTransparency = 0.3
        tabBtn.Text = (icon or "📁") .. " " .. name
        tabBtn.TextColor3 = config.Theme.TextColor
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.SourceSans
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Parent = tabContainer
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.Parent = tabBtn
        
        applyCorner(tabBtn, 10)
        applyStroke(tabBtn, config.Theme.PrimaryColor, 0.8)
        
        -- Tab Content (Scrolling Frame)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = config.Theme.PrimaryColor
        tabContent.ScrollBarImageTransparency = 0.4
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        tab.Content = tabContent
        
        -- Tab Selection Logic
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Content.Visible = false
                for _, btn in pairs(tabContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        createTween(btn, 0.15, {BackgroundTransparency = 0.3})
                    end
                end
            end
            tabContent.Visible = true
            createTween(tabBtn, 0.15, {BackgroundTransparency = 0.1})
        end)
        
        -- Hover Effects
        tabBtn.MouseEnter:Connect(function()
            if not tabContent.Visible then
                createTween(tabBtn, 0.15, {BackgroundTransparency = 0.2})
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if not tabContent.Visible then
                createTween(tabBtn, 0.15, {BackgroundTransparency = 0.3})
            end
        end)
        
        -- Create Button
        function tab:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local btn = Instance.new("TextButton")
            btn.Name = name
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            btn.BackgroundTransparency = 0.3
            btn.Text = name
            btn.TextColor3 = config.Theme.TextColor
            btn.TextSize = 14
            btn.Font = Enum.Font.SourceSans
            btn.Parent = tabContent
            
            applyCorner(btn, 10)
            applyStroke(btn, config.Theme.PrimaryColor, 0.8)
            
            btn.MouseButton1Click:Connect(callback)
            
            btn.MouseEnter:Connect(function()
                createTween(btn, 0.15, {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            
            btn.MouseLeave:Connect(function()
                createTween(btn, 0.15, {BackgroundTransparency = 0.3, TextColor3 = config.Theme.TextColor})
            end)
            
            return btn
        end
        
        -- Create Toggle
        function tab:CreateToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = name
            toggleFrame.Size = UDim2.new(1, -10, 0, 40)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = config.Theme.TextColor
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame
            
            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 50, 0, 24)
            switch.Position = UDim2.new(1, -50, 0.5, -12)
            switch.BackgroundColor3 = default and config.Theme.PrimaryColor or Color3.fromRGB(60, 60, 80)
            switch.Parent = toggleFrame
            
            applyCorner(switch, 12)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 22, 0, 22)
            knob.Position = default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            knob.BackgroundColor3 = Color3.fromRGB(220, 220, 255)
            knob.Parent = switch
            
            applyCorner(knob, 11)
            
            local toggled = default
            
            switch.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                   input.UserInputType == Enum.UserInputType.Touch then
                    toggled = not toggled
                    local goalPos = toggled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
                    local goalColor = toggled and config.Theme.PrimaryColor or Color3.fromRGB(60, 60, 80)
                    createTween(knob, 0.2, {Position = goalPos})
                    createTween(switch, 0.2, {BackgroundColor3 = goalColor})
                    callback(toggled)
                end
            end)
            
            return toggleFrame
        end
        
        -- Create Slider
        function tab:CreateSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = name
            sliderFrame.Size = UDim2.new(1, -10, 0, 50)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. default
            label.TextColor3 = config.Theme.TextColor
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame
            
            local sliderBack = Instance.new("Frame")
            sliderBack.Size = UDim2.new(1, 0, 0, 6)
            sliderBack.Position = UDim2.new(0, 0, 0, 25)
            sliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            sliderBack.Parent = sliderFrame
            
            applyCorner(sliderBack, 3)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = config.Theme.PrimaryColor
            sliderFill.Parent = sliderBack
            
            applyCorner(sliderFill, 3)
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Size = UDim2.new(0, 12, 0, 12)
            sliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            sliderKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 255)
            sliderKnob.Parent = sliderBack
            
            applyCorner(sliderKnob, 6)
            
            local dragging = false
            
            sliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                   input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            sliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                   input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                                input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(pos, -6, 0.5, -6)
                    local value = math.floor(min + (max - min) * pos)
                    label.Text = name .. ": " .. value
                    callback(value)
                end
            end)
            
            return sliderFrame
        end
        
        -- Create Section
        function tab:CreateSection(name)
            local section = Instance.new("Frame")
            section.Name = name
            section.Size = UDim2.new(1, -10, 0, 30)
            section.BackgroundTransparency = 1
            section.Parent = tabContent
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = name
            sectionLabel.TextColor3 = config.Theme.AccentColor
            sectionLabel.TextSize = 16
            sectionLabel.Font = Enum.Font.SourceSansSemibold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = section
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 1, -1)
            line.BackgroundColor3 = config.Theme.PrimaryColor
            line.BackgroundTransparency = 0.7
            line.BorderSizePixel = 0
            line.Parent = section
            
            return section
        end
        
        -- Create Label
        function tab:CreateLabel(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 30)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = config.Theme.TextColor
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true
            label.Parent = tabContent
            
            return label
        end
        
        table.insert(window.Tabs, tab)
        
        -- Auto-select first tab
        if #window.Tabs == 1 then
            tabContent.Visible = true
            createTween(tabBtn, 0.15, {BackgroundTransparency = 0.1})
        end
        
        return tab
    end
    
    -- Show initial notification
    window:Notify({
        Title = "✅ Loaded!",
        Content = config.Name .. " has been loaded successfully!",
        Duration = 3
    })
    
    return window
end

return NeonUI
