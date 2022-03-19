io.stdout:setvbuf("no")

-- lazy to do a util btw
function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local titlestate = require "src.states.titlestate"
sprite = require "src.sprite"
utils = require "src.utils"

lovebpm = require "libs.lovebpm"
xml = require("libs.xmlSimple").newParser()
-- json = require "libs.dkjson"

function love.load()
    titlestate.load()
end

function love.update(dt)
    titlestate.update(dt)
end

function love.draw()
    titlestate.draw()
end
