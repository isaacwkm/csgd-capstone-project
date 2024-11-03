class_name LevelCamera
extends Camera2D

@export var map: TileMapLayer
@export var subject: Node2D

func _ready():
	var rect = map.get_used_rect()
	var tsize = map.tile_set.tile_size
	limit_left = map.global_position.x + rect.position.x*tsize.x
	limit_right = limit_left + rect.size.x*tsize.x
	limit_top = map.global_position.y + rect.position.y*tsize.y
	limit_bottom = limit_top + rect.size.y*tsize.y

func _process(_delta):
	global_position = subject.global_position
