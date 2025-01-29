extends Control

@export var default_range: int = 100
@export var default_attempts: int = 10
@onready var sfx_menu: AudioStreamPlayer2D = $sfx_menu

var selected_range: int
var selected_attempts: int

func _ready():
	$RangeAndAttemptsContainer/ContinueButton.pressed.connect(Callable(self, "_on_continue_pressed"))
	$ModeSelectionContainer/PlayerModeButton.pressed.connect(Callable(self, "_on_player_mode_selected"))
	$ModeSelectionContainer/ComputerModeButton.pressed.connect(Callable(self, "_on_computer_mode_selected"))
	$BackButton.pressed.connect(Callable(self, "_on_back_pressed"))
	$ModeSelectionContainer.visible = false

func _on_continue_pressed():
	sfx_menu.play()
	await sfx_menu.finished
	# Speichere die Werte für den Zahlenbereich und die Versuche
	selected_range = $RangeAndAttemptsContainer/NumberRangeInput.value
	selected_attempts = $RangeAndAttemptsContainer/AttemptsInput.value
	print("Starting Normal Mode with range:", selected_range, " and attempts:", selected_attempts)
	
	# Gehe zur Modusauswahl
	$RangeAndAttemptsContainer.visible = false
	$ModeSelectionContainer.visible = true

func _on_player_mode_selected():
	sfx_menu.play()
	await sfx_menu.finished
	_start_game(true)

func _on_computer_mode_selected():
	sfx_menu.play()
	await sfx_menu.finished
	_start_game(false)

func _start_game(is_player_guessing: bool):
	# Wechsel zur Spielszene und übergebe die Parameter
	var game_scene = preload("res://scenes/normal_game.tscn").instantiate()
	game_scene.number_range = selected_range
	game_scene.max_attempts = selected_attempts
	game_scene.is_player_guessing = is_player_guessing
	get_tree().root.add_child(game_scene)
	queue_free()

func _on_back_pressed():
	sfx_menu.play()
	await sfx_menu.finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
