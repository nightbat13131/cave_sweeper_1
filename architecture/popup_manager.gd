class_name PopupManager extends Control

@onready var sound_section: PanelContainer = %SoundSection
@onready var how_to_play_section: PanelContainer = %HowToPlaySection

@onready var sound_tab: PopupButton = %SoundTab
@onready var help_tab_button: PopupButton = %HelpTabButton

static var _instance : PopupManager

func _ready() -> void:
	_instance = self

static func is_open() -> bool: 
	if _instance:
		return _instance.is_visible()
	return false

static func request_popup(popup_type: Utilties.Popups) -> void:
	if _instance == null:
		return
	_instance.set_visible( popup_type != Utilties.Popups.NA)
	
	_instance.sound_section.set_visible(popup_type == Utilties.Popups.SOUND_SETTINGS)
	_instance.sound_tab.set_pressed_no_signal(popup_type == Utilties.Popups.SOUND_SETTINGS)
	
	_instance.how_to_play_section.set_visible(popup_type == Utilties.Popups.HELP)
	_instance.help_tab_button.set_pressed_no_signal(popup_type == Utilties.Popups.HELP)
	
