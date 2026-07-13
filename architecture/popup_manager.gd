class_name PopupManager extends Control

@onready var sound_section: PanelContainer = %SoundSection
@onready var how_to_play_section: PanelContainer = %HowToPlaySection

static var _instance : PopupManager

func _ready() -> void:
	_instance = self

static func is_open() -> bool: 
	if _instance:
		return _instance.is_visable()
	return false

static func request_popup(popup_type: Utilties.Popups) -> void:
	if _instance == null:
		return
	match popup_type:
		Utilties.Popups.NA:
			_instance.hide()
		Utilties.Popups.SOUND_SETTINGS:
			_instance.show()
			_instance.sound_section.show()
			_instance.how_to_play_section.hide()
		Utilties.Popups.HELP:
			_instance.show()
			_instance.sound_section.hide()
			_instance.how_to_play_section.show()
	
