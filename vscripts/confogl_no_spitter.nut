lastSpitterLimit <- Convars.GetFloat("z_spitter_limit")

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

function OnGameEvent_player_team(params)
{
	if (params.disconnect && params.isbot && GetPlayerFromUserID(params.userid).GetZombieType() == 8) // Player is a disconnecting bot tank
	{
        Msg(format("OnGameEvent_player_team, %d", Director.IsTankInPlay() ? 1 : 0))
        if (lastSpitterLimit > 0.0) {
            Msg(format("Resetting Spitter Limit to %f", lastSpitterLimit));
            Convars.SetValue("z_spitter_limit", lastSpitterLimit)
            lastSpitterLimit = 0;
        }
	}
}

Msg("No Spitter During Tank: LOADED!\n");
