extends Node

@export var _general_mapping : GUIDEMappingContext
@export var _menu_toggle : GUIDEAction

func  _ready() -> void:
	PopupManager.request_popup(Utilties.Popups.NA)
	if _general_mapping:
		GUIDE.enable_mapping_context(_general_mapping)
		if _menu_toggle:
			_menu_toggle.triggered.connect(_on_menu_toggle)

func _on_menu_toggle() -> void:
	if PopupManager.is_open():
		PopupManager.request_popup(Utilties.Popups.NA)
	else:
		PopupManager.request_popup(Utilties.Popups.HELP)
