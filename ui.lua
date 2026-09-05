 
    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat
 

 Library init
    getgenv().library = {
        directory = "monolithhh",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        config_flags = {},
        connections = {},   
        notifications = {notifs = {}},
        current_open; 
    }

    local bwTheme = {
        Accent = rgb(255, 255, 255),
        WindowBg = rgb(10, 10, 10),
        TopFrameBg = rgb(14, 14, 14),
        InlineBg = rgb(12, 12, 12),
        PageHolderBg = rgb(9, 9, 9),
        Text = rgb(255, 255, 255),
        SubText = rgb(180, 180, 180),
        Border = rgb(42, 42, 42),
        ToggleActive = rgb(255, 255, 255),
        AccentGradient = { rgbkey(0, rgb(255, 255, 255)), rgbkey(0.5, rgb(215, 215, 215)), rgbkey(1, rgb(160, 160, 160)) }
    }

    library.themes = {
        ["BlackAndWhite"] = bwTheme,
        ["White"] = bwTheme,
        ["Default"] = bwTheme,
        ["Yellow"] = bwTheme
    }
    library.current_theme_name = "BlackAndWhite"
    library.current_theme = bwTheme

    function library:SetTheme(themeName)
        local t = library.themes[themeName] or bwTheme
        library.current_theme_name = "BlackAndWhite"
        library.current_theme = t

        if library.window_obj and library.window_obj.items then
            local items = library.window_obj.items
            if items["window"] then items["window"].BackgroundColor3 = t.WindowBg end
            if items["top_frame"] then items["top_frame"].BackgroundColor3 = t.TopFrameBg end
            if items["top_divider"] then 
                items["top_divider"].BackgroundColor3 = t.Accent
                local grad = items["top_divider"]:FindFirstChildOfClass("UIGradient")
                if grad and t.AccentGradient then
                    grad.Color = rgbseq(t.AccentGradient)
                end
            end
            if items["inline"] then items["inline"].BackgroundColor3 = t.InlineBg end
            if items["page_holder"] then items["page_holder"].BackgroundColor3 = t.PageHolderBg end
            if items["ui_title"] then items["ui_title"].TextColor3 = t.Accent end
            if items["ui_badge"] then
                items["ui_badge"].TextColor3 = t.Accent
                items["ui_badge"].BorderColor3 = t.Accent
            end
            if items["top_dot"] then items["top_dot"].BackgroundColor3 = t.Accent end
            if items["top_logo"] then items["top_logo"].ImageColor3 = t.Accent end
        end

        if library.window_obj and library.window_obj.selected_tab then
            local sel = library.window_obj.selected_tab
            if sel[1] then library:tween(sel[1], {ImageColor3 = t.Accent}, Enum.EasingStyle.Quad, 0.15) end
        end
    end

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }
        
    library.__index = library

    for _, path in next, library.folders do 
        makefolder(library.directory .. path)
    end

    local flags = library.flags 
    local config_flags = library.config_flags
    local notifications = library.notifications 

     Font importing system 
        if isfile(library.directory .. "/fonts/main.ttf") then 
            delfile(library.directory .. "/fonts/main.ttf")
        else 
            writefile(library.directory .. "/fonts/main.ttf", game:HttpGet("https://github.com/f1nobe7650/Nebula/raw/refs/heads/main/Minecraftia-Regular.ttf"))
        end 
        
        local minecraftia = {
            name = "Minecraftia",
            faces = {
                {
                    name = "Regular",
                    weight = 400,
                    style = "normal",
                    assetId = getcustomasset(library.directory .. "/fonts/main.ttf")
                }
            }
        }
        
        if not isfile(library.directory .. "/fonts/main_encoded.ttf") then 
            writefile(library.directory .. "/fonts/main_encoded.ttf", http_service:JSONEncode(minecraftia))
        end 
        
        library.font = Font.new(getcustomasset(library.directory .. "/fonts/main_encoded.ttf"), Enum.FontWeight.Regular)
        library.Font = library.font
     

 Library functions 
     Misc functions
        function library:tween(obj, properties, easing_style, time) 
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties)
            tween:Play()
                
            return tween
        end

        function library:get_transparency(obj)
            if obj:IsA("Frame") then
                return {"BackgroundTransparency"}
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif obj:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif obj:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("UIStroke") then 
                return { "Transparency" }
            end
            
            return nil
        end

        function library:fade(obj, prop, vis, speed)
            if not (obj and prop) then
                return
            end

            local OldTransparency = obj[prop]
            obj[prop] = vis and 1 or OldTransparency

            local Tween = library:tween(obj, { [prop] = vis and OldTransparency or 1 })

            library:connection(Tween.Completed, function()
                if not vis then
                    task.wait()
                    obj[prop] = OldTransparency
                end
            end)

            return Tween
        end

        function library:resizify(frame) 
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1 
            Frame.Text = ""

            local resizing = false 
            local start_size 
            local start 
            local og_size = frame.Size  

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            Frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            og_size.X.Offset,
                            viewport_x
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            og_size.Y.Offset,
                            viewport_y
                        )
                    )

                     library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)  nobody will ntoice this aswell 👿
                    frame.Size = current_size
                end
            end)
        end 

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame, targetFrame)
            local target = targetFrame or frame
            local dragging = false 
            local start_size = target.Position
            local start 

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    start = input.Position
                    start_size = target.Position
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input, game_event) 
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_position = dim2(
                        0,
                        clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            0,
                            viewport_x - target.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            0,
                            viewport_y - target.Size.Y.Offset
                        )
                    )

                    tween_service:Create(target, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = current_position}):Play()
                    library:close_current_element(nil) 
                end
            end)
        end 

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end
            
            if #values == 4 then              
                return unpack(values)
            else 
                return
            end
        end
        
        function library:convert_enum(enum)
            local enum_parts = {}
        
            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end
        
            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]
        
                enum_table = enum_item
            end
        
            return enum_table
        end

        local config_holder;
        function library:update_config_list() 
            if not config_holder then 
                return 
            end
            
            local list = {}
            
            for idx, file in listfiles(library.directory .. "/configs") do
                local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
                list[#list + 1] = name
            end

            config_holder.refresh_options(list)
        end 

        function library:get_config()
            local Config = {}
            
            for _, v in next, flags do
                if type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end 
            
            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json) 
            local config = http_service:JSONDecode(config_json)
            
            for _, v in config do 
                local function_set = library.config_flags[_]
                
                if _ == "config_name_list" then 
                    continue 
                end

                if function_set then 
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                    elseif type(v) == "table" and v["active"] then 
                        function_set(v)
                    else
                        function_set(v)
                    end
                end 
            end 
        end 
        
        function library:round(number, float) 
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end 

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)
            
            insert(library.connections, connection)

            return connection 
        end

        function library:close_current_element(cfg) 
			local path = library.current 

			if path and path ~= cfg then 
				path.set_visible(false)
				path.open = false 
			end
		end

        function library:create(instance, options)
            local ins = Instance.new(instance) 
            
            for prop, value in options do 
                ins[prop] = value
            end
            
            return ins 
        end

        function library:unload_menu() 
             Safely disconnect all tracked signals/connections
            if type(library.connections) == "table" then
                for index, connection in pairs(library.connections) do 
                    pcall(function()
                        if typeof(connection) == "RBXScriptConnection" then
                            connection:Disconnect()
                        elseif type(connection) == "table" and type(connection.Disconnect) == "function" then
                            connection:Disconnect()
                        end
                    end)
                end
                table.clear(library.connections)
            end

             Destroy screen GUI instances
            if library[ "items" ] then 
                pcall(function() library[ "items" ]:Destroy() end)
                library[ "items" ] = nil
            end

            if library[ "other" ] then 
                pcall(function() library[ "other" ]:Destroy() end)
                library[ "other" ] = nil
            end 

             Clean up watermark if created
            pcall(function()
                if watermark_obj then
                    watermark_obj:Destroy()
                    watermark_obj = nil
                end
            end)

             Clean up keybind list and custom cursor
            pcall(function()
                if library.cleanup_keybind_list then
                    library.cleanup_keybind_list()
                end
            end)
            pcall(function()
                if library.cleanup_cursor then
                    library.cleanup_cursor()
                end
            end)

             Clean up notifications
            pcall(function()
                if library.notifications and type(library.notifications.notifs) == "table" then
                    for _, notif in pairs(library.notifications.notifs) do
                        pcall(function() notif:Destroy() end)
                    end
                    table.clear(library.notifications.notifs)
                end
            end)

             Clear active references and state
            library.window_obj = nil
            library.current = nil
            library.current_open = nil
        end 

        library.Unload = function(self) return library:unload_menu() end
        library.unload = function(self) return library:unload_menu() end
        library.unloadMenu = function(self) return library:unload_menu() end
    
    
     Library element functions
        function library:window(properties)
            local cfg = { 
                 Properties
                name = properties.name or properties.Name or "nebula";
                size = properties.size or properties.Size or dim2(0, 760, 0, 460);
                logo = (properties.logo ~= false and properties.logo) or (properties.Logo ~= false and properties.Logo) or nil;

                selected_tab;
                items = {};
                tweening;
            }

            cfg.Unload = function(self) return library:unload_menu() end
            cfg.unload = function(self) return library:unload_menu() end
            cfg.unload_menu = function(self) return library:unload_menu() end
            cfg.unloadMenu = function(self) return library:unload_menu() end
            
            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            });
            
            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
                DisplayOrder = 9999;
            }); 

            local items = cfg.items; do
                local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]

                items[ "window" ] = library:create( "Frame" , {
                    Parent = library.items;
                    Name = "\0";
                    Visible = false;
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(35, 35, 35);
                    Size = cfg.size;
                    BorderSizePixel = 1;
                    BackgroundColor3 = curTheme.WindowBg or rgb(10, 10, 10);
                    ClipsDescendants = false;
                }); items[ "window" ].Position = dim2(0, items[ "window" ].AbsolutePosition.X, 0, items[ "window" ].AbsolutePosition.Y)          

                items[ "glow" ] = library:create( "ImageLabel" , {
                    Parent = items[ "window" ];
                    Name = "Glow";
                    ImageColor3 = rgb(0, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    ImageTransparency = 0.65;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 40, 1, 40);
                    Image = "rbxassetid://18245826428";
                    BackgroundTransparency = 1;
                    Position = dim2(0, -20, 0, -20);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(21, 21), vec2(79, 79));
                    ZIndex = 0;
                });

                local topBarH = 34

                items[ "top_frame" ] = library:create( "Frame" , {
                    Name = "TopBar";
                    Parent = items[ "window" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, topBarH);
                    Visible = true;
                    BorderSizePixel = 0;
                    ZIndex = 5;
                    BackgroundColor3 = curTheme.TopFrameBg or rgb(14, 14, 14);
                });
                
                items[ "top_divider" ] = library:create( "Frame" , {
                    Parent = items[ "window" ];
                    Name = "TopDivider";
                    Position = dim2(0, 0, 0, topBarH);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    ZIndex = 10;
                    BackgroundColor3 = curTheme.Accent or rgb(255, 255, 255);
                });

                items[ "ui_title" ] = library:create( "TextLabel" , {
                    Parent = items[ "top_frame" ];
                    Name = "Title";
                    Text = cfg.name or "alternate";
                    TextColor3 = curTheme.Accent or rgb(255, 255, 255);
                    TextSize = 19;
                    FontFace = library.font or Font.fromEnum(Enum.Font.GothamBold);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    Position = dim2(0, 16, 0.5, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Size = dim2(0, 300, 1, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    ZIndex = 6;
                });

                library:create( "UIStroke" , {
                    Parent = items[ "ui_title" ];
                    Color = rgb(0, 0, 0);
                    Thickness = 1;
                    Transparency = 0.3;
                });

                local sidebarW = 98
                local contentY = topBarH + 1

                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "window" ];
                    Name = "Sidebar";
                    Position = dim2(0, 0, 0, contentY);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, sidebarW, 1, -contentY);
                    BorderSizePixel = 0;
                    BackgroundColor3 = curTheme.InlineBg or rgb(12, 12, 12);
                    ZIndex = 3;
                });

                library:create( "Frame" , {
                    Parent = items[ "inline" ];
                    Name = "SidebarDivider";
                    Position = dim2(1, -1, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(26, 26, 26);
                    ZIndex = 4;
                });
                
                items[ "tab_button_holder" ] = library:create( "ScrollingFrame" , {
                    Parent = items[ "inline" ];
                    Name = "TabHolder";
                    Position = dim2(0, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    ClipsDescendants = true;
                    ScrollBarThickness = 0;
                    ScrollBarImageTransparency = 1;
                    CanvasSize = dim2(0, 0, 0, 0);
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ZIndex = 5;
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "tab_button_holder" ];
                    PaddingTop = dim(0, 2);
                    PaddingBottom = dim(0, 2);
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "tab_button_holder" ];
                    Padding = dim(0, 1);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                });
                
                items[ "page_holder" ] = library:create( "Frame" , {
                    Parent = items[ "window" ];
                    Name = "PageHolder";
                    Position = dim2(0, sidebarW, 0, contentY);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -sidebarW, 1, -contentY);
                    BorderSizePixel = 0;
                    BackgroundColor3 = curTheme.PageHolderBg or rgb(9, 9, 9);
                    ZIndex = 2;
                });
            end 

            do  Other
                library:draggify(items[ "window" ])
                if items[ "top_frame" ] then
                    library:draggify(items[ "top_frame" ], items[ "window" ])
                end
                library:resizify(items[ "window" ])
            end 
            
            library:connection(uis.InputBegan, function(input, game_event)
                if game_event then
                    return
                end
                local bind = flags["MenuKeybind"]
                local key = type(bind) == "table" and (bind.key or bind.Key) or bind
                if not key or key == "NONE" or key == Enum.KeyCode.Unknown then
                    return
                end
                local selected = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                if selected == key then
                    cfg.toggle_menu(not items["window"].Visible)
                end
            end)

            function cfg.toggle_menu(bool) 
                if cfg.tweening then 
                    return 
                end 

                cfg.tweening = true 

                if bool then 
                    items[ "window" ].Visible = true
                else
                    if items[ "tab_tooltip" ] then
                        items[ "tab_tooltip" ].Visible = false
                    end
                end

                local Children = items[ "window" ]:GetDescendants()
                table.insert(Children, items[ "window" ])

                local Tween;
                for _,obj in Children do
                    local Index = library:get_transparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = library:fade(obj, prop, bool)
                        end
                    else
                        Tween = library:fade(obj, Index, bool)
                    end
                end

                library:connection(Tween.Completed, function()
                    cfg.tweening = false
                    items[ "window" ].Visible = bool
                end)
            end 

            function cfg:SetVisible(bool)
                cfg.toggle_menu(bool)
            end
            function cfg:SetOpen(bool)
                cfg.toggle_menu(bool)
            end
            cfg.Main = items[ "window" ]
            library.window_obj = cfg
            if library.current_theme_name then
                library:SetTheme(library.current_theme_name)
            end
                
            return setmetatable(cfg, library)
        end 

        function library:Tab(properties)
            local prop_is_string = type(properties) == "string"
            local cfg = {
                 properties
                name = prop_is_string and properties or (type(properties) == "table" and (properties.name or properties.Name)) or "visuals"; 
                icon = (type(properties) == "table" and (properties.icon or properties.Icon)) or "http://www.roblox.com/asset/?id=6034767608";
                icon_size = (type(properties) == "table" and (properties.icon_size or properties.IconSize)) or 70;
                
                items = {};
            } 

            local items = cfg.items; do                
                 Tab buttons 
                    local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]

                    items[ "tab_button" ] = library:create( "TextButton" , {
                        Parent = self.items[ "tab_button_holder" ];
                        BackgroundTransparency = 1;
                        Text = "";
                        Size = dim2(0, 90, 0, 68);
                        BorderSizePixel = 0;
                        AutoButtonColor = false;
                        ZIndex = 6;
                    });
                    
                    items[ "image" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(110, 110, 110);
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "tab_button" ];
                        Name = "\0";
                        Size = dim2(0, cfg.icon_size, 0, cfg.icon_size);
                        AnchorPoint = vec2(0.5, 0.5);
                        Image = cfg.icon;
                        BackgroundTransparency = 1;
                        Position = dim2(0.5, 0, 0.5, 0);
                        Selectable = false;
                        BorderSizePixel = 0;
                        ScaleType = Enum.ScaleType.Fit;
                        ZIndex = 7;
                    });                       
                 

                 SubTab layout setup
                items[ "tab" ] = library:create( "Frame" , {
                    Parent = library.items;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Visible = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Vertical;
                    Parent = items[ "tab" ];
                    Padding = dim(0, 22);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });
                
                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 16);
                    PaddingBottom = dim(0, 16);
                    Parent = items[ "tab" ];
                    PaddingRight = dim(0, 20);
                    PaddingLeft = dim(0, 20)
                });     

                items[ "subtab_holder" ] = library:create( "Frame" , {
                    Parent = items[ "tab" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Visible = false;
                    Size = dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    LayoutOrder = 0;
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    Parent = items[ "subtab_holder" ];
                    Padding = dim(0, 16);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });

                items[ "subtab_content" ] = library:create( "Frame" , {
                    Parent = items[ "tab" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 1, -32);
                    BorderSizePixel = 0;
                    LayoutOrder = 1;
                });

                 Default main subtab (used if no subtabs are created)
                cfg.default_subtab = library:create( "Frame" , {
                    Parent = items[ "subtab_content" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = cfg.default_subtab;
                    Padding = dim(0, 21);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                });

                for _,column in {"left", "right"} do 
                    items[ column ] = library:create( "Frame" , {
                        Parent = cfg.default_subtab;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 100, 0, 100);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(8, 8, 8)
                    }); 
                    library:create( "UIListLayout" , {
                        Parent = items[ column ];
                        Padding = dim(0, 10);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end
            end 

            function cfg.open_tab() 
                local selected_tab = self.selected_tab
                local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]
                
                if selected_tab then 
                   library:tween(selected_tab[ 1 ], {ImageColor3 = rgb(110, 110, 110)}, Enum.EasingStyle.Quad, 0.15)
                   selected_tab[ 2 ].Parent = library.items
                   selected_tab[ 2 ].Visible = false
                end
                
                library:tween(items.image, {ImageColor3 = curTheme.Accent or rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.15)
                items.tab.Parent = self.items[ "page_holder" ]
                items.tab.Visible = true

                self.selected_tab = {
                    items.image;
                    items.tab;
                    items.tab_button;
                }

                library:close_current_element(nil) 
            end

            items[ "tab_button" ].MouseButton1Down:Connect(function()
                cfg.open_tab()
            end)

            cfg.selected_subtab = nil

            function cfg:SubTab(subprops)
                local sub_cfg = {
                    name = type(subprops) == "table" and (subprops.name or subprops.Name) or tostring(subprops or "SubTab");
                    items = {};
                }
                
                items[ "subtab_holder" ].Visible = true
                items[ "subtab_content" ].Size = dim2(1, 0, 1, -74)
                if cfg.default_subtab then
                    cfg.default_subtab:Destroy()
                    cfg.default_subtab = nil
                end

                local sub_items = sub_cfg.items
                
                sub_items[ "subtab_btn" ] = library:create( "TextButton" , {
                    Parent = items[ "subtab_holder" ];
                    BackgroundTransparency = 1;
                    Text = sub_cfg.name;
                    TextColor3 = rgb(130, 130, 130);
                    FontFace = subprops and (subprops.font or subprops.FontFace) or library.font or library.Font;
                    TextSize = subprops and (subprops.size or subprops.TextSize) or 12;
                    Size = dim2(0, 0, 1, 0);
                    AutomaticSize = Enum.AutomaticSize.X;
                    AutoButtonColor = false;
                });

                sub_items[ "subtab_indicator" ] = library:create( "Frame" , {
                    Parent = sub_items[ "subtab_btn" ];
                    BorderSizePixel = 0;
                    Size = dim2(1, 0, 0, 1);
                    Position = dim2(0, 0, 1, 2);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BackgroundTransparency = 1;
                });

                sub_items[ "subtab_content" ] = library:create( "Frame" , {
                    Parent = items[ "subtab_content" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Visible = false;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = sub_items[ "subtab_content" ];
                    Padding = dim(0, 21);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                });

                for _,column in {"left", "right"} do 
                    sub_items[ column ] = library:create( "Frame" , {
                        Parent = sub_items[ "subtab_content" ];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 100, 0, 100);
                        BorderSizePixel = 0;
                    }); 
                    library:create( "UIListLayout" , {
                        Parent = sub_items[ column ];
                        Padding = dim(0, 10);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end

                function sub_cfg.open_subtab()
                    local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]
                    if cfg.selected_subtab then
                        library:tween(cfg.selected_subtab.items[ "subtab_btn" ], {TextColor3 = rgb(130, 130, 130)}, Enum.EasingStyle.Quad, 0.15)
                        if cfg.selected_subtab.items[ "subtab_indicator" ] then
                            library:tween(cfg.selected_subtab.items[ "subtab_indicator" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.15)
                        end
                        cfg.selected_subtab.items[ "subtab_content" ].Visible = false
                    end
                    library:tween(sub_items[ "subtab_btn" ], {TextColor3 = curTheme.Accent or rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.15)
                    if sub_items[ "subtab_indicator" ] then
                        sub_items[ "subtab_indicator" ].BackgroundColor3 = curTheme.Accent or rgb(255, 255, 255)
                        library:tween(sub_items[ "subtab_indicator" ], {BackgroundTransparency = 0}, Enum.EasingStyle.Quad, 0.15)
                    end
                    sub_items[ "subtab_content" ].Visible = true
                    cfg.selected_subtab = sub_cfg
                end

                sub_items[ "subtab_btn" ].MouseEnter:Connect(function()
                    if cfg.selected_subtab ~= sub_cfg then
                        library:tween(sub_items[ "subtab_btn" ], {TextColor3 = rgb(200, 200, 200)}, Enum.EasingStyle.Quad, 0.15)
                    end
                end)

                sub_items[ "subtab_btn" ].MouseLeave:Connect(function()
                    if cfg.selected_subtab ~= sub_cfg then
                        library:tween(sub_items[ "subtab_btn" ], {TextColor3 = rgb(130, 130, 130)}, Enum.EasingStyle.Quad, 0.15)
                    end
                end)

                sub_items[ "subtab_btn" ].MouseButton1Down:Connect(function()
                    sub_cfg.open_subtab()
                end)

                if not cfg.selected_subtab then
                    sub_cfg.open_subtab()
                end

                return setmetatable(sub_cfg, library)
            end

            if not self.selected_tab then 
                cfg.open_tab(true) 
            end

            return setmetatable(cfg, library)
        end

        function library:Section(properties)
            local raw_side = properties.side or properties.Side or "left"
            local side_str = tostring(raw_side):lower()
            local resolved_side = (side_str == "right" or side_str == "2") and "right" or "left"

            local cfg = {
                name = properties.name or properties.Name or "section"; 
                side = resolved_side;
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or 0.5; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = properties.fading or properties.Fading or false;
                items = {};
            };
            
            self.column_sections = self.column_sections or { left = {}, right = {} }
            table.insert(self.column_sections[cfg.side], cfg)

            local function update_column_layout()
                local list = self.column_sections[cfg.side]
                if not list then return end
                local visible_sections = {}
                for _, s in ipairs(list) do
                    if s.items and s.items.section_outline and s.items.section_outline.Visible then
                        table.insert(visible_sections, s)
                    end
                end
                local count = #visible_sections
                if count == 0 then return end
                local gap = 10
                local total_gaps = (count - 1) * gap
                for _, s in ipairs(visible_sections) do
                    local scale = 1 / count
                    local offset = -math.floor(total_gaps / count)
                    s.items.section_outline.Size = dim2(1, 0, scale, offset)
                end
            end
            cfg.update_layout = update_column_layout

            local items = cfg.items; do 
                items[ "section_outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    BackgroundTransparency = 0;
                    Parent = self.items[ cfg.side ];
                    BorderColor3 = rgb(35, 35, 35);
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 1;
                    BackgroundColor3 = rgb(14, 14, 14)
                });

                items[ "section_shadow" ] = items[ "section_outline" ]
                items[ "section_shadow_one" ] = items[ "section_outline" ]
                items[ "section_shadow_two" ] = items[ "section_outline" ]
                items[ "section_shadow_three" ] = items[ "section_outline" ]
                
                items[ "scrolling" ] = library:create( "ScrollingFrame" , {
                    ScrollBarImageColor3 = rgb(60, 60, 60);
                    Active = true;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = 2;
                    Parent = items[ "section_outline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = dim2(0, 0, 0, 0);
                    ClipsDescendants = true;
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]

                items.text = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = curTheme.Accent or rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = " " .. cfg.name .. " ";
                    Parent = items[ "section_outline" ];
                    BackgroundTransparency = 0;
                    Position = dim2(0, 10, 0, -8);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 11;
                    ZIndex = 5;
                    BackgroundColor3 = rgb(14, 14, 14)
                });
                
                items.line = library:create( "Frame" , {
                    Parent = items.text;
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = curTheme.Accent or rgb(255, 255, 255);
                });                

                library:create( "UIStroke" , {
                    Parent = items.text;
                });            
            end;

            update_column_layout()

            items[ "section_outline" ].MouseEnter:Connect(function()
                library:tween(items[ "section_outline" ], {BorderColor3 = rgb(65, 65, 65)})
                library:tween(items.text, {TextColor3 = rgb(255, 255, 255)})
            end)

            items[ "section_outline" ].MouseLeave:Connect(function()
                library:tween(items[ "section_outline" ], {BorderColor3 = rgb(35, 35, 35)})
                local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]
                library:tween(items.text, {TextColor3 = curTheme.Accent or rgb(255, 255, 255)})
            end)

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items.section_outline then
                    items.section_outline.Visible = state
                end
                update_column_layout()
            end
            cfg.set_visible = cfg.SetVisibility

            return setmetatable(cfg, library)
        end

        function library:Toggle(options) 
            local cfg = {
                enabled = options.enabled or options.Enabled or nil,
                name = options.name or options.Name or "Toggle",
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺",
                
                default = options.default or options.Default or false,
                callback = options.callback or options.Callback or function() end,

                items = {};
            }

            local items = cfg.items; do 
                items[ "object" ] = library:create( "TextButton" , {
                    Parent = self.items[ "elements" ];
                    Text = "";
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 16);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "toggle_outline" ] = library:create( "Frame" , {
                    Parent = items[ "object" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 14, 0, 14);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "toggle_shading" ] = library:create( "Frame" , {
                    Parent = items[ "toggle_outline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(92, 92, 92)
                });
                
                items[ "toggle_inline" ] = library:create( "Frame" , {
                    Parent = items[ "toggle_shading" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(54, 54, 54)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 8);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal;
                    VerticalAlignment = Enum.VerticalAlignment.Center;
                });
                
                items[ "text" ] = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "object" ];
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 11;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIStroke" , {
                    Parent = items[ "text" ]
                });
                
                library:create( "UIPadding" , {
                    PaddingLeft = dim(0, 1);
                    Parent = items[ "text" ]
                });
            end;
            
            cfg.child_sliders = {}

            function cfg:Slider(slider_options)
                local s = library.Slider(self, slider_options)
                table.insert(cfg.child_sliders, s)
                if not cfg.enabled then
                    s:SetVisibility(false)
                end
                return s
            end

            function cfg.set(bool)
                cfg.enabled = bool
                local curTheme = library.current_theme
                local activeCol = (curTheme and curTheme.ToggleActive) or rgb(255, 255, 255)
                local subCol = (curTheme and curTheme.SubText) or rgb(178, 178, 178)
                library:tween(items[ "text" ], {TextColor3 = bool and activeCol or subCol})
                library:tween(items[ "toggle_outline" ], {BackgroundTransparency = bool and 0 or 1})
                library:tween(items[ "toggle_shading" ], {BackgroundTransparency = bool and 0 or 1})
                library:tween(items[ "toggle_inline" ], {BackgroundColor3 = bool and activeCol or rgb(54, 54, 54)})

                if cfg.child_sliders then
                    for _, s in ipairs(cfg.child_sliders) do
                        if s and s.SetVisibility then
                            s:SetVisibility(bool)
                        end
                    end
                end

                cfg.callback(bool)
                
                flags[cfg.flag] = bool
            end 
            
            items[ "object" ].MouseButton1Click:Connect(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end)
            
            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items[ "object" ] then
                    items[ "object" ].Visible = state
                end
                if cfg.child_sliders then
                    for _, s in ipairs(cfg.child_sliders) do
                        if s and s.SetVisibility then
                            s:SetVisibility(state and cfg.enabled)
                        end
                    end
                end
            end
            cfg.set_visible = cfg.SetVisibility

            return setmetatable(cfg, library)
        end 
        
        function library:Slider(options) 
            local cfg = {
                 Options
                name = options.name or options.Name or nil;
                suffix = options.suffix or options.Suffix or "";
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺";
                callback = options.callback or options.Callback or function() end; 
                show_value = options.ShowValue or options.show_value or true; 

                 value settings
                min = options.min or options.minimum or options.Min or options.Minimum or 0;
                max = options.max or options.maximum or options.Max or options.Maximum or 100;
                intervals = options.interval or options.decimal or options.Interval or options.Decimal or 1;
                default = options.default or options.Default or 10;
                value = options.default or options.default or 10; 

                 ignore
                dragging = false;
                items = {}
            } 

            local items = cfg.items; do
                items[ "object" ] = library:create( "Frame" , {
                    Parent = self.items.object or self.items.elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 24);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Vertical;
                });

                items[ "label_row" ] = library:create( "Frame" , {
                    Parent = items[ "object" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 13);
                    BorderSizePixel = 0;
                    LayoutOrder = 0;
                });

                if cfg.name then
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "label_row" ];
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Position = dim2(0, 0, 0, 0);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextSize = 11;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    library:create( "UIStroke" , { Parent = items[ "name" ] });
                end

                if cfg.show_value then 
                    items[ "value" ] = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "label_row" ];
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        Position = dim2(1, 0, 0, 0);
                        AnchorPoint = vec2(1, 0);
                        TextXAlignment = Enum.TextXAlignment.Right;
                        TextSize = 11;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    library:create( "UIStroke" , { Parent = items[ "value" ] });
                end       
                
                items[ "slider_parent" ] = library:create( "TextButton" , {
                    Parent = items[ "object" ];
                    BackgroundTransparency = 1;
                    Text = "";
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 10);
                    BorderSizePixel = 0;
                    LayoutOrder = 1;
                    AutoButtonColor = false;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "slider_holder" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 0.5);
                    Parent = items[ "slider_parent" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "gradient_holder" ] = library:create( "Frame" , {
                    Parent = items[ "slider_holder" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                local curTheme = library.current_theme
                local sliderGrad = (curTheme and curTheme.AccentGradient) or {rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(93, 93, 93))}
                library:create( "UIGradient" , {
                    Color = rgbseq(sliderGrad);
                    Parent = items[ "gradient_holder" ]
                });
                
                items[ "slider" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 0.5);
                    Parent = items[ "gradient_holder" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 5, 0, 11);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                local thumbCol = (curTheme and curTheme.Accent) or rgb(255, 255, 255)
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "slider" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = thumbCol
                });
            end 

            function cfg.set(value, ignore_callback)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)
                
                items[ "slider" ].Position = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 0.5, 0)

                if items[ "value" ] then
                    items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix
                end

                flags[cfg.flag] = cfg.value
                if not ignore_callback then
                    cfg.callback(flags[cfg.flag])
                end
            end

            items[ "slider_parent" ].MouseButton1Down:Connect(function()
                cfg.dragging = true 
            end)

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                    local size_x = (input.Position.X - items[ "gradient_holder" ].AbsolutePosition.X) / items[ "gradient_holder" ].AbsoluteSize.X
                    local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(value)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    cfg.dragging = false
                end 
            end)
            
            cfg.set(cfg.default, true)
            config_flags[cfg.flag] = cfg.set

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items[ "object" ] then
                    items[ "object" ].Visible = state
                end
            end
            cfg.set_visible = cfg.SetVisibility
            cfg.SetVisiblity = cfg.SetVisibility

            return setmetatable(cfg, library)
        end 

        function library:Dropdown(options) 
            local cfg = {
                obj_type = "dropdown";

                 Options
                name = options.name or options.Name or nil;
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺";
                options = options.items or options.Items or {"1", "2", "3"};
                callback = options.callback or options.Callback or function() end;
                multi = options.multi or options.Multi or false;

                 Ignore these 
                open = false;
                option_instances = {};
                multi_items = {};
                items = {};
            }   

            cfg.default = options.default or options.Default or (cfg.multi and {cfg.options[1]}) or cfg.options[1] or "None"
            flags[cfg.flag] = cfg.default
            
            local items = cfg.items; do 
                 Element
                    items[ "object" ] = library:create( "Frame" , {
                        Parent = self.items.object or self.items.elements;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 18);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if cfg.name then
                        items[ "name" ] = library:create( "TextLabel" , {
                            FontFace = library.font;
                            TextColor3 = rgb(178, 178, 178);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = cfg.name;
                            Parent = items[ "object" ];
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 0, 0);
                            Size = dim2(1, -118, 1, 0);
                            BorderSizePixel = 0;
                            TextSize = 11;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            TextTruncate = Enum.TextTruncate.AtEnd;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                        library:create( "UIStroke" , { Parent = items[ "name" ] });
                    end
                    
                    items[ "dropdown_outline" ] = library:create( "TextButton" , {
                        Parent = items[ "object" ];
                        Text = "";
                        AutoButtonColor = false;
                        Name = "\0";
                        AnchorPoint = vec2(1, 0.5);
                        Position = dim2(1, 0, 0.5, 0);
                        Size = dim2(0, 110, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "dropdown_shading" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_outline" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "dropdown_shading" ];
                        Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                    });
                    
                    items.inner_text = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "dropdown_shading" ];
                        AnchorPoint = vec2(0, 0.5);
                        Size = dim2(1, -12, 1, 0);
                        BackgroundTransparency = 1;
                        Position = dim2(0, 4, 0.5, 0);
                        BorderSizePixel = 0;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        TextSize = 10;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIStroke" , {
                        Parent = items.inner_text
                    });
                    
                    items[ "arrow" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown_outline" ];
                        Name = "\0";
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://76667213487638";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -4, 0.5, 0);
                        Size = dim2(0, 7, 0, 4);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                 

                 Element Holder
                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        Parent = library.items;
                        Size = dim2(0, 110, 0, 0);
                        Visible = false;
                        Name = "\0";
                        ZIndex = 50;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        ClipsDescendants = true;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "holder_shading" ] = library:create( "ScrollingFrame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        ScrollBarThickness = 2;
                        ScrollBarImageColor3 = rgb(80, 80, 80);
                        CanvasSize = dim2(0, 0, 0, 0);
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "holder_shading" ];
                        Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "holder_shading" ];
                        Padding = dim(0, 2);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 3);
                        PaddingTop = dim(0, 3);
                        Parent = items[ "holder_shading" ]
                    });            
                 
            end 

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "holder_shading" ];
                    Size = dim2(1, 0, 0, 14);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    BorderSizePixel = 0;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIStroke" , {
                    Parent = button
                });

                return button
            end
            
            function cfg.set_visible(bool)
                items[ "dropdown_holder" ].Visible = bool 
                items[ "arrow" ].Rotation = bool and 180 or 0

                if bool then
                    local count = #cfg.options
                    local maxVisible = math.min(count, 6)
                    local h = maxVisible * 18 + 6
                    items[ "dropdown_holder" ].Size = dim2(0, items.dropdown_outline.AbsoluteSize.X, 0, h)
                    items[ "dropdown_holder" ].Position = dim2(0, items.dropdown_outline.AbsolutePosition.X, 0, items.dropdown_outline.AbsolutePosition.Y + 22)
                end
                
                library.current = cfg
            end
             function cfg.set(value, ignore_callback)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do 
                    if option.Text == value or (isTable and find(value, option.Text)) then 
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = rgb(255, 255, 255)
                    else
                        option.TextColor3 = rgb(174, 174, 174)
                    end
                end

                items.inner_text.Text = if isTable then concat(selected, ", ") else selected[1] or ""
                flags[cfg.flag] = if isTable then selected else selected[1]
                
                if not ignore_callback then
                    cfg.callback(flags[cfg.flag]) 
                end
            end
            
            function cfg.refresh_options(list) 
                for _, option in cfg.option_instances do 
                    option:Destroy() 
                end
                
                cfg.option_instances = {} 

                for _, option in list do 
                    local button = cfg.render_option(option)
                    insert(cfg.option_instances, button)
                    
                    button.MouseButton1Down:Connect(function()
                        if cfg.multi then 
                            local selected_index = find(cfg.multi_items, button.Text)
                            
                            if selected_index then 
                                remove(cfg.multi_items, selected_index)
                            else 
                                insert(cfg.multi_items, button.Text)
                            end
                            
                            cfg.set(cfg.multi_items) 				
                        else 
                            cfg.set_visible(false)
                            cfg.open = false 
                            
                            cfg.set(button.Text)
                        end
                    end)
                end
            end

            items.dropdown_outline.MouseButton1Click:Connect(function()
                cfg.open = not cfg.open
                cfg.set_visible(cfg.open)
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not (library:mouse_in_frame(items.dropdown_holder) or library:mouse_in_frame(items.object)) then 
                        cfg.open = false
                        cfg.set_visible(false)
                    end
                end
            end)
            
            config_flags[cfg.flag] = cfg.set
            
            cfg.refresh_options(cfg.options)
            cfg.set(cfg.default, true)

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items[ "object" ] then
                    items[ "object" ].Visible = state
                end
                if not state and cfg.open then
                    cfg.open = false
                    cfg.set_visible(false)
                end
            end
            cfg.SetVisiblity = cfg.SetVisibility
            cfg.set_visible_element = cfg.SetVisibility
            cfg.Refresh = cfg.refresh_options

            return setmetatable(cfg, library)
        end

        function library:Label(options)
            if type(options) == "string" then
                options = {Name = options}
            end
            options = options or {}
            local cfg = {
                name = options.Name or options.name or "Label",

                 ignore
                padding_top = options.PaddingTop or options.padding_top or 0;
                padding_bottom = options.PaddingBottom or options.padding_bottom or 0;

                items = {};
            }

            local items = cfg.items; do 
                items[ "object" ] = library:create( "TextButton" , {
                    Parent = self.items.object or self.items.elements;
                    Text = "";
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 12);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items.text = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    RichText = true;
                    Parent = items.object;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 12, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 10;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });

                library:create( "UIStroke" , {
                    Parent = items.text
                });

                library:create( "UIPadding" , {
                    PaddingLeft = dim(0, 1);
                    PaddingTop = dim(0, cfg.padding_top);
                    PaddingBottom = dim(0, cfg.padding_bottom);
                    Parent = items.text
                });
            end 

            function cfg.set(text)
                items.text.Text = tostring(text or "")
            end
            function cfg:SetText(text)
                local str = (type(self) == "table") and text or self
                items.text.Text = tostring(str or "")
            end
            cfg.Set = cfg.SetText

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items[ "object" ] then
                    items[ "object" ].Visible = state
                end
            end
            cfg.set_visible = cfg.SetVisibility
            cfg.SetVisiblity = cfg.SetVisibility

            function cfg:Destroy()
                if items[ "object" ] then
                    items[ "object" ]:Destroy()
                end
            end

            return setmetatable(cfg, library)
        end 
        
        function library:Colorpicker(options) 
            local init_color = options.color or options.Color or options.default or options.Default
            if typeof(init_color) ~= "Color3" then
                if type(init_color) == "table" and (init_color.Color or init_color.color) then
                    init_color = init_color.Color or init_color.color
                else
                    init_color = color(1, 1, 1)
                end
            end
            local init_alpha = 0
            if options.alpha ~= nil then
                init_alpha = (type(options.alpha) == "number" and options.alpha <= 1) and (1 - options.alpha) or 0
            elseif options.Alpha ~= nil then
                init_alpha = (type(options.Alpha) == "number" and options.Alpha <= 1) and (1 - options.Alpha) or 0
            end

            local cfg = {
                 options
                name = options.name or options.Name or "", 
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺",
                color = init_color,
                alpha = init_alpha,
                callback = options.callback or options.Callback or function() end,

                 ignore
                open = false, 
                items = {};
            }

            local dragging_sat = false 
            local dragging_hue = false 
            local dragging_alpha = false 

            local h, s, v = cfg.color:ToHSV() 
            local a = cfg.alpha 

            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local items = cfg.items; do 
                 Component
                local parent_container = self.items.object or self.items.elements
                local holder_parent = parent_container

                if not self.items.object then
                    items[ "row" ] = library:create( "Frame" , {
                        Parent = self.items.elements;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 14);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                    });
                    library:create( "UIListLayout" , {
                        Parent = items[ "row" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal;
                        VerticalAlignment = Enum.VerticalAlignment.Center;
                    });
                    items[ "label" ] = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "row" ];
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 10;
                        BackgroundColor3 = rgb(255, 255, 255);
                    });
                    library:create( "UIStroke" , {
                        Parent = items[ "label" ]
                    });
                    holder_parent = items[ "row" ]
                end

                items[ "gear_holder" ] = library:create( "TextButton" , {
                    Parent = holder_parent;
                    AutoButtonColor = false;
                    Text = "";
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 14, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255);
                    AnchorPoint = vec2(0, 0);
                    Position = dim2(0, 0, 0, 0);
                });
                
                items[ "color_outline" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "gear_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0);
                });

                items[ "color_box" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "color_outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = cfg.color;
                });
                
                
                 Colorpicker
                    items[ "colorpicker_outline" ] = library:create( "Frame" , {
                        Parent = library.items;
                        Visible = false;
                        Size = dim2(0, 161, 0, 180);
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 100;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_outline" ];
                        Name = "\0";
                        CornerRadius = dim(0, 0)
                    });
                    
                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_outline" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(32, 32, 32)
                    });
                    
                    items[ "_" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        Name = "\0";
                        CornerRadius = dim(0, 0)
                    });
                    
                    items[ "colorpicker_background" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_inline" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(8, 8, 8)
                    });
                    
                    items[ "_" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        CornerRadius = dim(0, 0)
                    });
                    
                    items[ "_" ] = library:create( "UIPadding" , {
                        PaddingTop = dim(0, 18);
                        Name = "\0";
                        PaddingBottom = dim(0, 3);
                        Parent = items[ "colorpicker_background" ];
                        PaddingRight = dim(0, 3);
                        PaddingLeft = dim(0, 3)
                    });
                    
                    items[ "saturation_outline" ] = library:create( "TextButton" , {
                        Name = "\0";
                        AutoButtonColor = false;
                        Text = "";
                        Parent = items[ "colorpicker_background" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -12, 1, -12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "color_saturation" ] = library:create( "Frame" , {
                        Parent = items[ "saturation_outline" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });
                    
                    items[ "sat" ] = library:create( "Frame" , {
                        Parent = items[ "color_saturation" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });
                    
                    items[ "satval_picker" ] = library:create( "Frame" , {
                        Parent = items[ "color_saturation" ];
                        Size = dim2(0, 3, 0, 3);
                        Name = "\0";
                        Position = dim2(0, 1, 0.5, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 4;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "Frame" , {
                        Parent = items[ "satval_picker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "color_saturation" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });
                    
                    items[ "hue_slider" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        AutoButtonColor = false;
                        Text = "";
                        Position = dim2(1, -10, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 10, 1, -12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "hue_components" ] = library:create( "Frame" , {
                        Parent = items[ "hue_slider" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "_" ] = library:create( "UIGradient" , {
                        Rotation = 270;
                        Parent = items[ "hue_components" ];
                        Name = "\0";
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))}
                    });
                    
                    items[ "hue_picker" ] = library:create( "Frame" , {
                        Parent = items[ "hue_components" ];
                        Size = dim2(1, 2, 0, 3);
                        Name = "\0";
                        Position = dim2(0, -1, 0, -1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 4;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "Frame" , {
                        Parent = items[ "hue_picker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "alpha_slider" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        AutoButtonColor = false;
                        Text = "";
                        Position = dim2(0, 0, 1, -10);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -12, 0, 10);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "alpha_components" ] = library:create( "Frame" , {
                        Parent = items[ "alpha_slider" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "_" ] = library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Name = "\0";
                        Parent = items[ "alpha_components" ]
                    });
                    
                    items[ "alpha_picker" ] = library:create( "Frame" , {
                        Parent = items[ "alpha_components" ];
                        Size = dim2(0, 3, 1, 2);
                        Name = "\0";
                        Position = dim2(0, -1, 0, -1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 4;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "_" ] = library:create( "Frame" , {
                        Parent = items[ "alpha_picker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "visualize_outline" ] = library:create( "Frame" , {
                        AnchorPoint = vec2(1, 1);
                        Parent = items[ "colorpicker_background" ];
                        Name = "\0";
                        Position = dim2(1, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 10, 0, 10);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "visualizer" ] = library:create( "Frame" , {
                        Parent = items[ "visualize_outline" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(123, 83, 255)
                    });
                    
                    items[ "alpha_visualizer" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        ImageTransparency = 0.41999998688697815;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "visualizer" ];
                        Name = "\0";
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        
                        TileSize = dim2(0, 2, 0, 2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "title" ] = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "colorpicker_outline" ];
                        BackgroundTransparency = 1;
                        Position = dim2(0, 8, 0, 5);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 10;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIStroke" , {
                        Parent = items[ "title" ]
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingLeft = dim(0, 1);
                        Parent = items[ "title" ]
                    });                
                  
            end;

            function cfg.set_visible(bool) 
                items.colorpicker_outline.Visible = bool
                if bool then
                    local px = items.gear_holder.AbsolutePosition.X - 5
                    local py = items.gear_holder.AbsolutePosition.Y + items.gear_holder.AbsoluteSize.Y + 4
                    if camera and camera.ViewportSize then
                        if px + 165 > camera.ViewportSize.X then px = camera.ViewportSize.X - 170 end
                        if py + 185 > camera.ViewportSize.Y then py = items.gear_holder.AbsolutePosition.Y - 185 end
                    end
                    items.colorpicker_outline.Position = dim2(0, px, 0, py)
                    library.current = cfg
                end
            end

            function cfg.set(color, alpha)
                if color then
                    h, s, v = color:ToHSV()
                end
                
                if alpha then 
                    a = alpha
                end 
                
                local Color = Color3.fromHSV(h, s, v)
                
                items.hue_picker.Position = dim2(0, -1, 1 - h, -1)
                items.alpha_picker.Position = dim2(1 - a, -1, 0, -1)
                items.satval_picker.Position = dim2(s, -1, 1 - v, -1)

                items.color_saturation.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

                items.alpha_visualizer.ImageTransparency = 1 - a 
                items.visualizer.BackgroundColor3 = Color
                if items.color_box then
                    items.color_box.BackgroundColor3 = Color
                end

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a 
                }
                
                cfg.callback(Color, a)
            end

            function cfg.update_color() 
                local mouse = uis:GetMouseLocation() 
                local offset = vec2(mouse.X, mouse.Y) 

                if dragging_sat then	
                    s = math.clamp((offset - items.sat.AbsolutePosition).X / items.sat.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items.val.AbsolutePosition).Y / items.val.AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = 1 - math.clamp((offset - items.hue_slider.AbsolutePosition).Y / items.hue_slider.AbsoluteSize.Y, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items.alpha_slider.AbsolutePosition).X / items.alpha_slider.AbsoluteSize.X, 0, 1)
                end

                cfg.set(nil, nil)
            end

            items.gear_holder.MouseButton1Click:Connect(function()
                cfg.open = not cfg.open
                cfg.set_visible(cfg.open)            
            end)

            uis.InputChanged:Connect(function(input)
                if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                    cfg.update_color() 
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false  

                    if not (library:mouse_in_frame(items.gear_holder) or library:mouse_in_frame(items.colorpicker_outline)) then 
                        cfg.open = false
                        cfg.set_visible(false)
                    end
                end
            end)

            items.alpha_slider.MouseButton1Down:Connect(function()
                dragging_alpha = true 
            end)
            
            items.hue_slider.MouseButton1Down:Connect(function()
                dragging_hue = true 
            end)
            
            items.saturation_outline.MouseButton1Down:Connect(function()
                dragging_sat = true  
            end)

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items.row then
                    items.row.Visible = state
                elseif items.gear_holder then
                    items.gear_holder.Visible = state
                end
                if not state and cfg.open then
                    cfg.open = false
                    cfg.set_visible(false)
                end
            end
            cfg.SetVisiblity = cfg.SetVisibility

            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:Textbox(options) 
            local cfg = {
                name = options.name or options.Name or "TextBox",
                placeholder = options.placeholder or options.PlaceHolder or "type here...",
                default = options.default or options.Default or "",
                flag = options.flag or options.name or "please set me a flag 🥺",
                callback = options.callback or options.Callback or function() end,
                visible = options.visible or true,
                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                items[ "object" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 16);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "textbox_outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "object" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(0, 0, 0)
                });
                
                items[ "textbox_shading" ] = library:create( "Frame" , {
                    Parent = items[ "textbox_outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "textbox" ] = library:create( "TextBox" , {
                    FontFace = library.font;
                    Active = false;
                    Selectable = false;
                    PlaceholderText = cfg.placeholder;
                    TextSize = 10;
                    Size = dim2(1, 0, 1, 0);
                    TextColor3 = rgb(180, 180, 180);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = items[ "textbox_shading" ];
                    Name = "\0";
                    CursorPosition = -1;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    TextWrapped = true;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    PaddingLeft = dim(0, 7);
                    Parent = items[ "textbox" ]
                });
                
                library:create( "UIStroke" , {
                    Parent = items[ "textbox" ]
                });
                
                library:create( "UIGradient" , {
                    Rotation = 90;
                    Parent = items[ "textbox_shading" ];
                    Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "object" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                
            end 
            
            function cfg.set(text) 
                if type(text) == "boolean" then 
                    return 
                end 

                flags[cfg.flag] = text

                items[ "textbox" ].Text = text

                cfg.callback(text)
            end 
            
            items[ "textbox" ]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.set(items[ "textbox" ].Text) 
            end)

            items[ "textbox" ].Focused:Connect(function()
                library:tween(items[ "textbox" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "textbox" ].FocusLost:Connect(function()
                library:tween(items[ "textbox" ], {TextColor3 = rgb(72, 72, 72)})
            end)
                
            if cfg.default then 
                cfg.set(cfg.default) 
            end

            config_flags[cfg.flag] = cfg.set

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items[ "object" ] then
                    items[ "object" ].Visible = state
                end
            end
            cfg.set_visible = cfg.SetVisibility
            cfg.SetVisiblity = cfg.SetVisibility

            return setmetatable(cfg, library)
        end
        library.TextBox = library.Textbox
        library.textbox = library.Textbox

        function library:Keybind(options) 
            local init_key = options.key or options.Key or options.default or options.Default
            if type(init_key) == "boolean" then
                init_key = nil
            end
            if init_key == Enum.KeyCode.Unknown then
                init_key = nil
            end

            local cfg = {
                flag = options.flag or options.Flag or options.name or options.Name or "please set me a flag 🥺",
                callback = options.callback or options.Callback or function() end,
                name = options.name or options.Name or nil, 
                key = init_key, 
                mode = options.mode or options.Mode or "Toggle",
                active = false, 
                open = false,
                binding = nil, 
                hold_instances = {},
                items = {};
            }

            if cfg.mode == "Always" then
                cfg.active = true
            end

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key, 
                Key = cfg.key,
                active = cfg.active,
                Toggled = cfg.active
            }

            library.tracked_keybinds = library.tracked_keybinds or {}
            library.tracked_keybinds[cfg.flag] = cfg
            if library.update_keybind_list then
                library.update_keybind_list()
            end

            local parent_object = self.items.object or self.items.elements
            local attached = self.items.object ~= nil

            local items = cfg.items; do 
                    if not attached then
                        items[ "row" ] = library:create( "Frame" , {
                            Parent = parent_object;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            Size = dim2(1, 0, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create( "UIListLayout" , {
                            Parent = items[ "row" ];
                            Padding = dim(0, 5);
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            FillDirection = Enum.FillDirection.Horizontal;
                            VerticalAlignment = Enum.VerticalAlignment.Center;
                        });

                        if cfg.name then
                            items[ "name" ] = library:create( "TextLabel" , {
                                FontFace = library.font;
                                TextColor3 = rgb(178, 178, 178);
                                BorderColor3 = rgb(0, 0, 0);
                                Text = cfg.name;
                                Parent = items[ "row" ];
                                BackgroundTransparency = 1;
                                BorderSizePixel = 0;
                                AutomaticSize = Enum.AutomaticSize.XY;
                                TextSize = 10;
                                LayoutOrder = 0;
                                BackgroundColor3 = rgb(255, 255, 255)
                            });
                            library:create( "UIStroke" , { Parent = items[ "name" ] });
                        end
                    end

                    items.text_label = library:create( "TextButton" , {
                        FontFace = library.font;
                        AutoButtonColor = false;
                        TextColor3 = rgb(178, 178, 178);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "NONE";
                        Parent = attached and parent_object or items[ "row" ];
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 10;
                        LayoutOrder = 1;
                        BackgroundColor3 = rgb(38, 38, 38)
                    });

                    library:create( "UIStroke" , {
                        Parent = items.text_label
                    });

                    library:create( "UIPadding" , {
                        Parent = items.text_label;
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 4)
                    });

                    items[ "modes" ] = library:create( "Frame" , {
                        Parent = library.items;
                        Visible = false;
                        Size = dim2(0, 80, 0, 0);
                        Name = "\0";
                        ZIndex = 80;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "mode_shading" ] = library:create( "Frame" , {
                        Parent = items[ "modes" ];
                        Size = dim2(1, -2, 0, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "mode_shading" ];
                        Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(8, 8, 8))}
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "mode_shading" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 5);
                        PaddingTop = dim(0, 5);
                        Parent = items[ "mode_shading" ]
                    });
                    
                    for _, option in {"Hold", "Toggle", "Always"} do
                        local name = library:create( "TextButton" , {
                            FontFace = library.font;
                            AutoButtonColor = false;
                            TextColor3 = rgb(178, 178, 178);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "mode_shading" ];
                            BackgroundTransparency = 1;
                            Size = dim2(1, 0, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 10;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                        cfg.hold_instances[option] = name
                        
                        library:create( "UIStroke" , {
                            Parent = name
                        });

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 8);
                            PaddingLeft = dim(0, 8)
                        });

                        name.MouseButton1Click:Connect(function()
                            cfg.set(option)
                            cfg.show_modes(false)
                            cfg.open = false
                        end)
                    end
            end 
            
            local function key_text()
                if not cfg.key or cfg.key == "NONE" or cfg.key == Enum.KeyCode.Unknown then
                    return "NONE"
                end
                local text = keys[cfg.key] or tostring(cfg.key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
                return text
            end

            function cfg.modify_mode_color(path)
                for _,v in cfg.hold_instances do 
                    v.TextColor3 = rgb(178, 178, 178)
                end 
                if cfg.hold_instances[path] then
                    cfg.hold_instances[path].TextColor3 = rgb(255, 255, 255)
                end
            end

            function cfg.set_mode(mode) 
                cfg.mode = mode 
                if mode == "Always" then
                    cfg.active = true
                elseif mode == "Hold" then
                    cfg.active = false
                end
                cfg.modify_mode_color(mode)
            end 

            function cfg.show_modes(bool)
                items.modes.Visible = bool 
                if bool then
                    local abs = items.text_label.AbsolutePosition
                    local size = items.text_label.AbsoluteSize
                    items.modes.Position = dim_offset(abs.X + size.X + 6, abs.Y + 58)
                    library.current = cfg
                end
            end 

            function cfg.set(input)
                if type(input) == "boolean" then 
                    cfg.active = input
                    if cfg.mode == "Always" then 
                        cfg.active = true
                    end
                elseif typeof(input) == "EnumItem" then 
                    if input == Enum.KeyCode.Escape or (input.Name and input.Name == "Escape") then
                        cfg.key = nil
                    else
                        cfg.key = input
                    end
                elseif find({"Toggle", "Hold", "Always"}, input) then 
                    cfg.set_mode(input)
                elseif type(input) == "table" then 
                    local k = input.key or input.Key
                    if type(k) == "string" and k ~= "NONE" and k ~= "None" and k ~= "Unknown" then
                        k = library:convert_enum(k) or k
                    end
                    if k == Enum.KeyCode.Escape or k == "NONE" or k == Enum.KeyCode.Unknown then
                        k = nil
                    end
                    cfg.key = k
                    cfg.mode = input.mode or input.Mode or cfg.mode or "Toggle"
                    if input.active ~= nil then
                        cfg.active = input.active
                    elseif input.Toggled ~= nil then
                        cfg.active = input.Toggled
                    end
                    cfg.set_mode(cfg.mode) 
                end 

                if cfg.mode == "Always" then
                    cfg.active = true
                end

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key, 
                    Key = cfg.key,
                    active = cfg.active,
                    Toggled = cfg.active
                }

                items.text_label.Text = key_text()
                pcall(cfg.callback, cfg.active, cfg.key, cfg.mode)
                if library.update_keybind_list then
                    library.update_keybind_list()
                end
            end
            
            items.text_label.MouseButton1Click:Connect(function()
                if cfg.binding then
                    cfg.binding:Disconnect()
                    cfg.binding = nil
                end
                items.text_label.Text = "..."
                task.wait()
                cfg.binding = library:connection(uis.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        cfg.set(input.KeyCode)
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                        cfg.set(input.UserInputType)
                    end
                    if cfg.binding then
                        cfg.binding:Disconnect() 
                        cfg.binding = nil
                    end
                end)
            end)

            items.text_label.MouseButton2Click:Connect(function()
                cfg.open = not cfg.open 
                cfg.show_modes(cfg.open)
            end)

            library:connection(uis.InputBegan, function(input, game_event) 
                if game_event or cfg.binding then
                    return
                end
                if not cfg.key then
                    return
                end
                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                if selected_key == cfg.key then 
                    if cfg.mode == "Toggle" then 
                        cfg.set(not cfg.active)
                    elseif cfg.mode == "Hold" then 
                        cfg.set(true)
                    elseif cfg.mode == "Always" then
                        cfg.set(true)
                    end
                end
            end)    

            library:connection(uis.InputEnded, function(input, game_event) 
                if game_event or not cfg.key then 
                    return 
                end 
                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                if selected_key == cfg.key and cfg.mode == "Hold" then
                    cfg.set(false)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    if cfg.open and not (library:mouse_in_frame(items[ "modes" ]) or library:mouse_in_frame(items.text_label)) then 
                        cfg.open = false
                        cfg.show_modes(false)
                    end
                end
            end)
            
            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})           
            config_flags[cfg.flag] = cfg.set
            cfg.set_visible = cfg.show_modes

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items.row then
                    items.row.Visible = state
                elseif items.text_label then
                    items.text_label.Visible = state
                end
                if not state and items.modes then
                    items.modes.Visible = false
                    cfg.open = false
                end
            end
            cfg.SetVisiblity = cfg.SetVisibility

            return setmetatable(cfg, library)
        end

        function library:Button(options) 
            local cfg = {
                 options
                name = options.name or options.Name or "TextBox",
                callback = options.callback or options.Callback or function() end,

                 ignore
                items = {};
            }
            
            local items = cfg.items; do 
                items[ "button" ] = library:create( "TextButton" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 16);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button_outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "button" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(38, 38, 38);
                });
                
                items[ "button_shading" ] = library:create( "Frame" , {
                    Parent = items[ "button_outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button_gradient" ] = library:create( "UIGradient" , {
                    Rotation = 90;
                    Parent = items[ "button_shading" ];
                    Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(10, 10, 10))}
                });
                
                items[ "button_text" ] = library:create( "TextLabel" , {
                    FontFace = library.font;
                    TextColor3 = rgb(178, 178, 178);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button_shading" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 10;
                    RichText = true;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIStroke" , {
                    Parent = items[ "button_text" ]
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "button" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                             
            end 

            items[ "button" ].MouseEnter:Connect(function()
                local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]
                local accent = curTheme.Accent or rgb(255, 255, 255)
                library:tween(items[ "button_outline" ], {BackgroundColor3 = accent}, Enum.EasingStyle.Quad, 0.15)
                library:tween(items[ "button_text" ], {TextColor3 = accent}, Enum.EasingStyle.Quad, 0.15)
                if items[ "button_gradient" ] then
                    items[ "button_gradient" ].Color = rgbseq{rgbkey(0, rgb(45, 45, 45)), rgbkey(1, rgb(20, 20, 20))}
                end
            end)

            items[ "button" ].MouseLeave:Connect(function()
                library:tween(items[ "button_outline" ], {BackgroundColor3 = rgb(38, 38, 38)}, Enum.EasingStyle.Quad, 0.15)
                library:tween(items[ "button_text" ], {TextColor3 = rgb(178, 178, 178)}, Enum.EasingStyle.Quad, 0.15)
                if items[ "button_gradient" ] then
                    items[ "button_gradient" ].Color = rgbseq{rgbkey(0, rgb(33, 33, 33)), rgbkey(1, rgb(10, 10, 10))}
                end
            end)

            items[ "button" ].MouseButton1Click:Connect(function()
                local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]
                local accent = curTheme.Accent or rgb(255, 255, 255)
                items[ "button_text" ].TextColor3 = rgb(255, 255, 255) 
                items[ "button_outline" ].BackgroundColor3 = rgb(255, 255, 255)
                task.delay(0.1, function()
                    library:tween(items[ "button_outline" ], {BackgroundColor3 = accent}, Enum.EasingStyle.Quad, 0.15)
                    library:tween(items[ "button_text" ], {TextColor3 = accent}, Enum.EasingStyle.Quad, 0.15)
                end)
                cfg.callback()
            end)

            function cfg:SetVisibility(state)
                if state == nil and type(self) == "boolean" then state = self end
                cfg.visible = state
                if items[ "button" ] then
                    items[ "button" ].Visible = state
                end
            end
            cfg.set_visible = cfg.SetVisibility
            cfg.SetVisiblity = cfg.SetVisibility

            function cfg:SetText(text)
                cfg.name = tostring(text or "")
                if items[ "button_text" ] then
                    items[ "button_text" ].Text = cfg.name
                end
            end
            cfg.set = cfg.SetText
            cfg.Set = cfg.SetText

            function cfg:SetState(boolState)
                if items[ "button_text" ] then
                    items[ "button_text" ].TextColor3 = boolState and rgb(255, 255, 255) or rgb(178, 178, 178)
                end
            end

            function cfg:Destroy()
                if items[ "button" ] then
                    items[ "button" ]:Destroy()
                end
            end
            
            return setmetatable(cfg, library)
        end

        function library:PlayerCard(options)
            local cfg = {
                name = options.name or options.Name or "PlayerName",
                display_name = options.display_name or options.DisplayName or "",
                user_id = options.user_id or options.UserId or 1,
                callback = options.callback or options.Callback or function() end,
                items = {};
            }
            local items = cfg.items; do
                items[ "card" ] = library:create( "TextButton" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    AutoButtonColor = false;
                    BackgroundColor3 = rgb(12, 12, 12);
                    BorderColor3 = rgb(28, 28, 28);
                    BorderSizePixel = 1;
                    BackgroundTransparency = 0;
                    Size = dim2(1, 0, 0, 24);
                    Text = "";
                });

                items[ "avatar" ] = library:create( "ImageLabel" , {
                    Parent = items[ "card" ];
                    Size = dim2(0, 18, 0, 18);
                    Position = dim2(0, 3, 0.5, -9);
                    BackgroundColor3 = rgb(8, 8, 8);
                    BorderColor3 = rgb(35, 35, 35);
                    BorderSizePixel = 0;
                    Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(cfg.user_id) .. "&w=100&h=100";
                });

                local initialText = cfg.display_name ~= "" and cfg.display_name or cfg.name
                items[ "display_label" ] = library:create( "TextLabel" , {
                    Parent = items[ "card" ];
                    Size = dim2(1, -28, 1, 0);
                    Position = dim2(0, 25, 0, 0);
                    BackgroundTransparency = 1;
                    Text = initialText;
                    TextColor3 = rgb(215, 215, 215);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    FontFace = library.font;
                    TextSize = 10;
                    RichText = true;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                });

                items["card"].MouseButton1Click:Connect(function()
                    cfg.callback()
                    library:tween(items["card"], {BackgroundColor3 = rgb(30, 30, 30), BorderColor3 = rgb(80, 80, 80)})
                    task.delay(0.15, function()
                        library:tween(items["card"], {BackgroundColor3 = rgb(18, 18, 18), BorderColor3 = rgb(45, 45, 45)})
                    end)
                end)
                items["card"].MouseEnter:Connect(function()
                    local curTheme = library.current_theme or library.themes["BlackAndWhite"] or library.themes["Default"]
                    local accent = curTheme.Accent or rgb(255, 255, 255)
                    library:tween(items["card"], {BackgroundColor3 = rgb(24, 24, 24), BorderColor3 = accent})
                    library:tween(items["display_label"], {TextColor3 = accent})
                end)
                items["card"].MouseLeave:Connect(function()
                    library:tween(items["card"], {BackgroundColor3 = rgb(12, 12, 12), BorderColor3 = rgb(28, 28, 28)})
                    library:tween(items["display_label"], {TextColor3 = rgb(215, 215, 215)})
                end)
            end
            function cfg:SetText(text)
                if items["display_label"] then
                    items["display_label"].Text = tostring(text or cfg.name)
                end
            end
            function cfg:SetUserId(userId)
                cfg.user_id = userId
                if items["avatar"] then
                    items["avatar"].Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId or 1) .. "&w=100&h=100"
                end
            end
            cfg.set = cfg.SetText
            function cfg:Destroy()
                if items["card"] then items["card"]:Destroy() end
            end
            return setmetatable(cfg, library)
        end

        function library:list(properties) 
            local cfg = {
                items = {};
                options = properties.options or {"1", "2", "3"};
                flag = properties.flag or options.name or "please set me a flag 🥺";    
                callback = properties.callback or function() end;
                data_store = {};        
                current_element;
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end 

            function cfg.refresh_options(options_to_refresh)  ignore goofy parameter
                for _,option in cfg.data_store do 
                    option:Destroy()
                end

                for _, option_data in options_to_refresh do  haha u skids no next >_<
                    local button = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "list" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); cfg.data_store[#cfg.data_store + 1] = button;

                    local name = library:create( "TextLabel" , {
                        FontFace = library.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option_data;
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });     

                    button.MouseButton1Click:Connect(function()
                        local current = cfg.current_element 
                        if current and current ~= name then 
                            library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                        end

                        flags[cfg.flag] = option_data
                        cfg.callback(option_data)
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end)

                    name.MouseEnter:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                    end)

                    name.MouseLeave:Connect(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                    end)
                end
            end

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end 

        function library:init_config(window, existing_tab, target_section) 
            local textbox;
            local section = target_section or (existing_tab or window):Section({name = "Configs", side = "right", size = 1, default = true})
            config_holder = section:Dropdown({Name = "Configs", options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) if textbox then textbox.set(option) end end, flag = "config_name_list"}); library:update_config_list()
            textbox = section:Textbox({name = "Config name:", flag = "config_name_text"})
            section:Button({name = "Create Config", callback = function() 
                local name = flags["config_name_text"]
                if not name or name:gsub("%s+", "") == "" then 
                    library:notify("Please enter a config name!", 2)
                    return 
                end
                local path = library.directory .. "/configs/" .. name .. ".cfg"
                pcall(function()
                    if not isfolder(library.directory .. "/configs") then makefolder(library.directory .. "/configs") end
                    writefile(path, library:get_config()) 
                    library:update_config_list()
                    library:notify("Created config: " .. name, 2)
                end)
            end}) 
            section:Button({name = "Save Config", callback = function() 
                local name = flags["config_name_text"]
                if not name or name:gsub("%s+", "") == "" then 
                    library:notify("Please enter a config name!", 2)
                    return 
                end
                local path = library.directory .. "/configs/" .. name .. ".cfg"
                local ok, err = pcall(function()
                    if not isfolder(library.directory .. "/configs") then makefolder(library.directory .. "/configs") end
                    writefile(path, library:get_config()) 
                end)
                if ok then
                    library:update_config_list()
                    library:notify("Saved config: " .. name, 2)
                else
                    library:notify("Failed to save: " .. tostring(err), 3)
                end
            end}) 
            section:Button({name = "Load Config", callback = function() 
                local name = flags["config_name_text"]
                if not name or name:gsub("%s+", "") == "" then 
                    library:notify("Please enter a config name!", 2)
                    return 
                end
                local path = library.directory .. "/configs/" .. name .. ".cfg"
                local ok, data = pcall(readfile, path)
                if ok and data then
                    library:load_config(data)
                    library:notify("Loaded config: " .. name, 2)
                else
                    library:notify("Config not found: " .. name, 3)
                end
                library:update_config_list()
            end})
            section:Button({name = "Delete Config", callback = function() 
                local name = flags["config_name_text"]
                if not name or name:gsub("%s+", "") == "" then 
                    library:notify("Please enter a config name!", 2)
                    return 
                end
                local path = library.directory .. "/configs/" .. name .. ".cfg"
                local ok = pcall(delfile, path)
                library:update_config_list()
                library:notify("Deleted config: " .. name, 2)
            end})
        end
    
    
     Watermark library
        local watermark_obj = nil
        local watermark_label = nil
        local watermark_visible = true
        function library:Watermark(text)
            if not watermark_obj then
                watermark_obj = library:create("Frame", {
                    Parent = library.other;
                    Position = dim2(0, 20, 0, 20);
                    Size = dim2(0, 0, 0, 22);
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = rgb(10, 10, 10);
                    BorderColor3 = rgb(35, 35, 35);
                    BorderSizePixel = 1;
                    ClipsDescendants = false;
                    Active = true;
                    Selectable = true;
                })

                library:create("ImageLabel", {
                    Parent = watermark_obj;
                    Name = "Glow";
                    ImageColor3 = rgb(0, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    ImageTransparency = 0.65;
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 40, 1, 40);
                    Image = "rbxassetid://18245826428";
                    BackgroundTransparency = 1;
                    Position = dim2(0, -20, 0, -20);
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(21, 21), vec2(79, 79));
                    ZIndex = 0;
                })

                library:create("UIPadding", {
                    Parent = watermark_obj;
                    PaddingLeft = dim(0, 9);
                    PaddingRight = dim(0, 9);
                    PaddingTop = dim(0, 2);
                    PaddingBottom = dim(0, 2);
                })

                watermark_label = library:create("TextLabel", {
                    Parent = watermark_obj;
                    Name = "WatermarkText";
                    Size = dim2(0, 0, 1, 0);
                    AutomaticSize = Enum.AutomaticSize.X;
                    Text = text or "";
                    TextColor3 = rgb(240, 240, 240);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = library.font;
                    TextSize = 11;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    ZIndex = 4;
                })

                 Draggable Watermark
                local dragging = false
                local drag_start = nil
                local start_pos = nil

                watermark_obj.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        drag_start = input.Position
                        start_pos = watermark_obj.Position
                    end
                end)

                watermark_obj.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                library:connection(uis.InputChanged, function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local delta = input.Position - drag_start
                        local targetPos = UDim2.new(
                            start_pos.X.Scale,
                            start_pos.X.Offset + delta.X,
                            start_pos.Y.Scale,
                            start_pos.Y.Offset + delta.Y
                        )
                        tween_service:Create(watermark_obj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                    end
                end)
            else
                if watermark_label then
                    watermark_label.Text = text or ""
                end
            end

            watermark_obj.Visible = (watermark_visible == true)

            return {
                Object = watermark_obj,
                TextLabel = watermark_label,
                SetText = function(self, t)
                    if watermark_label then
                        watermark_label.Text = t or ""
                    end
                end,
                SetVisibility = function(self, v)
                    watermark_visible = (v == true)
                    if watermark_obj then
                        watermark_obj.Visible = watermark_visible
                    end
                end
            }
        end
    

     Keybind list library
        local keybind_list_obj = nil
        local keybind_list_visible = false

        function library:KeybindList()
            if keybind_list_obj then
                return keybind_list_obj
            end

            local kl_frame = library:create("Frame", {
                Parent = library.other;
                Name = "KeybindList";
                Position = dim2(0, 20, 0, 260);
                Size = dim2(0, 175, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundColor3 = rgb(10, 10, 10);
                BorderColor3 = rgb(35, 35, 35);
                BorderSizePixel = 1;
                ClipsDescendants = false;
                Visible = false;
                ZIndex = 50;
            })

            library:create("ImageLabel", {
                Parent = kl_frame;
                Name = "Glow";
                ImageColor3 = rgb(0, 0, 0);
                ScaleType = Enum.ScaleType.Slice;
                ImageTransparency = 0.65;
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(1, 40, 1, 40);
                Image = "rbxassetid://18245826428";
                BackgroundTransparency = 1;
                Position = dim2(0, -20, 0, -20);
                BorderSizePixel = 0;
                SliceCenter = rect(vec2(21, 21), vec2(79, 79));
                ZIndex = 49;
            })

            local kl_header = library:create("Frame", {
                Parent = kl_frame;
                Name = "Header";
                Size = dim2(1, 0, 0, 22);
                BackgroundColor3 = rgb(14, 14, 14);
                BorderSizePixel = 0;
                ZIndex = 51;
            })

            local kl_bot_divider = library:create("Frame", {
                Parent = kl_header;
                Name = "BottomDivider";
                Size = dim2(1, 0, 0, 1);
                Position = dim2(0, 0, 1, -1);
                BackgroundColor3 = rgb(255, 255, 255);
                BorderSizePixel = 0;
                ZIndex = 52;
            })

            local kl_title = library:create("TextLabel", {
                Parent = kl_header;
                Name = "Title";
                Text = "keybinds";
                FontFace = library.font;
                TextSize = 11;
                TextColor3 = rgb(255, 255, 255);
                Position = dim2(0, 8, 0.5, 0);
                AnchorPoint = vec2(0, 0.5);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 53;
            })

            local kl_content = library:create("Frame", {
                Parent = kl_frame;
                Name = "Content";
                Position = dim2(0, 0, 0, 22);
                Size = dim2(1, 0, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                ZIndex = 51;
            })

            library:create("UIListLayout", {
                Parent = kl_content;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Padding = dim(0, 2);
            })

            library:create("UIPadding", {
                Parent = kl_content;
                PaddingTop = dim(0, 5);
                PaddingBottom = dim(0, 5);
                PaddingLeft = dim(0, 8);
                PaddingRight = dim(0, 8);
            })

             Dragging
            local kl_dragging = false
            local kl_drag_start = nil
            local kl_start_pos = nil

            kl_header.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    kl_dragging = true
                    kl_drag_start = input.Position
                    kl_start_pos = kl_frame.Position
                end
            end)

            uis.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    kl_dragging = false
                end
            end)

            library:connection(uis.InputChanged, function(input)
                if kl_dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - kl_drag_start
                    local targetPos = UDim2.new(
                        kl_start_pos.X.Scale,
                        kl_start_pos.X.Offset + delta.X,
                        kl_start_pos.Y.Scale,
                        kl_start_pos.Y.Offset + delta.Y
                    )
                    tween_service:Create(kl_frame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                end
            end)

            local function update_list()
                if not kl_frame or not kl_frame.Parent then return end
                for _, child in ipairs(kl_content:GetChildren()) do
                    if child:IsA("Frame") and child.Name == "BindRow" then
                        child:Destroy()
                    end
                end

                if not library.tracked_keybinds then return end
                local count = 0
                for flag, cfg in pairs(library.tracked_keybinds) do
                    if cfg.key and cfg.key ~= "NONE" and cfg.key ~= Enum.KeyCode.Unknown then
                        count = count + 1
                        local key_name = tostring(cfg.key)
                        if typeof(cfg.key) == "EnumItem" then
                            key_name = cfg.key.Name
                        end
                        local mode_str = tostring(cfg.mode or "Toggle")
                        local active_str = cfg.active and "[toggled]" or "[off]"
                        if mode_str == "Hold" then
                            active_str = cfg.active and "[holding]" or "[hold]"
                        elseif mode_str == "Always" then
                            active_str = "[always]"
                        end

                        local row = library:create("Frame", {
                            Parent = kl_content;
                            Name = "BindRow";
                            Size = dim2(1, 0, 0, 14);
                            BackgroundTransparency = 1;
                            BorderSizePixel = 0;
                            ZIndex = 52;
                            LayoutOrder = count;
                        })

                        local name_lbl = library:create("TextLabel", {
                            Parent = row;
                            Name = "Name";
                            Text = tostring(cfg.name or cfg.flag or "Keybind");
                            FontFace = library.font;
                            TextSize = 10;
                            TextColor3 = cfg.active and rgb(255, 255, 255) or rgb(140, 140, 140);
                            Position = dim2(0, 0, 0, 0);
                            Size = dim2(0.58, 0, 1, 0);
                            BackgroundTransparency = 1;
                            BorderSizePixel = 0;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            TextTruncate = Enum.TextTruncate.AtEnd;
                            ZIndex = 53;
                        })

                        local state_lbl = library:create("TextLabel", {
                            Parent = row;
                            Name = "State";
                            Text = "[" .. key_name .. "] " .. active_str;
                            FontFace = library.font;
                            TextSize = 10;
                            TextColor3 = cfg.active and rgb(255, 255, 255) or rgb(110, 110, 110);
                            Position = dim2(1, 0, 0, 0);
                            AnchorPoint = vec2(1, 0);
                            Size = dim2(0.42, 0, 1, 0);
                            BackgroundTransparency = 1;
                            BorderSizePixel = 0;
                            TextXAlignment = Enum.TextXAlignment.Right;
                            ZIndex = 53;
                        })
                    end
                end
            end

            library.update_keybind_list = update_list
            update_list()

            keybind_list_obj = {
                Frame = kl_frame,
                Update = update_list,
                SetVisibility = function(self, v)
                    keybind_list_visible = (v == true)
                    if kl_frame then
                        kl_frame.Visible = keybind_list_visible
                        if keybind_list_visible then
                            update_list()
                        end
                    end
                end
            }

            kl_frame.Visible = (keybind_list_visible == true)
            return keybind_list_obj
        end

        library.cleanup_keybind_list = function()
            if keybind_list_obj and keybind_list_obj.Frame then
                pcall(function() keybind_list_obj.Frame:Destroy() end)
                keybind_list_obj = nil
            end
        end

         Custom Cursor
        local cursor_enabled = true
        local cursor_frame = nil
        local cursor_connection = nil

        function library:SetCustomCursor(enabled)
            cursor_enabled = (enabled == true)

            if cursor_enabled then
                if not cursor_frame or not cursor_frame.Parent then
                    local initPos = uis:GetMouseLocation()
                    cursor_frame = library:create("Frame", {
                        Parent = library.other;
                        Name = "CustomCursor";
                        Size = dim2(0, 0, 0, 0);
                        Position = dim2(0, initPos.X, 0, initPos.Y);
                        AnchorPoint = vec2(0, 0);
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        ZIndex = 100000;
                        Visible = true;
                    })

                    local gap = 3
                    local len = 5
                    local thick = 1

                     4 sides: Top, Bottom, Left, Right
                     Top arm
                    library:create("Frame", {
                        Parent = cursor_frame;
                        Name = "Top";
                        Position = dim2(0, 0, 0, -gap - len);
                        Size = dim2(0, thick, 0, len);
                        BackgroundColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 1;
                        ZIndex = 100001;
                    })

                     Bottom arm
                    library:create("Frame", {
                        Parent = cursor_frame;
                        Name = "Bottom";
                        Position = dim2(0, 0, 0, gap + 1);
                        Size = dim2(0, thick, 0, len);
                        BackgroundColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 1;
                        ZIndex = 100001;
                    })

                     Left arm
                    library:create("Frame", {
                        Parent = cursor_frame;
                        Name = "Left";
                        Position = dim2(0, -gap - len, 0, 0);
                        Size = dim2(0, len, 0, thick);
                        BackgroundColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 1;
                        ZIndex = 100001;
                    })

                     Right arm
                    library:create("Frame", {
                        Parent = cursor_frame;
                        Name = "Right";
                        Position = dim2(0, gap + 1, 0, 0);
                        Size = dim2(0, len, 0, thick);
                        BackgroundColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 1;
                        ZIndex = 100001;
                    })

                    if not cursor_connection then
                        cursor_connection = run.RenderStepped:Connect(function()
                            if cursor_enabled and cursor_frame then
                                local mouseLoc = uis:GetMouseLocation()
                                cursor_frame.Position = dim2(0, mouseLoc.X, 0, mouseLoc.Y)
                                uis.MouseIconEnabled = false
                            end
                        end)
                    end
                end

                local curLoc = uis:GetMouseLocation()
                cursor_frame.Position = dim2(0, curLoc.X, 0, curLoc.Y)
                cursor_frame.Visible = true
                uis.MouseIconEnabled = false
            else
                if cursor_frame then
                    cursor_frame.Visible = false
                end
                uis.MouseIconEnabled = true
            end
        end

        library.cleanup_cursor = function()
            if cursor_connection then
                cursor_connection:Disconnect()
                cursor_connection = nil
            end
            if cursor_frame then
                pcall(function() cursor_frame:Destroy() end)
                cursor_frame = nil
            end
            uis.MouseIconEnabled = true
        end

        task.spawn(function()
            task.wait(0.1)
            pcall(function() library:SetCustomCursor(true) end)
        end)
    

     Notification library
		local notifications = library.notifications

		function notifications:refresh_notifs() 
			local yOffset = 50
			for i, v in notifications.notifs do
				local Position = vec2(20, yOffset)
				tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = dim_offset(Position.X, Position.Y)}):Play()
				yOffset = yOffset + v.AbsoluteSize.Y + 10
			end
		end
		
		function notifications:fade(path, is_fading)
			local fading = is_fading and 1 or 0 
			
			tween_service:Create(path, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = fading}):Play()

			for _, instance in path:GetDescendants() do 
				if instance:IsA("UIStroke") then
					tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = fading}):Play()
				elseif instance:IsA("TextLabel") then
					tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = fading}):Play()
				elseif instance:IsA("Frame") then
					tween_service:Create(instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = fading}):Play()
				end
			end
		end 

		function notifications:create_notification(options)
			local cfg = {
				name = options.name or options.content or "Notification";
				color = options.color or rgb(255, 255, 255);
				clickable = options.click or false;
                duration = options.duration or 3;
			}
			
			local outline = library:create("Frame", {
				Parent = library.items or library.other;
				Size = dim2(0, 0, 0, 0);
				BorderColor3 = rgb(35, 35, 35);
				BorderSizePixel = 1;
				AutomaticSize = Enum.AutomaticSize.XY;
				BackgroundColor3 = rgb(10, 10, 10);
				ClipsDescendants = false;
			});

			library:create("ImageLabel", {
				Parent = outline;
				Name = "Glow";
				ImageColor3 = rgb(0, 0, 0);
				ScaleType = Enum.ScaleType.Slice;
				ImageTransparency = 0.65;
				BorderColor3 = rgb(0, 0, 0);
				Size = dim2(1, 40, 1, 40);
				Image = "rbxassetid://18245826428";
				BackgroundTransparency = 1;
				Position = dim2(0, -20, 0, -20);
				BorderSizePixel = 0;
				SliceCenter = rect(vec2(21, 21), vec2(79, 79));
				ZIndex = 0;
			});

			local top_line = library:create("Frame", {
				Parent = outline;
				Name = "TopLine";
				Position = dim2(0, 0, 0, 0);
				Size = dim2(1, 0, 0, 1);
				BackgroundColor3 = rgb(255, 255, 255);
				BorderSizePixel = 0;
				ZIndex = 4;
			});

			local left_bar = library:create("Frame", {
				Parent = outline;
				Name = "LeftBar";
				Position = dim2(0, 0, 0, 0);
				Size = dim2(0, 2, 1, 0);
				BackgroundColor3 = cfg.color or rgb(255, 255, 255);
				BorderSizePixel = 0;
				ZIndex = 4;
			});

			local content_padding = library:create("UIPadding", {
				Parent = outline;
				PaddingTop = dim(0, 7);
				PaddingBottom = dim(0, 8);
				PaddingLeft = dim(0, 11);
				PaddingRight = dim(0, 13);
			});

			local misc_text = library:create("TextLabel", {
				FontFace = library.font;
				Parent = outline;
				TextColor3 = rgb(240, 240, 240);
				BorderColor3 = rgb(0, 0, 0);
				Text = cfg.name;
				AutomaticSize = Enum.AutomaticSize.XY;
				BackgroundTransparency = 1;
				TextXAlignment = Enum.TextXAlignment.Left;
				BorderSizePixel = 0;
				ZIndex = 2;
				TextSize = 11;
			});

			local line = library:create("Frame", {
				Parent = outline;
				Name = "TimerLine";
				Position = dim2(0, 0, 1, -1);
				BorderColor3 = rgb(0, 0, 0);
				Size = dim2(1, 0, 0, 1);
				BorderSizePixel = 0;
				BackgroundColor3 = rgb(255, 255, 255);
				ZIndex = 5;
			});
			
			local index = #notifications.notifs + 1
			notifications.notifs[index] = outline
			
			notifications:refresh_notifs()
			outline.Position = dim2(0, 20, 0, 50);

			if cfg.clickable then 
				outline.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        notifications.notifs[index] = nil
                        outline:Destroy() 
                        notifications:refresh_notifs()
                    end
				end)
			else 
				task.spawn(function()
					tween_service:Create(line, TweenInfo.new(cfg.duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = dim2(0, 0, 0, 1)}):Play()
					task.wait(cfg.duration)
					notifications.notifs[index] = nil
                    notifications:fade(outline, true)
					task.wait(0.6)
					outline:Destroy() 
					notifications:refresh_notifs()
				end)
			end
		end
        notifications.notify = notifications.create_notification
        function library:Notify(text, duration)
            notifications:create_notification({name = tostring(text or ""), duration = duration or 3})
        end
        library.Unload = library.unload_menu
        library.unload = library.unload_menu
        library.unloadMenu = library.unload_menu

return library, notifications
