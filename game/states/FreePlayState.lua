local state = {}

local menuBG
local funniText
local menu
local selected
local rz

function state.load()
    rz=1
    menuBG = paths.getImage("menuDesat")
    _c.add(menuBG)
    funniText = alphabet("Tutorial", true)
    funniText2 = alphabet("Bopeebo", true)
    funniText3 = alphabet("Fresh", true)
    funniText4 = alphabet("Dad-Battle", true)
    funniText5 = alphabet("Spookeez", true)
    funniText6 = alphabet("South", true)
    funniText7 = alphabet("Monster", true)
    menu={funniText,funniText2,funniText3,funniText4,funniText5,funniText6,funniText7}
    selectred=menu[1]
end

local addX = 15
local addY = 15

function state.update(dt)
    selectred:update(dt)    

    if input:pressed "back" then
        utils.playSound(cancelSnd)
        switchState(mainmenu)
    end
    if input:pressed "accept" then
        if rz==2 then
            playstate.SONG = song.loadFromJson("bopeebo")
            switchState(playstate)
        elseif rz==1 then
            playstate.SONG = song.loadFromJson("tutorial")
            switchState(playstate)
        elseif rz==3 then
            playstate.SONG = song.loadFromJson("fresh")
            switchState(playstate)
        elseif rz==4 then
            playstate.SONG = song.loadFromJson("dad-battle")
            switchState(playstate)
        elseif rz==5 then
            playstate.SONG = song.loadFromJson("spookeez")
            switchState(playstate)
        elseif rz==6 then
            playstate.SONG = song.loadFromJson("south")
            switchState(playstate)
        elseif rz==7 then
            playstate.SONG = song.loadFromJson("monster")
            switchState(playstate)
        end
    end
    if input:pressed "up" then
        utils.playSound(scrollSnd)
        rz=rz-1
        if rz<1 then
            rz=table.maxn(menu)
        end
        selectred=menu[rz]
    end
    if input:pressed "down" then
        utils.playSound(scrollSnd)
        rz=rz+1
        if rz>table.maxn(menu) then
            rz=1
        end
        selectred=menu[rz]
        
    end
end

function state.draw()
    love.graphics.setColor(234 / 255, 113 / 255, 253 / 255)
    love.graphics.draw(menuBG, 0, 0, 0, 1.1, 1.1)
    love.graphics.setColor(1, 1, 1)
    for k,v in ipairs(menu) do
        love.graphics.
        v:draw(addX,addY)
        if k==1 then
            v.y=35
        else
            v.y=k*70
        end
        v.x=50
    end
end

return state
