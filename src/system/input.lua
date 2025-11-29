local Input = {}

Input.keys = {}
Input.keysPressed = {}

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
end

function Input.isDown(key)
    return love.keyboard.isDown(key)
end

function Input.wasPressed(key)
    return Input.keysPressed[key]
end

return Input
