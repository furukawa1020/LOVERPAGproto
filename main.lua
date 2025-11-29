-- Love OS Main Entry Point

-- Constants
RPG = {} -- Keep global namespace for compatibility if needed later
RPG.WIDTH = 1280
RPG.HEIGHT = 720

local Terminal = require("src.system.terminal")
local Shader = require("src.system.shader")
local MapState = require("src.state.map") -- Require MapState

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Setup Font (Retro Monospace if possible, default for now)
    love.graphics.setFont(love.graphics.newFont(16))
    
    Terminal.init()
    
    -- Initialize Assets and MapState (but don't enter it fully yet, just for data)
    local Assets = require("src.system.assets")
    Assets.generate()
    MapState.enter() -- Initialize map data
    
    -- Canvas for CRT effect
    RPG.canvas = love.graphics.newCanvas(RPG.WIDTH, RPG.HEIGHT)
    RPG.shader = Shader.crt
    RPG.shader:send("screen_size", {RPG.WIDTH, RPG.HEIGHT})
end

function love.update(dt)
    Terminal.update(dt)
    
    -- Update Map/Player only if player is ready
    if Terminal.state == "player_ready" then
        MapState.update(dt)
    end
end

function love.draw()
    -- Draw to Canvas
    love.graphics.setCanvas(RPG.canvas)
    love.graphics.clear(0, 0.05, 0, 1) -- Very dark green background
    
    -- Draw World (Behind Terminal)
    if Terminal.state == "compiling_world" or Terminal.state == "world_ready" or Terminal.state == "player_ready" then
        -- Calculate limit based on progress
        local totalTiles = 20 * 12 -- Approx map size (screen size / tile size)
        -- Actually MapData.width * MapData.height is better but let's just use a large number or 1.0
        
        local limit = nil
        if Terminal.state == "compiling_world" then
            limit = math.floor(Terminal.compileProgress * 400) -- 400 tiles approx
        end
        
        love.graphics.setColor(1, 1, 1, 0.5) -- Dim the world initially
        if Terminal.state == "player_ready" then love.graphics.setColor(1, 1, 1, 1) end
        
        MapState.draw(limit)
    end
    
    -- Draw Terminal
    -- If player is ready, maybe hide terminal or make it toggleable?
    -- For now, keep it overlayed but maybe cleaner.
    if Terminal.state ~= "player_ready" then
        Terminal.draw()
    else
        -- Minimal terminal or toggle
        -- Let's just draw it for now, user can clear it.
        Terminal.draw()
    end
    
    love.graphics.setCanvas()
    
    -- Apply CRT Shader
    love.graphics.setColor(1, 1, 1)
    love.graphics.setShader(RPG.shader)
    love.graphics.draw(RPG.canvas, 0, 0)
    love.graphics.setShader()
end

function love.textinput(t)
    Terminal.textinput(t)
    local Audio = require("src.system.audio")
    Audio.playSynth("key")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    Terminal.keypressed(key)
    local Audio = require("src.system.audio")
    Audio.playSynth("key")
end
