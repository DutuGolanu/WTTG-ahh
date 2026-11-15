extends Area2D
# Întrerupător: cât timp jucătorul e lângă el și apasă E,
# lumina camerei se aprinde sau se stinge.

# Culoarea camerei când lumina e stinsă (aproape negru)
const COLOR_OFF := Color("3a3a55")
# Culoarea camerei când lumina e aprinsă (alb = culorile normale)
const COLOR_ON := Color.WHITE

@export var darkness: CanvasModulate

var light_on := true       # camera începe cu lumina aprinsă
var player_near := false   # devine true când jucătorul e lângă întrerupător


func _ready() -> void:
	# Legăm semnalele Area2D de funcțiile noastre
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Setăm culoarea de start a camerei
	_update_light()


func _on_body_entered(body: Node2D) -> void:
	# Contează doar dacă cel care a intrat e jucătorul
	if body.name == "PlayerCharacter":
		player_near = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_near = false


func _unhandled_input(event: InputEvent) -> void:
	# Dacă jucătorul e aproape și apasă E, inversăm starea luminii
	if player_near and event.is_action_pressed("interact"):
		light_on = not light_on   # true devine false și invers
		_update_light()


func _update_light() -> void:
	if darkness == null:
		push_warning("LightSwitch: nu ai ales nodul Darkness în Inspector!")
		return

	if light_on:
		darkness.color = COLOR_ON
	else:
		darkness.color = COLOR_OFF
