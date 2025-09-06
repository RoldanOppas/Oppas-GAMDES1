extends CharacterBody2D

@export var tile_size: int = 16
@export var speed: float = 2.0
@export var move_distance: int = 5
@export var wait_time: float = 1.0

var direction: int = -1
var target_x: float
var is_moving: bool = false
var wait_timer: float = 0.0
var tiles_moved: int = 0
var enemy_state: String = "idle"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Snap to grid horizontally
	global_position.x = round(global_position.x / tile_size) * tile_size
	target_x = global_position.x

func _physics_process(delta):
	# Add gravity - enemy will fall and touch ground
	if not is_on_floor():
		velocity.y += gravity * delta
		enemy_state = "idle"  # Use idle animation when falling
	else:
		velocity.y = 0
	
	# Handle horizontal movement - only when on ground
	if is_on_floor():
		if is_moving:
			# Move towards target
			global_position.x = move_toward(global_position.x, target_x, speed * tile_size * delta)
			velocity.x = sign(target_x - global_position.x) * speed * tile_size
			
			if abs(global_position.x - target_x) < 1:
				global_position.x = target_x
				is_moving = false
				enemy_state = "idle"
				wait_timer = wait_time
				tiles_moved += 1
				velocity.x = 0
				
				# Check if we need to turn around
				if tiles_moved >= move_distance:
					direction *= -1
					tiles_moved = 0
		else:
			velocity.x = 0
			
			# Wait before next move
			if wait_timer > 0:
				wait_timer -= delta
			else:
				# Start next move
				target_x = global_position.x + direction * tile_size
				is_moving = true
				enemy_state = "walk"
				
				# Flip sprite
				$AnimatedSprite2D.flip_h = direction < 0
	else:
		# When in air, stop horizontal movement
		velocity.x = 0
		is_moving = false
		enemy_state = "idle"
	
	# Apply movement
	move_and_slide()
	
	play_anim()

func play_anim():
	match enemy_state:
		"idle":
			$AnimatedSprite2D.play("idle")
		"walk":
			$AnimatedSprite2D.play("walk")
		"run":
			$AnimatedSprite2D.play("run")
