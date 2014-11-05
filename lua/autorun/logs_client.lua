if SERVER then return end
print("Logs Client Loaded")


death_logs = {}

function player_die_info( data )

	victim = data:ReadString()
	killer = data:ReadString()
	weapon = data:ReadString()
	timestamp = data:ReadLong()
	table.insert(death_logs, {victim = victim, killer = killer, weapon = weapon, timestamp = timestamp})
end
usermessage.Hook( "player_die_info", player_die_info );


--[[



]]

function time_ago( timestamp )
		timeago = (os.time() - timestamp) / 2
		if timeago < 60 then
			timeago = timeago .. " Secs"
		elseif timeago > 3600 then
			timeago = (timeago / 60) .. " Hours"
		else
			timeago = timeago .. " Mins"
		end
		return timeago
end

function menu()
	if LocalPlayer():IsAdmin() then

		local frame = vgui.Create("DFrame")
		frame:SetSize(400, 400)
		frame:MakePopup()

		local loglist = vgui.Create("DListView", frame)
		loglist:SetSize(frame:GetWide() - 10, frame:GetTall() - 30)
		loglist:SetPos(5, 25)
		loglist:AddColumn( "Time" )
		loglist:AddColumn( "Action" )
		loglist:ColumnWidth(102)

		for k, v in pairs(death_logs) do
			message = v['victim'] .. " was killed by " .. v['killer'] .. " with " .. v['weapon']
			loglist:AddLine(time_ago(v['timestamp']), message)
		end


	else
		print("Insufficient permissions.")
	end

	
end
concommand.Add("fgh_logs", menu)