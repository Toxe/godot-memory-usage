# Godot Memory Usage Test

| Class      | Engine (Source Code) | GDScript Measured |
| ---------- | -------------------: | ----------------: |
| Object     |                  312 |               352 |
| RefCounted |                  328 |               368 |
| Resource   |                  456 |               496 |
| Node       |                  784 |               784 |
| Node2D     |                 1216 |              1216 |
| Control    |                 2272 |              2904 |

| Scene                   | Loading Scene | Instantiating |
| ----------------------- | ------------: | ------------: |
| empty_node              |          1636 |           784 |
| empty_node2d            |          1652 |          1216 |
| empty_control           |          2028 |          2904 |
| node_with_empty_script  |          1860 |           920 |
| node_with_simple_script |          1844 |           920 |

| Scene              | Loading Scene | Instantiating | Instantiating Sub-Scenes |
| ------------------ | ------------: | ------------: | -----------------------: |
| scene_with_load    |          1808 |          1564 | 4904                     |
| scene_with_preload |          1832 |          1564 | 4904                     |
