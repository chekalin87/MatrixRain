local component = require("component")
local gpu = component.gpu
local unicode = require("unicode")
local thread = require("thread")
local w, h = gpu.getResolution()


local char = {12040, 12065, 12090, 12103, 12144, 12043, 12047, 7112, 48, 81, 56, 2059, 2069, 3908, 3946, 3947, 7249, 7193, 7934, 8040, 5862, 5809, 5871, 5801, 12452, 12456, 12640, 12530, 12484, 12793, 12796, 12799, 12784}
local lengthChar = #char

local function drop(x)
    local t = {} 
    while true do
        local speed = math.random()
        local length = math.random(7, math.floor(h*1.5))
        os.sleep(math.random(3, 20))
        for i=1, h + length do
            local v = i
            table.insert(t, 1, unicode.char(char[math.random(lengthChar)]))
            for j=1, length do
                if v >= 1 and v <= h then
                    if j == 1 then
                        gpu.setForeground(0xFFFFFF)
                        gpu.set(x, v, t[j])
                    elseif j == length - 6 then
                        gpu.setForeground(0x006000)
                        gpu.set(x, v, t[j]) 
                    elseif j == length - 2  then
                        gpu.setForeground(0x002000)
                        gpu.set(x, v, t[j])
                    elseif j == 2 then
                        gpu.setForeground(0x00FF00)
                        gpu.set(x, v, t[j])
                    end
                end
                v = v - 1
            end
            gpu.set(x, v, " ")
            os.sleep(speed)
        end
    end
end

gpu.setBackground(0x000000)
gpu.setForeground(0x00FF00)
thread.init()
for i=1, w, 2 do
    thread.create(drop,i)
end
thread.waitForAll()
