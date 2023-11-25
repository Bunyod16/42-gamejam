extends Control

var peer = ENetMultiplayerPeer.new() #Creates peer
@export var player_scene: PackedScene #You Also have to link the player scence to this

#Handles host button
func _on_host_pressed():
	_handle_disbale_join() #Disables join button
	
	peer.create_server(8080) #Creates server with max 4 players
	multiplayer.multiplayer_peer = peer #Set multiplayer peer to the recently connected peer
	multiplayer.peer_connected.connect(_add_player) #Adds callback function whenever any player connects to server
	_add_player() #this is for the host process to run add_player on join
	
	var ip_address = _get_address()
	_handle_ip_popup(ip_address) #Shows popup window

	print("HOST IP:" + ip_address)

#Handles join button
func _on_join_pressed():
	_handle_disable_host() #Disables host button
	_show_ip_input() #Show Ip Input Popup

#=================================#
#=============UTILS===============#
#=================================#

#Adds player to scene
func _add_player(id = 1):
	var player = player_scene.instantiate() #Instantiate player
	player.name = str(id) #Set player name to id
	call_deferred("add_child", player) #Add player to scene
	
#Returs host ip address
func _get_address():
	for address in IP.get_local_addresses():
		if address.find(":") >= 0:
			continue
		if address == "127.0.0.1":
			continue
		return address
		
#Popsup IP UI 
func _handle_ip_popup(ip_address: String):
	$IpPopup.visible = true #sets Ip Popup to true
	$IpPopup.text = "Your IP:" + ip_address

#Handle disbaling host buttona after join is pressed
func _handle_disable_host():
	$MainMenuVContainer/Host.disabled = true

#Handle disabling join button after host is pressed
func _handle_disbale_join():
	$MainMenuVContainer/Join.disabled = true

#Handles getting ip from user input
func _show_ip_input():
	$IpInput.grab_focus() #Auto focus text box
	$IpInput.visible = true

#Handles testing input field for regex
func _on_ip_input_text_submitted(new_text):
	var ip: String = new_text as String

	if (ip.is_valid_ip_address()):
		_connect_player_to_ip(ip)
	else:
		pass

func _connect_player_to_ip(ip: String):
	if (peer.create_client(ip, 8080) == OK): #Join as client to "ip", port
		print("IP OK: "+ ip)
		$IpInput.visible = false
		multiplayer.multiplayer_peer = peer #Set multiplayer peer to the recently connected peer
	else:
		print("IP NOT OK")
