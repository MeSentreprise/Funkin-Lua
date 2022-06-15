local song = {}

function song.loadFromJson(song, folder,difficulty)
    if not difficulty==nil then
        song = paths.formatToSongPath(song .. difficulty)
    else
        song = paths.formatToSongPath(song)
    end
    if folder == nil then
        folder = song   
    else
        folder = paths.formatToSongPath(folder)
    end
    return utils.readJson(paths.json(folder .. "/" .. song)).song
end

return song
