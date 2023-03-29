extends Control


func _input(event: InputEvent) -> void:
	if event.is_action('ui_cancel'):
		get_tree().quit()

func _on_StartButton_pressed():
	get_tree().change_scene("res://Level1.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
