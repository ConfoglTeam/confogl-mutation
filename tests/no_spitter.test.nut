nospitter <- {}

EventScopes.push(nospitter);
IncludeScript("vscripts/confogl_no_spitter.nut", nospitter);


print("TEST: Spitter limit set to 0 after tank spawns\n");
expect(Convars.GetFloat("z_spitter_limit") == 1.0, "spitter limit 1 before tank");
FireGameEvent("tank_spawn", {});
expect(Convars.GetFloat("z_spitter_limit") == 0, "spitter limit 0 during tank");
FireGameEvent("tank_killed", {});
expect(Convars.GetFloat("z_spitter_limit") == 1.0, "spitter limit 1 after tank dies");


print("TEST: Spitter limit reverts to whatever previous limit\n");
Convars.SetValue("z_spitter_limit", 2.0);

IncludeScript("vscripts/confogl_no_spitter.nut", nospitter);

expect(Convars.GetFloat("z_spitter_limit") == 2.0, "spitter limit 2 before tank");
FireGameEvent("tank_spawn", {});
expect(Convars.GetFloat("z_spitter_limit") == 0, "spitter limit 0 during tank");
FireGameEvent("tank_killed", {});
expect(Convars.GetFloat("z_spitter_limit") == 2.0, "spitter limit 2 after tank");

EventScopes.pop();