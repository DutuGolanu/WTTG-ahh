
extends SubViewportContainer

var browser_open := false

var browser_ui: Control
var tabs: Array[Dictionary] = []
var active_tab := 0

var tab_bar: HBoxContainer
var address_bar: LineEdit
var page: VBoxContainer
var page_title: Label


func _ready() -> void:
	hide()
	browser_open = false
	_build_browser()


func open_browser() -> void:
	browser_open = true
	show()


func close_browser() -> void:
	browser_open = false
	hide()


func is_browser_open() -> bool:
	return browser_open


func _build_browser() -> void:
	var viewport = $browser_SubViewport

	browser_ui = Control.new()
	browser_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	viewport.add_child(browser_ui)

	var main = VBoxContainer.new()
	main.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_theme_constant_override("separation", 0)
	browser_ui.add_child(main)

	# TAB BAR
	var tabs_panel = PanelContainer.new()
	tabs_panel.custom_minimum_size.y = 42
	tabs_panel.add_theme_stylebox_override(
		"panel", _style(Color("#202124"))
	)
	main.add_child(tabs_panel)

	tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 5)
	tabs_panel.add_child(tab_bar)

	# TOOLBAR
	var toolbar = PanelContainer.new()
	toolbar.custom_minimum_size.y = 52
	toolbar.add_theme_stylebox_override(
		"panel", _style(Color("#303134"))
	)
	main.add_child(toolbar)

	var tools = HBoxContainer.new()
	tools.add_theme_constant_override("separation", 7)
	toolbar.add_child(tools)

	_add_button(tools, "←", _go_back)
	_add_button(tools, "→", _go_forward)
	_add_button(tools, "↻", _refresh)
	_add_button(tools, "⌂", _go_home)

	address_bar = LineEdit.new()
	address_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	address_bar.placeholder_text = "Search or enter address"
	address_bar.custom_minimum_size.y = 35
	var address_normal = _style(Color("#3a3a3a"), 6)
	var address_focus = _style(Color("#505050"), 6)

	address_bar.add_theme_stylebox_override("normal", address_normal)
	address_bar.add_theme_stylebox_override("focus", address_focus)
	address_bar.add_theme_color_override("font_color", Color.WHITE)
	address_bar.add_theme_color_override("font_placeholder_color", Color("#b0b0b0"))
	address_bar.text_submitted.connect(_on_address_submitted)
	
	tools.add_child(address_bar)

	_add_button(tools, "Go", _submit_address)

	# WEBPAGE AREA
	var page_scroll = ScrollContainer.new()
	page_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page_scroll.add_theme_stylebox_override(
		"panel", _style(Color.WHITE)
	)
	main.add_child(page_scroll)

	page = VBoxContainer.new()
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.add_theme_constant_override("separation", 15)
	page.add_theme_stylebox_override(
		"panel", _style(Color.WHITE)
	)
	page.add_theme_constant_override("margin_left", 30)
	page.add_theme_constant_override("margin_right", 30)
	page.add_theme_constant_override("margin_top", 20)
	page.add_theme_constant_override("margin_bottom", 20)
	page.add_theme_color_override("font_color", Color.BLACK)
	page_scroll.add_child(page)

	_create_tab("New Tab")


func _style(color: Color, radius: int = 0) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.corner_radius_top_left = radius
	s.corner_radius_top_right = radius
	s.corner_radius_bottom_left = radius
	s.corner_radius_bottom_right = radius
	return s


func _add_button(parent: Control, caption: String, action: Callable) -> void:
	var b = Button.new()
	b.text = caption
	b.custom_minimum_size = Vector2(38, 34)
	b.add_theme_stylebox_override(
		"normal", _style(Color("#303134"), 8)
	)
	b.add_theme_stylebox_override(
		"hover", _style(Color("#505258"), 8)
	)
	b.add_theme_color_override("font_color", Color.WHITE)
	b.pressed.connect(action)
	parent.add_child(b)


# TABS

func _create_tab(url: String) -> void:
	tabs.append({
		"url": url,
		"history": [url],
		"history_index": 0
	})
	active_tab = tabs.size() - 1
	_refresh_tabs()
	_load_page(url)


func _refresh_tabs() -> void:
	for child in tab_bar.get_children():
		child.queue_free()

	for i in range(tabs.size()):
		var tab_button = Button.new()
		tab_button.text = "Tab %d  ×" % (i + 1)
		tab_button.custom_minimum_size = Vector2(115, 35)
		tab_button.pressed.connect(_select_tab.bind(i))
		tab_bar.add_child(tab_button)

	var add_tab = Button.new()
	add_tab.text = "+"
	add_tab.custom_minimum_size = Vector2(35, 35)
	add_tab.pressed.connect(_new_tab)
	tab_bar.add_child(add_tab)


func _new_tab() -> void:
	_create_tab("New Tab")


func _select_tab(index: int) -> void:
	if index >= 0 and index < tabs.size():
		active_tab = index
		_refresh_tabs()
		_load_page(tabs[index]["url"])


# NAVIGATION

func _on_address_submitted(value: String) -> void:
	_navigate(value)


func _submit_address() -> void:
	_navigate(address_bar.text)


func _navigate(value: String) -> void:
	var destination = value.strip_edges()

	if destination.is_empty():
		return

	if destination.begins_with("search://"):
		destination = destination.trim_prefix("search://")

	if destination == "New Tab":
		_go_home()
		return

	if destination.contains(" ") or not destination.contains("."):
		destination = "search://" + destination
	elif not destination.begins_with("http://") and not destination.begins_with("https://"):
		destination = "https://" + destination

	var history: Array = tabs[active_tab]["history"]
	var history_index: int = tabs[active_tab]["history_index"]

	history.resize(history_index + 1)
	history.append(destination)

	tabs[active_tab]["history"] = history
	tabs[active_tab]["history_index"] = history.size() - 1
	tabs[active_tab]["url"] = destination

	_load_page(destination)


func _go_back() -> void:
	var index: int = tabs[active_tab]["history_index"]

	if index > 0:
		index -= 1
		tabs[active_tab]["history_index"] = index
		_load_page(tabs[active_tab]["history"][index])


func _go_forward() -> void:
	var history: Array = tabs[active_tab]["history"]
	var index: int = tabs[active_tab]["history_index"]

	if index < history.size() - 1:
		index += 1
		tabs[active_tab]["history_index"] = index
		_load_page(history[index])


func _refresh() -> void:
	_load_page(tabs[active_tab]["url"])


func _go_home() -> void:
	var destination = "New Tab"

	var history: Array = tabs[active_tab]["history"]
	var history_index: int = tabs[active_tab]["history_index"]

	history.resize(history_index + 1)
	history.append(destination)

	tabs[active_tab]["history"] = history
	tabs[active_tab]["history_index"] = history.size() - 1
	tabs[active_tab]["url"] = destination

	_load_page(destination)


# PAGE DISPLAY

func _load_page(url: String) -> void:
	if url.begins_with("search://"):
		address_bar.text = url.trim_prefix("search://")
	elif url == "New Tab":
		address_bar.text = ""
	else:
		address_bar.text = url

	for child in page.get_children():
		child.queue_free()

	if url == "New Tab" or url == "":
		_show_homepage()
	elif url.begins_with("search://"):
		_show_search_page(url.trim_prefix("search://"))
	else:
		_show_website_page(url)


func _show_homepage() -> void:
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 35
	page.add_child(spacer)

	var title = Label.new()
	title.text = "Super Secret Browser"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	title.add_theme_color_override("font_color", Color("000103ff"))
	page.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Search the web"
	subtitle.add_theme_color_override("font_color", Color("#666666"))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	page.add_child(subtitle)

	var websites = [
		["website 1", "website 1"],
		["website 2", "website 2"],
		["website 3", "website 3"],
		["website 4", "website 4"],
		["website 5", "website 5"]
	]

	var list = VBoxContainer.new()
	list.add_theme_constant_override("separation", 12)
	list.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	page.add_child(list)

	for website in websites:
		var link = LinkButton.new()
		link.text = website[0]
		link.add_theme_font_size_override("font_size", 22)
		link.add_theme_color_override("font_color", Color("#1a73e8"))
		link.add_theme_color_override("font_hover_color", Color("#174ea6"))
		link.underline = LinkButton.UNDERLINE_MODE_ON_HOVER
		link.pressed.connect(_navigate.bind(website[1]))
		list.add_child(link)


func _show_search_page(query: String) -> void:
	var title = Label.new()
	title.text = "Search results for: " + query
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", Color.BLACK)
	page.add_child(title)

	var info = Label.new()
	info.text = "This is a simulated search page.\nConnect a web browser integration to load real search results."
	info.add_theme_color_override("font_color", Color("#444444"))
	page.add_child(info)


func _show_website_page(url: String) -> void:
	var title = Label.new()
	title.text = url
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color("#202124"))
	page.add_child(title)

	var info = Label.new()
	info.text = "Website address:\n" + url + "\n\nThis browser currently displays simulated pages.\nReal website rendering requires a WebView integration."
	info.add_theme_color_override("font_color", Color("#444444"))
	page.add_child(info)
