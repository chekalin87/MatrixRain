-- Спасибо Zer0Galaxy за библиотеку Thread.
-- pastebin get E0SzJcCx /lib/thread.lua

local component = require("component")
local term = require("term")
local unicode = require("unicode")
local event = require("event")
local thread = require("thread")
local gpu = component.gpu
local w, h = gpu.getResolution()

local frequency = 3                                                     -- частота капель (максимальная задержка в секундах)
local speedLimit = 0                                                    -- ограничение разницы скоростей капель, от 0 до 0.95 (0 - наибольшая разница)
local speedDrop = 20                                                    -- скорость капель
local maxDropLength = 80                                                -- максимальная длина капли (в процентах от высоты монитора)
maxDropLength = maxDropLength*h/100
local minDropLength = 5                                                 -- минимальная длина капли в символах


-- символы юникод
local char = {12040, 12065, 12090, 12103, 12144, 12043, 12047, 7112, 48, 81, 56, 2059, 2069, 3908, 3946, 3947, 7249, 7193, 7934, 8040, 5862, 5809, 5871, 5801, 12452, 12456, 12640, 12530, 12484, 12793, 12796, 12799, 12784}
local lengthChar = #char

local function drop(x)
    local t = {} 
    os.sleep(math.random(30))
    while true do
        local speed = math.random()
        while speed < speedLimit do
            speed = math.random()
        end
        local length = math.random(minDropLength, math.floor(maxDropLength))
        local color1 =math.floor(length - length / 3)
        local color2 =math.floor(length - length / 6)
        local color3 =math.floor(length - length / 12)
        os.sleep(math.random(0, frequency))

        for i=1, h + length do
            table.insert(t, 1, unicode.char(char[math.random(lengthChar)]))
        end

        for i=1, h + length do
            gpu.setForeground(0xFFFFFF)
            gpu.set(x, i, t[i])
            if i - 1 > 0 then
                gpu.setForeground(0x00FF00)
                gpu.set(x, i-1, t[i-1])
            end
            if i - color1 + 1 > 0 then
                gpu.setForeground(0x006000)
                gpu.set(x, i-color1+1, t[i-color1+1]) 
            end
            if i - color2 + 1 > 0 then
                gpu.setForeground(0x004000)
                gpu.set(x, i-color2+1, t[i-color2+1])
            end
            if i - color3 + 1> 0 then
                gpu.setForeground(0x002000)
                gpu.set(x, i-color3+1, t[i-color3+1])
            end
            if i - length > 0 then
                gpu.set(x, i - length, " ")
            end
            os.sleep(speed/speedDrop)
        end
        t = {}
    end
end

local function exit()
    if event.pull("touch") then
        thread.killAll()
        gpu.setBackground(0x000000)
        gpu.setForeground(0xFFFFFF)
        term.clear()
    end
end

gpu.setBackground(0x000000)
gpu.setForeground(0x00FF00)
thread.init()
for i=1, w, 2 do
    thread.create(drop,i)
    --thread.create(drop,i)                                                      --если раскомментировать - будет больше похоже на оригинал, но с некоторыми артефактами(кому как нравится)  
end
exit()