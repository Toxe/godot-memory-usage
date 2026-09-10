extends Control

var _scene: PackedScene = null
var _instance: Node = null
var _object: Object = null
var _refcounted: RefCounted = null
var _resource: Resource = null

@onready var _timer: Timer = $Timer


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

    var scene_size1 := m1 - m0
    var scene_size2 := m3 - m4
    var scene_size_diff := scene_size1 - scene_size2
    var instance_size1 := m2 - m1
    var instance_size2 := m2 - m3
    var instance_size_diff := instance_size1 - instance_size2

    if scene_size_diff == 0 && instance_size_diff == 0:
        print("%s: scene=%d, instance=%d" % [path, scene_size1, instance_size1])
    else:
        print("%s: ERROR, something went wrong, scene: %d vs. %d, instance: %d vs. %d" % [path, scene_size1, scene_size2, instance_size1, instance_size2])


func _measure_object() -> void:
    var _throw_away := await _wait_and_get_memory()
    var m0 := await _wait_and_get_memory()

    _object = Object.new()
    var m1 := await _wait_and_get_memory()

    _object.free()
    _object = null
    var m2 := await _wait_and_get_memory()

    var size1 := m1 - m0
    var size2 := m1 - m2
    var size_diff := size1 - size2

    if size_diff == 0:
        print("object=%d" % [size1])
    else:
        print("ERROR, something went wrong, object: %d vs. %d" % [size1, size2])


func _measure_refcounted() -> void:
    var _throw_away := await _wait_and_get_memory()
    var m0 := await _wait_and_get_memory()

    _refcounted = RefCounted.new()
    var m1 := await _wait_and_get_memory()

    _refcounted = null
    var m2 := await _wait_and_get_memory()

    var size1 := m1 - m0
    var size2 := m1 - m2
    var size_diff := size1 - size2

    if size_diff == 0:
        print("refcounted=%d" % [size1])
    else:
        print("ERROR, something went wrong, refcounted: %d vs. %d" % [size1, size2])


func _measure_resource() -> void:
    var _throw_away := await _wait_and_get_memory()
    var m0 := await _wait_and_get_memory()

    _resource = Resource.new()
    var m1 := await _wait_and_get_memory()

    _resource = null
    var m2 := await _wait_and_get_memory()

    var size1 := m1 - m0
    var size2 := m1 - m2
    var size_diff := size1 - size2

    if size_diff == 0:
        print("resource=%d" % [size1])
    else:
        print("ERROR, something went wrong, resource: %d vs. %d" % [size1, size2])


func _on_measure_load_scenes_button_pressed() -> void:
    print("============================================================")
    await _measure_scene("res://scenes/test_scenes/empty_node.tscn")
    await _measure_scene("res://scenes/test_scenes/empty_node2d.tscn")
    await _measure_scene("res://scenes/test_scenes/empty_control.tscn")
    assert(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == 0)


func _on_measure_objects_button_pressed() -> void:
    print("============================================================")
    await _measure_object()
    assert(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == 0)


func _on_measure_ref_counted_button_pressed() -> void:
    print("============================================================")
    await _measure_refcounted()
    assert(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == 0)


func _on_measure_resources_button_pressed() -> void:
    print("============================================================")
    await _measure_resource()
    assert(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == 0)
