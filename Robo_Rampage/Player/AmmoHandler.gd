extends Node
class_name AmmoHandler

@export var ammo_label: Label

enum ammo_type {
	BULLET,
	SMALL_BULLET
}

var ammo_storage := {
	ammo_type.BULLET: 10,
	ammo_type.SMALL_BULLET: 60
}

func has_ammo(type: ammo_type) -> bool:
	return ammo_storage[type] > 0

func use_ammo(type: ammo_type) -> void:
	if has_ammo(type):
		ammo_storage[type] -= 1
		update_ammo_label(type)
		
func add_ammo(type: ammo_type, amount: int) -> void:
	var string_ammo_type := str(ammo_storage[type])
	if ammo_label.text == string_ammo_type:
		ammo_storage[type] += amount
		update_ammo_label(type)
	else:
		ammo_storage[type] += amount

func update_ammo_label(type: ammo_type) -> void:
	ammo_label.text = str(ammo_storage[type])
