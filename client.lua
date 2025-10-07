-- Initialize Config
local Config = Config or {}

local hasPlayerLoaded = false
CreateThread(function()
	Wait(10000)
	hasPlayerLoaded = true
end)

-- Client event to handle gavel sounds (No changes needed here)
RegisterNetEvent('zogavel:play_gavel_sound', function(soundFile, soundVolume)
    if hasPlayerLoaded then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = soundFile,
            transactionVolume = soundVolume
        })
    end
end)

-- Create the qb-target BoxZone
CreateThread(function()
    -- Wait for the config to be loaded, just in case
    while Config.gavelLocation == nil do
        Wait(100)
    end

    exports['qb-target']:AddBoxZone("judge_gavel", Config.gavelLocation, 1.0, 1.0, {
        name = "judge_gavel",
        heading = 45,
        minZ = Config.gavelLocation.z - 1.0,
        maxZ = Config.gavelLocation.z + 1.0,
        debugPoly = false,
    }, {
        options = {
            {
                type = "client",
                event = "zogavel:play_gavel_sound_server",
                icon = "fa-solid fa-gavel",
                label = "Gavel - one time",
                job = "judge", -- ADD PROPER JOB NAME
                soundType = "one" -- Custom parameter passed to the event
            },
            {
                type = "client",
                event = "zogavel:play_gavel_sound_server",
                icon = "fa-solid fa-gavel",
                label = "Gavel - three times",
                job = "judge", -- ADD PROPER JOB NAME
                soundType = "three" -- Custom parameter passed to the event
            },
        },
        distance = 1.5 -- The distance from which the target can be seen
    })
end)


-- EventHandler for clicking the target option (No changes needed here)
RegisterNetEvent("zogavel:play_gavel_sound_server", function(data)
    -- qb-target passes the 'soundType' parameter from the selected option in the 'data' table
    TriggerServerEvent('zogavel:play_gavel_sound', data.soundType)
end)
