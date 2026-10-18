extends Control # Sau ce scrie la tine pe primul rând (ex: Node2D)

# Funcția pentru butonul de PLAY (Joacă)
func _on_button_joaca_pressed():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

# Funcția pentru butonul de EXIT (Ieșire)
func _on_button_iesire_pressed():
	get_tree().quit()
