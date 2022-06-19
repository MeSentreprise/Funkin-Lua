local state = {}

local menuBG
local menu={}
local rz
local rgb
local follow_x
local follow_y

local function lerp(a, b, x) return a + (b - a)*x end

function state.load()
    rz=1

    rgb={178/255,34/255,34/255}
    menuBG = paths.getImage("menuDesat")
    _c.add(menuBG)  

    for line in io.lines(paths.text('freeplaySongs')) do
        menu[ #menu+1 ] = alphabet(line,true)
    end

    for k,v in ipairs(menu) do
        v.y=140*k
    end

    selectred=menu[1]

    camera=Camera()
    camera.x=0
    camera.y=0
end

local addX = 15
local addY = 15

function state.update(dt)
    camera:lockY(selectred.y, camera.smooth.damped(10))
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
    end
    if input:pressed "down" then
        utils.playSound(scrollSnd)
        rz=rz+1
        selectred=menu[rz]
    end
end

function state.draw()
        love.graphics.setColor(rgb)
        love.graphics.draw(menuBG)
    
        for k,v in ipairs(menu) do
            camera:attach(-500,0)
                v:draw(50,addY,50/255)
                v.alpha=0.4
            camera:detach()
        end
        selectred.alpha=1
    
end

return state
