if CLIENT then return end --Make sure the client does not try to run any lua in this file.

-- Function to call when a player dies.
function player_die( victim, inflictor, killer)

	player_name = victim:Name() --Get the Vicims name
	weapon = inflictor:GetClass() --Get the weapon the victim was killed with
	killer_name = killer:Name() --Get killers name
	time = os.time() --Get the time the player died

	umsg.Start( "player_die_info" );-------------------------
		umsg.String(player_name)-----------------------------
		umsg.String(killer_name)--------Sending the Data to 
		umsg.String(weapon)-------------be recieved by client
		umsg.Long(time)--------------------------------------
	umsg.End();----------------------------------------------


end
hook.Add( "PlayerDeath", "playerDeath", player_die )
