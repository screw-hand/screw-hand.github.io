---
title: webpack5
date: 2022-03-12 22:20:48
categories: 工程化
tags: webpack
---

简介：本质上，**webpack** 是一个用于现代 JavaScript 应用程序的 *静态模块打包工具*。当 webpack 处理应用程序时，它会在内部从一个或多个入口点构建一个 [依赖图(dependency graph)](https://webpack.docschina.org/concepts/dependency-graph/)，然后将你项目中所需的每一个模块组合成一个或多个 *bundles*，它们均为静态资源，用于展示你的内容。

<!-- more -->

## base

1. entry 入口，Webpack 执行构建的第一步将从 Entry 开始，可抽象成输入。

2. output 输出结果，在 Webpack 经过一系列处理并得出最终想要的代码后输出结果。

3. loaders 模块转换器，用于把模块原内容按照需求转换成新内容。

4. plugins 扩展插件，在 Webpack 构建流程中的特定时机注入扩展逻辑来改变构建结果或做你想要的事情。

5. mode 告知 webpack 使用相应模式的[内置优化](https://webpack.docschina.org/configuration/mode)。

6. module 模块，在 Webpack 里一切皆模块，一个模块对应着一个文件。Webpack 会从配置的 Entry 开始递归找出所有依赖的模块。

7. resolve 配置webpack对模块的解析规则

8. externals 指定模块为外包模块，构建时不打包

9. bundle 由多个不同的模块生成，bundles 包含了早已经过加载和编译的最终源文件版本。

10. chunk 通常 chunk 会直接对应所输出的 bundle，但是有一些配置并不会产生一对一的关系。bundle 由 chunk 组成，其中有几种类型（例如，入口 chunk(entry chunk) 和子 chunk(child chunk)）。

11. vendors 第三方模块。

## 常见配置

```js
module.exports = {
  mode: "production", // "production" | "development" | "none"
  // Chosen mode tells webpack to use its built-in optimizations accordingly.
  entry: "./app/entry", // string | object | array
  // 默认为 ./src
  // 这里应用程序开始执行
  // webpack 开始打包
  output: {
    // webpack 如何输出结果的相关选项
    path:path.resolve(__dirname, "dist"), // string (default)
    // 所有输出文件的目标路径
    // 必须是绝对路径（使用 Node.js 的 path 模块）
    filename: "[name].js", // string (default)
    // entry chunk 的文件名模板
    publicPath: "/assets/", // string
    // 输出解析文件的目录，url 相对于 HTML 页面
    library: { // 这里有一种旧的语法形式可以使用（点击显示）
      type: "umd", // 通用模块定义
      // the type of the exported library
      name: "MyLibrary", // string | string[]
      // the name of the exported library

      /* Advanced output.library configuration (click to show) */
    },
    uniqueName: "my-application", // (defaults to package.json "name")
    // unique name for this build to avoid conflicts with other builds in the same HTML
    name: "my-config",
    // name of the configuration, shown in output
    /* 高级输出配置（点击显示） */
    /* Expert output configuration 1 (on own risk) */
    /* Expert output configuration 2 (on own risk) */
  },
  module: {
    // 模块配置相关
    rules: [
      // 模块规则（配置 loader、解析器等选项）
      {
        // Conditions:
        test: /\.jsx?$/,
        include: [
          path.resolve(__dirname, "app")
        ],
        exclude: [
          path.resolve(__dirname, "app/demo-files")
        ],
        // these are matching conditions, each accepting a regular expression or string
        // test and include have the same behavior, both must be matched
        // exclude must not be matched (takes preferrence over test and include)
        // Best practices:
        // - Use RegExp only in test and for filename matching
        // - Use arrays of absolute paths in include and exclude to match the full path
        // - Try to avoid exclude and prefer include
        // Each condition can also receive an object with "and", "or" or "not" properties
        // which are an array of conditions.
        issuer: /\.css$/,
        issuer: path.resolve(__dirname, "app"),
        issuer: { and: [ /\.css$/, path.resolve(__dirname, "app") ] },
        issuer: { or: [ /\.css$/, path.resolve(__dirname, "app") ] },
        issuer: { not: [ /\.css$/ ] },
        issuer: [ /\.css$/, path.resolve(__dirname, "app") ], // like "or"
        // conditions for the issuer (the origin of the import)
        /* Advanced conditions (click to show) */

        // Actions:
        loader: "babel-loader",
        // 应该应用的 loader，它相对上下文解析
        options: {
          presets: ["es2015"]
        },
        // options for the loader
        use: [
          // apply multiple loaders and options instead
          "htmllint-loader",
          {
            loader: "html-loader",
            options: {
              // ...
            }
          }
        ],
        type: "javascript/auto",
        // specifies the module type
        /* Advanced actions (click to show) */
      },
      {
        oneOf: [
          // ... (rules)
        ]
        // only use one of these nested rules
      },
      {
        // ... (conditions)
        rules: [
          // ... (rules)
        ]
        // use all of these nested rules (combine with conditions to be useful)
      },
    ],
    /* 高级模块配置（点击展示） */
  },
  resolve: {
    // options for resolving module requests
    // (does not apply to resolving of loaders)
    modules: ["node_modules",path.resolve(__dirname, "app")],
    // directories where to look for modules (in order)
    extensions: [".js", ".json", ".jsx", ".css"],
    // 使用的扩展名
    alias: {
      // a list of module name aliases
      // aliases are imported relative to the current context
      "module": "new-module",
      // 别名："module" -> "new-module" 和 "module/path/file" -> "new-module/path/file"
      "only-module$": "new-module",
      // 别名 "only-module" -> "new-module"，但不匹配 "only-module/path/file" -> "new-module/path/file"
      "module": path.resolve(__dirname, "app/third/module.js"),
      // alias "module" -> "./app/third/module.js" and "module/file" results in error
      "module": path.resolve(__dirname, "app/third"),
      // alias "module" -> "./app/third" and "module/file" -> "./app/third/file"
      [path.resolve(__dirname, "app/module.js")]: path.resolve(__dirname, "app/alternative-module.js"),
      // alias "./app/module.js" -> "./app/alternative-module.js"
    },
    /* 可供选择的别名语法（点击展示） */
    /* 高级解析选项（点击展示） */
    /* Expert resolve configuration (click to show) */
  },
  performance: {
    hints: "warning", // 枚举
    maxAssetSize: 200000, // 整数类型（以字节为单位）
    maxEntrypointSize: 400000, // 整数类型（以字节为单位）
    assetFilter: function(assetFilename) {
      // 提供资源文件名的断言函数
      return assetFilename.endsWith('.css') || assetFilename.endsWith('.js');
    }
  },
  devtool: "source-map", // enum
  // 通过为浏览器调试工具提供极其详细的源映射的元信息来增强调试能力，
  // 但会牺牲构建速度。
  context: __dirname, // string（绝对路径！）
  // webpack 的主目录
  // entry 和 module.rules.loader 选项
  // 都相对于此目录解析
  target: "web", // 枚举
  // the environment in which the bundle should run
  // changes chunk loading behavior, available external modules
  // and generated code style
  externals: ["react", /^@angular/],
  // Don't follow/bundle these modules, but request them at runtime from the environment
  externalsType: "var", // (defaults to output.library.type)
  // Type of externals, when not specified inline in externals
  externalsPresets: { /* ... */ },
  // presets of externals
  ignoreWarnings: [/warning/],
  stats: "errors-only",
  stats: {
    // lets you precisely control what bundle information gets displayed
    preset: "errors-only",
    // A stats preset

    /* Advanced global settings (click to show) */

    env: true,
    // include value of --env in the output
    outputPath: true,
    // include absolute output path in the output
    publicPath: true,
    // include public path in the output

    assets: true,
    // show list of assets in output
    /* Advanced assets settings (click to show) */

    entrypoints: true,
    // show entrypoints list
    chunkGroups: true,
    // show named chunk group list
    /* Advanced chunk group settings (click to show) */

    chunks: true,
    // show list of chunks in output
    /* Advanced chunk group settings (click to show) */

    modules: true,
    // show list of modules in output
    /* Advanced module settings (click to show) */
    /* Expert module settings (click to show) */

    /* Advanced optimization settings (click to show) */

    children: true,
    // show stats for child compilations

    logging: true,
    // show logging in output
    loggingDebug: /webpack/,
    // show debug type logging for some loggers
    loggingTrace: true,
    // show stack traces for warnings and errors in logging output

    warnings: true,
    // show warnings

    errors: true,
    // show errors
    errorDetails: true,
    // show details for errors
    errorStack: true,
    // show internal stack trace for errors
    moduleTrace: true,
    // show module trace for errors
    // (why was causing module referenced)

    builtAt: true,
    // show timestamp in summary
    errorsCount: true,
    // show errors count in summary
    warningsCount: true,
    // show warnings count in summary
    timings: true,
    // show build timing in summary
    version: true,
    // show webpack version in summary
    hash: true,
    // show build hash in summary
  },
  devServer: {
    proxy: { // proxy URLs to backend development server
      '/api': 'http://localhost:3000'
    },
    static: path.join(__dirname, 'public'), // boolean | string | array | object, static file location
    compress: true, // enable gzip compression
    historyApiFallback: true, // true for index.html upon 404, object for multiple paths
    hot: true, // hot module replacement. Depends on HotModuleReplacementPlugin
    https: false, // true for self-signed, object for cert authority
    // ...
  },
  experiments: {
    asyncWebAssembly: true,
    // WebAssembly as async module (Proposal)
    syncWebAssembly: true,
    // WebAssembly as sync module (deprecated)
    outputModule: true,
    // Allow to output ESM
    topLevelAwait: true,
    // Allow to use await on module evaluation (Proposal)
  },
  plugins: [
    // ...
  ],
  // list of additional plugins
  optimization: {
    chunkIds: "size",
    // method of generating ids for chunks
    moduleIds: "size",
    // method of generating ids for modules
    mangleExports: "size",
    // rename export names to shorter names
    minimize: true,
    // minimize the output files
    minimizer: [new CssMinimizer(), "..."],
    // minimizers to use for the output files

    /* Advanced optimizations (click to show) */

    splitChunks: {
      cacheGroups: {
        "my-name": {
          // define groups of modules with specific
          // caching behavior
          test: /\.sass$/,
          type: "css/mini-extract",

          /* Advanced selectors (click to show) */

          /* Advanced effects (click to show) */
        }
      },

      fallbackCacheGroup: { /* Advanced (click to show) */ }

      /* Advanced selectors (click to show) */

      /* Advanced effects (click to show) */

      /* Expert settings (click to show) */
    }
  },
  /* 高级配置（点击展示） */
  /* Advanced caching configuration (click to show) */
  /* Advanced build configuration (click to show) */
}
```

[配置速览](https://webpack.docschina.org/configuration/#options)

## 基本功能

webpack：webpack核心功能

webpack-cli：webpack命令行包，提供命令行的方式调用

webpack-dev-server： webpack开发服务，提供开发周期的服务

### 初始化项目

以上三个包强烈建议全部安装

```shell
mkdir 005-webpack-init
npm init -y
npm i -D webpack webpack-cli webpack-dev-server

# 安装html-webpack-plugin管理html
npm i -D html-webpack-plugin

npm set-script build "webpack --mode=production  --node-env=production"
npm set-script serve "webpack serve"
npm set-script watch "webpack --watch"
```

src/index.html - 被html-webpack-plugin所引用为模板，编译后自动引入src/index.js脚本

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>
  <h1>Hello world!</h1>
</body>
</html>
```

src/index.js - 指定为 webpack的入口模块，将从这个模块开始便利依赖树

```js
console.log('hello world')
```

webpack.config.js - webpack的配置文件

```js
const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

const config = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name]@[contenthash].js',
    chunkFilename: '[name]@[contenthash].async.js'
  },
  devServer: {
    open: false,
    host: '0.0.0.0',
    client: {
      overlay: true
    }
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/index.html'
    }),
  ]
}

module.exports = config
```

使用

```
# 编译代码
npm run build

# 监听代码变化并自动编译
npm run watch

# 启动开发服务 http://lcoalhost:8080
npm run serve
```

- build：编译后的源码在dist目录，可以直接在浏览器打开dist/index.html以查看编译后的代码（建议每次build之前手动清空dist目录）

- watch：相当于自动完成build动作，其他同build

- serve：启动一个本地的开发服务，编译的代码默认不输出在dist，存储在内存中

### loader心得

原则：webpack默认只能识别js模块，如果入口模块的依赖树有对其他模块（样式/html/图片）等依赖，需要配置相应的模块规则，匹配对应的文件，使用需要的loader。

**使用babel转义js**

1. 添加核心编译器/库 （babel/typescript）

```
npm install -D @babel/core @babel/preset-env webpack
```

2. 添加webpack的loader（babel-loader/ ts-loader）

```
npm install -D babel-loader
```

3. 配置编译器（.babelrc、tsconfig.json）

```json
{
  "plugins": ["@babel/transform-runtime"],
  "presets": [
    ["@babel/react"],
    [
      "@babel/env",
      {
        "modules": false
      }
    ]
  ]
}
```

4. 配置webpack的模块解析规则（webpack.config.js）

```js
module: {
  rules: [
    {
      test: /\.m?js$/,
      exclude: /(node_modules|bower_components)/,
      use: {
        loader: 'babel-loader',
        options: {
          presets: ['@babel/preset-env']
        }
      }
    }
  ]
}
```

总结：ES6+ / TypeScript / Flow / Scss Sass  / Less / Styl / Rect / Vue / Angular 的模块解析基本按照以上原则。

js/ts脚本分别只需要babel-loader 还有ts-loader，而一般样式模块（Scss Sass / Less / Styl ）需要使用多个loader，**loader的执行顺序是从右到左。**

### 最简单的解析样式

```js
  module: {
    rules: [
      {
        // 用正则去匹配要用该 loader 转换的 CSS 文件
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      }
    ]
  }
```

```
npm install -D style-loader css-loader
```

css-loader用于解析css模块，style-loader把解析的css模块插入到html的style标签中。

### 解析css预处理语言并使用postcss插件

1. css预处理语言需要对应的**预处理语言核心、loader**（styl、styl-loader)

2. *如果需要增强样式功能，可以使用postcss以及其loader（postcss、post-loader）(可选)

3. 此刻预处理语言被转换为css，同样需要使用css-loader解析

4. 使用style-loader插入html成为内联样式

```
npm install -D styl styl-loader postcss postcss-loader css-loader style-loader
```

```js
  module: {
    rules: [
      {
        test: /\.styl$/,
        use: ['style-loader', 'css-loader', 'postcss-loader', 'stylus-loader'],
      }
    ]
  }
```

### 分离样式文件

默认情况下，webpack将样式内容耦合在js中，然后使用style-loader使样式内容插入html成为内联样式，如果需要使样式文件单独分离出来，webpack5内置了插件——mini-css-extract-plugin，可以分离出独立的样式文件。只需要把style-loader替换成mini-css-extract-plugin的loader，配置插件即可。

```js
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

const config = {
  // ...
  module: {
    rules: [
      {
        test: /\.styl$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'stylus-loader'],
      }
    ]
  }，
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name]@[contenthash].css',
      chunkFilename: '[name]@[contenthash].async.css'
    })
  ]
}
```

### css模块化

css-loader提供了选项，可配置使得支持css模块化。

```js
  module: {
    rules: [
      {
        test: /\.styl$/,
        use: [
          /* stylesHandler, */
          {
            loader: MiniCssExtractPlugin.loader
          },
          {
            loader: 'css-loader',
            options: {
              sourceMap: true,
              modules: {
                mode: 'local',
                localIdentName: '[path][name]__[local]--[hash:base64:5]'
              }
            }
          },
          'postcss-loader',
          'stylus-loader'
        ]
      }
    ]
  }
```

### 静态资源

对于一些静态资源（字体、图片等）可以使用以下loader处理

- [`url-loader`](https://v4.webpack.js.org/loaders/url-loader/) 将一个文件作为一个数据URI内联到bundle中（图片）
- [`file-loader`](https://v4.webpack.js.org/loaders/file-loader/) 将文件发送到输出目录（字体）
- [`raw-loader`](https://v4.webpack.js.org/loaders/raw-loader/) 以字符串形式导入文件（其他文件，不常用）

[webpack - loaders](https://webpack.js.org/loaders/)

### HTML管理实现MPA

webpack默认不创建html文件，html-webpack-plugin可以用来管理html，自动引入entry的编译后的js、以及分离样式文件等。

实现多页面应用，必须指定多个入口模块（entry），可以多次实例化html-webpack-plugin，并配置不同的chunks选项，以指定不同的入口模块。

```ts
const config = {
  // ...
  entry: {
    app: './src/main_client.tsx',
    pageA: './src/multi-page/pageA.tsx',
    pageB: './src/multi-page/pageB.tsx'
  },
  output: {
    filename: "[name].js"
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "src/index.html",
      filename: 'app.html',
      chunks: ['app']
    }),
    new HtmlWebpackPlugin({
      template: "src/index.html",
      filename: 'pageA.html',
      chunks: ['pageA']
    }),
    new HtmlWebpackPlugin({
      template: "src/index.html",
      filename: 'pageB.html',
      chunks: ['pageB']
    })
  ]
  // ...
});
```

## 开发体验

### source map

webpack把源码编译后，浏览器的开发者工具看到的代码是编译后的代码，不方便调试。

为此source-map可以将编译后的代码映射到源码，让其调试变得方便。

- webpack配置文件设置`devtool:"source-map"`

- 也可以设置成其他的，为了构建速度，推荐

- `devtool: 'cheap-module-source-map', // recommend dev`

- `devtool: 'eval-source-map' // product`

[webpack - devtool](https://webpack.js.org/configuration/devtool/#devtool)

`devtool:"source-map"`只是第一步，调试不同模块的源码，还需在相应loader进行配置，具体还需查阅相关的loader文档。

- typescript `tsconfig.json` `compilerOptions.sourceMap: true`开启

- 样式 css-loader `options.sourceMap:true`

- webpack的devtool默认设置的是JavaScript

[source-map-loader](https://webpack.js.org/loaders/source-map-loader/) 可从现有的source-map文件提取出相应的映射文件。

### 模块热替换(Hot Module Replacement)

live reload：源代码更新，webpack-dev-server自动构建并刷新web

HMR：live reload的升级版，可在web不刷新的情况下更新web内容

webpack-dev-server v4.0.0 默认启动HMR

**以上仅在开发环境下有效。**

entry入口文件结尾追加以下内容（必须）

```js
if (process.env.NODE_ENV === 'development' && module.hot) {
  module.hot.accept()
}
```

![](./webpack5/hmr.png)

### 检查代码

安装相应的lint，合理地配置lint规则， 使用webpack-[lint]-plugin即可。

- 在webpack中检查代码会使构建速度变慢

- 终端会打印lint规则的信息（错误/警告）

- 定位并不一定在源码的行数

- 建议使用集成代码检查的编辑器

- 把代码检测步骤放到代码提交之前

## 优化策略

### 限制webpack处理模块范围

1. loader include / exclude (优先级更高)

2. resolve.modules 使用绝对路径指明第三方模块存放的位置，以减少搜索步骤

3. resolve.mainFields（配置第三方模块使用哪个入口文件，对应package.json的字段)

4. resolve.alias 常用的库可以硬性配置

5. resolve.extensions 长度减少，更常用的先放在前面

6. module.noParse 非模块化实现的库可以配置不解析，并使用script标签引入

7. IgnorePlugin 忽略指定模块的生成，一些体积比较大的库只需要使用部分可以排除掉

### 提取公共代码

痛点

- 相同的资源被重复的加载，浪费用户的流量和服务器的成本；

- 每个页面需要加载的资源太大，导致网页首屏加载缓慢，影响用户体验。

optimization.SplitChunks，适用于SPA、MPA，SPA的效果并不是很明显。

效果

- 减少网络传输流量，降低服务器成本；
- 虽然用户第一次打开网站的速度得不到优化，但之后访问其它页面的速度将大大提升。

### 代码分割

按需加载/异步加载/预加载  `import()`

```js
import(/* webpackChunkName: "chunk_script" */ '../src/script.js').then(() => {
  console.log('1')
})
```

### 压缩代码

webpack v4+在生产模式下默认使用[terser-webpack-plugin](https://webpack.js.org/plugins/terser-webpack-plugin/)压缩代码，也可以使用[closure-webpack-plugin](https://github.com/webpack-contrib/closure-webpack-plugin)压缩，结合[optimization.minimizer](https://webpack.js.org/configuration/optimization/#optimizationminimizer)一起使用。

### dll (well？)

### cdn加速

```
output.publicPath: '//js.cdn.com/id/'

new MiniCssExtractPlugin({
    filename: 'style/[name]_[hash].css',
    chunkFilename: 'style/[id]_[hash].css',
    pubicPath: '//css.cdn.com/id/'
})
```

### Tree Shaking

基于ES2015的模块化实现（import、export），因为ES2015的模态化是静态机制的，所以webpack在构建的时候，能剔除一些引入但未被使用的代码。webpack内置功能。

### 输出分析

## 原理

编译后的代码

异步模块

热更新

loader

plugin

## 生态圈

- webpack
- webpack-cli
- webpack-dev-server
- webpack-dev-middleware
- webpack-merge
- webpack-chain

loader https://webpack.js.org/loaders/

plugin https://webpack.js.org/plugins/

命令行 https://webpack.js.org/api/cli/

npm包 https://www.npmjs.com/search?q=keywords:webpack

github https://github.com/webpack

## 版本差异

v3~v4 [Release v4.0.0 · webpack](https://github.com/webpack/webpack/releases/tag/v4.0.0)

v4~v5 [2020-10-10-webpack-5-release](https://webpack.js.org/blog/2020-10-10-webpack-5-release/)

- 使用持久化缓存提高构建性能；
- 使用更好的算法和默认值改进长期缓存（long-term caching）；
- 清理内部结构而不引入任何破坏性的变化；
- 引入一些breaking changes，以便尽可能长的使用v5版本。

## 其他构建工具
- grunt
- gulp
- vite
- esbuild
- rollup

## 参考资料
[深入浅出 Webpack](http://webpack.wuhaolin.cn/)

[Node.js+Webpack开发实战-夏磊](https://weread.qq.com/web/reader/7fd32de0723278b37fd69c3)

[Webpack实战：入门、进阶与调优](https://weread.qq.com/web/reader/e9542392a43425f386c7736754b367530425a65365671365534c24)
