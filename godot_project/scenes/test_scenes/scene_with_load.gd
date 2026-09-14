extends Node

var _scene1: PackedScene = null
var _scene2: PackedScene = null
var _scene3: PackedScene = null
var _instance1: Node = null
var _instance2: Node = null
var _instance3: Node = null


func load_scenes() -> void:
    _scene1 = load("res://scenes/test_scenes/empty_node.tscn")
    _scene2 = load("res://scenes/test_scenes/empty_node2d.tscn")
    _scene3 = load("res://scenes/test_scenes/empty_control.tscn")


func instantiate_scenes() -> void:
    _instance1 = _scene1.instantiate()
    _instance2 = _scene2.instantiate()
    _instance3 = _scene3.instantiate()


func cleanup_scenes() -> void:
    _scene1 = null
    _scene2 = null
    _scene3 = null


func cleanup_instances() -> void:
    _instance1.queue_free()
    _instance2.queue_free()
    _instance3.queue_free()
    _instance1 = null
    _instance2 = null
    _instance3 = null
