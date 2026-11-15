extends PointLight2D

const DRAIN_PER_SECOND := 2.0
const TIP_DISTANCE := 40.0
const HAND_FORWARD := 10.0
const MAX_ANGLE_DEG := 100.0
const SPRITE_TO_TIP := 26.0

@onready var player: CharacterBody2D = get_parent()
@onready var player_sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
@onready var sprite: Sprite2D = $Sprite2D
@onready var hand_position: Vector2 = position


func _ready() -> void:
	enabled = false
	sprite.position = Vector2(-SPRITE_TO_TIP, 0.0)


func _process(delta: float) -> void:
	aim()

	var equipped := Global.is_equipped("lanterna")
	sprite.visible = equipped
	if not equipped:
		enabled = false

	if enabled:
		Global.battery -= DRAIN_PER_SECOND * delta
		if Global.battery <= 0.0:
			Global.battery = 0.0
			enabled = false


func aim() -> void:
	var facing_left: bool = player_sprite.flip_h
	var side := -1.0 if facing_left else 1.0
	var hand := hand_position + Vector2(HAND_FORWARD * side, 0.0)
	var hand_global := player.global_position + hand

	var angle := (get_global_mouse_position() - hand_global).angle()
	var facing_angle := PI if facing_left else 0.0
	var relative := wrapf(angle - facing_angle, -PI, PI)
	var limit := deg_to_rad(MAX_ANGLE_DEG)
	relative = clampf(relative, -limit, limit)
	angle = facing_angle + relative

	rotation = angle
	position = hand + Vector2.from_angle(angle) * TIP_DISTANCE
	sprite.flip_v = facing_left


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("toggle_light"):
		return
	if not Global.is_equipped("lanterna"):
		return
	if Global.battery <= 0.0:
		return
	enabled = not enabled
