local insert = table.insert

----AlphaEnFolieee----
---Charger les fonctions de la table
Load = {}

---Dict de charges
---@param dict string
Load.Dict = function(dict)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict) or timeout
end

---Charge le modèle/props
---@param model string
Load.Model = function(model)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    local hashModel = GetHashKey(model)
    repeat
        RequestModel(hashModel)
        Wait(50)
    until HasModelLoaded(hashModel) or timeout
end

---Charge l'animation/la marche
---@param walk string
Load.Walk = function(walk)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimSet(walk)
        Wait(50)
    until HasAnimSetLoaded(walk) or timeout
end

---Charge les effets de particules
---@param asset string
Load.Ptfx = function(asset)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestNamedPtfxAsset(asset)
        Wait(50)
    until HasNamedPtfxAssetLoaded(asset) or timeout
end

---Crée un ptfx à l'emplacement
---@param ped number
---@param prop number
---@param name string
---@param placement table
---@param rgb table
Load.PtfxCreation = function(ped, prop, name, asset, placement, rgb)
    local ptfxSpawn = ped
    if prop then
        ptfxSpawn = prop
    end
    local newPtfx = StartNetworkedParticleFxLoopedOnEntityBone(name, ptfxSpawn, placement[1] + 0.0, placement[2] + 0.0, placement[3] + 0.0, placement[4] + 0.0, placement[5] + 0.0, placement[6] + 0.0, GetEntityBoneIndexByName(name, "VFX"), placement[7] + 0.0, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    if newPtfx then
        SetParticleFxLoopedColour(newPtfx, rgb[1] + 0.0, rgb[2] + 0.0, rgb[3] + 0.0)
        if ped == PlayerPedId() then
            insert(cfg.ptfxEntities, newPtfx)
        else
            cfg.ptfxEntitiesTwo[GetPlayerServerId(NetworkGetEntityOwner(ped))] = newPtfx
        end
        cfg.ptfxActive = true
    end
    RemoveNamedPtfxAsset(asset)
end

---Supprime les effets de particules existants
Load.PtfxRemoval = function()
    if cfg.ptfxEntities then
        for _, v in pairs(cfg.ptfxEntities) do
            StopParticleFxLooped(v, false)
        end
        cfg.ptfxEntities = {}
    end
end

---Crée un accessoire sur place
---@param ped number
---@param prop string
---@param bone number
---@param placement table
Load.PropCreation = function(ped, prop, bone, placement)
    local coords = GetEntityCoords(ped)
    local newProp = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z + 0.2, true, true, true)
    if newProp then
        AttachEntityToEntity(newProp, ped, GetPedBoneIndex(ped, bone), placement[1] + 0.0, placement[2] + 0.0, placement[3] + 0.0, placement[4] + 0.0, placement[5] + 0.0, placement[6] + 0.0, true, true, false, true, 1, true)
        insert(cfg.propsEntities, newProp)
        cfg.propActive = true
    end
    SetModelAsNoLongerNeeded(prop)
end

---Supprime les accessoires | Supprime les accessoires
---@param type string
Load.PropRemoval = function(type)
    if type == 'global' then
        if not cfg.propActive then
            for _, v in pairs(GetGamePool('CObject')) do
                if IsEntityAttachedToEntity(PlayerPedId(), v) then
                    SetEntityAsMissionEntity(v, true, true)
                    DeleteObject(v)
                end
            end
        else
            Play.Notification('info', 'Suppression d accessoires empêchée...')
        end
    else
        if cfg.propActive then
            for _, v in pairs(cfg.propsEntities) do
                DeleteObject(v)
            end
            cfg.propsEntities = {}
            cfg.propActive = false
        end
    end
end

---Obtient le ped le plus proche
---@return any
Load.GetPlayer = function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(coords.x, coords.y, coords.z, offset.x, offset.y, offset.z, 3.0, 12, ped, 7)
    local _, hit, _, _, pedResult = GetShapeTestResult(rayHandle)

    if hit and pedResult ~= 0 and IsPedAPlayer(pedResult) then
        if not IsEntityDead(pedResult) then
            return pedResult
        end
    end
    return false
end

---Envoie une confirmation au joueur
---@param target number
---@param shared string
Load.Confirmation = function(target, shared)
    Play.Notification('info', '[E] Accepter la requête\n[L] Refuser la demande')
    local hasResolved = false
    SetTimeout(10000, function()
        if not hasResolved then
            hasResolved = true
            TriggerServerEvent('anims:resolveAnimation', target, shared, false)
        end
    end)

    CreateThread(function()
        while not hasResolved do
            if IsControlJustPressed(0, cfg.acceptKey) then
                if not hasResolved then
                    if cfg.animActive or cfg.sceneActive then
                        Load.Cancel()
                    end
                    TriggerServerEvent('anims:resolveAnimation', target, shared, true)
                    hasResolved = true
                end
            elseif IsControlJustPressed(0, cfg.denyKey) then
                if not hasResolved then
                    TriggerServerEvent('anims:resolveAnimation', target, shared, false)
                    hasResolved = true
                end
            end
            Wait(5)
        end
    end)
end

---Annule les animations en cours de lecture
Load.Cancel = function()
    if cfg.animDisableMovement then
        cfg.animDisableMovement = false
    end
    if cfg.animDisableLoop then
        cfg.animDisableLoop = false
    end

    if cfg.animActive then
        ClearPedTasks(PlayerPedId())
        cfg.animActive = false
    elseif cfg.sceneActive then
        if cfg.sceneForcedEnd then
            ClearPedTasksImmediately(PlayerPedId())
        else
            ClearPedTasks(PlayerPedId())
        end
        cfg.sceneActive = false
    end

    if cfg.propActive then
       Load.PropRemoval()
       cfg.propActive = false
    end
    if cfg.ptfxActive then
        if cfg.ptfxOwner then
            TriggerServerEvent('anims:syncRemoval')
            cfg.ptfxOwner = false
        end
        Load.PtfxRemoval()
        cfg.ptfxActive = false
    end
end

exports('Load', function()
    return Load
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestions', {
        {name = '/' .. cfg.commandNameEmote, help = cfg.commandNameSuggestion, params = {{name = 'emote', help = 'Emote name'}}},
        {name = '/' .. cfg.commandName, help = cfg.commandSuggestion, params = {}}
    })
end)
