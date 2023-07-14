extends AudioStreamPlayer

@onready var music_player = $"."

func set_level_music(music_name: String):
	var music: AudioStream = load(music_name)
	music_player.set_stream(music)
