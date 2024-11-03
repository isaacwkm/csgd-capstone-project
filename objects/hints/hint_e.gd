class_name HintE
extends Hint

@onready var _subject := $'..' as CarriableItem

func _should_open():
	return _subject.in_contact

func _should_close():
	return _subject.is_carried()
