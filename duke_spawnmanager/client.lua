RegisterNetEvent('spawnmanager:spawn')
AddEventHandler('spawnmanager:spawn', function()
    --[[print("Spieler wird jetzt gespawnt")
    RequestModel("mp_m_freemode_01")
    while not HasModelLoaded("mp_m_freemode_01") do
        RequestModel("mp_m_freemode_01")
        Wait(0)
    end
    SetPlayerModel(PlayerId(), "mp_m_freemode_01")
    SetModelAsNoLongerNeeded("mp_m_freemode_01")
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, -1135.24, -2804.194, 27.70873, false, false, false, true)
    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    ShutdownLoadingScreen()]]--
    function spawnPlayer()
        if spawnLock then
            return
        end
    
        spawnLock = true
    
        Citizen.CreateThread(function()
            -- if the spawn isn't set, select a random one
            --[[if not spawnIdx then
                spawnIdx = GetRandomIntInRange(1, #spawnPoints + 1)
            end]]--
    
            -- get the spawn from the array
            local spawn
    
            if type(spawnIdx) == 'table' then
                spawn = spawnIdx
    
                -- prevent errors when passing spawn table
                spawn.x = spawn.x + 0.00
                spawn.y = spawn.y + 0.00
                spawn.z = spawn.z + 0.00
    
                spawn.heading = spawn.heading and (spawn.heading + 0.00) or 0
            else
                spawn = spawnPoints[spawnIdx]
            end
    
            if not spawn.skipFade then
                DoScreenFadeOut(500)
    
                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end
            end
    
            -- validate the index
            if not spawn then
                Citizen.Trace("tried to spawn at an invalid spawn index\n")
    
                spawnLock = false
    
                return
            end
    
            -- freeze the local player
            freezePlayer(PlayerId(), true)
    
            -- if the spawn has a model set
            if spawn.model then
                RequestModel(spawn.model)
    
                -- load the model for this spawn
                while not HasModelLoaded(spawn.model) do
                    RequestModel(spawn.model)
    
                    Wait(0)
                end
    
                -- change the player model
                SetPlayerModel(PlayerId(), spawn.model)
    
                -- release the player model
                SetModelAsNoLongerNeeded(spawn.model)
                
                -- RDR3 player model bits
                if N_0x283978a15512b2fe then
                    N_0x283978a15512b2fe(PlayerPedId(), true)
                end
            end
    
            -- preload collisions for the spawnpoint
            RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
    
            -- spawn the player
            local ped = PlayerPedId()
    
            -- V requires setting coords as well
            SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
    
            NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)
    
            -- gamelogic-style cleanup stuff
            ClearPedTasksImmediately(ped)
            --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
            RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
            ClearPlayerWantedLevel(PlayerId())
    
            -- why is this even a flag?
            --SetCharWillFlyThroughWindscreen(ped, false)
    
            -- set primary camera heading
            --SetGameCamHeading(spawn.heading)
            --CamRestoreJumpcut(GetGameCam())
    
            -- load the scene; streaming expects us to do it
            --ForceLoadingScreen(true)
            --loadScene(spawn.x, spawn.y, spawn.z)
            --ForceLoadingScreen(false)
    
            local time = GetGameTimer()
    
            while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
                Citizen.Wait(0)
            end
    
            ShutdownLoadingScreen()
    
            if IsScreenFadedOut() then
                DoScreenFadeIn(500)
    
                while not IsScreenFadedIn() do
                    Citizen.Wait(0)
                end
            end
    
            if cb then
                cb(spawn)
            end
    

            spawnLock = false
        end)
    end
end)