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
		var label_heart = get_node("HBoxContainer/" + str(index) + "/Heart Container/Label")
		var label_gold = get_node("HBoxContainer/" + str(index) + "/Gold Container/Label")

		label_heart.text = str(GameManager.Players[i].health)
		label_gold.text = str(GameManager.Players[i].gold)
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
		var label_heart = get_node("HBoxContainer/" + str(index) + "/Heart Container/Label")
		var label_gold = get_node("HBoxContainer/" + str(index) + "/Gold Container/Label")

		if label_heart.text != str(GameManager.Players[i].health):
			label_heart.text = str(GameManager.Players[i].health)

		if label_gold.text != str(GameManager.Players[i].gold):
			label_gold.text = str(GameManager.Players[i].gold)
		index+= 1

func _set_ui_data(ui: NodePath, player_id:int):
	get_node(ui)
