extends Node

var _scene1: PackedScene = preload("res://scenes/test_scenes/empty_node.tscn")
var _scene2: PackedScene = preload("res://scenes/test_scenes/empty_node2d.tscn")
var _scene3: PackedScene = preload("res://scenes/test_scenes/empty_control.tscn")
var _instance1: Node = null
var _instance2: Node = null
var _instance3: Node = null


func load_scenes() -> void:
    pass


func instantiate_scenes() -> void:
    _instance1 = _scene1.instantiate()
    _instance2 = _scene2.instantiate()
    _instance3 = _scene3.instantiate()


func cleanup_scenes() -> void:
    pass


func cleanup_instances() -> void:
    _instance1.queue_free()
    _instance2.queue_free()
    _instance3.queue_free()
    _instance1 = null
    _instance2 = null
    _instance3 = null
