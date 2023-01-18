extends Control

signal pause_button_down


onready var hp_value := $InfoPanel/MarginContainer/VBoxContainer/HBoxContainer/Hp/HpValue
onready var fund_value := $InfoPanel/MarginContainer/VBoxContainer/HBoxContainer/Fund/FundValue
onready var wvalue := $InfoPanel/MarginContainer/VBoxContainer/Wave/HBoxContainer/Wvalue
onready var mw_value := $InfoPanel/MarginContainer/VBoxContainer/Wave/HBoxContainer/MWValue


func set_hp(value: int):
	hp_value.text = str(value)


func set_fund(value: int):
	fund_value.text = str(value)


func set_wave(value: int):
	wvalue.text = str(value)


func set_max_wave(value: int):
	mw_value.text = str(value)


func _on_Hasten_toggled(button_pressed):
	if button_pressed:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0


func _on_Pause_toggled(button_pressed):
	if button_pressed:
		get_tree().paused = false
		emit_signal("pause_button_down")
	else:
		get_tree().paused = true
		
