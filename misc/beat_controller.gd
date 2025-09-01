extends Node

@export var tilemap: TileMapLayer
@export var audio_player: AudioStreamPlayer

@export var cycle_length: int = 8
@export var warning_beats: int = 2
@export var beats_per_minute: float = 100

var current_beat: int = 0
var active_color: int = 1
var beat_timer: float = 0.0
var seconds_per_beat: float = 0.0

const SOLID   = 1
const WARNING = 2
const GHOST   = 3

const BLUE = 1
const PINK = 2

var atlas_lookup = {
	SOLID: {
		BLUE:  Vector2i(3, 0),
		PINK:  Vector2i(4, 0),
	},
	WARNING: {
		BLUE:  Vector2i(3, 0),
		PINK:  Vector2i(4, 0),
	},
	GHOST: {
		BLUE:  Vector2i(5, 0),
		PINK:  Vector2i(6, 0),
	},
}

func _ready() -> void:
	seconds_per_beat = 60.0 / beats_per_minute
	update_tiles()

func _process(delta: float) -> void:
	beat_timer += delta
	if beat_timer >= seconds_per_beat:
		beat_timer -= seconds_per_beat
		current_beat += 1
		update_tiles()

func update_tiles() -> void:
	var beat_in_cycle = current_beat % cycle_length

	# flip active color every cycle
	if beat_in_cycle == 0:
		active_color = PINK if active_color == BLUE else BLUE

	for cell in tilemap.get_used_cells():
		var tile_data = tilemap.get_cell_tile_data(cell)
		if not tile_data:
			continue

		var color: int = tile_data.get_custom_data("color")
		var state: int = tile_data.get_custom_data("state")

		if color == 0 or state == 0:
			continue


		if color == active_color:
			if beat_in_cycle >= cycle_length - warning_beats:
				state = WARNING
			else:
				state = SOLID
		else:
			state = GHOST


		if state in atlas_lookup and color in atlas_lookup[state]:
			var atlas_coords = atlas_lookup[state][color]
			tilemap.set_cell(cell, 0, atlas_coords)
