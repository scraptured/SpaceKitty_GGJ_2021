extends Actor

const TYPE = "player"

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	if Input.get_action_strength("sprint") == 1:
		speed.x = 500
		get_node("Walk_Left").speed_scale = 1
		get_node("Walk_Right").speed_scale = 1
	else:
		speed.x = 250
		get_node("Walk_Left").speed_scale = 0.75
		get_node("Walk_Right").speed_scale = 0.75
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	set_sprite()
	
	play_boot_audio()
	play_jump_audio()


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and (is_on_floor() or is_on_wall()) else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_inturrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_inturrupted:
		out.y = 0.0
	return out


func turn_off_sprites():
	get_node("Idle_Front").visible = false
	get_node("Walk_Left").visible = false
	get_node("Walk_Right").visible = false
	get_node("Jump_Left").visible = false
	get_node("Jump_Right").visible = false
	
	
func set_sprite():
	turn_off_sprites()
	if Input.get_action_strength("move_left") == 1:
		if is_on_floor(): get_node("Walk_Left").visible = true
		else: get_node("Jump_Left").visible = true
	elif Input.get_action_strength("move_right") == 1:
		if is_on_floor(): get_node("Walk_Right").visible = true
		else: get_node("Jump_Right").visible = true
	elif _velocity.x == 0 or is_on_floor(): get_node("Idle_Front").visible = true


#Audio Functions

func choose_boot_audio() :
	if Input.get_action_strength("sprint") == 1: 
		get_node("BootAudio").stream = load("res://AssetsSK/Sound Effects/Effects/Snow Crunch/Snow Crunch -- soft -- 2.wav")
	else:
		get_node("BootAudio").stream = load("res://AssetsSK/Sound Effects/Effects/Snow Crunch/Snow Crunch -- soft -- 40s.wav")
	
func play_boot_audio() -> void:
	if get_node("BootAudio").playing==false:
		if _velocity.x != 0 and is_on_floor():
			choose_boot_audio()
			get_node("BootAudio").play()
		elif Input.is_action_just_pressed("jump") and is_on_wall():
			choose_boot_audio()
			get_node("BootAudio").play()
		else:
			get_node("BootAudio").stop()
			
func choose_jump_audio(jump_audio: AudioStreamPlayer):
	var format_string := "res://AssetsSK/Sound Effects/Effects/Hehs and Hmphs/Heh -- %s.wav"
	var choice = (randi() % 3) + 1
	var actual_string := format_string % str(choice)
	jump_audio.stream = load(actual_string)
	jump_audio.play()
	
func play_jump_audio() -> void:
	if get_node("JumpAudio").playing==false:
		if Input.is_action_just_pressed("jump"):
			choose_jump_audio(get_node("JumpAudio"))
			get_node("BootAudio").play()
