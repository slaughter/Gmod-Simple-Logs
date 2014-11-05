if CLIENT then return end --Make sure the client does not try to run any lua in this file.

-- Function to call when a player dies.
function player_die( victim, inflictor, killer)

	player_name = victim:Name() --Get the Vicims name
	weapon = inflictor:GetName() --Get the weapon the victim was killed with
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

-- Function to call when a player takes damage
function player_take_damage( victim, attacker, healthLeft, damageTaken )
	if attacker:IsPlayer() then --Make sure player is hurt by another player, rather than the world or console.
		player_name = victim:Name() --Get the Vicims name
		attacker = attacker:Name() --Get attackers name
		damage = damageTaken --Get the damage Dealt
		time = os.time() --Get the time of the event

		umsg.Start( "player_hurt_info" );------------------------
			umsg.String(player_name)-----------------------------
			umsg.String(attacker)-----------Sending the Data to 
			umsg.Long(damage)---------------be recieved by client
			umsg.Long(time)--------------------------------------
		umsg.End();----------------------------------------------
	end
end
hook.Add( "PlayerHurt", "playerHurt", player_take_damage )
