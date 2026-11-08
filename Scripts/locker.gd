extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

		
func hide_in_locker(pos: Vector2, locker_pos:Vector2):
	Global.hidden = true
	pos.x = locker_pos.x
	pos.y = locker_pos.y
	return pos

func exit_locker(pos: Vector2,locker_pos:Vector2):
	Global.hidden = false
	pos.x = locker_pos.x
	pos.y = locker_pos.y + 50
	return pos
	
