extends Control
@export var start_scene = PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect/VBoxContainer/Start.connect('pressed',Callable(self,"start"))
	$TextureRect/VBoxContainer/Quit.connect('pressed',Callable(self, "_quit"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		_quit()

func _quit():
		get_tree().quit()

func start():
	get_tree().change_scene_to_packed(start_scene)
