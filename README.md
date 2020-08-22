![test](https://img.shields.io/badge/test-passing-green.svg)
![docs](https://img.shields.io/badge/docs-passing-green.svg)
![platform](https://img.shields.io/badge/platform-Quartus|Vivado-blue.svg)

VGA-Char
===========================
FPGA VGA 字符显示控制器

* **功能** ：通过 VGA 接口在屏幕上显示 86 列 32 行的 ASCII 字符。
* 完全使用 **SystemVerilog**  , 便于移植和仿真。

# 简单示例

| ![Show](https://github.com/WangXuan95/FPGA-VGA-Char/blob/master/show.jpg) |
| :----------: |
| 图：基于 Nexys4 开发板的简单示例 |

若想运行上图展示的示例，使用 Vivado 2018.3 打开 nexys4 文件夹中的工程，并烧录到 [Nexys4-DDR 开发板](http://www.digilent.com.cn/products/product-nexys-4-ddr-artix-7-fpga-trainer-board.html)。

# 模块接口描述

vga_char_86x32 模块 （在源文件 [vga_char_86x32.sv](https://github.com/WangXuan95/FPGA-VGA-Char/blob/master/vga_char_86x32.sv) 中） 接口如下表

| 接口名称  | 接口分组           | 方向 | 宽度 | 描述                   |
| :-----:   | :-----:            | :--: | :--: | :------------          |
| rst_n     | 复位               | in   | 1    | 低电平复位，高电平运行 |
| clk       | 时钟               | in   | 1    | 要求 48MHz ~ 50MHz     |
| hsync     | VGA 接口           | out  | 1    | 行同步，接 VGA 接口 的 HSYNC 信号  |
| vsync     | VGA 接口           | out  | 1    | 场同步，接 VGA 接口 的 VSYNC 信号  |
| red       | VGA 接口           | out  | 1    | 红通道，接 VGA 接口 的 RED 信号    |
| green     | VGA 接口           | out  | 1    | 绿通道，接 VGA 接口 的 GREEN 信号  |
| blue      | VGA 接口           | out  | 1    | 蓝通道，接 VGA 接口 的 BLUE 信号   |
| req       | ASCII 字符读取接口 | out  | 1    | 请求读 ASCII 字符       |
| reqx      | ASCII 字符读取接口 | out  | 7    | 请求读 ASCII 字符的列号 |
| reqy      | ASCII 字符读取接口 | out  | 5    | 请求读 ASCII 字符的行号 |
| ascii     | ASCII 字符读取接口 | in   | 7    | 响应的 ASCII 码         |

模块在工作时， rst_n 信号应保持高电平， clk 上应保持 48MHz ~ 50MHz 的稳定时钟， VGA 接口应连接到 VGA 连接器。 ASCII 字符读取接口时序如下图，模块会从左到右，从上到下的请求读取字符的 ASCII 码，请求时，req 信号出现一个时钟周期的高电平，同时 reqx 和 reqy 信号上分别出现当前列号和行号，在下一时钟周期，外部需要将 ASCII 码 (7bit) 放在 ascii 信号上，这样，控制器就能在 reqx 列 reqy 行上显示该 ascii 码对应的字符。 ASCII 字符读取接口可以连接到一个 4096B 的 RAM 的读取口，外部可以将该 RAM 作为显存。

| ![Wave](https://github.com/WangXuan95/FPGA-VGA-Char/blob/master/wave.png) |
| :----------: |
| 图：ASCII 字符读取接口波形图 |
