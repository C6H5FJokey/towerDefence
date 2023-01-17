extends Control

onready var hp_value = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Hp/HpValue
onready var fund_value = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Fund/FundValue

func set_hp(value):
	hp_value.text = str(value)


func set_fund(value):
	fund_value.text = str(value)
