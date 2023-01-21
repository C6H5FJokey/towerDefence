extends CanvasLayer


func _ready():
	GameManager.reset()


func _on_Quit_pressed():
	get_tree().quit()


func _on_NewGame_pressed():
	get_tree().change_scene("res://GameScene/GameScene.tscn")
