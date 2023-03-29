extends Control

func _ready():
	$GridContainer/VBoxContainer/StartButton.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()

func _on_StartButton_pressed():
	get_tree().change_scene("res://Level1.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
