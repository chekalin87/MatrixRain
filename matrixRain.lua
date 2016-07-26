local component = require("component")
local gpu = component.gpu
local unicode = require("unicode")
--local thread = require("thread")
local w, h = gpu.getResolution()

local char = {12040, 12065, 12090, 12103, 12144, 12043, 12047, 7112, 48, 81, 56} 
local length = #char

local function drop(x)
    local t = {} 
    for i=1, h + 10 do
        local v = i
        table.insert(t, 1, unicode.char(char[math.random(length)]))
        for j=1, 10 do
            if v >= 1 and v < h then
              gpu.set(x, v, t[j])
            end
            v = v - 1
        end
        gpu.set(x, v, " ")
        os.sleep(0.1)
    end
end

drop(5)