local xmlParser = require "lib.xml"

local function tableHasValue(table, val)
    for index, value in ipairs(table) do if value == val then return true end end
    return false
end

local Sprite = {}
Sprite.__index = Sprite

function Sprite:new(path, x, y)
    self = setmetatable({}, {__index = Sprite})

    self.x = x or 0
    self.y = y or 0

    self.width = 0
    self.height = 0

    self.angle = 0
    self.alpha = 1

    self.sizeX = 1
    self.sizeY = 1

    self.offsetX = 0
    self.offsetY = 0
    self.centerOffsets = false

    self.animOffsets = {}

    self.paused = false

    self.visible = true
    self.active = true

    self.destroyed = false

    self.path = ""
    self.xmlData = {}
    self.image = {}

    self.animations = {}
    self.curAnim = {
        name = "",
        frames = {},
        indices = {},
        offsets = {},
        length = 0,
        framerate = 24,
        loop = false,
        finished = false
    }

    self.firstFrame = nil
    self.curFrame = 1

    self:load(path)
    _c.add(self)

    return self
end

function Sprite:load(path)
    print(path)
    if path == nil then path = "" end
        self.path = path
        print("[sprite.lua] path=".. path)

        local lePath = path .. ".xml"
        print("[sprite.lua] lePath=".. lePath)
        assert(love.filesystem.getInfo(lePath) ~= nil,
               "'" .. lePath .. "' was not found!")

        local contents, size = love.filesystem.read(lePath)
        local data = xmlParser.parse(contents)
        self.xmlData = {}
        for _, e in pairs(data) do
            if e.tag == "SubTexture" then
                table.insert(self.xmlData, e)
            end
        end

        lePath = self.path .. ".png"
        assert(love.filesystem.getInfo(lePath) ~= nil,
               "'" .. lePath .. "' was not found!")
        self.image = _c.getImage(lePath)    

    return self
end

function Sprite:update(dt)
    if not self.active then return end

    if self.curAnim ~= nil and not self.destroyed then
        local frame = self.curFrame + dt * self.curAnim.framerate
        if #self.curAnim.frames > 1 and (not self.paused or
            (self.curAnim.indices ~= nil and
                tableHasValue(self.curAnim.frames, frame))) then
            self.curFrame = frame
            if self.curFrame >= #self.curAnim.frames - 1 then
                if self.curAnim.loop then
                    self.curFrame = 0
                else
                    self.curFrame = #self.curAnim.frames - 1
                end
            end
        end
    end
end

function Sprite:draw(addX, addY,alpha)
    if not self.visible then return end

    if addX == nil then addX = 0 end
    if addY == nil then addY = 0 end
    if alpha == nil then alpha = 1 end


    if self.curAnim ~= nil and not self.destroyed then
        local spriteNum = math.floor(self.curFrame)
        if not self.paused then spriteNum = spriteNum + 1 end

        local frame = self.curAnim.frames[spriteNum]
        if frame == nil then return end

        local x = self.x
        local y = self.y

        local offsetX = frame.offsets.x
        local offsetY = frame.offsets.y

        -- why this taken two days to be done
        if self.centerOffsets then
            local funni = self.curAnim.frames[1]
            local rock = 11

            -- lol more funni than funni variable
            x = x - rock / 2
            y = y - rock / 2

            offsetX = offsetX * rock / 10 - funni.offsets.x / 2 + funni.width /
                          2
            offsetY = offsetY * rock / 10 - funni.offsets.y / 2 + funni.height /
                          2
        end

        local animOffset = self.animOffsets[self.curAnim.name]
        if animOffset == nil then animOffset = {0, 0} end

        love.graphics.setColor(255, 255, 255,alpha)
        love.graphics.draw(self.image, frame.quad, x - self.offsetX + addX,
                           y - self.offsetY + addY, self.angle, self.sizeX,
                           self.sizeY, offsetX + animOffset[1],
                           offsetY + animOffset[2])
        love.graphics.setColor(255, 255, 255)

        if not self.paused and not self.curAnim.loop and spriteNum >=
            #self.curAnim.frames then self.curAnim.finished = true end
    end
end

function Sprite:addByPrefix(name, prefix, framerate, loop)
    self:__addAnim(name, prefix, nil, framerate, loop)
end

function Sprite:addByIndices(name, prefix, indices, framerate, loop)
    self:__addAnim(name, prefix, indices, framerate, loop)
end

function Sprite:__addAnim(name, prefix, indices, framerate, loop)
    if not self.destroyed then
        if framerate == nil then framerate = 24 end
        if loop == nil then loop = true end

        local anim = {
            name = name,
            frames = {},
            indices = indices,
            length = 0,
            framerate = framerate,
            loop = loop
        }

        for f = 1, #self.xmlData do
            local data = self.xmlData[f].attr

            if string.sub(data["name"], 1, string.len(prefix)) == prefix then
                if (indices == nil or indices == {}) or
                    tableHasValue(indices, f) then
                    local width = tonumber(data["width"])
                    local height = tonumber(data["height"])

                    local frame = {
                        quad = love.graphics.newQuad(tonumber(data["x"]),
                                                     tonumber(data["y"]), width,
                                                     height,
                                                     self.image:getDimensions()),
                        width = width,
                        height = height
                    }

                    frame.offsets = {
                        x = tonumber(data["frameX"]) or 0,
                        y = tonumber(data["frameY"]) or 0
                    }

                    table.insert(anim.frames, frame)
                end
            end
        end

        self.animations[name] = anim
    end

    self:updateHitbox()

    return self
end

function Sprite:updateHitbox()
    self.width = 0
    self.height = 0

    -- try to get da average size
    for i, v in pairs(self.animations) do
        for i, f in pairs(v.frames) do
            if f.width > self.width then self.width = f.width end
            if f.height > self.height then self.height = f.height end
        end
    end
end

function Sprite:removeAnim(name)
    if self.animations[name] ~= nil then
        if self.curAnim.name == name then self:stop() end
        self.animations[name] = nil
    end
    return self
end

function Sprite:playAnim(anim, forced)
    if forced == nil then forced = false end

    if self.animations[anim] ~= nil and self.animations[anim].frames[1] ~= nil and
        not self.destroyed and not self.paused then
        if not forced and anim == self.curAnim.name then return end

        if anim ~= self.curAnim.name then
            self.curAnim = self.animations[anim]
        end
        self.curAnim.finished = false
        self.curFrame = 0
    end

    return self
end

function Sprite:addOffset(anim, x, y)
    x = x or 0
    y = y or 0
    self.animOffsets[anim] = {x, y}
end

function Sprite:pause()
    self.paused = true
    return self
end

function Sprite:play()
    self.paused = false
    return self
end

function Sprite:stop()
    self.curAnim = nil
    return self
end

function Sprite:destroy()
    if not self.destroyed then
        self:stop()

        self.animations = {}
        self.image = nil
        self.xmlData = nil

        self.destroyed = true

        collectgarbage()
    end

    return self
end

return Sprite
