

自定义快捷键

如果我们想要直接在浏览器中预览效果的话，可以自定义快捷键：点击Preferences--> 选择Key Bindings User，输入：

"keys": ["alt+m"], "command": "markdown_preview", "args": { "target": "browser"}
保存后，直接输入快捷键：Alt+M就可以直接在浏览器中预览生成的HTML文件了。

设置语法高亮和mathjax支持

在Preferences->Package Settings->Markdown Preview->Setting Default中的：

/* Enable or not mathjax support.
*/ "enable_mathjax": false,

/* Enable or not highlight.js support for syntax highlighting.
*/ "enable_highlight": false,