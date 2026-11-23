extends CharacterBody2D

@export var reaction_time: float = 2.0
@export var stay_duration: float = 5.0
@export var back_threshold: float = -0.5 #pana la 60 de grade marja de eroare + sau -

@export var player: CharacterBody2D
var warning_sound: AudioStreamPlayer2D
var active: bool = false
var checking: bool = false
var back_timer: float = 0.0

signal caught
signal escaped

func _ready() -> void:
	player = get_node("../Player")
	warning_sound = $warning_sound
	start_encounter()

func start_encounter() -> void:
	active = true
	checking = false
	back_timer = 0.0
	visible = true

	#Sunet de avertizare cand apare
	warning_sound.play()

	await get_tree().create_timer(reaction_time).timeout
	checking = true

func _process(delta: float) -> void:
	if not active or not checking:
		return
	if player == null:
		print("player e null")

	if is_player_facing_me():
		active = false
		checking = false
		print("Te-ai uitat la el! Jumpscare.")
		caught.emit()
	else:
		back_timer += delta
		if back_timer >= stay_duration:
			active = false
			checking = false
			print("A plecat.")
			escaped.emit()
			queue_free()

func get_player_look_dir() -> Vector2:
	# Varianta 1: dacă player are o variabilă look_dir (ex. actualizată spre mouse sau mișcare)
	if "look_dir" in player and player.look_dir != Vector2.ZERO:
		return player.look_dir.normalized()

	# Varianta 2: fallback pe rotația nodului player (presupunând că "fața" e +X / RIGHT)
	return Vector2.RIGHT.rotated(player.global_rotation).normalized()

func is_player_facing_me() -> bool:
	var look_dir := get_player_look_dir()
	var to_enemy := (global_position - player.global_position).normalized()
	var dot := look_dir.dot(to_enemy)

	# Dacă dot este mai mare decât back_threshold (ex: -0.5), nu stai cu spatele spre el
	return dot > back_threshold
