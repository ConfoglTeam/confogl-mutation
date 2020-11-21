lastSpitterLimit <- Convars.GetFloat("z_spitter_limit")

// TODO: These game events don't capture AI tanks getting kicked... let's just poll `IsTankInPlay()`
function OnGameEvent_tank_spawn( params )
{
    Msg(format("OnGameEvent_tank_spawn, %d", Director.IsTankInPlay() ? 1 : 0))
    local spitterLimit = Convars.GetFloat("z_spitter_limit");
    if (spitterLimit > 0) {
        Msg("Setting Spitter Limit to 0")
        lastSpitterLimit = spitterLimit;
        Convars.SetValue("z_spitter_limit", 0)
    }
}

function OnGameEvent_tank_killed( params ) 
{
    Msg(format("OnGameEvent_tank_killed, %d", Director.IsTankInPlay() ? 1 : 0))
    if (lastSpitterLimit > 0.0) {
        Msg(format("Resetting Spitter Limit to %f", lastSpitterLimit));
        Convars.SetValue("z_spitter_limit", lastSpitterLimit)
        lastSpitterLimit = 0;
    }
}

Msg("No Spitter During Tank: LOADED!\n");
