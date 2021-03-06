#### 为人忽略的 tips 

1. ` typeof null ` 结果是 'object'？
  `JavaScript` 中不同对象底层都表现为二进制，其中二进制里前三位是 0 的话会被判断为 `Object` , `null` 的二进制全是 0，所以被判断为 `Object` .

2. 浅拷贝与深拷贝
 浅拷贝 复制对象，对于源对象中的引用对象依然是引用，ES5 中可以采用如下方法：

 ```
 //Object.assign(目标对象, 一系列源对象...)
 // newObj 可以接受源对象中的所有 `可枚举` 的 `自有键` , 并把它们复制（使用 `=` 赋值运算符）到目标对象。
 var newObj = Object.assign({}, Obj1, Obj2)
 ```

 深拷贝 复制对象，对于其中的引用对象一级一级深挖，深挖到字面量为止。

3. 闭包：
 定义： 简单的说，闭包是在函数声明时所创建的作用域，它使得函数能够访问并处理函数的外部变量。当函数可以记住并访问所在的词法作用域时，就产生了闭包，即使函数是在当前词法作用域之外执行。
 一个函数执行之后，通常其内部作用域会被销毁，JavaScript 引擎有垃圾回收器用来释放不再使用的内存空间。而闭包的神奇之处是可以阻止这样的事件发生，记住其词法作用域。闭包可以使得函数继续访问定义时的词法作用域。
 无论通过何种手段将内部函数传递给所在的词法作用域以外，它都会持有对原始定义作用域的引用，无论在何处执行这个函数都会使用闭包。

 `for` 循环头部的 `let` 声明有一个特殊的行为，其指出变量在循环过程中不止被声明一次，每次迭代都会声明。随后的每个迭代都会使用上一个迭代结束时的值来初始化这个变量

 ```
 for (let i = 0; i < 5; i++){
    setTimeout(function timer() {
        console.log(i)
        }, i * 1000)
 }
 ```