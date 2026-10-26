extends CharacterBody2D


const SPEED = 600.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	
	if direction_x < 0:
		animated_sprite_2d.flip_h = true
	elif direction_x > 0:
		animated_sprite_2d.flip_h = false
		
	if direction_x or direction_y:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("default")
	
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

	move_and_slide()
