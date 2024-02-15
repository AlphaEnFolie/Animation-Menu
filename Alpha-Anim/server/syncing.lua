local currentlyPlaying = {}

----AlphaEnFolieee----
---Print AlphaEnFolie----

--partagé animations
RegisterNetEvent('anims:resolveAnimation', function(target, shared, accepted)
    local playerId <const> = source
    if type(shared) ~= "table" and tonumber(playerId) ~= tonumber(target) then
        return false
    end
    if playerId and target then
        if accepted then
            TriggerClientEvent('anims:requestShared', target, shared.first, target, true)
            TriggerClientEvent('anims:requestShared', playerId, shared.second, tonumber(playerId))
        else
            TriggerClientEvent('anims:notify', target, 'info', 'Le joueur a refusé votre demande...')
            TriggerClientEvent('anims:notify', playerId, 'info', 'Demande refusée')
        end
    end
end)

RegisterNetEvent('anims:awaitConfirmation', function(target, shared)
    local playerId <const> = source
    if playerId > 0 then
        if target and type(shared) == "table" then
            TriggerClientEvent('anims:awaitConfirmation', target, playerId, shared)
        end
    end
end)
--

--#PTFX Synchronisation
RegisterNetEvent('anims:syncParticles', function(particles, nearbyPlayers)
    local playerId <const> = source
    if type(particles) ~= "table" or type(nearbyPlayers) ~= "table" then
        error('Le tableau n a pas réussi')
    end
    if playerId > 0 then
        for i = 1, #nearbyPlayers do
            TriggerClientEvent('anims:syncPlayerParticles', nearbyPlayers[i], playerId, particles)
        end
        currentlyPlaying[playerId] = nearbyPlayers
    end
end)

RegisterNetEvent('anims:syncRemoval', function()
    local playerId <const> = source
    if playerId > 0 then
        local nearbyPlayers = currentlyPlaying[playerId]
        if nearbyPlayers then
            for i = 1, #nearbyPlayers do
                TriggerClientEvent('anims:syncRemoval', nearbyPlayers[i], playerId)
            end
            currentlyPlaying[playerId] = nil
        end
    end
end)
--

----AlphaEnFolie ! --- 