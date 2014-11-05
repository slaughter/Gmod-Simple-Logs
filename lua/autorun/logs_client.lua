if SERVER then return end --Make sure the server does not try to run any lua in this file.

death_logs = {} --List that will hold all the information when player dies

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
	if LocalPlayer():IsAdmin() then --Only admins can open the logs.

		--Create the frame
		local frame = vgui.Create("DFrame")
		frame:SetSize(400, 400)
		frame:MakePopup()

		--Create the list to display the logs.
		local loglist = vgui.Create("DListView", frame)
		loglist:SetSize(frame:GetWide() - 10, frame:GetTall() - 30) --So you do not need to change values if you decide to change frame size.
		loglist:SetPos(5, 25)
		loglist:AddColumn( "Time" ):SetFixedWidth(60) --Just so the time column does not take up so much space.
		loglist:AddColumn( "Action" )

		for k, v in pairs(death_logs) do
			message = v['victim'] .. " was killed by " .. v['killer'] .. " with " .. v['weapon']
			loglist:AddLine(time_ago(v['timestamp']), message) --Add an entry to the list view containing the time and message.
		end


	else
		print("Insufficient permissions.") --This will print if the user is not an admin.
	end

	
end
concommand.Add("fgh_logs", menu)