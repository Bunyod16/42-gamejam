extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	print("UI READY")

	var player_count = 0;
	var index = 0;
	for i in GameManager.Players:
		player_count += 1
	print("Player Count: ", player_count)
	print_tree_pretty()

	for i in GameManager.Players:
		var node = get_node("HBoxContainer/" + str(index))
		var label = get_node("HBoxContainer/" + str(index) + "/Gold Container/Label")
		
		label.text = str(GameManager.Players[i].health)
		node.visible = true
		print("range:", index)
		index+= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_count = 0;
	var index = 0;
	for i in GameManager.Players:
		player_count += 1

	for i in GameManager.Players:
		var node = get_node("HBoxContainer/" + str(index))
		var label = get_node("HBoxContainer/" + str(index) + "/Gold Container/Label")
		
		if label.text != str(GameManager.Players[i].health):
			label.text = str(GameManager.Players[i].health)
		index+= 1

func _set_ui_data(ui: NodePath, player_id:int):
	get_node(ui)
