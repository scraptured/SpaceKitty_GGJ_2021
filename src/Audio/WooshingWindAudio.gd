extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play_wind_audio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.playing == false:
		var x = randf() 
		if x > 0.9:
			play_wind_audio()
			



func choose_wind_audio(boot_audio: AudioStreamPlayer):
	var format_string := "res://AssetsSK/Sound Effects/Effects/Wind/Whooshing Wind -- %s.wav"
	var choice = (randi() % 4) + 1
	var actual_string := format_string % str(choice)
	self.stream = load(actual_string)
	
func play_wind_audio() -> void:
	choose_wind_audio(self)
	self.play()
