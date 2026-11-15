extends Node

var screen_width = 1280
var screen_height = 720

const MAX_SLOTS := 4

signal inventory_changed

var items: Array[String] = ["lanterna"]
var selected_slot := -1

var battery := 100.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slot_1"):
		select_slot(0)


func select_slot(index: int) -> void:
	if selected_slot == index:
		selected_slot = -1
	else:
		selected_slot = index
	print("Slot selectat: ", selected_slot, " -> ", get_item_in_slot(selected_slot))
	inventory_changed.emit()


func get_item_in_slot(index: int) -> String:
	if index >= 0 and index < items.size():
		return items[index]
	return ""


func is_equipped(item_name: String) -> bool:
	return get_item_in_slot(selected_slot) == item_name


func add_item(item_name: String) -> bool:
	if items.size() >= MAX_SLOTS:
		return false
	items.append(item_name)
	inventory_changed.emit()
	return true


func has_item(item_name: String) -> bool:
	return item_name in items


func remove_item(item_name: String) -> void:
	items.erase(item_name)
	inventory_changed.emit()
