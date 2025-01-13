extends CharacterBody2D

@onready var body: Sprite2D = $body
@onready var turret: Sprite2D = $turret
@onready var bullet_scene = preload("res://Scenes/bullet.tscn")
@export var retrypage : PackedScene

const SPEED = 400.0
const TURNING_SPEED = 200.0  # Speed while turning
const TURN_RATE = 3.0  # How fast it turns while moving

var direction = Vector2.ZERO
var health = 3
var current_speed = 0.0
var facing_direction = Vector2.RIGHT
var can_shoot = true
var shoot_delay = 1.0
var ammo = 3
var max_ammo = 3
var reload_time = 3.0
var is_reloading = false
var isDying = false
var playerdead = false

func _physics_process(delta: float) -> void:
	if !isDying:
		
		# Get input
		if Input.is_action_pressed("Up"):
			current_speed = SPEED
		elif Input.is_action_pressed("Down"):
			current_speed = -SPEED
		else:
			current_speed = 0
			
		# Handle turning while moving
		if current_speed != 0:
			if Input.is_action_pressed("Left"):
				body.rotation -= TURN_RATE * delta
				current_speed = TURNING_SPEED  # Reduce speed while turning
			elif Input.is_action_pressed("Right"):
				body.rotation += TURN_RATE * delta
				current_speed = TURNING_SPEED  # Reduce speed while turning
		
		# Calculate movement based on body rotation
		facing_direction = Vector2.UP.rotated(body.rotation)
		velocity = facing_direction * current_speed
		move_and_slide()
		
		if direction != Vector2.ZERO:
			body.rotation = direction.angle() + PI/2
			
		turret.look_at(get_global_mouse_position())
		turret.rotation = (get_global_mouse_position() - turret.global_position).angle() + PI / 2
		
		if Input.is_action_pressed('Shoot') and can_shoot and !is_reloading and ammo > 0:
			shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	var spawn_offset = direction * 100 * PI/2
	bullet.position = turret.global_position + spawn_offset
	bullet.player = self
	
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - turret.global_position).normalized()
	
	bullet.direction = dir
	get_parent().add_child(bullet)
	
	ammo -= 1
	
	# Start reload if out of ammo
	if ammo <= 0:
		start_reload()
	else:
		# Normal shoot delay between shots
		can_shoot = false
		await get_tree().create_timer(shoot_delay).timeout
		can_shoot = true

func start_reload():
	print("Reloading...")  # Debug message
	is_reloading = true
	can_shoot = false
	
	# Wait for reload time
	await get_tree().create_timer(reload_time).timeout
	
	# Reset ammo and flags
	ammo = max_ammo
	is_reloading = false
	can_shoot = true
	print("Reload complete!")  # Debug message

func _damaged(damage : int):
	health -= damage
	if health <= 0 and !isDying:
		death_sequence()
		playerdead = true
		if playerdead:
			await get_tree().create_timer(3.0).timeout
			dead()
			

func death_sequence():
	isDying = true
	set_physics_process(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 0, 0, 1), 0.2)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	tween.tween_property(self, "modulate", Color(1, 0, 0, 0), 0.5)
	
	await  get_tree().create_timer(3.0).timeout
	queue_free()

func dead():
	get_tree().change_scene_to_packed(retrypage)
