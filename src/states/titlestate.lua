local titlestate = {}

function titlestate.load()
    gf = utils.makeSprite("gfDanceTitle")
    gf.danceLeft = false
    gf:addAnim("danceLeft", "gfDance", {30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14})
    gf:addAnim("danceRight", "gfDance", {15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29})
    gf:playAnim("idle")

    logo = utils.makeSprite("logoBumpin")
    logo:addAnim("bump", "logo bumpin instance ", nil, 24, false)

    titleText = utils.makeSprite("titleEnter")
    titleText:addAnim("idle", "Press Enter to Begin")
    titleText:addAnim("press", "ENTER PRESSED")
    titleText:playAnim("idle")

    music = lovebpm.newTrack():load("assets/music/freakyMenu.ogg"):setBPM(102):setLooping(true):on("beat", function(n)
        logo:playAnim("bump", true)

        gf.danceLeft = not gf.danceLeft
        if gf.danceLeft then
            gf:playAnim("danceRight", true)
        else
            gf:playAnim("danceLeft", true)
        end
    end):play()
end

function titlestate.update(dt)
    gf:update(dt)
    logo:update(dt)
    titleText:update(dt)

    music:update()
end

function titlestate.draw()
    gf:draw(512, 40)
    logo:draw(-100, -50)
    titleText:draw(100, 576)
end

return titlestate
