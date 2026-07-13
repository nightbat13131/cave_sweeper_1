class_name PopupButton extends ButtonEnhanced

@export var popup_type : Utilties.Popups

func _on_pressed() -> void:	PopupManager.request_popup(popup_type)
