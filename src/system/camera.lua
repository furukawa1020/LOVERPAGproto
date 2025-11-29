local Camera = {}

Camera.x = 0
Camera.y = 0
Camera.scale = 1

function Camera.set(x, y)
    Camera.x = x
    Camera.y = y
end

function Camera.move(dx, dy)
    Camera.x = Camera.x + dx
    Camera.y = Camera.y + dy
end

function Camera.attach()
    love.graphics.push()
    love.graphics.translate(-Camera.x, -Camera.y)
end

function Camera.detach()
    love.graphics.pop()
end

function Camera.follow(x, y)
    -- Center the camera on the target (x, y)
    -- Screen width/height are logical (320x180)
    Camera.x = x - RPG.WIDTH / 2
    Camera.y = y - RPG.HEIGHT / 2
    
    -- Clamp camera to map bounds if needed (TODO)
end

return Camera
