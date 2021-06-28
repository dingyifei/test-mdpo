欢迎使用Klipper文档。如果刚接触Klipper，请从[特性](features.md)和[安装](installation.md)文档开始阅读。

# 概览信息

- [功能](Features.md)：Klipper 中的高级功能列表。
- [常见问题](FAQ.md)：常见问题。
- [发行版](Release.md)：Klipper的版本发布历史。
- [配置更改](Config_Changes.md)：可能需要手动更新打印机配置文件的软件更改。
- [联系](Contact.md)：关于如何提交错误报告和联系 Klipper 开发者的信息。

# 配置与调优指南

- [安装](Installation.md)：Klipper 安装指南。
- [配置参考](Config_Reference.md)：配置参数说明。
  - [旋转距离](Rotation_Distance.md)：计算rotation_distance步进参数。

- [检查配置](Config_checks.md)：验证配置文件中的基本引脚设置。
- [Bed level](Bed_Level.md): Information on "bed leveling" in Klipper.
  - [三角洲校准](Delta_Calibrate.md)：校准三角洲结构。
  - [探针校准](Probe_Calibrate.md)：校准自动Z探针。
  - [BL-Touch](BLTouch.md): Configure a "BL-Touch" Z probe.
  - [手动调平](Manual_Level.md)：校准 Z 限位和调整热床调平螺丝。
  - [床网](Bed_Mesh)：基于 XY 位置的热床高度补偿。
  - [限位相位](Endstop_Phase.md)：使用步进电机相位辅助Z限位定位。

- [共振补偿](Resonance_Compensation)：减少打印震纹的工具。
  - [测量共振](Measuring_Resonances.md)：使用 adxl345 加速度计模块测量共振。

- [提前压力](Pressure_Advance.md)：校准挤出机压力。
- [Slicers](Slicers.md): Configure "slicer" software for Klipper.
- [命令模板](Command_Templates.md)：G代码宏和条件判断。
  - [状态参考](Status_Reference.md)：可用于宏和类似功能的信息。

- [TMC驱动](TMC_Drivers.md)：在 Klipper 中使用 Trinamic 步进电机驱动。
- [偏斜校正](skew_correction.md): 轴调整不是一个完美的方形。
- [PWM 工具](Using_PWM_Tools.md)：关于如何使用 PWM 控制的工具，例如激光器或电钻头。
- [G-代码](G-Codes.md)：用于 Klipper 的G代码指令。

# 开发者文档

- [代码概述](Code_Overview.md)：开发者应该从这个文档开始阅读。
- [运动学](Kinematics.md)：关于 Klipper 如何实现运动的技术细节。
- [协议](Protocol.md)：主机和微控制器之间的低级通信协议的信息。
- [API 服务器](API_Server.md)：关于 Klipper 的命令和控制 API 的信息。
- [MCU 指令](MCU_Commands.md)：描述在微控制器软件中实施的低级指令。
- [CAN 总线协议](CANBUS_protocol.md)：Klipper 的 CAN总线通信格式。
- [调试](Debugging.md)：有关如何测试和调试 Klipper。
- [基准测试](Benchmarks.md)：关于 Klipper 基准测试的方法。
- [贡献](CONTRIBUTING.md)：有关如何向 Klipper 提交改进方法的信息。
- [打包](Packaging.md)：有关于如何构建系统包的信息。

# 设备特定文档

- [示列配置](Example_Configs.md)：有关于添加示列配置到 Klipper 的信息。
- [SD卡更新](SDCard_Updates.md)：通过将固件拷贝到SD卡中，再通过微控制器的SD卡槽来烧写微控制器。
- [将树莓派作为微控制器](RPi_microcontroller.md)：连接到树莓派的 GPIO 引脚设备的详细信息。
- [Beaglebone](beaglebone.md)：在 Beaglebone PRU （可编程实时单元）上运行 Klipper 的详细信息。
- [底层引导程序](Bootloaders.md)：有关于微控制器烧写的开发者信息。
- [CAN 总线](CANBUS.md)：有关于 Klipper 使用 CAN 总线的信息。
- [TSL1401CL 耗材线径传感器](TSL1401CL_Filament_Width_Sensor.md)
- [霍尔耗材线径宽度传感器](HallFilamentWidthSensor.md)
