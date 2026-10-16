extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.position = Vector2(Global.screen_width/2,Global.screen_height/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pc_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/pc.tscn")
