extends CanvasLayer

const ICONS := {
	"lanterna": "res://Assets/lanterna_icon.png",
}

@onready var slots: HBoxContainer = $Slots
@onready var battery_label: Label = $BatteryLabel


func _ready() -> void:
	slots.offset_bottom = -10
	Global.inventory_changed.connect(refresh)
	refresh()


func _process(_delta: float) -> void:
	battery_label.visible = Global.has_item("lanterna")
	battery_label.text = "Baterie: %d%%" % int(Global.battery)


func make_style(selected: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.set_corner_radius_all(6)
	if selected:
		style.bg_color = Color(0.28, 0.22, 0.05, 0.95)
		style.border_color = Color(1.0, 0.85, 0.2)
		style.set_border_width_all(5)
	else:
		style.bg_color = Color(0.08, 0.08, 0.12, 0.85)
		style.border_color = Color(0.3, 0.3, 0.4)
		style.set_border_width_all(2)
	return style


func refresh() -> void:
	for child in slots.get_children():
		child.queue_free()

	for i in Global.MAX_SLOTS:
		var slot := Panel.new()
		slot.custom_minimum_size = Vector2(64, 64)
		slot.add_theme_stylebox_override("panel", make_style(i == Global.selected_slot))
		slots.add_child(slot)

		if i < Global.items.size():
			var item_name: String = Global.items[i]
			if ICONS.has(item_name):
				var icon := TextureRect.new()
				icon.texture = load(ICONS[item_name])
				icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
				icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
				slot.add_child(icon)
			else:
				var label := Label.new()
				label.text = item_name
				label.set_anchors_preset(Control.PRESET_FULL_RECT)
				label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				slot.add_child(label)
