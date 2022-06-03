local state = {}

local menuBG
local funniText
local menu
local selected
local rz
local rgb
local oldrgb
function state.load()
    rz=1
    rgb={255,255,255}
    menuBG = paths.getImage("menuDesat")
    menuBGBlue = paths.getImage("menuBGBlue")
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

    if selectred==funniText2 or selectred==funniText3 or selectred==funniText4 then
        rgb={45/255,105/255,225/255,0.5}
    elseif selectred==funniText5 or selectred==funniText6 then
        rgb={0/255,0/255,25/255} 
    end
    love.graphics.setColor(rgb)
    love.graphics.draw(menuBG)
    for k,v in ipairs(menu) do  
        v:draw(addX,addY)
        v.y=k*90
        v.x=50
    end
end

return state
