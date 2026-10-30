
extends Control

@onready var browser = $browser_SubViewportContainer
@onready var cursor = $cursor


func _ready() -> void:
	var browser_button = Button.new()
	browser_button.text = "Open browser"
	browser_button.position = Vector2(100, 100)
	browser_button.size = Vector2(180, 60)
	browser_button.z_index = 100

	add_child(browser_button)
	browser_button.pressed.connect(_on_browser_button_pressed)

	cursor.show()
	cursor.z_index = 200

	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _on_browser_button_pressed() -> void:
	browser.open_browser()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():

		if browser.is_browser_open():
			browser.close_browser()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().call_deferred(
				"change_scene_to_file",
				"res://Scenes/node_2d.tscn"
			)

		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	cursor.global_position = get_global_mouse_position()
