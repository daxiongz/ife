### grid 学习

#### 网格容器:

设置了 `display: grid;` 或 `display: inline-grid;` 的元素

```
<style>
  .wrapper {
    display: grid;
  }
</style>

<div class="wrapper">
  <div class="one"></div>
  <div class="two"></div>
</div>
```

#### 网格轨道：

 网格中任意两条线之间的空间，也就是行距 列距。

 | 

#### `fr` 单位

 1 fr 代表网格容器中可用空间的一等分

#### 轨道清单中使用 `repeat(num,size)` , 第一个参数是重复次数，第二个参数是重复的尺寸大小

 ```
 .wrapper {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
 }
 //以上代码跟以下代码效果一样
 .wrapper {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
 }
 ```

 也可以用来创建一个多轨道模式的重复轨道列表：

 ```
 // 创建的网格将有十个轨道，1个 1fr 轨道后面跟着 1个 2fr 轨道，重复5次
 .wrapper {
    display: grid;
    grid-template-columns: repeat(5, 1fr, 2fr);
 }
 ```

#### 隐式和显式网格

 对于用 `grid-template-columns` 等创建的网格，是显式的，因为定义了其行宽或者列宽；而没定义的行宽或者列宽时，网格就会按照内容自行创建，也就是隐式网格了，可以通过 `grid-auto-rows` 和 `grid-auto-columns` 进行设置隐式网格的尺寸。

 ```
 // 创建一个网格，列宽 3 等分， 行宽 200px
 .wrapper {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-auto-rows: 200px;
 }
 ```

#### 轨道大小

 轨道大小可以通过 `minmax(min, max)` 来设置大小范围

 ```
 .wapper {
    // 隐式网格 轨道最小 100px，大于 100px 时，根据内容走尺寸
    display: grid;
    grid-template-columns: repeat(3 1fr);
    grid-auto-rows: minmax(100px, auto);
 }
 ```

#### 跨轨道放置网格元素

 网格元素所处的轨道行位于 `grid-row-start` 和 `grid-row-end` 之间，列位于 `grid-column-start` 和 `grid-column-end` 之间。

 | 属性 | 说明 |
 | -- | -- |
 | grid-column-start | 列网格线开始，缺省时为 end-1 |
 | grid-column-end | 列网格线结束，缺省时为 start+1 |
 | grid-row-start | 行网格线开始，缺省时为 end-1 |
 | grid-row-end | 行网格线结束，缺省时为 start+1 |

#### 网格单元与网格元素
 
 1. 网格单元是一个网格元素中的最小单位，相邻网格线间的最小单位，井字形的中间元素就是网格单元。
 2. 网格元素可以向行或者列的方向扩展多个单元，形成网格区域。

#### 网格间距

 两个相邻网格单元间的间距，就是网格间距。分为网格横向间距和网格纵向间距，前者通过 `grid-row-gap` 设置， 后者 `grid-column-gap` 设置。合并起来 `grid-gap: row-gap, col-gap;`, 参数一是横向间距，参数二是纵向间距。

 ```
 //横向间距是10px 纵向间距是20px
 .wrapper {
    display: grid;
    grid-template-columns: repeat(3 1fr);
    grid-row-gap: 10px;
    grid-column-gap: 20px;
    /*
    上面 css 实现的网格间距跟以下实现的网格间距效果一致
    grid-gap: 10px 20px;    
     */
 }
 ```

#### 嵌套网格

 1. 嵌套网格和其父级无关，未从父级继承 `grid-gap` 属性。
 2. 使用 `z-index` 控制层级。默认情况后来居上

