// Loaded into ::DirectorScript.MapScript.ChallengeScript
MutationOptions <-
{
  cm_ProhibitBosses = 0
 	cm_AllowPillConversion = 0
}

function LoadPlugin(name) {
  Msg("Loading plugin " + name + "\n");
  local pluginTable = {};
  g_ModeScript[name] <- pluginTable;
  IncludeScript(name, pluginTable)
  __CollectEventCallbacks(pluginTable, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}


LoadPlugin("confogl_no_spitter");

// Msg(format("ModeScript = this? %s\n", g_ModeScript == this ? "true" : "false"));
// Msg(format("ChallengeScript = this? %s\n", ::DirectorScript.MapScript.ChallengeScript == this ? "true" : "false"));
// Msg(format("ModeScript = ChallengeScript? %s\n", ::DirectorScript.MapScript.ChallengeScript == g_ModeScript ? "true" : "false"));
Msg("Confogl mutation is go!\n");



