extends Node2D

@onready var sfx_menu: AudioStreamPlayer2D = $sfx_menu

func _ready():
	$BackButton.pressed.connect(Callable(self, "_on_backbutton_pressed"))

func _on_backbutton_pressed():
	sfx_menu.play()
	await sfx_menu.finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
