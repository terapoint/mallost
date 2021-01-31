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

var difficulty = 100
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
var object_on_hold = {}
var selected_inventory_slot: Slot

onready var _obj = preload("res://objects/Object.tscn")
onready var _security_char = preload("res://mobs/security/SecurityChar.tscn")

func _ready():
	randomize()
	available_objects.shuffle()
	Events.connect("request_spawn", self, "_on_spawn_requested")
	Events.connect("on_mob_despawn", self, "_on_mob_despawn")
	Events.connect("on_object_dropped", self, "_on_object_dropped")
	Events.connect("on_object_clicked", self, "_on_object_clicked")
	Events.connect("on_mob_clicked", self, "_on_mob_clicked")
	Events.connect("select_inventory_slot", self, "_on_inventory_slot_selected")
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

func _should_add_object():
	var available = len(available_objects)
	if available == 0:
		return false
	var rand = randi() % 100
	return rand < 10

func _on_spawn_requested(spawner: Spawner, mob: Mob):
	if client_spawned > difficulty:
		mob.queue_free()
		return
	client_spawned += 1
	var id = _get_random_color_id()
	var obj_id = null
	if _should_add_object() and spawner.direction == Constants.DIRECTIONS.RIGHT:
		obj_id = available_objects.pop_back()
		client_with_object[id] = obj_id
	mob.init(id, spawner, obj_id)
	Events.emit_signal("spawn", spawner, mob)

func _on_mob_despawn(mob):
	client_spawned -= 1

func _on_object_dropped(obj_id, mob):
	var obj: Obj = _obj.instance()
	obj.init(obj_id, OBJECTS[obj_id], mob.position, mob.spawner)

func _on_object_clicked(obj):
	var obj_key = hash(obj)
	if obj_key in object_on_hold:
		return
	object_on_hold[hash(obj)] = obj
	var security_char: SecurityChar = _security_char.instance()
	security_char.init(obj)
	Events.emit_signal("spawn", obj.spawner, security_char)

func _on_mob_clicked(mob: Client):
	if not selected_inventory_slot or selected_inventory_slot.is_empty():
		mob.show_what()
		return
	mob.stop()
	var obj = selected_inventory_slot.remove()
	var security_char: SecurityChar = _security_char.instance()
	security_char.init(obj, mob)
	Events.emit_signal("spawn", null, security_char)
	

func _on_inventory_slot_selected(slot):
	selected_inventory_slot = slot
