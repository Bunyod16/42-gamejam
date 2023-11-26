extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	print("UI READY")

	var player_count = 0;
	for i in GameManager.Players:
		player_count += 1
	print("Player Count: ", player_count)
	print_tree_pretty()

	for i in range(player_count):
		var node = get_node("HBoxContainer/" + str(i))
		node.visible = true
		print("range:", i)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_ui_data(ui: NodePath, player_id:int):
	get_node(ui)
