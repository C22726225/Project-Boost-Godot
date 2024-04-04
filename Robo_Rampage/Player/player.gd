extends CharacterBody3D
class_name Player

@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu
@onready var ammo_handler: Node = %AmmoHandler
@onready var game_win_menu: Control = $GameWinMenu
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pause_menu: Control = $PauseMenu

@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var weapon_camera: Camera3D = %WeaponCamera
@onready var smooth_camera_fov := smooth_camera.fov
@onready var weapon_camera_fov := weapon_camera.fov

@export var jump_height := 1.0
@export var fall_multiplier := 2.5
@export var max_hitpoints := 100
@export var aim_multiplier := 0.7
@export var zoom_speed := 20.0
@export var speed := 8.0
@export var head_bobbing_walk_intensity = 0.1
@export var head_bobbing_walk_speed = 14
@export var lerp_speed = 10.0

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 3.0
var head_bobbing_current_intensity = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
var health: int = max_hitpoints:
	set(value):
		if value < health:
			damage_animation_player.stop(false)
			damage_animation_player.play("TakeDamage")
		health = value
		if health <= 0:
			game_over_menu.game_over()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.pause_menu()

func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		smooth_camera.fov = lerp(
			smooth_camera.fov, 
			smooth_camera_fov * aim_multiplier, 
			delta * zoom_speed
			)
		weapon_camera.fov = lerp(
			weapon_camera.fov, 
			weapon_camera_fov * aim_multiplier, 
			delta * zoom_speed
			)
	else:
		smooth_camera.fov = lerp(
			smooth_camera.fov,
			smooth_camera_fov,
			delta * zoom_speed
			)
		weapon_camera.fov = lerp(
			weapon_camera.fov, 
			weapon_camera_fov, 
			delta * zoom_speed
			)

func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		head_bobbing_current_intensity = head_bobbing_walk_intensity
		head_bobbing_index += head_bobbing_walk_speed * delta
		if Input.is_action_pressed("aim"):
			velocity.x *= aim_multiplier
			velocity.z *= aim_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if is_on_floor() && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2) + 0.5
		
		camera_pivot.position.y = lerp(
			camera_pivot.position.y, 
			head_bobbing_vector.y * (head_bobbing_current_intensity/2), 
			delta * lerp_speed
			)
		camera_pivot.position.x = lerp(
			camera_pivot.position.x, 
			head_bobbing_vector.x * head_bobbing_current_intensity, 
			delta * lerp_speed
			)
	else:
		camera_pivot.position.y = lerp(
			camera_pivot.position.y, 
			0.0, 
			delta * lerp_speed
			)
		camera_pivot.position.x = lerp(
			camera_pivot.position.x, 
			0.0, 
			delta * lerp_speed
			)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * 0.001
			if Input.is_action_pressed("aim"):
				mouse_motion *= aim_multiplier
			
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.pause_menu()
		

func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x, -90.0, 90.0)
	mouse_motion = Vector2.ZERO
