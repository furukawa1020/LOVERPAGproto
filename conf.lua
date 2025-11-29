function love.conf(t)
    t.window.title = "Love2D RPG Engine"
    t.window.width = 1280
    t.window.height = 720
    t.window.resizable = false
    t.window.vsync = 1
    t.modules.joystick = false
    t.modules.physics = false
    t.console = true -- Enable console for debugging

    -- Pixel art filtering
    t.window.minwidth = 320
    t.window.minheight = 180
end
