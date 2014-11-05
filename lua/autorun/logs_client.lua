--[[
	
	Simple logs. Made by fghdx.
	https://github.com/fghdx/Gmod-Simple-Logs/
	fghdx.me

]]--

if SERVER then return end --Make sure the server does not try to run any lua in this file.

--Add tables Here--
death_logs = {} --List that will hold all the information when player dies
damage_logs = {} --List that will hold all the information when player gets hurt
prop_logs = {} --List that will hold all the information when player spawns a prop
--[[
	EXAMPLE:
	TABLE_NAME = {}
]]


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

	--See line 24
	table.insert(damage_logs, {victim = victim, attacker = attacker, damage = damage, timestamp = timestamp})

end
usermessage.Hook( "player_hurt_info", player_hurt_info );

function player_spawn_info( data )

	player_name = data:ReadString() ------------------------
	prop = data:ReadString() --Reading information From the user
	timestamp = data:ReadLong() ------Message sent from the server

	--See line 24
	table.insert(prop_logs, {player_name = player_name, prop = prop, timestamp = timestamp})

end
usermessage.Hook( "player_spawn_info", player_spawn_info );

------------------------------------------------------
------------------ADD NEW HOOKS HERE------------------
------------------------------------------------------

--[[
	EXAMPLE:
	function function_name( data )

		variable = data:ReadString()
		timestamp = data:ReadLong()

		table.insert(TABLE_NAME, {variable = variable, timestamp = timestamp})

	end
	usermessage.Hook( "USERMESSAGE_NAME", function_name );


]]



-------------------------------------------------------
-------------------------------------------------------



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
		
		--Create the list to display damage logs
		local loglist_props = vgui.Create("DListView")
		loglist_props:SetSize(tabs:GetWide() - 10, tabs:GetTall() - 50) --So you do not need to change values if you decide to change frame size.
		loglist_props:SetPos(5, 50)
		loglist_props:AddColumn( "Time" ):SetFixedWidth(60) --Just so the time column does not take up so much space.
		loglist_props:AddColumn( "Action" )

		for i = #prop_logs, 1, -1 do --Iterate through the list prop_logs in reverse so most recent items are at the top.
		  v = prop_logs[i]
			message = v['player_name'] .. " spawned " .. v['prop']
			loglist_props:AddLine(time_ago(v['timestamp']), message) --Add an entry to the list view containing the time and message.
		end
		
		------------------------------------------------------
		------------------ADD NEW LISTS HERE------------------
		------------------------------------------------------
		
		--[[
			EXAMPLE:
			local loglist_EXAMPLE = vgui.Create("DListView")
			loglist_EXAMPLE:SetSize(tabs:GetWide() - 10, tabs:GetTall() - 50) 
			loglist_EXAMPLE:SetPos(5, 50)
			loglist_EXAMPLE:AddColumn( "Time" ):SetFixedWidth(60) 
			loglist_EXAMPLE:AddColumn( "Action" )

			for i = #prop_logs, 1, -1 do
			  v = prop_logs[i]
				message = v['variable']
				loglist_EXAMPLE:AddLine(time_ago(v['timestamp']), message) 
			end
		]]	




		------------------------------------------------------
		------------------ADD NEW TABS HERE-------------------
		------------------------------------------------------

		tabs:AddSheet( "Deaths", loglist_deaths, false, false, "Death Logs" )
		tabs:AddSheet( "Damage", loglist_damage, false, false, "Damage Logs" )
		tabs:AddSheet( "Props", loglist_props, false, false, "Prop Logs" )
		
		--[[
			EXAMPLE:
			tabs:AddSheet( "NAME:", LISTNAME, false, false, "TOOLTIP" )

		]]

		------------------------------------------------------
		-------------------------------------------------------

	else
		print("Insufficient permissions.") --This will print if the user is not an admin.
	end

	
end
concommand.Add("fgh_logs", menu)