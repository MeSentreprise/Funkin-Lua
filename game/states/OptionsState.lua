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
    funniText = alphabet("cool swag", true)
    funniText2 = alphabet("bbpanzu be like", true)
    menu={funniText,funniText2}
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
        selectred:changeText("yeah\nbitch")
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
