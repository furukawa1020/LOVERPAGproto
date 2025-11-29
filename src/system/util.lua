-- Utility functions
local Util = {}

function Util.printTable(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end

return Util
