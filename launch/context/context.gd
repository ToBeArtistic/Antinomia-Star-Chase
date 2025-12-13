extends Node

var data : Dictionary[String, Variant] = {
	"secret" : {
		"1337" : "magic"
	}
}

func _ready() -> void:
	print_debug(data)


