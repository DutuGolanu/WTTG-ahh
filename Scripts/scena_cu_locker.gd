extends Node2D

@onready var locker = $locker
@onready var player = $Player
@onready var text = $locker/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_locker()

func update_locker():
	text.hide()
	if locker.get_overlapping_bodies():
		text.show()
		if Input.is_action_just_pressed("interact"):
			if !Global.hidden:
				player.position = locker.hide_in_locker(player.position,locker.position)
			else:
				player.position = locker.exit_locker(player.position,locker.position)
