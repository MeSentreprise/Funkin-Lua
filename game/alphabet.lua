local Alphabet = {}

local characters = {
    alphabet = "abcdefghijklmnopqrstuvwxyz",
    numbers = "1234567890",
    symbols = "|~#$%()*+-:;<=>@[]^_.,'!?"
}

function Alphabet:update(dt)
    if not self.destroyed then utils.callGroup(self.letters, "update", dt) end
end

function Alphabet:draw()
    if not self.destroyed then
        utils.callGroup(self.letters, "draw", self.x, self.y,self.alpha)
    end
end

function Alphabet:changeText(text)
    self:clear()
    self.lastLetter = nil

    self.text = text

    local coolY = 0

    local consecutiveSpaces = 0

    for c in string.gmatch(text, ".") do
        local xPos = 0

        local isNumber = string.find(characters.numbers, c, 1, true)
        local isSymbol = string.find(characters.symbols, c, 1, true)
        local isAlphabet = string.find(characters.alphabet, string.lower(c), 1,
                                       true)

        if c == "\n" then
            xPos = xPos - 110
            coolY = coolY + 75

            consecutiveSpaces = 0
            self.lastLetter = nil
        elseif isAlphabet or isSymbol or isNumber then
            if self.lastLetter ~= nil then
                xPos = xPos + self.lastLetter.x + self.lastLetter.width
            end

            if consecutiveSpaces > 0 then
                xPos = xPos + 40 * consecutiveSpaces
                consecutiveSpaces = 0
            end

            local letter = sprite:new(paths.atlas("alphabet"), xPos,
                                  self.isBold and coolY or coolY + 15)

            letter.alpha=self.isAlpha


            local animName
            if self.isBold then
                if isNumber then
                    animName = "bold" .. c
                elseif isSymbol then
                    if c == "." then
                        animName = "PERIOD bold"
                    elseif c == "'" then
                        animName = "APOSTRAPHIE bold"
                    elseif c == "?" then
                        animName = "QUESTION MARK bold"
                    elseif c == "!" then
                        animName = "EXCLAMATION POINT bold"
                    else
                        animName = "bold " .. c
                    end

                    -- set position
                    if c == "-" then
                        letter.y = letter.y + 25
                    elseif c == ")" then
                        letter.x = letter.x - 28
                    elseif c == "." then
                        letter.y = letter.y + 50
                    end
                elseif isAlphabet then
                    animName = string.upper(c) .. " bold"
                end
            else
                if isNumber then
                    animName = c
                elseif isSymbol then
                    if c == "#" then
                        animName = "hashtag"
                    elseif c == "." then
                        animName = "period"
                    elseif c == "'" then
                        animName = "apostraphie"
                    elseif c == "?" then
                        animName = "question mark"
                    elseif c == "!" then
                        animName = "exclamation point"
                    elseif c == "," then
                        animName = "comma"
                    else
                        animName = c
                    end

                    -- ima set position again
                    if c == "-" then
                        letter.y = letter.y + 18
                    elseif c == "," then
                        letter.y = letter.y + 35
                    elseif c == "?" or c == "!" then
                        letter.x = letter.x + 10
                        letter.y = letter.y - 15
                    end
                elseif isAlphabet then
                    local case
                    if string.lower(c) ~= c then
                        case = "capital"
                    else
                        case = "lowercase"
                    end

                    animName = c .. " " .. case
                end
            end

            letter:addByPrefix(c, animName)

            if isAlphabet then
                letter.y = letter.y + 48
                if self.isBold then
                    letter.y = letter.y - letter.height / 1.5
                else
                    letter.y = letter.y - letter.height
                end
            end

            table.insert(self.letters, letter)
            self.lastLetter = letter

            letter:playAnim(c)
        elseif c == " " or (self.isBold and c == "_") then
            consecutiveSpaces = consecutiveSpaces + 1
        else
            error("Couldn't find a animation for the character " .. c)
        end
    end
end

function Alphabet:clear()
    if not self.destroyed then utils.callGroup(self.letters, "destroy") end
end

function Alphabet:destroy()
    if not self.destroyed then
        self:clear()
        self.destroyed = true
        collectgarbage()
    end

    return self
end

return function(text, bold, x, y,alpha)
    local self = setmetatable({
        x = x or 0,
        y = y or 0,

        text = "",
        isBold = bold or false,
        isAlpha= alpha or 1,
        destroyed = false,

        letters = {},
        lastLetter = nil
    }, {__index = Alphabet})

    self:changeText(text)

    return self
end
