local MapState = {}
local Input = require("src.system.input")
local Camera = require("src.system.camera")
local MapData = require("src.map.map1")
local Player = require("src.entity.player")

function MapState.enter()
    print("Entered Map State")
    Player.init(2, 2)
    Camera.set(0, 0)
end

function MapState.update(dt)
    Player.update(dt, MapData)
    Camera.follow(Player.x + Player.width/2, Player.y + Player.height/2)
    
    if Input.wasPressed("return") then
        RPG.switchState("menu")
    end
end

function MapState.draw()
    Camera.attach()
    
    -- Draw Map
    for y = 0, MapData.height - 1 do
        for x = 0, MapData.width - 1 do
            local index = y * MapData.width + x + 1
            local tile = MapData.layers[1][index]
            
            if tile == 1 then
                love.graphics.setColor(0.5, 0.5, 0.5) -- Wall (Gray)
            else
                love.graphics.setColor(0.2, 0.2, 0.2) -- Floor (Dark Gray)
            end
            
            love.graphics.rectangle("fill", x * MapData.tilewidth, y * MapData.tileheight, MapData.tilewidth, MapData.tileheight)
        end
    end
    
    -- Draw Player
    Player.draw()
    
    Camera.detach()
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Map State", 10, 10)
end

function MapState.exit()
    print("Exited Map State")
end

return MapState
