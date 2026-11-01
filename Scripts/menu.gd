extends Control # Sau ce scrie la tine pe primul rând (ex: Node2D)

# Funcția pentru butonul de PLAY (Joacă)
func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

#settings button
func _on_button_settings_pressed() -> void:
	pass # Replace with function body.

# Funcția pentru butonul de EXIT (Ieșire)
func _on_button_exit_pressed() -> void:
	get_tree().quit()
