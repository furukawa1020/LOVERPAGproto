local Input = {}

Input.keys = {}
Input.keysPressed = {}
Input.keyHistory = ""

function Input.init()
    -- Initialize input mappings if needed
end

function Input.update()
    -- Reset single-frame input states
    Input.keysPressed = {}
end

function Input.keypressed(key)
    if key == "up" or key == "down" or key == "left" or key == "right" or key == "return" or key == "escape" or key == "tab" then
        Input.keysPressed[key] = true
    end
    
    -- Cheat Code Detection
    if #key == 1 then -- Only record single characters
        Input.keyHistory = Input.keyHistory .. key
        if #Input.keyHistory > 10 then
            Input.keyHistory = string.sub(Input.keyHistory, -10)
        end
        
        if string.sub(Input.keyHistory, -4) == "love" then
            Input.keysPressed["cheat_love"] = true
            Input.keyHistory = "" -- Reset to prevent double trigger
        end
    end
end

function Input.isDown(key)
    return love.keyboard.isDown(key)
end

function Input.wasPressed(key)
    return Input.keysPressed[key]
end

return Input
