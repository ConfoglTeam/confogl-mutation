// Loaded into ::DirectorScript.MapScript.ChallengeScript
MutationOptions <-
{
  cm_ProhibitBosses = 0
  cm_AllowPillConversion = 0
}

local pluginScopes = []

// int AllowBash(handle basher, handle bashee): called whenever melee bash is used.
// Returns these values:
// ALLOW_BASH_ALL - normal melee behavior
// ALLOW_BASH_NONE - do nothing at all
// ALLOW_BASH_PUSHONLY - applies physics push but deals no damage (including prevention of insta-kill ambush behavior)
function AllowBash(basher, bashee) {
  Msg(format("AllowBash(%s, %s)\n", basher.tostring(), bashee.tostring()));
  // Default to allow the bash.
  local retVal = ALLOW_BASH_ALL;
  for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
    local nextPlugin = pluginScopes[idx];
    if ("AllowBash" in pluginScopes[idx]) {
	  local fn = pluginScopes[idx].AllowBash;
	  if ( typeof (fn) == "function" ) {
	    local res = fn(basher, bashee)
	    // If any plugin returns ALLOW_BASH_NONE, we return ALLOW_BASH_NONE.
	    if(res == ALLOW_BASH_NONE) {
		  return ALLOW_BASH_NONE;
	    }
	    // If any plugin returns ALLOW_BASH_PUSHONLY, we return ALLOW_BASH_PUSHONLY.
	    if(res == ALLOW_BASH_PUSHONLY) {
		  return ALLOW_BASH_PUSHONLY;
	    }
	  }
    }
  }
  return retVal;
}
// bool AllowTakeDamage(table damageTable): Adding a function with this name in the script causes C++ to call it on all damage events.
// The damageTable is actually defined in scriptedmode.nut and filled in as appropriate before each call.
function AllowTakeDamage(damageTable) {
  Msg(format("AllowTakeDamage(%s)\n", damageTable.tostring()));
  // Default to allow the damage.
  local retVal = true;
  for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
    local nextPlugin = pluginScopes[idx];
    if ("AllowTakeDamage" in pluginScopes[idx]) {
	  local fn = pluginScopes[idx].AllowTakeDamage;
	  if ( typeof (fn) == "function" ) {
	    local res = fn(damageTable)
	    // If any plugin returns false, we return false.
	    if(res == false) {
		  return false;
	    }
	  }
    }
  }
  return retVal;
}
// bool BotQuery(int queryflag, handle entity, bool defaultvalue): Hook to control survivor bot behavior.
// Only one known flag is supported.
// BOT_QUERY_NOTARGET - Fired when a bot wants to bash a prop. Returning false disallows the bashing.
function BotQuery(queryflag, entity, defaultvalue) {
  Msg(format("BotQuery(%d, %s, %s)\n", queryflag, entity.tostring(), defaultvalue));
  // Default to allow the bash.
  local retVal = true;
  for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
    local nextPlugin = pluginScopes[idx];
    if ("BotQuery" in pluginScopes[idx]) {
	  local fn = pluginScopes[idx].BotQuery;
	  if ( typeof (fn) == "function" ) {
	    local res = fn(queryflag, entity, defaultvalue)
	    // If any plugin returns false, we return false.
	    if(res == false) {
		  return false;
	    }
	  }
    }
  }
  return retVal;
}
// bool CanPickupObject(handle object): Hook function for deciding whether a given prop should be pickupable (HL2 style).
// Returning true makes the players able to pick up the object.
// Only functional for server side props. If this is defined it must return true in order the PickupObject() function to work. 
function CanPickupObject(object) {
  Msg(format("CanPickupObject(%s)\n", object.tostring()));
  // Default to disallow the pickup.
  local retVal = false;
  for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
    local nextPlugin = pluginScopes[idx];
    if ("CanPickupObject" in pluginScopes[idx]) {
	  local fn = pluginScopes[idx].CanPickupObject;
	  if ( typeof (fn) == "function" ) {
	    local res = fn(object)
	    // If any plugin returns true, we return true.
	    if(res == true) {
		  return true;
	    }
	  }
    }
  }
  return retVal;
}
// void InterceptChat(string message, CTerrorPlayer speaker): If you put a function with this name in your script, C++ will call it on all chat messages. Passing in the (annotated) chat string and the handle of the speaker.
// If the function returns false, it will prevent other players from seeing the chat message except for the player who entered it. 
function InterceptChat(message, speaker) {
  Msg(format("InterceptChat(%s, %s)\n", message, speaker.tostring()));
  // Default to allow the message to be seen by other players.
  local retVal = true;
  for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
    local nextPlugin = pluginScopes[idx];
    if ("InterceptChat" in pluginScopes[idx]) {
	  local fn = pluginScopes[idx].InterceptChat;
	  if ( typeof (fn) == "function" ) {
	    local res = fn(message, speaker)
	    // If any plugin returns false, we return false.
	    if(res == false) {
		  return false;
	    }
	  }
    }
  }
  return retVal;
}
// void UserConsoleCommand(handle playerScript, arg): when a user does a <scripted_user_func argument> at console (or bound to a key) this function is called (if it exists).
// The playerscript is which players console it came from. You can pass strings or whatever, of course. So could do a switch statement off <arg> to give players special controls, etc. 
function UserConsoleCommand(playerScript, arg) {
  Msg(format("UserConsoleCommand(%s)\n", playerScript.tostring()));
  // Default to allow the command(? Does returning false do anything special for this function?).
  local retVal = true;
  for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
    local nextPlugin = pluginScopes[idx];
    if ("UserConsoleCommand" in pluginScopes[idx]) {
	  local fn = pluginScopes[idx].UserConsoleCommand;
	  if ( typeof (fn) == "function" ) {
	    local res = fn(playerScript, arg)
	    // If any plugin returns false, we return false.
	    if(res == false) {
		  return false;
	    }
	  }
    }
  }
  return retVal;
}

DirectorOptions <- {
  // bool AllowFallenSurvivorItem(string classname)
  // Returns true or false if Fallen Survivors are allowed to carry the given classname.
  function AllowFallenSurvivorItem(classname) {
    Msg(format("DirectorOptions.AllowFallenSurvivorItem(%s)\n", classname));
	// Default to disallow carrying the classname.
    local retVal = false;
	for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
	  if ("DirectorOptions" in pluginScopes[idx]) {
		if ("AllowFallenSurvivorItem" in pluginScopes[idx].DirectorOptions) {
		  local fn = pluginScopes[idx].DirectorOptions.AllowFallenSurvivorItem;
		  if ( typeof (fn) == "function" ) {
		    local res = fn(classname)
		    // If any plugin returns true, we return true.
		    if(res == true) {
		      return true;
		    }
		  }
	    }
	  }
    }
	return retVal;
  }
  // bool AllowWeaponSpawn(string classname)
  // Returns true or false if the given classname is allowed to spawn, used by several mutations.
  function AllowWeaponSpawn(classname) {
    Msg(format("DirectorOptions.AllowWeaponSpawn(%s)\n", classname));
    // Default to allow spawning the classname.
    local retVal = true;
	for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
	  if ("DirectorOptions" in pluginScopes[idx]) {
	    if ("AllowWeaponSpawn" in pluginScopes[idx].DirectorOptions) {
	      local fn = pluginScopes[idx].DirectorOptions.AllowWeaponSpawn;
	      if ( typeof (fn) == "function" ) {
		    local res = fn(classname)
		    // If any plugin returns false, we return false.
		    if(res == false) {
		      return false;
		    }
		  }
	    }
	  }
    }
	return retVal;
  }
  // string ConvertWeaponSpawn(string classname)
  // Converts a weapon spawn of given classname to another, used by several mutations.
  function ConvertWeaponSpawn(classname) {
    Msg(format("DirectorOptions.ConvertWeaponSpawn(%s)\n", classname));
	// Default to no conversion.
    local retVal = 0;
	for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
	  if ("DirectorOptions" in pluginScopes[idx]) {
	    if ("ConvertWeaponSpawn" in pluginScopes[idx].DirectorOptions) {
          local fn = pluginScopes[idx].DirectorOptions.ConvertWeaponSpawn;
          if ( typeof (fn) == "function" ) {
            local res = fn(classname)
		    // If any plugin overrides this function, we return its return value.
		    return res;
          }
		}
	  }
    }
	return retVal;
  }
  // int ConvertZombieClass(infectedClass)
  // Converts one spawn into another, used by the Taaannnk!! mutation (mutation19.nut).
  function ConvertZombieClass(infectedClass) {
    Msg(format("DirectorOptions.ConvertZombieClass(%d)\n", infectedClass));
	// Default to no conversion.
    local retVal = 0;
	for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
	  if ("DirectorOptions" in pluginScopes[idx]) {
	    if ("ConvertZombieClass" in pluginScopes[idx].DirectorOptions) {
          local fn = pluginScopes[idx].DirectorOptions.ConvertZombieClass;
          if ( typeof (fn) == "function" ) {
		    local res = fn(infectedClass);
			// If any plugin overrides this function, we return its return value.
            return res;
          }
	    }
	  }
    }
	return retVal;
  }
  // string GetDefaultItem(index)
  // Repeatedly called with incrementing indices. 
  // Return a string of a weapon name to make it a default item for survivors, or 0 to end the iteration.
  function GetDefaultItem(index) {
    Msg(format("DirectorOptions.GetDefaultItem(%d)\n", index));
	// Default to ending iteration.
    local retVal = 0;
	for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
	  if ("DirectorOptions" in pluginScopes[idx]) {
	    if ("GetDefaultItem" in pluginScopes[idx].DirectorOptions) {
          local fn = pluginScopes[idx].DirectorOptions.GetDefaultItem;
          if ( typeof (fn) == "function" ) {
            local res = fn(index)
		    // If any plugin overrides this function, we return its return value.
		    return res;
          }
	    }
	  }
    }
	// We don't want to take away the default single pistol if no plugins override this function.
	if (index == 0) {
	  return "weapon_pistol"
	}
	return retVal;
  }
  // bool ShouldAvoidItem(string classname)
  // To do: Probably a bot related function or spawn related
  // Yep, survivor bots avoid picking up items when this returns true.
  function ShouldAvoidItem(classname) {
    Msg(format("DirectorOptions.ShouldAvoidItem(%s)\n", classname));
    // Default to no avoidance.
    local retVal = false;
	for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
	  if ("DirectorOptions" in pluginScopes[idx]) {
	    if ("ShouldAvoidItem" in pluginScopes[idx].DirectorOptions) {
          local fn = pluginScopes[idx].DirectorOptions.ShouldAvoidItem;
          if ( typeof (fn) == "function" ) {
            local res = fn(classname)
		    // If any plugin returns true, we return true.
            if(res == true) {
              return true;
            }
          }
		}
	  }
    }
	return retVal;
  }
  // bool ShouldPlayBossMusic(index)
  // Returns true or false if the music index is allowed to play. 
  function ShouldPlayBossMusic(index) {
    Msg(format("DirectorOptions.ShouldPlayBossMusic(%d)\n", index));
    // Default to playing boss music.
    local retVal = true;
	for ( local idx = pluginScopes.len() - 1; idx >= 0; --idx ) {
      local nextPlugin = pluginScopes[idx];
	  if ("DirectorOptions" in pluginScopes[idx]) {
	    if ("ConvertZombieClass" in pluginScopes[idx].DirectorOptions) {
          local fn = pluginScopes[idx].DirectorOptions.ShouldPlayBossMusic;
          if ( typeof (fn) == "function" ) {
            local res = fn(index)
		    // If any plugin returns false, we return false.
            if(res == false) {
              return false;
            }
          }
		}
	  }
    }
	return retVal;
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



