if CLIENT then return end
print("Logs Server Loaded")
-- Function to call when a player dies.

--new timestamp - old timestamp = time in seconds past since event

function player_die( victim, inflictor, killer)

	player_name = victim:Name()
	weapon = inflictor:GetClass()
	killer_name = killer:Name()
	time = os.time()

	umsg.Start( "player_die_info" );
	umsg.String(player_name)
	umsg.String(killer_name)
	umsg.String(weapon)
	umsg.Long(time)
	umsg.End();


end
hook.Add( "PlayerDeath", "playerDeath", player_die )
