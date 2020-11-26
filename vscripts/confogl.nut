// Loaded into ::DirectorScript.MapScript.ChallengeScript
MutationOptions <-
{
  cm_ProhibitBosses = 0
 	cm_AllowPillConversion = 0
}


local pluginScopes = []
Hooks <- {
  function AllowBash(basher, bashee) {
    // Default to allow the bash.
    local retVal = true;
	  for ( local idx = pluginScopes.len(); idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
      local fn = pluginScopes[idx].AllowBash;
      if ( typeof (fn) == "function") {
        local res = fn(basher, bashee)
        // If any plugin returns false, we return false.
        if(res == false) {
          return false;
        }
      }
    }
  }
  // bool AllowFallenSurvivorItem(string classname)
  // Returns true or false if Fallen Survivors are allowed to carry the given classname.
  function AllowFallenSurvivorItem(classname) {
    Msg(format("DirectorOptions.AllowFallenSurvivorItem(%s)\n", classname));
    return true;
  }
  // bool AllowWeaponSpawn(string classname)
  // Returns true or false if the given classname is allowed to spawn, used by several mutations.
  function AllowWeaponSpawn(classname) {
    Msg(format("DirectorOptions.AllowWeaponSpawn(%s)\n", classname));
    return true;
  }
  // string ConvertWeaponSpawn(string classname)
  // Converts a weapon spawn of given classname to another, used by several mutations.
  function ConvertWeaponSpawn(classname) {
    Msg(format("DirectorOptions.ConvertWeaponSpawn(%s)\n", classname));
  }
  // int ConvertZombieClass(infectedClass)
  // Converts one spawn into another, used by the Taaannnk!! mutation (mutation19.nut).
  function ConvertZombieClass(infectedclass) {
    Msg(format("DirectorOptions.ConvertWeaponSpawn(%d)\n", infectedclass));
  }
  // string GetDefaultItem(index)
  // Repeatedly called with incrementing indices. 
  // Return a string of a weapon name to make it a default item for survivors, or 0 to end the iteration.
  function GetDefaultItem(index) {
    Msg(format("DirectorOptions.GetDefaultItem(%d)\n", index));
  }
  // bool ShouldAvoidItem(string classname)
  // To do: Probably a bot related function or spawn related
  function ShouldAvoidItem(classname) {
    Msg(format("DirectorOptions.ShouldAvoidItem(%s)\n", classname));
    return false;
  }
  // bool ShouldPlayBossMusic(index) 
  function ShouldPlayBossMusic(index) {
    Msg(format("DirectorOptions.ShouldPlayBossMusic(%d)\n", index));
    return true;
  }
}


function LoadPlugin(name) {
  Msg("Loading plugin " + name + "\n");
  local pluginTable = {};
  g_ModeScript[name] <- pluginTable;
  IncludeScript(name, pluginTable)
  __CollectGameEventCallbacks(pluginTable);
  pluginScopes.append(pluginTable)
}


LoadPlugin("confogl_no_spitter");

// Msg(format("ModeScript = this? %s\n", g_ModeScript == this ? "true" : "false"));
// Msg(format("ChallengeScript = this? %s\n", ::DirectorScript.MapScript.ChallengeScript == this ? "true" : "false"));
// Msg(format("ModeScript = ChallengeScript? %s\n", ::DirectorScript.MapScript.ChallengeScript == g_ModeScript ? "true" : "false"));
Msg("Confogl mutation is go!\n");



