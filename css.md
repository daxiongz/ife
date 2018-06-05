1. CSS 指层叠样式表，定义如何显示 HTML 元素。
2. 当同一个 HTML 元素呗多个 CSS 样式定义时，优先级如下，依次升高：浏览器缺省设置、外部样式表、内部样式表（head 标签内）、内联样式。
3. CSS 由选择器和声明两部分构成: 选择器 {属性：值; 属性：值;}, CSS 的属性值如果是若干个单词需要加引号。
4. 关于颜色的设置，多种方式：英文颜色单词、十六进制颜色值 '#abcdef' 、CSS 缩写颜色值 '#123'、RGB 数值 rgb(255,0,0)、RGB 百分比 rgb(100%, 0%, 0%)。注意当时用 RGB 百分比时，即使值是0，也要加上 %。
5. 选择器分组，被分组在一起的选择器就可共享相同的 CSS 声明。
		h1, h2, h3 {
			color: green;
		}
6. 类选择器，类名的第一个字符不能使用数字，他无法在 firefox 中生效。
7. 属性选择器，为拥有指定属性的 HTML 元素设置样式，只有在规定了 !DOCTYPE 时，IE7 和 IE8才支持属性选择器：
	1. attr~=val:选取属性值包含指定词汇，关键词以空格分隔的属性
	2. attr|=val：属性以 指定值/指定值- 开头
	3. attr^=val: 指定值开头
	4. attr$=val：指定值结尾
	5. attr*=val：包含指定值
8. CSS 背景：所有背景属性都不可继承
	1. background-color 背景颜色，任何元素都可以设置背景颜色，不能继承，默认属性值是 transparent，即透明，其祖先元素才可见。
	2. background-image：url(img_url)， 背景图像, 默认 none。
	3. background-repeat: repeat(水平、垂直重复，默认值)、repeat-x、repeat-y、no-repeat
	4. background-position: center/top/right/left/bottom(关键字水平、垂直各一个，制定一个后，另一个自动置为center)、百分比、单位长（指定一个另一个自动为50%）。关于百分比，同时应用于元素和图像，将两者对应的点对应覆盖重叠。默认值0% 0%。关于长度，指的是图像距离元素左上角的坐标
	5. background-attachment：fixed/scroll（默认）。背景过长时，文档滚动，背景也会随着滚动，fixed可禁用掉。
	6. 简写，background：background-color background-position background-size background-repeat background-origin background-clip background-attachment background-image
    7. background-clip(元素背景延伸到何处)：border-box(border外边沿) padding-box(padding外边沿) content-box(内容content外边沿) text(文本前景色，目前只支持chrome，属性还必须加上 `-webkit-`)。目前支持到IE9
9. CSS 文本：
	1. text-indent:length(定义固定缩进，默认0，可为负)/%(基于父元素的百分比缩进)/inherit（IE不支持，继承父元素）,元素的第一行文本缩进，所有块级元素都可应用，可继承。
	2. text-align：left、right、center（居中）、justify（两边对齐）、inherit（IE不支持），如果文本direction是ltr，默认为left，direction是rtl的话，那就默认为rifght
	3. word-spacing：normal（默认，值是0）、length（可负）、inherit（IE不支持），设置字间隔。“字”定义为由空白字符包含的字符串，无间隔的中文就不在此列。
	4. letter-spacing：normal（默认，值是0）、length（可负）、inherit（IE不支持），设置字母间隔，中文间隔可由此属性调整
	5. text-transform：none（不改动）、uppercase（大写）、lowercase（小写）、capitalize(首字母大写)、inherit（继承）
	6. text-decoration:none、underline（下划线）、overline（上划线）、line-through（穿过线）、blink（闪烁文本）、inherit（继承）
	7. white-space：normal（合并空白/忽略换行符、允许自动换行，默认）、nowrap（合并空白/忽略换行符、不允许自动换行）、pre（保留空白/保留换行符、不允许自动换行）、pre-wrap（保留空白/保留换行符、允许自动换行）、pre-line（合并空白/忽略换行符、允许换行）
	8. direction：ltr（左到右、默认）、rtl（从右到左）
	9. line-height,normal、数字（当前行高为1）、length（xx+px）、百分比（默认行高为110%~120%之间）
	10. text-shadow：h-shadow(水平阴影） v-shadow（垂直阴影） blue（可选，模糊距离） color（可选，阴影颜色），文本阴影
	11. 文本color可继承
    12. `word-break` 单词内如何断行。

 | 属性值 | 说明 |
 | -- | -- |
 | normal | 默认断行规则 |
 | keep-all | cjk（中日韩）文字不能断行 |
 | break-all | 所有文字都可以断行，按所处元素长度，到了限度就断行 |
 | break-word | 所有文字都断行，条件允许的情况下尽可能根据单词长度断行 |

    13. `overflow-wrap` 一个不能被分割的字符串因为太长而超出其包裹盒时，为防止其溢出，是否允许其换行。原为 `word-wrap`, css3 中使用 `overflow-wrap` 将其代替。 该属性原为 IE 中引入的私有属性，`word-wrap` 为其别名。

 | 属性值 | 说明 |
 | -- | -- |
 | normal | 正常单词结束处换行 |
 | break-word | 根据包裹盒宽度，强制对内容进行换行，即使处于单词内 |

10. CSS字体：
	1. css有两种不同类型的字体系列名称，通用字体系列和特定子体系列，CSS规范规定了5种通用自体系列：serif(字体成比例，有上下断线)、sans-serif(字体成比例，无短线)、monospace(字体等宽)、cursive(花式字体)、fantasy(特征不明晰而又不同)
	2. font-family属性值为多个且为逗号隔开时，依次加载字体，加载到哪个字体用哪个字体展示，字体名含空格或# $等特殊字符时需要用引号
	3. font-style 用于规定斜体文本，包含 normal（正常显示）、italic（斜体）、oblique（倾斜），italic 是正常文本的倾斜展示，oblique 是文本倾斜书写，浏览器中两者展示相同
	4. font-variant：normal（正常文本）、small-caps（小写大型字母，大写字母，但又比正常大写字母字号小一些）
	5. font-weight，文本粗细。属性值 100~900（400-normal，700-bold）、normal、bold（加粗）。若为bolder，则比继承值加粗一个字体，若为lighter，则比继承值更细
	6. font-size，字体大小。xx-small、x-small、small、medium、large、x-large、xx-large（多个等级）、smaller、larger（比父元素更大或更小）、数值+px（固定像素大小）、百分比（基于父元素的百分比值）。px 固定大小，em 基于浏览器默认尺寸（大多数为16px）。
	7. 一个适配em 方案： body {font-size：100%} div{ font-size: xxem}
	8. 简写方案，font：font-style font-variant font-weight font-size font-family，字体大小和字体系列必须得指定
11. CSS 边框
	1. 元素的边框是围绕元素内容和内边距的一条或多条线，边框绘制在 `元素的背景智商` 
	2. 如果希望设置边框相关样式，必须首先设置一个边框样式非none
	3. 简写，border：border-width border-style border-color
 | 属性名 | 属性值 | 备注 |
	| - | - | - |
	| border-style 边框样式 | none hidden(与none相同时，吃了用于解决表的边框冲突) dotted(点状边框) dashed(虚线) solid(实线) double(双线) groove(3D 凹槽边) ridge(3D 垄状边) inset(3D inset边) outset(3D outset边) | 一个边框可以分上右下左分别定义样式，单边属性要放在简写属性之后；如果边框样式设置为none，就没有边框了 |
	| border-width 边框宽度 | thin midium(默认) thick(粗) length(xx+px) | 不可为负 |
	| border-color 边框颜色 | color_name hex_name(16进制) rgb_number(rgb颜色，rgb(255,0,0) transparent(透明背景，IE7开始支持)) | 默认颜色是元素本身前景色(文本色或边框色)；未声明边框颜色时，与元素文本颜色相同；若元素无文本，则与其父级元素文本颜色一致(因为文本颜色color可继承) |
12. CSS 列表
	1. CSS 列表属性允许你放置、改变列表项标志，或者将图像作为列表项标志，所有浏览器都支持此样式设置
	2. 简写，list: xx xx xx xx.可以按任何顺序给出，缺省的会填入默认值
 | 属性名 | 属性值 | 备注 | 
	| - | - | - |
	| list-style-type 列表样式 | none(无标记) disc(默认，实心圆) circle(空心圆) square(实心方块) decimal(数字) decimal-leading-zero(0开头的数字标记 01 02) lower-roman(小写罗马数字 i,ii) upper-roman(大写罗马数字) lower-greek(小写希腊字母) lower-latin(小写拉丁字母) upper-latin armenian(传统的亚美尼亚编号) georgian(传统的乔治亚编号) | 所有浏览器都支持此属性 |
	| list-style-image 列表项图像 | none(默认) url(图像地址) |
	| list-style-position 列表标志位置 | inside(项目标记放在文本以内) outside(项目标记放在文本外部，默认) | null |
13. CSS 链接
  1. 链接的四种状态：
   * `a:link` 未被访问的链接
   * `a:visited` 已被访问的链接
   * `a:hover` 鼠标放到链接上的样式
   * `a:active` 链接被点击时的样式
	请注意：`a:hover` 必须位于 `a:link` 和 `a:visited` 之后; `a:active` 位于 `a:hover` 之后。LoVe HAte！
	1、鼠标经过的“未访问链接” 同时拥有 `a:link` 和 `a:hover`，后面属性会覆盖前面属性；
	2、鼠标经过的“已访问链接” 同时拥有 `a:visited` 和 `a:hover` 之后。
  2. 链接可以应用常见的文本修饰样式，text-decoration background-color 等
14. 复杂选择器：
  1. 后代选择器：`父级选择器 目标选择器` 可以将父级选择器下所有的目标选择器都用于某样式，层级可无限叠加；
  2. 子元素选择器：`父级选择器 > 子元素选择器` 只可选取某一元素的子元素，`>` 两边空格可选；
  3. 相邻兄弟选择器：`A元素 + B元素` 只选取紧跟在A元素后且与A元素有共同父元素的兄弟元素，`+` 两边空格可选。
  4. 伪类选择器：`选择器: 伪类` ，常见伪类如下：
  | 属性 | 描述 |
  | - | - |
  | :active | 被激活元素 |
  | :focus | 焦点元素 |
  | :hover | 鼠标悬浮元素 |
  | :link | 未被访问的链接 |
  | :visited | 已被访问的链接 |
  | A:first-child | A元素作为某一个元素的第一个子元素 添加样式 |
  | :lang(language) | 带有 lang 属性的元素他添加样式 |
  5. 伪元素：`选择器: 伪元素`，常见伪元素如下：
  | 属性 | 描述 |
  | - | - |
  | :first-line | 文本首行,且只能用于块级元素 |
  | :first-letter | 文本的首字母，只能用于块级元素 |
  | A:before | 某个A元素的内容之前 |
  | :after | 某个元素的内容之后 |
  `注意：在CSS2中，伪元素是以:开头的，而伪类中，写法也是如此，无法很好区分。所以在CSS2.1中，伪元素支持以::开头用以区分。:: 支持的IE9`







参考文档：[CSS 前景色和透明度](https://www.cnblogs.com/xiaohuochai/p/5218459.html)

