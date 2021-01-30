extends Node

enum KEY_PARTS {
	HEAD,
	UPPER_BODY,
	LOWER_BODY
}
const PARTS = {
	KEY_PARTS.HEAD: "head",
	KEY_PARTS.UPPER_BODY: "upper_body",
	KEY_PARTS.LOWER_BODY: "lower_body",
}

enum KEY_COLORS {
	BLUE,
	BROWN,
	ROSE,
	LIGHT_GREEN,
	GREEN,
	PURPLE,
	RED,
	YELLOW
}
const COLORS = {
	KEY_COLORS.BLUE: "blue",
	KEY_COLORS.BROWN: "brown",
	KEY_COLORS.ROSE: "rose",
	KEY_COLORS.LIGHT_GREEN: "light_green",
	KEY_COLORS.GREEN: "green",
	KEY_COLORS.PURPLE: "purple",
	KEY_COLORS.RED: "red",
	KEY_COLORS.YELLOW: "yellow"
}
enum KEY_OBJECTS {
	BOOK,
	CARD,
	PHONE,
	GLASS,
	UNKNOWN,
	KEY,
	RING,
	TOY
}
const OBJECTS = {
	KEY_OBJECTS.BOOK: preload("res://objects/assets/book.png"),
	KEY_OBJECTS.CARD: preload("res://objects/assets/CCard.png"),
	KEY_OBJECTS.PHONE: preload("res://objects/assets/cellphone.png"),
	KEY_OBJECTS.GLASS: preload("res://objects/assets/glass.png"),
	KEY_OBJECTS.UNKNOWN: preload("res://objects/assets/green.png"),
	KEY_OBJECTS.KEY: preload("res://objects/assets/key.png"),
	KEY_OBJECTS.RING: preload("res://objects/assets/ring.png"),
	KEY_OBJECTS.TOY: preload("res://objects/assets/toy.png"),
}

const ANIMATION_PATH_FORMAT = "res://mobs/client/animations/%s_%s.tres"
const CLIENT_ID_FORMAT = "%s|%s|%s"

var difficulty = 40
var client_ressources = {}
var client_with_object = {}
var available_objects = [
	KEY_OBJECTS.BOOK,
	KEY_OBJECTS.CARD,
	KEY_OBJECTS.PHONE,
	KEY_OBJECTS.GLASS,
	KEY_OBJECTS.UNKNOWN,
	KEY_OBJECTS.KEY,
	KEY_OBJECTS.RING,
	KEY_OBJECTS.TOY
]
var client_spawned := 0

onready var _obj = preload("res://objects/Object.tscn")

func _ready():
	randomize()
	available_objects.shuffle()
	Events.connect("request_spawn", self, "_on_spawn_requested")
	Events.connect("on_mob_despawn", self, "_on_mob_despawn")
	Events.connect("on_object_dropped", self, "_on_object_dropped")
	for color in COLORS:
		for part in PARTS:
			var path = ANIMATION_PATH_FORMAT % [COLORS[color], PARTS[part]]
			client_ressources[COLORS[color] + "|" + PARTS[part]] = load(path)

func _get_random_key():
	var head_color = COLORS[randi() % len(KEY_COLORS)]
	var upper_color = COLORS[randi() % len(KEY_COLORS)]
	var lower_color = COLORS[randi() % len(KEY_COLORS)]
	return CLIENT_ID_FORMAT % [head_color, upper_color, lower_color]

func _get_random_color_id():
	var color = _get_random_key()
	while color in client_with_object:
		color = _get_random_key()
	return color

func get_animations(id: String):
	var colors = id.split("|", false)
	return [
		client_ressources[colors[KEY_PARTS.HEAD] + "|" + PARTS[KEY_PARTS.HEAD]],
		client_ressources[colors[KEY_PARTS.UPPER_BODY] + "|" + PARTS[KEY_PARTS.UPPER_BODY]],
		client_ressources[colors[KEY_PARTS.LOWER_BODY] + "|" + PARTS[KEY_PARTS.LOWER_BODY]],
	]

func _get_random_object():
	if len(available_objects) > 0:
		return available_objects.pop_back()

func can_generate():
	pass

func _get_odd():
	var available = len(available_objects)
	if available == 0:
		return 0
	return randi() % (available * 10)

func _on_spawn_requested(spawner, mob):
	if client_spawned > difficulty:
		mob.queue_free()
		return
	client_spawned += 1
	var odd = _get_odd()
	var obj = null
	var id = _get_random_color_id()
	if odd < len(available_objects) and spawner.direction == Constants.DIRECTIONS.RIGHT:
		obj = available_objects.pop_back()
		client_with_object[id] = obj
	mob.init(id, obj)
	Events.emit_signal("spawn", spawner, mob)

func _on_mob_despawn(mob):
	client_spawned -= 1

func _on_object_dropped(obj, mob):
	var item: Obj = _obj.instance()
	item.init(OBJECTS[obj], mob.position, mob.z_index)
	mob.get_parent().add_child(item)
