----AlphaEnFolieee----

local firstTime = false
local resourceName = GetCurrentResourceName() or 'anims'
local versionData = json.decode(LoadResourceFile(resourceName, 'update.json'))

local function checkVersion(e, latest, _)
    local latest = json.decode(latest)
    if e ~= 200 then
        return print('erreur : Anime n a pas pu vérifier avec Github')
    end
    if versionData then
        local version = versionData.version
        if version ~= latest.version and version < latest.version then
            print('^1Panel animations by AlphaEnFolie!')
        elseif version > latest.version then
            print('^3Version 1.0^7')
        else
            if not firstTime then
                firstTime = true
                print('^2Les animations sont mises à jour !^7')
            end
        end
    else
        if not firstTime then
            firstTime = true
            print('Vous avez supprimé le fichier JSON smh. Adieu les mises à jour :sadge:')
        end
    end
end

local function updateStatus()
    SetTimeout(1000 * 60 * 30, updateStatus)

    PerformHttpRequest('https://raw.githubusercontent.com/BombayV/anims/main/update.json', checkVersion, "GET")
end

updateStatus()
