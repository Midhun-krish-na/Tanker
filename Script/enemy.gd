extends CharacterBody2D
const SPEED = 200.0
var player = null
var health = 3
var direction = Vector2.ZERO
@onready var body: Sprite2D = $body
@onready var turret: Sprite2D = $turret
@onready var bullet_scene = preload("res://Scenes/bullet.tscn")
var can_shoot = true
var shoot_delay = 2.0
var detection_range = 2000
var isDying = false  # Changed from true to false - this was the issue!
var stop_range = 1000 # To stop

func _ready() -> void:
	player = get_parent().get_node('player') 

func _physics_process(_delta: float) -> void:
	if !isDying and is_instance_valid(player):  # Only process movement if not dying
		var direction_to_player = player.position - position
		var distance_to_player = direction_to_player.length()
		
		if distance_to_player > stop_range :
			direction = direction_to_player.normalized()
			velocity = direction * SPEED
			move_and_slide()
		
		else :
			velocity = Vector2.ZERO
		
		body.rotation = direction.angle() +PI/2
		turret.look_at(player.position) 
		turret.rotation = (player.position - turret.global_position).angle() + PI / 2
		if direction_to_player.length() < detection_range and can_shoot:
			shoot()

func _take_damage(damage : int):
	health -= damage
	if health <= 0 and !isDying:  # Changed to !isDying
		_death_sequence()

func _death_sequence():
	isDying = true
	#stop every physics
	set_physics_process(false)
	
	var tween = create_tween()
	#death animation
	tween.tween_property(self, "modulate", Color(1, 0, 0, 1), 0.2) # Flash red
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2) 
	tween.tween_property(self, "modulate", Color(1, 0, 0, 0), 0.5) # Fade out
	
	await get_tree().create_timer(2.0).timeout
	queue_free()

func shoot():
	var bullet = bullet_scene.instantiate()
	var spawn_offset = direction * 100 * PI/2
	bullet.position = turret.global_position + spawn_offset
	bullet.enemy = self
	var dir = (player.position - turret.global_position).normalized()
	bullet.direction = dir
	get_parent().add_child(bullet)
	
	can_shoot = false
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true
