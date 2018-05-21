1、flex 概念介绍：

 ![flex 模型图](https://s20.postimg.cc/k9kx1iqfx/flex_1.png)
 
 * 主轴（main axis），沿着flex元素放置方向的轴（页面的列和行），该轴开始和结束的地方称为 `main start` 和 `main end`
 * 交叉轴（cross axis）,与主轴垂直的轴，开始和结束称为 `cross start` 和 `cross end`
 * 设置了 `display: flex` 的父元素是 flex 容器（flex container）
 * 在 flex 容器中表现为柔性的盒子的元素项称之为 flex 项（flex item）
2、`flex-direction` 设置容器属性，调整主轴方向设置：

 | 属性值 | 描述 |
 | -- | -- |
 | row | 与文本方向排列一致 |
 | row | 语文本方向相反 |
 | column | 列排列，与块轴方向一致，上到下 |
 | column-reverse | 与 column 相反 |
 
3、`flex-wrap` flex项是否换行，容器属性设置：

 | 属性值 | 描述 |
 | -- | -- |
 | nowrap | 不换行，会导致溢出 flex 容器，默认 |
 | wrap | 换行 |
 | wrap-reverse | 换行，与 wrap 相比，cross start 和 cross end 互换，整个内容颠倒 |
 
4、`flex-flow` 是 `flex-direction` 和 `flex-wrap` 的缩写
5、`flex` flex项设置， 包含三个属性值的压缩：
 1. `flex-grow`，设置 flex 项除去 margin padding 等外实际 content 尺寸站得比例大小。
 
 | 属性值 | 描述 |
 | -- | -- |
 | number | 表示各个 flex 子项占得 content 比例，不可为负，默认 0 |

 2. `flex-shrink` 指定 flex 元素 收缩规则，仅在 flex 元素默认宽度之和大于容器的时候才会发生收缩 

 | 属性值 | 描述 |
 | -- | -- |
 | number | 表示各个 flex 子项占得 content 比例，不可为负，默认 1 |

 3. `flex-basis` 指定 flex 项初始默认大小，最小大小

 | 属性值 | 描述 |
 | -- | -- |
 | width | xx+px，固定宽度 |
 | auto | 取决于内容大小，默认 0% |
 | initial | 继承于 agent 实现 |

 4. 总属性值为 none 时，等于三个属性分别为 0 0 auto
6、`align-items` flex 容器设置，设置子项在交叉轴上位置排列：

 | 属性值 | 描述 |
 | -- | -- |
 | stretch | 默认值，父容器设置高度时，将都变得与父容器一般高；否则将会变得与子项最大高度一样 |
 | center | 垂直居中 |
 | flex-start/flex-end | 交叉轴的开始或结束 |

7、`align-self` 子项设置，可以覆盖父元素容器设置的 `align-item` 属性，属性值与 `align-itens` 基本一致。某个子项 margin 置为0时，再设置此属性时，不在生效。
8、`justify-content` 容器设置，子项在主轴上的排列。请注意，如果有任何一个子项 设置了 flex-grow 属性不为0，此属性将不会生效：

 | 属性值 | 描述 |
 | -- | -- |
 | flex-start | 主轴起点，默认值 |
 | flex-end | 主轴终点 |
 | space-between | 相对居中，子项中间都有空，两端紧贴主轴起点和终点 |
 | space-around | 居中，子项间都有空 |
 | center | 水平居中 |
