extends Control

signal menu_hide


func show():
	.show()
	get_tree().paused = true


func _on_Exit_pressed():
	get_tree().change_scene("res://UI/Title.tscn")


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Continue_pressed():
	hide()
	get_tree().paused = false
	emit_signal("menu_hide")
