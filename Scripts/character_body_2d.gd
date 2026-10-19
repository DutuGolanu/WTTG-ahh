extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -800.0


func _physics_process(_delta: float) -> void:
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")

	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if direction_x and direction_y:
		velocity.x = direction_x * (SPEED / sqrt(2))
		velocity.y = direction_y * (SPEED / sqrt(2))
	var col_box_size_x = get_node("hitbox").shape.size.x
	var col_box_size_y = get_node("hitbox").shape.size.y
	position.x = clamp(position.x,col_box_size_x/2,Global.screen_width-col_box_size_x/2)
	position.y = clamp(position.y,col_box_size_y/2,Global.screen_height-col_box_size_y/2)
	print("velocity x:%f " % velocity.x) 
	print("velocity y:%f \n" % velocity.y)
	move_and_slide()
