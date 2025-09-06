extends CharacterBody2D

@export var tile_size: int = 16
@export var speed: float = 2.0        # Movement animation speed
@export var move_distance: int = 5    # How many tiles to patrol
@export var wait_time: float = 1.0    # Pause between moves

var direction: int = -1
var start_position: Vector2
var target_position: Vector2
var is_moving: bool = false
var wait_timer: float = 0.0
var tiles_moved: int = 0
var enemy_state: String = "idle"

func _ready():
	# Snap to grid
	global_position = Vector2(
		round(global_position.x / tile_size) * tile_size,
		round(global_position.y / tile_size) * tile_size
	)
	start_position = global_position
	target_position = global_position

func _physics_process(delta):
	if is_moving:
		# Move towards target
		global_position = global_position.move_toward(target_position, speed * tile_size * delta)
		
		if global_position.distance_to(target_position) < 1:
			global_position = target_position
			is_moving = false
			enemy_state = "idle"
			wait_timer = wait_time
			tiles_moved += 1
			
			# Check if we need to turn around
			if tiles_moved >= move_distance:
				direction *= -1
				tiles_moved = 0
	else:
		# Wait before next move
		if wait_timer > 0:
			wait_timer -= delta
		else:
			# Start next move
			target_position = global_position + Vector2(direction * tile_size, 0)
			is_moving = true
			enemy_state = "walk"
			
			# Flip sprite
			$AnimatedSprite2D.flip_h = direction < 0
	
	play_anim()

func play_anim():
	match enemy_state:
		"idle":
			$AnimatedSprite2D.play("idle")
		"walk":
			$AnimatedSprite2D.play("walk")
		"run":
			$AnimatedSprite2D.play("run")
