local MapState = {}
local Input = require("src.system.input")
local Camera = require("src.system.camera")
local MapData = require("src.map.map1")
local Player = require("src.entity.player")
local NPC = require("src.entity.npc")

local npcs = {}
local showDialog = false
local currentDialog = {}
local dialogIndex = 1
local dialogTimer = 0
local lightCanvas = nil

function MapState.enter(params)
    print("Entered Map State")
    if not params or not params.fromBattle then
        Player.init(2, 2)
        Camera.set(0, 0)
    end
    
    local Audio = require("src.system.audio")
    Audio.playBGM("field")
    Audio.setReverb(true)
    
    -- Initialize NPCs
    npcs = {}
    table.insert(npcs, NPC.new(5, 5, {"Welcome to the Floating Isle.", "The void surrounds us all."}))
    table.insert(npcs, NPC.new(10, 8, {"Have you seen the Slimes?", "They are weak to Fire."}))
    table.insert(npcs, NPC.new(15, 12, {"The Demon Lord waits ahead.", "Prepare yourself."}))
    table.insert(npcs, NPC.new(8, 15, {"This world is built of pixels.", "64 by 64, to be exact."}))
end

local Bug = require("src.entity.bug")
local bugs = {}

function MapState.spawnEnemies()
    for i = 1, 5 do
        local x = math.random(2, MapData.width - 2)
        local y = math.random(2, MapData.height - 2)
        table.insert(bugs, Bug.new(x, y))
    end
end

function MapState.update(dt)
    if showDialog then
        if Input.wasPressed("return") then
            dialogIndex = dialogIndex + 1
            if dialogIndex > #currentDialog then
                showDialog = false
                dialogIndex = 1
            end
        end
    else
        Player.update(dt, MapData)
        Camera.follow(Player.x + Player.width/2, Player.y + Player.height/2)
        
        -- Update Bugs
        for _, bug in ipairs(bugs) do
            Bug.update(bug, dt, Player)
            -- Simple collision check for attack (Space key)
            if Input.isDown("space") then
                 local dx = Player.x - bug.x
                 local dy = Player.y - bug.y
                 if math.sqrt(dx*dx + dy*dy) < 64 then
                     bug.isDead = true
                 end
            end
        end
        
        if Input.wasPressed("return") then
            -- Check for NPC interaction
            for _, npc in ipairs(npcs) do
                local dx = math.abs(Player.tileX - npc.tileX)
                local dy = math.abs(Player.tileY - npc.tileY)
                if dx + dy == 1 then
                    currentDialog = npc.dialog
                    showDialog = true
                    dialogIndex = 1
                    break
                end
            end
            
            if not showDialog then
                 -- RPG.switchState("menu") -- Disabled for now
            end
        end
    end
end

function MapState.draw(limit)
    Camera.attach()
    
    -- Draw Map
    local Assets = require("src.system.assets")
    local drawnCount = 0
    for y = 0, MapData.height - 1 do
        for x = 0, MapData.width - 1 do
            if limit and drawnCount >= limit then break end
            
            local index = y * MapData.width + x + 1
            local tile = MapData.layers[1][index]
            
            if tile == 1 then
                love.graphics.draw(Assets.textures.wall, x * MapData.tilewidth, y * MapData.tileheight)
            else
                love.graphics.draw(Assets.textures.grass, x * MapData.tilewidth, y * MapData.tileheight)
            end
            drawnCount = drawnCount + 1
        end
        if limit and drawnCount >= limit then break end
    end
    
    -- Draw NPCs
    for _, npc in ipairs(npcs) do
        NPC.draw(npc)
    end
    
    -- Draw Bugs
    for _, bug in ipairs(bugs) do
        Bug.draw(bug)
    end
    
    -- Draw Player
    Player.draw()
    
    -- Lighting Effect
    if not lightCanvas then
        lightCanvas = love.graphics.newCanvas(RPG.WIDTH, RPG.HEIGHT)
    end
    
    Camera.detach()
    
    -- Draw Lighting to Canvas
    love.graphics.setCanvas(lightCanvas)
    love.graphics.clear(0, 0, 0, 0.95) -- Darkness
    
    love.graphics.setBlendMode("replace")
    love.graphics.setColor(0, 0, 0, 0) -- Transparent
    
    -- Calculate Player Screen Position
    local px = Player.x - Camera.x + Player.width/2
    local py = Player.y - Camera.y + Player.height/2
    
    local lightRadius = 200 + math.sin(love.timer.getTime() * 2) * 10 -- Pulsing light
    love.graphics.circle("fill", px, py, lightRadius)
    
    love.graphics.setBlendMode("alpha")
    love.graphics.setCanvas(RPG.canvas) -- Return to main canvas
    
    -- Draw Light Overlay
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(lightCanvas, 0, 0)
    
    -- Draw UI (Dialog)
    if showDialog then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 50, RPG.HEIGHT - 200, RPG.WIDTH - 100, 150)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", 50, RPG.HEIGHT - 200, RPG.WIDTH - 100, 150)
        
        love.graphics.print(currentDialog[dialogIndex], 100, RPG.HEIGHT - 150, 0, 2, 2)
    end
end

function MapState.exit()
    print("Exited Map State")
end

return MapState
