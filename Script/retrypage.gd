extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		$TextureRect/HBoxContainer/PlayAgain.connect('pressed', Callable(self, "_on_play_again_pressed"))
		$TextureRect/HBoxContainer/MainMenu.connect('pressed', Callable(self, '_on_main_menu_pressed'))

func _process(_delta: float) -> void:
	pass

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	print('Main menu')

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
	print('reloaded')
