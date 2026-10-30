
extends Node2D

@onready var player = $Player

func _ready() -> void:
	var label = $RichTextLabel
	player.position = Vector2(Global.screen_width / 2, Global.screen_height / 2)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	label.position = Vector2(Global.screen_width / 2, 0)
	label.hide()


func _process(_delta: float) -> void:
	$RichTextLabel.hide()

	if $pc.get_overlapping_bodies():
		$RichTextLabel.show()

		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file("res://Scenes/pc.tscn")


func _on_pc_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred(
		"change_scene_to_file",
		"res://Scenes/pc.tscn"
	)
