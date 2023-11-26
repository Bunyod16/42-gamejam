extends Node

var Players = {}
var Teams = { "1": { "total_gold": 0 }, "2": { "total_gold": 0 } }

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer")
func send_player_information(id, name, health, update=false):
	if not GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"health": health,
			"gold": 0,
			"collected_gold": 0
		}
	else:
		if update:
			print("UPDATED")
			GameManager.Players[id].health = health

	if multiplayer.is_server():
		print("SERVER SENDING TO CLIENTS")
		for i in GameManager.Players:
			print("i:" + str(i))
			send_player_information.rpc(i, GameManager.Players[i].name, GameManager.Players[i].health)


@rpc("any_peer")
func update_player_information(id, name, health, gold, collected_gold):
	if GameManager.Players.has(id):
		if (GameManager.Players[id].health == health and 
			GameManager.Players[id].gold == gold and 
			GameManager.Players[id].collected_gold == collected_gold):
			return
		else:
			GameManager.Players[id].health = health
			GameManager.Players[id].gold = gold
			GameManager.Players[id].collected_gold = collected_gold

	for i in multiplayer.get_peers():
		print("IDSOMEWHERE:", i)
		update_player_information.rpc(id, name, health, gold, collected_gold)

#func update_player_information_rpc(peer, id, name, health):
#	rpc_id(peer, "update_player_information", id, name, health)

# Function to update a player's health
@rpc("any_peer")
func update_player_health(id, new_health):
	if GameManager.Players.has(id):
		GameManager.Players[id].health = new_health

		# Broadcast the health update to all connected peers
		if multiplayer.is_server():
			for i in GameManager.Players:
				send_player_information.rpc(i, GameManager.Players[i].id, GameManager.Players[i].name, GameManager.Players[i].health, true)
