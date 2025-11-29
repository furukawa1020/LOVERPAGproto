local Console = {}

Console.isOpen = false
Console.history = {
    "Welcome to Love2D Shell v1.0",
    "Type 'help' for commands."
}
Console.currentLine = ""
Console.cursorTimer = 0

function Console.toggle()
    Console.isOpen = not Console.isOpen
    -- Clear input when closing? No, keep it.
end

function Console.log(text)
    table.insert(Console.history, text)
    if #Console.history > 20 then
        table.remove(Console.history, 1)
    end
end

function Console.execute(cmd)
    Console.log("> " .. cmd)
    
    local parts = {}
    for part in string.gmatch(cmd, "%S+") do
        table.insert(parts, part)
    end
    
    if #parts == 0 then return end
    
    local command = parts[1]
    
    if command == "help" then
        Console.log("Available commands:")
        Console.log("  install love  - Install the Love package")
        Console.log("  man love      - Read manual for Love")
        Console.log("  clear         - Clear console")
        Console.log("  exit          - Close console")
    elseif command == "clear" then
        Console.history = {}
    elseif command == "exit" then
        Console.isOpen = false
    elseif command == "man" then
        if parts[2] == "love" then
            Console.log("NAME")
            Console.log("    love - the framework you are playing with")
            Console.log("DESCRIPTION")
            Console.log("    Make love, not war.")
        else
            Console.log("No manual entry for " .. (parts[2] or ""))
        end
    elseif command == "apt-get" or command == "apt" then
        if parts[2] == "install" and parts[3] == "love" then
            Console.log("Reading package lists... Done")
            Console.log("Building dependency tree... Done")
            Console.log("The following NEW packages will be installed:")
            Console.log("  love")
            Console.log("0 upgraded, 1 newly installed, 0 to remove.")
            Console.log("Setting up love (11.4)...")
            Console.log("Love installed successfully!")
            
            -- Trigger Love Effect
            if RPG.loveParticles then
                RPG.loveParticles:setPosition(RPG.WIDTH/2, RPG.HEIGHT/2)
                RPG.loveParticles:emit(100)
                local Audio = require("src.system.audio")
                Audio.playSFX("select") -- Or a special sound
            end
        else
            Console.log("Usage: apt-get install <package>")
        end
    elseif command == "install" and parts[2] == "love" then
         -- Alias for just "install love"
         Console.execute("apt-get install love")
    else
        Console.log("Command not found: " .. command)
    end
end

function Console.textinput(t)
    Console.currentLine = Console.currentLine .. t
end

function Console.keypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(Console.currentLine, -1)
        if byteoffset then
            Console.currentLine = string.sub(Console.currentLine, 1, byteoffset - 1)
        end
    elseif key == "return" then
        Console.execute(Console.currentLine)
        Console.currentLine = ""
    end
end

function Console.draw()
    if not Console.isOpen then return end
    
    local h = RPG.HEIGHT / 2
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, RPG.WIDTH, h)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 0, h, RPG.WIDTH, 1) -- Separator
    
    local fontHeight = 14 -- Assuming default font size roughly
    local y = h - fontHeight - 10
    
    -- Draw Input Line
    local cursor = "|"
    if math.floor(love.timer.getTime() * 2) % 2 == 0 then cursor = " " end
    love.graphics.print("> " .. Console.currentLine .. cursor, 10, y)
    
    -- Draw History
    for i = #Console.history, 1, -1 do
        y = y - fontHeight - 4
        if y < 0 then break end
        love.graphics.print(Console.history[i], 10, y)
    end
end

return Console
