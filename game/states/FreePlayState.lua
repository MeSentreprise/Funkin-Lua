local state = {}

local menuBG
local funniText
local menu
local selected
local rz
local rgb
local oldrgb


local function lerp(a, b, x) return a + (b - a)*x end


function state.load()
    rz=1
    rgb={178/255,34/255,34/255}
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
    for k,v in ipairs(menu) do
        v.y=90*k
    end
    selectred=menu[1]
end

local addX = 15
local addY = 15

function state.update(dt)
    selectred.alpha=1
    selectred:update(dt)    

    if input:pressed "back" then
        utils.playSound(cancelSnd)
        switchState(mainmenu)
    end
    if input:pressed "accept" then
            playstate.SONG = song.loadFromJson(selectred.text)
            switchState(playstate)
    end
    if input:pressed "up" then
        utils.playSound(scrollSnd)
        rz=rz-1
        selectred=menu[rz]
        for k,v in ipairs(menu) do
            v.y=v.y+rz*10
        end
    end
    if input:pressed "down" then
        utils.playSound(scrollSnd)
        rz=rz+1
        selectred=menu[rz]
        for k,v in ipairs(menu) do
            v.y=v.y-rz*10
        end
    end
end

function state.draw()
    if selectred==funniText then
        rgb[1]=lerp(rgb[1],178/255,0.05)
        rgb[2]=lerp(rgb[2],34/255,0.05)
        rgb[3]=lerp(rgb[3],34/255,0.05)
    elseif selectred==funniText2 or selectred==funniText3 or selectred==funniText4 then
        rgb[1]=lerp(rgb[1],45/255,0.05)
        rgb[2]=lerp(rgb[2],105/255,0.05)
        rgb[3]=lerp(rgb[3],225/255,0.05)
    elseif selectred==funniText5 or selectred==funniText6 then
        rgb[1]=lerp(rgb[1],0/255,0.05)
        rgb[2]=lerp(rgb[2],0/255,0.05)
        rgb[3]=lerp(rgb[3],25/255,0.05)
    end
    love.graphics.setColor(rgb)
    love.graphics.draw(menuBG)
    
    for k,v in ipairs(menu) do
        v:draw(addX,addY,50/255)
        v.x=50
        v.alpha=0.4
    end

    selectred.alpha=1
end

return state
