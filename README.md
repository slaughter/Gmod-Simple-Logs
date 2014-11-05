#_**Simple Gmod Logs**_
####By fghdx
---

A simple Gmod logging system with highly commented code so it can easily be edited to your specifications. It can also be
a very good resource learn from if you're planning to make a logging system. This addon will work in any gamemode.

##How to use:
To use simply [download the ZIP](https://github.com/fghdx/Gmod-Simple-Logs/archive/master.zip) and extract into `garrysmod/garrysmod/addons` folder. To open the logs use the console command `fgh_logs`. If you want to bind it to a key use
`bind [key] fgh_logs`.

##ScreenShots:
Deaths:

![Death Logs](http://i.fghdx.me/f0bf5.png "Death Logs")




Damage:

![Damage Logs](http://i.fghdx.me/b609e.png "Damage Logs")

Props:

![Prop Logs](http://i.fghdx.me/e7561.png "Prop Logs")



##How to add diffent events to the logs?
To add new logs you just need to create the a function in `logs_server.lua` with the event hook attached to it. For example when a player dies it calls the function `PlayerDeath`, when a player gets hurt it calls `PlayerHurt`, and when a prop is spawned `PlayerSpawnProp`.

Looking at the code should make it fairly obvious. You need to follow a template such as:
```
--Function called when player spawns a prop.
function player_spawn_prop( ply, model )
	player_name = ply:Name()
	time = os.time() --Get the time of the event

umsg.Start( "player_spawn_info" );------------------------
		umsg.String(player_name)-----------------------------
		umsg.String(model)------------Sending the Data to 
		umsg.Long(time)---------------be recieved by client
	umsg.End();----------------------------------------------
end
hook.Add("PlayerSpawnProp", "playerSpawnProp", player_spawn_prop)
```

As you can see it has the hook for "PlayerSpawnProp" so it is called when ever a player spawns a prop. Say you wanted to log when ever a player disconnected. Your function would look something like this:
```
function player_disconnect( ply ) --PlayerDisconnected takes one parameter to get the player information.
    
    --You're going to want to send the information to the client.
    umsg.Start("player_disconnect")
        umsg.Sring(ply:Name())
        umsg.Long(os.time()) -- You need to send the timestamp
    umsg.End();
end
hook.Add("PlayerDisconnected", "playerDisconnected", player_disconnect)
```

Now that we have a function that is called when the player disconnects and we have sent the information to the client, we need to recieve it and then create a new tab on our derma vgui.

Now in `logs_client.lua` create an empty table on line 15 with `disconnect_logs = {}`

Then make a new function to recieve the data from the server and populate the list. On line 85 make a function like so:
```
function player_die_info( data )

	player_name = data:ReadString() --Read the fist string send it usermessage.
	timestamp = data:ReadLong() --Read the first long in usermessage
    
    --Inserting the data to the table.
	table.insert(disconnect_logs, {player_name = player_name, timestamp = timestamp})


end
usermessage.Hook( "player_disconnect", player_die_info );

```

Now we can recieve the data sent from the server lets add a tab to our vgui. On line 180 you are going to want to add a DListView to add to the PropertySheet.
```
		--Create the list to display disconnet logs
		local loglist_disconnect = vgui.Create("DListView")
		loglist_disconnect:SetSize(tabs:GetWide() - 10, tabs:GetTall() - 50)
		loglist_disconnect:SetPos(5, 50)
		loglist_disconnect:AddColumn( "Time" ):SetFixedWidth(60) 

		for i = #prop_logs, 1, -1 do --Iterate through the list in reverse so most recent items are at the top.
		  v = prop_logs[i]
			message = v['player_name'] .. " has disconnected."
			loglist_disconnect:AddLine(time_ago(v['timestamp']), message) --Add an entry to the list view containing the info
		end
```

Now you want to add that to the propery sheet. Line 206.
`tabs:AddSheet( "Disconnect", loglist_disconnect, false, false, "Disconnected Players Log" )`

And then you're done. That was easy, wasn't it?
