local g_isGauntletFinale = false;
local g_allowDamageTimestampTable = {};
local HITTABLE_DAMAGE = 100;
local HITTABLE_IMMUNITY_TIME = 1.2;

function OnGameplayStart()
{
    g_isGauntletFinale = false;
}

/*
finale_start doesn't fire for Gauntlet finales, but this does. We use this instead of OnGameplayStart(),
because the trigger_finale does not exist until after the initial radio conversation,
and also because hittables do normal damage until this point.
*/
function OnGameEvent_finale_radio_start(params)
{
    if (NetProps.GetPropInt(Entities.FindByClassname(null, "trigger_finale"), "m_type") == 1)
    {
        g_isGauntletFinale = true;
    }
}

function AllowTakeDamage(damageTable)
{
    if (!damageTable.Attacker.IsValid() || !damageTable.Inflictor.IsValid() || !damageTable.Victim.IsValid())
    {
        return true;
    }
    if (!damageTable.Attacker.IsPlayer() || !damageTable.Victim.IsPlayer())
    {
        return true;
    }

    local inflictorClassname = damageTable.Inflictor.GetClassname();
    if (inflictorClassname == "prop_physics" || inflictorClassname == "prop_car_alarm")
    {
        if (damageTable.Attacker.GetZombieType() == 8) // Attacker is a Tank.
        {
            if (damageTable.Attacker == damageTable.Victim)
            {
                return false; // Prevent Tank self-harm.
            }
            else if (damageTable.Victim.IsSurvivor())
            {
                if (g_isGauntletFinale)
                {
                    damageTable.DamageDone = HITTABLE_DAMAGE * 4; // Hittable damage on Gauntlet finales is divided by 4 past where this function returns.
                }
                else
                {
                    damageTable.DamageDone = HITTABLE_DAMAGE;
                }
                if (damageTable.Victim in g_allowDamageTimestampTable)
                {
                    if ((g_allowDamageTimestampTable[damageTable.Victim] - Time()) > 0.0)
                    {
                        return false; // Not enough time has passed, prevent this damage.
                    }
                    else
                    {
                        g_allowDamageTimestampTable[damageTable.Victim] <- (Time() + HITTABLE_IMMUNITY_TIME)
                        return true;
                    }
                }
                else
                {
                    g_allowDamageTimestampTable[damageTable.Victim] <- (Time() + HITTABLE_IMMUNITY_TIME)
                    return true; // Allow this damage and prevent damage for HITTABLE_IMMUNITY_TIME seconds.
                }
            }
        }
    }

    return true; // Let the damage through if we make it this far.
}

Msg("Hittable Control: LOADED!\n");
