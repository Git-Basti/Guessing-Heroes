extends Control

# Referenz auf AudioStreamPlayer2D-Node
@onready var sfx_menu: AudioStreamPlayer2D = $sfx_menu

func _ready():
	$VBoxContainer/StoryModeButton.pressed.connect(_on_StoryModeButton_pressed)
	$VBoxContainer/NormalModeButton.pressed.connect(_on_NormalModeButton_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_OptionsButton_pressed)
	$VBoxContainer/ExitButton.pressed.connect(_on_QuitButton_pressed)

# Funktionen für Buttons
func _on_StoryModeButton_pressed():
	sfx_menu.play()
	await sfx_menu.finished
	print("StoryModeButton pressed")
	get_tree().change_scene_to_file("res://scenes/story_mode.tscn")

func _on_NormalModeButton_pressed():
	sfx_menu.play()
	await sfx_menu.finished
	print("NormalModeButton pressed")
	get_tree().change_scene_to_file("res://scenes/normal_mode.tscn")

func _on_OptionsButton_pressed():
	sfx_menu.play()
	await sfx_menu.finished
	print("OptionsButton pressed")
	print("Options geöffnet")
	# Hier kannst du die Optionsszene laden oder einen Dialog öffnen.

func _on_QuitButton_pressed():
	sfx_menu.play()
	await sfx_menu.finished
	print("QuitButton pressed")
	get_tree().quit()
