extends Control

@onready var menu_bar: MenuBar = $MenuBar
var is_paused = false

func _ready() -> void:
	# Menu is hidden when the game starts
	menu_bar.hide()
	menu_bar.process_mode = Node.PROCESS_MODE_ALWAYS  # Add this line
	# Connect menu buttons to functions
	$MenuBar/VBoxContainer/SaveExit.connect("pressed", Callable(self, "_on_save_exit_pressed"))
	$MenuBar/VBoxContainer/Continue.connect("pressed", Callable(self, "_on_continue_pressed"))

func _input(event: InputEvent) -> void:
	# Toggle the pause menu with the "Exit" action (such as the Esc key)
	if event.is_action_pressed("Exit"):
		toggle_pause()

func toggle_pause():
	# Toggle the game's pause state and menu visibility
	is_paused = !is_paused
	print("Pause state: ", is_paused)
	menu_bar.visible = is_paused
	get_tree().paused = is_paused


func _on_continue_pressed():
	# Resume the game when "Continue" is pressed
	print("Continue pressed") 
	toggle_pause()  # Resumes the game and hides the menu

func _on_save_exit_pressed():
	# Quit the game when "Save and Exit" is pressed
	get_tree().quit()

func _on_main_menu_pressed():
	# Handle returning to the main menu (if implemented)
	print("Return to the main menu")

func _on_settings_pressed():
	# Handle opening the settings menu (if implemented)
	print("Open settings menu")
