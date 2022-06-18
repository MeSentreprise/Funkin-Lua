local Character = {}
Character.__index = Character
setmetatable(Character, {__index = sprite})

function Character:new(char, x, y)
    if char=='dad' then
        self = setmetatable(sprite.new(self, paths.atlas("characters/DADDY_DEAREST"), x, y), self)
    elseif char=='spooky' then
        self = setmetatable(sprite.new(self, paths.atlas("characters/spooky_kids_assets"), x, y), self)
    elseif char=='mom' then
        self = setmetatable(sprite.new(self, paths.atlas("characters/Mom_Assets"), x, y), self)
    elseif char=='monster' then
        self = setmetatable(sprite.new(self, paths.atlas("characters/Monster_Assets"), x, y), self)
    else
        self = setmetatable(sprite.new(self, paths.atlas("characters/BOYFRIEND"), x, y), self)
    end

    self.curCharacter = char or "bf"
    self.offsets = {}

    if self.curCharacter == "bf" then
        --self:load(paths.atlas("BOYFRIEND"))
        --self:load("BOYFRIEND")
        self:addByPrefix("idle", "BF idle dance", nil, true)
        self:addByPrefix("singUP", "BF NOTE UP0", nil, true)
        self:addByPrefix("singLEFT", "BF NOTE LEFT0", nil, true)
        self:addByPrefix("singRIGHT", "BF NOTE RIGHT0", nil, true)
        self:addByPrefix("singDOWN", "BF NOTE DOWN0", nil, true)

        self:addOffset("idle", -5)
        self:addOffset("singUP", -29, 27)
        self:addOffset("singRIGHT", -38, -7)
        self:addOffset("singLEFT", 12, -6)
        self:addOffset("singDOWN", -10, -50)

    end

    if self.curCharacter == "dad" then
        --self:load(paths.atlas("BOYFRIEND"))
        --self:load("BOYFRIEND")
        self:addByPrefix("idle", "Dad idle dance", nil, true)
        self:addByPrefix("singUP", "Dad Sing Note UP0", nil, false)
        self:addByPrefix("singLEFT", "Dad Sing Note LEFT0", nil, false)
        self:addByPrefix("singRIGHT", "Dad Sing Note RIGHT0", nil, false)
        self:addByPrefix("singDOWN", "Dad Sing Note DOWN0", nil, false)

        self:addOffset("idle", -5)
        self:addOffset("singUP", -29, 27)
        self:addOffset("singRIGHT", -38, -7)
        self:addOffset("singLEFT", 12, -6)
        self:addOffset("singDOWN", -10, -50)

    end

    if self.curCharacter == "spooky" then
        --self:load(paths.atlas("BOYFRIEND"))
        --self:load("BOYFRIEND")
        self:addByPrefix("idle", "spooky dance idle", nil, true)
        self:addByPrefix("singUP", "spooky UP NOTE0", nil, false)
        self:addByPrefix("singLEFT", "note sing left0", nil, false)
        self:addByPrefix("singRIGHT", "spooky sing right0", nil, false)
        self:addByPrefix("singDOWN", "spooky DOWN note0", nil, false)

        self:addOffset("idle", -5)
        self:addOffset("singUP", -29, 27)
        self:addOffset("singRIGHT", -38, -7)
        self:addOffset("singLEFT", 12, -6)
        self:addOffset("singDOWN", -10, -50)

    end

    if self.curCharacter == "mom" then
        --self:load(paths.atlas("BOYFRIEND"))
        --self:load("BOYFRIEND")
        self:addByPrefix("idle", "Mom idle", nil, true      )
        self:addByPrefix("singUP", "Mom Up0 ", nil, false)
        self:addByPrefix("singLEFT", "Mom Left Pose0", nil, false)
        self:addByPrefix("singRIGHT", "Mom Pose Left0", nil, false)
        self:addByPrefix("singDOWN", "MOM DOWN POSE0", nil, false)

        self:addOffset("idle", -5)
        self:addOffset("singUP", -29, 27)
        self:addOffset("singRIGHT", -38, -7)
        self:addOffset("singLEFT", 12, -6)
        self:addOffset("singDOWN", -10, -50)

    end

    return self
end

function Character:playAnim(anim, forced)
    if self.offsets[anim] ~= nil then
        local offset = self.offsets[anim]
        self.offsetX = offset[1]
        self.offsetY = offset[2]
    else
        self.offsetX = 0
        self.offsetY = 0
    end
    sprite.playAnim(self, anim, forced)
end

function Character:addOffset(anim, x, y)
    if x == nil then x = 0 end
    if y == nil then y = 0 end
    self.offsets[anim] = {x, y}
end

function Character:dance() self:playAnim("idle", false) end

return Character
