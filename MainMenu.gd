extends Control

const PORT = 25564
var peer
@export var player_scene: PackedScene #You Also have to link the player scence to this

func _ready():
	#Callback functions for certain event listeneres
	connect("mouse_entered", _on_mouse_entered);
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.connected_to_server.connect(connected_to_server)

#Handles host button
func _on_host_pressed():
	var ip_address = _get_address()
	
	#Hides ui elemnts
	$MarginContainer/MainMenuVContainer/Host.visible = false
	$MarginContainer/MainMenuVContainer/Join.visible = false
	$MarginContainer/MainMenuVContainer/Start.visible = true
	$IpPopup.visible = true
	$IpPopup.text = "Your IP:" + ip_address
	
	#sets peer for connection
	peer = ENetMultiplayerPeer.new() 
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	#Send host information
	print("host unique id"+  str(multiplayer.get_unique_id()))
	GameManager.send_player_information(multiplayer.get_unique_id(), "name", 3)
	
	print("HOST IP:" + ip_address)

#Handles join button
func _on_join_pressed():
	#Hides ui elements
	$MarginContainer/MainMenuVContainer/Host.disabled = true
	$IpInput.visible = true
	$IpInput.grab_focus() #Auto focus text box
	
@rpc("any_peer", "call_local")
func _on_start_pressed():
	start_game.rpc()
	

func _on_mouse_entered():
	$AudioStreamPlayer.play()


#=================================#
#=============UTILS===============#
#=================================#

func peer_connected(id):
	print("Peer Connected:" + str(id))

func connected_to_server():
	print("Peer Connected To Server")
	#Send Player Information
	GameManager.send_player_information.rpc_id(1, multiplayer.get_unique_id(), "name", 3)

#Adds player to scene
#func _add_player(id = 1):
#	var player = player_scene.instantiate() #Instantiate player
#	player.name = str(id) #Set player name to id
#	call_deferred("add_child", player) #Add player to scene
	
#Returs host ip address
func _get_address():
	for address in IP.get_local_addresses():
		if address.find(":") >= 0:
			continue
		if address == "127.0.0.1":
			continue
		return address

#Handles testing input field for regex
func _on_ip_input_text_submitted(new_text):
	var ip: String = new_text as String

	if (ip.is_valid_ip_address()):
		_connect_player_to_ip(ip)
	else:
		pass

func _connect_player_to_ip(ip: String):
	peer = ENetMultiplayerPeer.new()
	if (peer.create_client(ip, PORT) == OK): #Join as client to "ip", port
		print("IP OK: " + ip)
		
		#Hides ui elemnt
		$IpInput.visible = false
		$MarginContainer/MainMenuVContainer/Host.visible = false
		$MarginContainer/MainMenuVContainer/Join.visible = false
		$WaitingForHost.visible = true
		
		#sets peer for connection
		multiplayer.multiplayer_peer = peer #Set multiplayer peer to the recently connected peer
	else:
		print("IP NOT OK")

#Remote procedure calls
#Handles calling function from any file to send to any other file
#Basically handles signals from any peer to any other peer
@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://world.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
