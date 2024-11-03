class_name ScreenOverlay
extends Node2D

@export var color: Color

func _draw():
	draw_rect(get_viewport_rect()*get_canvas_transform(), color)

func _process(_delta):
	queue_redraw()
