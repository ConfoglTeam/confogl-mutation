local isGauntletFinale = false;
local allowDamageTimestampTable = {};
local hittableDamage = 100;
local hittableImmunityTime = 1.2;

 // finale_start doesn't fire for Gauntlet finales, but this does. We can't use OnGameplayStart(),
 // because the trigger_finale does not exist until after the initial radio conversation.
function OnGameEvent_finale_radio_start(params)
{
    if (NetProps.GetPropInt(Entities.FindByClassname(null, "trigger_finale"), "m_type") == 1)
    {
        isGauntletFinale = true;
    }
}

function AllowTakeDamage(damageTable)
{
    if (!damageTable.Attacker.IsValid() || !damageTable.Inflictor.IsValid() || !damageTable.Victim.IsValid())
    {
        return true;
    }
    else if (!damageTable.Attacker.IsPlayer() || !damageTable.Victim.IsPlayer())
    {
        return true;
    }

    if (damageTable.Inflictor != null)
    {
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
                    if (isGauntletFinale)
                    {
                        damageTable.DamageDone = hittableDamage * 4; // Hittable damage on Gauntlet finales is divided by 4 past where this function returns.
                    }
                    else
                    {
                        damageTable.DamageDone = hittableDamage;
                    }
                    if (damageTable.Victim in allowDamageTimestampTable)
                    {
                        if ((allowDamageTimestampTable[damageTable.Victim] - Time()) > 0.0)
                        {
                            return false; // Not enough time has passed, prevent this damage.
                        }
                        else
                        {
                            allowDamageTimestampTable[damageTable.Victim] <- (Time() + hittableImmunityTime)
                            return true;
                        }
                    }
                    else
                    {
                        allowDamageTimestampTable[damageTable.Victim] <- (Time() + hittableImmunityTime)

                        return true; // Allow this damage and prevent damage for hittableImmunityTime seconds.
                    }
                }
            }
        }
    }

    return true; // Let the damage through if we make it this far.
}

Msg("Hittable Control: LOADED!\n");
