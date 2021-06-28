网床 插件可用于补偿热床表面的不规则性，以保证在打印过程中获得更好的第一层。 需要注意的是，基于软件的校正还不能达到完美的程度，它只能尽可能达到床的形状。网床
也无法补偿机械和电气导致的问题。 如果机器没装好结构歪了或探针不准确，则 网床 模块将无法从探测过程中获得令人满意的结果。

在进行网格校准之前，请确保您已经校准了探头的 Z 偏移。 如果使用限位开关进行 Z 归位，则还需要对其进行校准。 有关详细信息，请参阅
[手动调平](Manual_Level.md) 中的 [探针校准](Probe_Calibrate.md) 和 Z_ENDSTOP_CALIBRATE。

## 基本配置

### 矩形床

此示例假定打印机具有 250 mm x 220 mm 矩形床和一个 x 偏移为 24 mm和 y 偏移为 5 mm的探针。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35,6
mesh_max: 240, 198
probe_count: 5,3
```

- `speed: 120` *默认值：50* 探针在两个点之间移动的速度。

- `horizontal_move_z: 5` *默认值：5* 探针前往下一个点之前Z需要抬升的高度。

- `mesh_min: 35,6` *必须配置* 第一个探测的坐标，距离原点最近。该坐标就是探针所在的位置。

- `mesh_max: 240,198` *必须配置* 距离原点最远的探测坐标。 这不一定是探测的最后一个点，因为探测过程以锯齿形的方式运动。 与
`mesh_min` 一样，这个坐标是探针的位置。

- `probe_count: 5,3` *默认值：3,3* 每条轴上要探测的点数，指定为 x,y 整数值。 在本示例中，将沿 X 轴探测 5 个点，沿 Y 轴探测
3 个点，总共探测 15 个点。 请注意，如果您想要一个方形网格，例如 3x3，可以将指定其为一个整数值，比如 `probe_count: 3`。
请注意，网格需要沿每个轴的最小probe_count 为3。


下图演示了如何使用 `mesh_min`、`mesh_max` 和 `probe_count` 选项来生成探测点。
箭头表示探测过程的运动方向，从“mesh_min”开始。 图中所示，当探针位于“mesh_min”时，喷嘴将位于 (11,
1)，当探针位于“mesh_max”时，喷嘴将位于 (206, 193)。

![矩形网床基本配置](img/bedmesh_rect_basic.svg)

### 圆形床

本示例假设打印机配备的圆床半径为 100 mm。 我们将使用与矩形网床示例相同的探针偏移来演示，X 偏移为 24 mm，Y 偏移为 5 mm。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_radius: 75
mesh_origin: 0,0
round_probe_count: 5
```

- `mesh_radius: 75` *必须配置* 探测网格范围的半径（以毫米为单位），相对于 `mesh_origin`。
请注意，探针的偏移会限制网格半径的大小。 在此示例中，大于 76 mm的半径会将打印头移动到打印机的范围之外。

- `mesh_origin: 0,0` *默认值： 0,0* 探测网格的中心点。 该坐标相对于探针的位置。 虽然默认值为
0,0，但为了探测床更多的部分而调整原点可能很有用。 请参阅下图。

- `round_probe_count: 5` *Default Value: 5* This is an integer value that defines
the maximum number of probed points along the X and Y axes. By "maximum", we
mean the number of points probed along the mesh origin. This value must be an
odd number, as it is required that the center of the mesh is probed.


下图展示了如何生成探测点。 如您所见，将 `mesh_origin` 设置为 (-10, 0) 允许我们指定更大的网格半径 85mm。

![圆形网床基本配置](img/bedmesh_round_basic.svg)

## 高级配置

下面详细解释了更高级的配置选项。 每个示例都将建立在上面显示的基本矩形床配置之上。 每个高级选项都以相同的方式应用于圆床。

### 网格插值

虽然可以使用简单的双线性插值直接对探测网格的数据进行采样以确定探测点之间的 Z 值，但使用更高级的插值算法来插入额外的点以增加网格密度通常很有用。
这些算法向网格添加曲率，试图模拟床的材料属性。 网床提供了拉格朗日和双三次插值来实现这一点。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35,6
mesh_max: 240, 198
probe_count: 5,3
mesh_pps: 2,3
algorithm: bicubic
bicubic_tension: 0.2
```

- `mesh_pps: 2,3` *默认值：2,2*`mesh_pps` 选项是每段网格点数的简写。 此选项指定沿 x 轴和 y 轴为每个线段插值的点数。
将“段”视为每个探测点之间的间隔。 与 `probe_count` 一样，`mesh_pps` 被指定为 x,y 整数对，也可以指定为应用于两个轴的单个整数。
在此示例中，沿 X 轴有 4 个线段，沿 Y 轴有 2 个线段。 这计算为沿 X 的 8 个插值点，沿 Y 的 6 个插值点，从而产生 13x8 网格。
请注意，如果 mesh_pps 设置为 0，则禁用网格插值，并且将直接对探测网格进行采样。

- `algorithm: lagrange` *默认值：lagrange* 用于插入网格的算法。 可能是 `lagrange` or `bicubic`。
拉格朗日插值最多为 6 个探测点，因为大量样本容易发生振荡。 双三次插值要求沿每个轴至少有 4 个探测点，如果指定的点少于 4 个，则强制拉格朗日采样。 如果
`mesh_pps` 设置为 0，则该值将被忽略，因为没有进行网格插值。

- `bicubic_tension: 0.2` *默认值：0.2* 双三次插值的张力值。如果`algorithm` 选项设置为双三次，则可以指定张力值。
张力越高，内插的斜率越大。 调整时要小心，因为较高的值也会产生更多的过冲，这将导致插值高于或低于探测点。


下图显示了如何使用上述选项生成网格插值。

![网床插值](img/bedmesh_interpolated.svg)

### 移动拆分

Bed Mesh 的工作原理是拦截 gcode 移动命令并对它们的 Z 坐标应用变换。 将长距离移动并拆分成更小的移动，让打印出来的效果尽量接近床的形状。
下面的选项控制如何拆分。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35,6
mesh_max: 240, 198
probe_count: 5,3
move_check_distance: 5
split_delta_z: .025
```

- `move_check_distance: 5` *默认值：5* 在执行拆分之前检查 Z 中需要变化的最小距离。 在此示例中，算法将遍历超过 5 毫米的移动。
每 5mm 将查找一次网格的Z ，并将其与前一次移动的 Z 值进行比较。 如果三角洲满足 `split_delta_z` 设置的阈值，则移动将被拆分并继续遍历。
重复此过程，直到到达移动结束处，在此将应用最终调整。 比 `move_check_distance` 短的移动将正确的 Z 调整直接应用于移动，无需遍历或拆分。

- `split_delta_z: .025` *默认值：.025* 如上所述，这是触发移动拆分所需的最小偏差。 在上面的示例中，任何偏差为 +/- .025
mm的 Z 值都将触发拆分。


一般来说，这些选项的默认值就足够了，但事实上，`move_check_distance` 的默认值 5mm 可能会有点过度矫正。
所以，高端可能希望尝试使用这个选项来获得挤出最佳的第一层。

### 网格淡出

When "fade" is enabled Z adjustment is phased out over a distance defined by
the configuration. This is accomplished by applying small adjustments to the
layer height, either increasing or decreasing depending on the shape of the bed.
When fade has completed, Z adjustment is no longer applied, allowing the top of
the print to be flat rather than mirror the shape of the bed. Fade also may have
some undesirable traits, if you fade too quickly it can result in visible
artifacts on the print. Also, if your bed is significantly warped, fade can
shrink or stretch the Z height of the print. As such, fade is disabled by
default.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35,6
mesh_max: 240, 198
probe_count: 5,3
fade_start: 1
fade_end: 10
fade_target: 0
```

- `fade_start: 1` *默认值：1* 开始网格淡出的值，在设定的fade_start值之后逐步停止调整Z的高度。 建议在打印几层之后再开始淡出层高。

- `fade_end: 10` *默认值：0* 网格淡出完成的 Z 高度。 如果此值低于`fade_start`，则禁用网格淡出。
该值可以根据打印表面的弯曲程度进行调整。 明显弯曲的表面应该在将网格淡出的距离长。 接近平坦的表面可能能够降低该值以更快地逐步淘汰。 如果对
`fade_start` 使用默认值 1，则 10mm 是一个合理的值。

- `fade_target: 0` *默认值：热床网格的平均Z值* `fade_target` 是在网格淡出完成后应用于整个床的额外 Z 偏移。一
般来说，这个值是 0，但有些情况下它需要改动。 例如，您在热床的归位位置与床的平均探测高度有偏差，它比床的平均探测高度低 0.2 mm。 如果
`fade_target` 为 0，淡出会将整个床的打印平均缩小 0.2 mm。 通过将 `fade_target` 设置为 0.2，归位的位置将扩大 0.2
毫米，但床的其余部分将具有准确的尺寸。 一般来说，最好不要修改 `fade_target` 而修正机器本身导致的误差，以便使用网格的平均高度，但是如果想要在床的特定部分打印，可能需要手动调整网格淡出。


### 相对参考索引

大部分探针检测到的值容易产生误差，即：由温度或探测介质干扰产生的探测误差。 这加大探针Z偏移的看计算难度，尤其是在不同的热床温度下。
因此，一些打印机使用限位开关来归位 Z 轴，并使用探针来校准网格。 这些打印机可以从配置的相对参考索引中寻找帮助。

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35,6
mesh_max: 240, 198
probe_count: 5,3
relative_reference_index: 7
```

- `relative_reference_index: 7` *Default Value: None (disabled)* When the probed
points are generated they are each assigned an index. You can look up this
index in klippy.log or by using BED_MESH_OUTPUT (see the section on Bed Mesh
GCodes below for more information). If you assign an index to the
`relative_reference_index` option, the value probed at this coordinate will
replace the probe's z_offset. This effectively makes this coordinate the
"zero" reference for the mesh.

When using the relative reference index, you should choose the index nearest to
the spot on the bed where Z endstop calibration was done. Note that when looking
up the index using the log or BED_MESH_OUTPUT, you should use the coordinates
listed under the "Probe" header to find the correct index.

### Faulty Regions

It is possible for some areas of a bed to report inaccurate results when probing
due to a "fault" at specific locations. The best example of this are beds with
series of integrated magnets used to retain removable steel sheets. The magnetic
field at and around these magnets may cause an inductive probe to trigger at a
distance higher or lower than it would otherwise, resulting in a mesh that does
not accurately represent the surface at these locations. **Note: This should not
be confused with probe location bias, which produces inaccurate results across
the entire bed.**

The `faulty_region` options may be configured to compensate for this affect. If
a generated point lies within a faulty region bed mesh will attempt to probe up
to 4 points at the boundaries of this region. These probed values will be
averaged and inserted in the mesh as the Z value at the generated (X, Y)
coordinate.

```
[bed_mesh]
speed: 120
horizontal_move_z: 5
mesh_min: 35,6
mesh_max: 240, 198
probe_count: 5,3
faulty_region_1_min: 130.0, 0.0
faulty_region_1_max: 145.0, 40.0
faulty_region_2_min: 225.0, 0.0
faulty_region_2_max: 250.0, 25.0
faulty_region_3_min: 165.0, 95.0
faulty_region_3_max: 205.0, 110.0
faulty_region_4_min: 30.0, 170.0
faulty_region_4_max: 45.0, 210.0
```

- `faulty_region_{1...99}_min` `faulty_region_{1..99}_max` *Default Value: None
(disabled)* Faulty Regions are defined in a way similar to that of mesh itself,
where minimum and maximum (X, Y) coordinates must be specified for each region.
A faulty region may extend outside of a mesh, however the alternate points
generated will always be within the mesh boundary. No two regions may overlap.

The image below illustrates how replacement points are generated when a
generated point lies within a faulty region. The regions shown match those in
the sample config above. The replacement points and their coordinates are
identified in green.

![bedmesh_interpolated](img/bedmesh_faulty_regions.svg)

## Bed Mesh Gcodes

### Calibration

`BED_MESH_CALIBRATE METHOD=[manual | automatic] [<probe_parameter>=<value>] [<mesh_parameter>=<value>]`
*Default Method: automatic if a probe is detected, otherwise manual*

Initiates the probing procedure for Bed Mesh Calibration. If `METHOD=manual` is
selected then manual probing will occur. When switching between automatic and
manual probing the generated mesh points will automatically be adjusted.

It is possible to specify mesh parameters to modify the probed area. The
following parameters are available:

- Rectangular beds (cartesian):
  - `MESH_MIN`
  - `MESH_MAX`
  - `PROBE_COUNT`

- Round beds (delta):
  - `MESH_RADIUS`
  - `MESH_ORIGIN`
  - `ROUND_PROBE_COUNT`

- All beds:
  - `RELATIVE_REFERNCE_INDEX`
  - `ALGORITHM` See the configuration documentation above for details on how each
parameter applies to the mesh.


### Profiles

`BED_MESH_PROFILE SAVE=name LOAD=name REMOVE=name`

After a BED_MESH_CALIBRATE has been performed, it is possible to save the
current mesh state into a named profile. This makes it possible to load a mesh
without re-probing the bed. After a profile has been saved using
`BED_MESH_PROFILE SAVE=name` the `SAVE_CONFIG` gcode may be executed to write
the profile to printer.cfg.

Profiles can be loaded by executing `BED_MESH_PROFILE LOAD=name`.

It should be noted that each time a BED_MESH_CALIBRATE occurs, the current state
is automatically saved to the *default* profile. If this profile exists it is
automatically loaded when Klipper starts. If this behavior is not desirable the
*default* profile can be removed as follows:

`BED_MESH_PROFILE REMOVE=default`

Any other saved profile can be removed in the same fashion, replacing *default*
with the named profile you wish to remove.

### Output

`BED_MESH_OUTPUT PGP=[0 | 1]`

Outputs the current mesh state to the terminal. Note that the mesh itself is
output

The PGP parameter is shorthand for "Print Generated Points". If `PGP=1` is
set, the generated probed points will be output to the terminal:

```
// bed_mesh: generated points
// Index | Tool Adjusted | Probe
// 0 | (11.0, 1.0) | (35.0, 6.0)
// 1 | (62.2, 1.0) | (86.2, 6.0)
// 2 | (113.5, 1.0) | (137.5, 6.0)
// 3 | (164.8, 1.0) | (188.8, 6.0)
// 4 | (216.0, 1.0) | (240.0, 6.0)
// 5 | (216.0, 97.0) | (240.0, 102.0)
// 6 | (164.8, 97.0) | (188.8, 102.0)
// 7 | (113.5, 97.0) | (137.5, 102.0)
// 8 | (62.2, 97.0) | (86.2, 102.0)
// 9 | (11.0, 97.0) | (35.0, 102.0)
// 10 | (11.0, 193.0) | (35.0, 198.0)
// 11 | (62.2, 193.0) | (86.2, 198.0)
// 12 | (113.5, 193.0) | (137.5, 198.0)
// 13 | (164.8, 193.0) | (188.8, 198.0)
// 14 | (216.0, 193.0) | (240.0, 198.0)
```

The "Tool Adjusted" points refer to the nozzle location for each point, and
the "Probe" points refer to the probe location. Note that when manually
probing the "Probe" points will refer to both the tool and nozzle locations.

### Clear Mesh State

`BED_MESH_CLEAR`

This gcode may be used to clear the internal mesh state.

### Apply X/Y offsets

`BED_MESH_OFFSET [X=<value>] [Y=<value>]`

This is useful for printers with multiple independent extruders, as an offset is
necessary to produce correct Z adjustment after a tool change. Offsets should be
specified relative to the primary extruder. That is, a positive X offset should
be specified if the secondary extruder is mounted to the right of the primary
extruder, and a positive Y offset should be specified if the secondary extruder
is mounted "behind" the primary extruder.
