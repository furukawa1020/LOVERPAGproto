local BattleState = {}
local Input = require("src.system.input")

local playerStats = {hp = 100, maxHp = 100, mp = 20, maxMp = 20, atk = 10, def = 5}
local enemyStats = {hp = 50, maxHp = 50, atk = 8, def = 3, name = "Slime"}

local turn = "PLAYER" -- PLAYER, ENEMY, WIN, LOSE
local battleMenu = {"Attack", "Skill", "Item", "Run"}
local selection = 1
local message = "Battle Start!"
local timer = 0

function BattleState.enter()
    print("Entered Battle State")
    playerStats.hp = 100
    enemyStats.hp = 50
    turn = "PLAYER"
    selection = 1
    message = "Encountered " .. enemyStats.name .. "!"
        love.graphics.rectangle("line", RPG.WIDTH - 300, RPG.HEIGHT - 300, 250, 250)
        for i, option in ipairs(battleMenu) do
            if i == selection then
                love.graphics.print("> " .. option, RPG.WIDTH - 280, RPG.HEIGHT - 280 + (i-1)*50, 0, fontScale, fontScale)
            else
                love.graphics.print("  " .. option, RPG.WIDTH - 280, RPG.HEIGHT - 280 + (i-1)*50, 0, fontScale, fontScale)
            end
        end
    elseif turn == "WIN" then
        love.graphics.print("YOU WON! Press Enter.", RPG.WIDTH/2 - 150, RPG.HEIGHT/2 + 100, 0, fontScale, fontScale)
    elseif turn == "LOSE" then
        love.graphics.print("YOU LOST... Press Enter.", RPG.WIDTH/2 - 150, RPG.HEIGHT/2 + 100, 0, fontScale, fontScale)
    end
end

function BattleState.exit()
    print("Exited Battle State")
end

return BattleState
