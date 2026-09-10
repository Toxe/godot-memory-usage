extends Control

var _scene: PackedScene = null
var _instance: Node = null

@onready var _timer: Timer = $Timer


func _on_measure_load_scenes_button_pressed() -> void:
    print("============================================================")
    await measure_scene("res://scenes/test_scenes/empty_node.tscn")
    await measure_scene("res://scenes/test_scenes/empty_node2d.tscn")
    await measure_scene("res://scenes/test_scenes/empty_control.tscn")
    assert(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == 0)


func wait_and_get_memory() -> int:
    _timer.start();
    await _timer.timeout
    return int(Performance.get_monitor(Performance.MEMORY_STATIC))


func measure_scene(path: String) -> void:
    var _throw_away := await wait_and_get_memory()
    var m0 := await wait_and_get_memory()

    _scene = load(path)
    var m1 := await wait_and_get_memory()

    _instance = _scene.instantiate()
    var m2 := await wait_and_get_memory()

    _instance.queue_free()
    _instance = null
    var m3 := await wait_and_get_memory()

    _scene = null
    var m4 := await wait_and_get_memory()

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
