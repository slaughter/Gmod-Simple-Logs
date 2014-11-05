if SERVER then return end --Make sure the server does not try to run any lua in this file.

death_logs = {} --List that will hold all the information when player dies
damage_logs = {} --List that will hold all the information when player gets hurt

function player_die_info( data )

	victim = data:ReadString() ------------------------
	killer = data:ReadString() -----Reading information From the user
	weapon = data:ReadString() -----Message sent from the server
	timestamp = data:ReadLong() -----------------------

	table.insert(death_logs, {victim = victim, killer = killer, weapon = weapon, timestamp = timestamp})
	--[[
		The above line inserts a table containing all the information from the players death that we will
		need to display in our list view into the death_logs table.
		
		It will look something like this:

		death_logs{
			1 	{
					victim = "Bob",
					killer = "Jim",
					weapon = "gun",
					timestamp = *timestamp*
				},

			2 	{
					victim = "Jim"
					killer = "Bob"
					weapon = "gun"
					timestamp = *timestamp*
				}
			
		}

	]]

end
usermessage.Hook( "player_die_info", player_die_info );

function player_hurt_info( data )

	victim = data:ReadString() ------------------------
	attacker = data:ReadString() --Reading information From the user
	damage = data:ReadLong() ------Message sent from the server
	timestamp = data:ReadLong() -----------------------

	--See line 14
	table.insert(damage_logs, {victim = victim, attacker = attacker, damage = damage, timestamp = timestamp})

end
usermessage.Hook( "player_hurt_info", player_hurt_info );


--This function is used to calculate the time that has passed since
--the event has happened.
--It takes the timestamp we saved to our deaths_logs as a parameter
--and returns a value either "x Secs", "x Mins", or "x Hours"
function time_ago( timestamp )
		timeago = os.time() - timestamp
		if timeago < 60 then
			timeago = timeago .. " Secs"
		elseif timeago > 3600 then
			timeago = math.Round(timeago / 60) .. " Hours"
		else
			timeago = math.Round(timeago / 60) .. " Mins"
		end
		return timeago
end

--Create the derma menu.
function menu()
	if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then --Only admins can open the logs.

		--Create the frame
		local frame = vgui.Create("DFrame")
		frame:SetSize(400, 400)
		frame:SetTitle("Simple Logs | fghdx.me")
		frame:MakePopup()
		
		local tabs = vgui.Create( "DPropertySheet", frame )
		tabs:SetPos( 5, 30 )
		tabs:SetSize( frame:GetWide() - 10, frame:GetTall() - 35 )
	
		--Create the list to display the logs.
		local loglist_deaths = vgui.Create("DListView")
		loglist_deaths:SetSize(tabs:GetWide() - 10, tabs:GetTall() - 50) --So you do not need to change values if you decide to change frame size.
		loglist_deaths:SetPos(5, 50)
		loglist_deaths:AddColumn( "Time" ):SetFixedWidth(60) --Just so the time column does not take up so much space.
		loglist_deaths:AddColumn( "Action" )

		for i = #death_logs, 1, -1 do --Iterate through the list death_logs in reverse so most recent items are at the top.
		  v = death_logs[i]
			message = v['victim'] .. " was killed by " .. v['killer'] .. " with " .. v['weapon']
			loglist_deaths:AddLine(time_ago(v['timestamp']), message) --Add an entry to the list view containing the time and message.
		end

		--Create the list to display damage logs
		local loglist_damage = vgui.Create("DListView")
		loglist_damage:SetSize(tabs:GetWide() - 10, tabs:GetTall() - 50) --So you do not need to change values if you decide to change frame size.
		loglist_damage:SetPos(5, 50)
		loglist_damage:AddColumn( "Time" ):SetFixedWidth(60) --Just so the time column does not take up so much space.
		loglist_damage:AddColumn( "Action" )

		for i = #damage_logs, 1, -1 do --Iterate through the list damage_logs in reverse so most recent items are at the top.
		  v = damage_logs[i]
			message = v['victim'] .. " was hurt by " .. v['attacker'] .. " for " .. v['damage']
			loglist_damage:AddLine(time_ago(v['timestamp']), message) --Add an entry to the list view containing the time and message.
		end
						 
		tabs:AddSheet( "Deaths", loglist_deaths, false, false, "Death Logs" )
		tabs:AddSheet( "Damage", loglist_damage, false, false, "Damage Logs" )

	else
		print("Insufficient permissions.") --This will print if the user is not an admin.
	end

	
end
concommand.Add("fgh_logs", menu)