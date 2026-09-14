extends Control

var _scene: PackedScene = null
var _instance: Node = null
var _object: Object = null

@onready var _timer: Timer = $Timer


func _ready() -> void:
    ($HBoxContainer/VBoxContainer/MeasureObjectsButton as Control).grab_focus()


func _wait_and_get_memory() -> int:
    _timer.start();
    await _timer.timeout
    return int(Performance.get_monitor(Performance.MEMORY_STATIC))


func _measure_scene(path: String) -> void:
    var _throw_away := await _wait_and_get_memory()
    var m0 := await _wait_and_get_memory()

    _scene = load(path)
    var m1 := await _wait_and_get_memory()

    _instance = _scene.instantiate()
    var m2 := await _wait_and_get_memory()

    _instance.queue_free()
    _instance = null
    var m3 := await _wait_and_get_memory()

    _scene = null
    var m4 := await _wait_and_get_memory()

    var scene_size := m1 - m0
    var instance_size := m2 - m1
    if scene_size == (m3 - m4) && instance_size == (m2 - m3):
        print("%s, scene: %d, instance: %d" % [path, scene_size, instance_size])
    else:
        print("%s, ERROR, something went wrong" % [path])
    assert(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == 0)


func _measure_type(type: Variant) -> void:
    var _throw_away := await _wait_and_get_memory()
    var m0 := await _wait_and_get_memory()

    @warning_ignore("unsafe_method_access")
    _object = type.new()
    var m1 := await _wait_and_get_memory()

    var type_name := _get_type_name(_object)
    var m2 := await _wait_and_get_memory()

    if _object is not RefCounted:
        _object.free()
    _object = null
    var m3 := await _wait_and_get_memory()

    var type_size := m1 - m0
    if type_size == (m2 - m3):
        print("%s: %d" % [type_name, type_size])
    else:
        print("ERROR, something went wrong")
    assert(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == 0)


func _get_type_name(type: Variant) -> String:
    return str(type).get_slice("<", 1).get_slice("#", 0)


func _on_measure_load_scenes_button_pressed() -> void:
    await _measure_scene("res://scenes/test_scenes/empty_node.tscn")
    await _measure_scene("res://scenes/test_scenes/empty_node2d.tscn")
    await _measure_scene("res://scenes/test_scenes/empty_control.tscn")
    await _measure_scene("res://scenes/test_scenes/node_with_empty_script.tscn")
    await _measure_scene("res://scenes/test_scenes/node_with_simple_script.tscn")


func _on_measure_objects_button_pressed() -> void:
    await _measure_type(Object)


func _on_measure_ref_counted_button_pressed() -> void:
    await _measure_type(RefCounted)


func _on_measure_resources_button_pressed() -> void:
    await _measure_type(Resource)


func _on_quit_button_pressed() -> void:
    get_tree().quit()
