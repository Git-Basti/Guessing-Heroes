extends Control

@export var number_range: int # import des Nummernbereichs
@export var max_attempts: int # import der max. Versuche
@export var is_player_guessing: bool
@onready var sfx_menu: AudioStreamPlayer2D = $sfx_menu

var target_number: int = 0
var current_attempts: int = 0
var low: int = 1
var high: int = 1000000
var current_computer_guess: int = 0

func _ready():
	print("Starting Normal Game with range:", number_range, " and attempts:", max_attempts)
	$VBoxContainer/AttemptsLabel.text = "Versuche übrig: %d" % max_attempts
	low = 1
	high = number_range
	if is_player_guessing:
		_start_player_guessing_mode()
	else:
		_start_computer_guessing_mode()

func _start_player_guessing_mode():
	# Bereitet die Szene vor, sowie die target_number
	$VBoxContainer/InputField.visible = true
	$VBoxContainer/HintLabel2.visible = false
	$VBoxContainer/OptionsButton.visible = false
	target_number = randi_range(1, number_range)
	print("Gesucht:", target_number)
	$VBoxContainer/InfoLabel.text = "Errate die Zahl zwischen 1 und %d!" % number_range
	$VBoxContainer/HintLabel.text = "Trage eine Zahl ein."
	$VBoxContainer/SubmitButton.pressed.connect(_on_player_guess)
	$BackButton.pressed.connect(Callable(self, "_on_BackButton_presses"))

func _start_computer_guessing_mode():
	# Bereitet die Szene vor
	$VBoxContainer/InputField.visible = false
	$VBoxContainer/HintLabel.visible = false
	$VBoxContainer/HintLabel2.visible = true
	$VBoxContainer/OptionsButton.visible = true
	$VBoxContainer/InfoLabel.text = "Denke dir eine Zahl zwischen 1 und %d!" % number_range
	$VBoxContainer/SubmitButton.text = "Weiter!"
	$VBoxContainer/SubmitButton.pressed.connect(_on_computer_guess)
	$BackButton.pressed.connect(Callable(self, "_on_BackButton_presses"))
	_on_computer_guess()

# Hier startet die Logik des Spiels

func _on_player_guess(): # Spieler muss Raten
	current_attempts += 1
	var player_guess = $VBoxContainer/InputField.text.to_int()
	$VBoxContainer/AttemptsLabel.text = "Versuche übrig: %d" % (max_attempts - current_attempts)

	if player_guess == target_number: # Spieler gibt die Richtige Zahl ein ==
		sfx_menu.play()
		await sfx_menu.finished # Button Sound
		
		$VBoxContainer/HintLabel.text = "Richtig! Du hast die Zahl erraten!"
		_end_game()
	elif current_attempts >= max_attempts: # Spieler hat keine Versuche mehr übrig 
		sfx_menu.play()
		await sfx_menu.finished # Button Sound
		
		$VBoxContainer/HintLabel.text = "Game Over! Die richtige Zahl war %d." % target_number
		_end_game()
	elif player_guess < target_number: # Spieler gibt eine Zahl ein die kleiner der target_number ist
		sfx_menu.play()
		await sfx_menu.finished # Button Sound
		
		$VBoxContainer/HintLabel.text = "Die Zahl ist größer!"
	else:
		sfx_menu.play() # Spieler gibt eine Zahl ein die größer der target_number ist
		await sfx_menu.finished # Button Sound
		
		$VBoxContainer/HintLabel.text = "Die Zahl ist kleiner!"

func _on_computer_guess(): # der Computer muss Raten, keine target_number (Spieler denkt sich die Zahl)
	if current_attempts < max_attempts:
		# low = Durch Spielertipps ermittelte niedrigste Zahl
		# high = Durch Spielertipps ermittelte Höchstzahl
		if low > high: # Low und high passen sich den Hinweisen des Spielers an. Wird low größer als high, ist ein Erraten der Zahl unmöglich
			$VBoxContainer/InfoLabel.text = "Unmöglich!"
			$VBoxContainer/HintLabel2.text = "Starte neu! Du Unhold."
			$VBoxContainer/AttemptsLabel.visible = false
			$VBoxContainer/OptionsButton.visible = false
			_end_game()
			return

		current_attempts += 1

		current_computer_guess = randi_range(low, high)# Rate innerhalb des aktuellen Bereichs [low, high] (randi_range gibt dabei eine Zufällige Zahl)

		$VBoxContainer/HintLabel2.text = "Computer schätzt: %d" % current_computer_guess
		$VBoxContainer/AttemptsLabel.text = "Schätzungen übrig: %d" % (max_attempts - current_attempts)

		# Setze die Optionen für den OptionsButton (SpielerTipps)
		var options_button = $VBoxContainer/OptionsButton
		$VBoxContainer/SubmitButton.visible = false
		options_button.clear()
		options_button.add_item("Gib einen Tipp")
		options_button.add_item("Größer")  
		options_button.add_item("Kleiner")  
		options_button.add_item("Stimmt") 
		options_button.item_selected.connect(_on_player_hint) # Verbinde mit neuer func
		
	else: # Computer hat keine Versuche mehr
		$VBoxContainer/HintLabel2.text = "Game Over! Der Computer hat verloren!"
		_end_game()

func _on_player_hint(selected_index: int):
	match selected_index:
		1: # Größer
			sfx_menu.play()
			await sfx_menu.finished # Button Sound
			
			low = max(low, current_computer_guess + 1)
			# low Update
			if low > number_range:
				low = number_range
			print("Die Zahl ist größer! Neuer Bereich: [%d, %d]" % [low, high])
			_on_computer_guess()
		2: # Kleiner
			sfx_menu.play()
			await sfx_menu.finished # Button Sound
			
			high = min(high, current_computer_guess - 1)
			# high Update
			if high < 1:
				high = 1
			print("Die Zahl ist kleiner! Neuer Bereich: [%d, %d]" % [low, high])
			_on_computer_guess()
		3: # Stimmt
			sfx_menu.play()
			await sfx_menu.finished # Button Sound
			
			$VBoxContainer/InfoLabel.text = "Deine Zahl war die: %d" % current_computer_guess
			$VBoxContainer/HintLabel2.text = "Computer hat die Zahl erraten!"
			print("Deine Zahl war die: %d" % current_computer_guess)
			_end_game()


func _on_BackButton_presses():
	sfx_menu.play()
	await sfx_menu.finished # Button Sound
	
	get_tree().change_scene_to_file("res://scenes/normal_mode.tscn")

func _end_game():
	$BackButton.visible = false
	$VBoxContainer/SubmitButton.visible = true
	$VBoxContainer/SubmitButton.text = "Zurück"
	$VBoxContainer/SubmitButton.pressed.connect(_on_BackButton_presses)
	$VBoxContainer/InputField.editable = false
	$VBoxContainer/OptionsButton.disabled = true
