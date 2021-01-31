extends Control

onready var t_alert = preload("res://popup/assets/info_halt.png")
onready var t_no = preload("res://popup/assets/info_no.png")
onready var t_question = preload("res://popup/assets/info_question.png")
onready var t_empty = preload("res://popup/assets/info_empty.png")

func _ready():
	none()

func _show(t_bubble, t_obj = null):
	$Bubble.texture = t_bubble
	$Obj.texture = t_obj
	$Timer.start()

func none():
	$Bubble.texture = null
	$Obj.texture = null

func alert():
	_show(t_alert)

func no():
	_show(t_no)

func question():
	_show(t_question)

func object(obj: Obj):
	_show(t_empty, obj.get_texture())

func _on_Timer_timeout():
	none()
