local component = require("component")
local gpu = component.gpu
local unicode = require("unicode")
local thread = require("thread")
local w, h = gpu.getResolution()


local char = {12040, 12065, 12090, 12103, 12144, 12043, 12047, 7112, 48, 81, 56} 
local length = #char

local function drop(x)
    local t = {} 
    while true do
        os.sleep(math.random(5, 20))
        for i=1, h + 20 do
            local v = i
            table.insert(t, 1, unicode.char(char[math.random(length)]))
            for j=1, 20 do
                if v >= 1 and v < h then
                    if j == 1 then
                        gpu.setForeground(0xFFFFFF)
                    else
                        gpu.setForeground(0x00FF00)
                    end
                    gpu.set(x, v, t[j])
                end
                v = v - 1
            end
            gpu.set(x, v, " ")
            os.sleep(0.1)
        end
    end
end
gpu.setForeground(0x00FF00)
thread.init()
for i=1, w, 2 do
    thread.create(drop,i)
end
thread.waitForAll()
