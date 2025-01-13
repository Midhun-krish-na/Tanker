extends Area2D

var speed = 800
var direction = Vector2.ZERO
var damage = 1
var player = null
var enemy = null


func _ready() -> void:

	
	await get_tree().create_timer(0.1).timeout
	monitoring = true
	monitorable = true
	
	
	connect("body_entered", Callable(self, "_on_bullet_entered_body"))
	#set collision layer based on who fired
	if player:
		set_collision_layer_value(3,true)
		set_collision_mask_value(2,true)
	elif enemy:
		set_collision_layer_value(4,true)
		set_collision_mask_value(1,true)


func _process(delta: float) -> void:
	position += delta * direction * speed 


func _on_bullet_entered_body(body: Node) -> void:
	if player and body.is_in_group("enemy"):
		print("Should destroy player bullet")
		body._take_damage(damage)
		queue_free()

	elif enemy and body.is_in_group("player"):
		print("Should destroy enemy bullet")
		body._damaged(damage)
		queue_free()
