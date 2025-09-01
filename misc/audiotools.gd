extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func get_stream_bpm():
	var playlist = stream as AudioStreamPlaylist
	if playlist:
		var pos = get_playback_position()
		var cumulative_time = 0.0
		
		for i in range(playlist.get_stream_count()):
			var _stream = playlist.get_list_stream(i)
			
			if _stream:
				cumulative_time += _stream.get_length()
				if pos < cumulative_time:
					return _stream.bpm

func get_current_stream_name():
	var playlist = stream as AudioStreamPlaylist
	if playlist:
		var pos = get_playback_position()
		var cumulative_time = 0.0
		
		for i in range(playlist.get_stream_count()):
			var _stream = playlist.get_list_stream(i)
			
			if _stream:
				cumulative_time += _stream.get_length()
				if pos < cumulative_time:
					return _stream.resource_path

	return "No stream playing"
