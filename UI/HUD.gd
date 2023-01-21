extends Control

signal pause_toggled(button_pressed)
signal menu_pressed

onready var hp_value := $InfoPanel/MarginContainer/VBoxContainer/HBoxContainer/Hp/HpValue
onready var fund_value := $InfoPanel/MarginContainer/VBoxContainer/HBoxContainer/Fund/FundValue
onready var wvalue := $InfoPanel/MarginContainer/VBoxContainer/Wave/HBoxContainer/Wvalue
onready var mw_value := $InfoPanel/MarginContainer/VBoxContainer/Wave/HBoxContainer/MWValue
onready var speed_line := $SpeedLine


func _ready():
	speed_line.hide()


func set_hp(value: int):
	hp_value.text = str(value)


func set_fund(value: int):
	fund_value.text = str(value)


func set_wave(value: int):
	wvalue.text = str(value)


func set_max_wave(value: int):
	mw_value.text = str(value)


func _on_Hasten_toggled(button_pressed: bool):
	GameManager.hasted = button_pressed
#	if get_tree().paused:
#		return
	if button_pressed:
		speed_line.show()
	else:
		speed_line.hide()


func _on_Pause_toggled(button_pressed: bool):
#	if button_pressed:
#		get_tree().paused = false
#		emit_signal("pause_button_down")
##		if not Engine.time_scale == 1.0:
##			speed_line.show()
#	else:
#		get_tree().paused = true
##		if not Engine.time_scale == 1.0:
##			speed_line.hide()
	if button_pressed:
		emit_signal("pause_toggled", button_pressed)
	GameManager.paused = !button_pressed
	(speed_line.material as ShaderMaterial).set_shader_param("paused", !button_pressed)


func _on_Menu_pressed():
	emit_signal("menu_pressed")
