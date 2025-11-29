local NPC = {}

function NPC.new(x, y, dialog)
    local self = {}
    self.x = x * RPG.TILE_SIZE
    self.y = y * RPG.TILE_SIZE
    self.width = 64
    self.height = 64
    self.tileX = x
    self.tileY = y
    self.dialog = dialog or {"..."}
    self.color = {1, 0, 0} -- Red NPC
    
    return self
end

function NPC.draw(self)
    local Assets = require("src.system.assets")
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Assets.textures.npc, self.x, self.y)
end

return NPC
