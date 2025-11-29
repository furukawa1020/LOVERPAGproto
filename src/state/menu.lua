local MenuState = {}
local Input = require("src.system.input")

local options = {"Items", "Status", "Save", "Quit"}
local selection = 1

function MenuState.enter()
    print("Entered Menu State")
    selection = 1
end

function MenuState.update(dt)
    if Input.wasPressed("up") then
        selection = selection - 1
        if selection < 1 then selection = #options end
    elseif Input.wasPressed("down") then
        selection = selection + 1
        if selection > #options then selection = 1 end
    elseif Input.wasPressed("return") then
        if options[selection] == "Quit" then
            love.event.quit()
        elseif options[selection] == "Status" then
            -- Show status (placeholder)
        else
            -- Placeholder for other options
            RPG.switchState("map")
        end
    elseif Input.wasPressed("escape") then
        RPG.switchState("map")
    end
end

function MenuState.draw()
    -- Draw semi-transparent background
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, RPG.WIDTH, RPG.HEIGHT)
    
    -- Draw Menu Window
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 10, 10, 100, 100)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 10, 10, 100, 100)
    
    -- Draw Options
    for i, option in ipairs(options) do
        if i == selection then
            love.graphics.print("> " .. option, 20, 20 + (i-1)*15)
        else
            love.graphics.print("  " .. option, 20, 20 + (i-1)*15)
        end
    end
end

function MenuState.exit()
    print("Exited Menu State")
end

return MenuState
