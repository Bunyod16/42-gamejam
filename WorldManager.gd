extends Node

@export var PlayerScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	
	print(GameManager.Players)
	
	for i in GameManager.Players:
		var current_player = PlayerScene.instantiate()
		current_player.name = str(i)
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoints"):
			print("SPAWN NAME: " + spawn.name)
			if spawn.name == str(index):
				current_player.global_position = spawn.global_position
		print("================")
		index += 1
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
