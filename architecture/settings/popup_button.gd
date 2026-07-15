class_name PopupButton extends ButtonEnhanced

@export var popup_type : Utilties.Popups

func _on_pressed() -> void:	
	SoundManager.request_sfx_via_enum(Utilties.SFX.BUTTON_PRESS_SETTINGS)
	PopupManager.request_popup(popup_type)

func _on_mouse_entered() -> void:
	SoundManager.request_sfx_via_enum(Utilties.SFX.BUTTON_MOUSE_OVER_SETTINGS)
