extends Node

@export var tilemap: TileMapLayer

@export var audio_player: AudioStreamPlayer2D

@export var cycle_length: int = 8
@export var warning_beats: int = 2
@export var beats_per_minute: float = 100

var current_beat: int = 0
var active_color: int = 1
var beat_timer: float = 0.0
var seconds_per_beat = 60/beats_per_minute
const SOLID = 1
const WARNING = 2
const GHOST = 3

const BLUE = 1
const PINK = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_tiles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	beat_timer += delta
	if beat_timer >= seconds_per_beat:
		beat_timer -= seconds_per_beat
		current_beat += 1
		update_tiles()
		
func update_tiles() -> void:
	var beat_in_cycle = current_beat%cycle_length
	if beat_in_cycle == 0:
		active_color = PINK if active_color == BLUE else BLUE # fun litl single liner
		if audio_player:
			if audio_player.stream:
				beats_per_minute = audio_player.get_stream_bpm()
				print(beats_per_minute)
				seconds_per_beat = 60.0 / beats_per_minute
	
	for cell in tilemap.get_used_cells():
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data:
			var color = tile_data.get_custom_data("color")
			var state = tile_data.get_custom_data("state")
			if color == 0 or state == 0:
				continue

			if color == active_color:
				if current_beat > cycle_length-warning_beats:
					state = WARNING
				else:
					state = SOLID
			else:
				state = GHOST

			var atlas_coords = Vector2(color-1, state-1)
			tilemap.set_cell(cell, 0, atlas_coords)
