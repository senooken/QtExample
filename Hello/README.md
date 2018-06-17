# Hello

This program is minimum Qt Widgets based application (Only show "Hello" window).

Also this application has configuration for Visual Studio Code (VS Code) in `.vscode`.

If you want to try building this application with VS Code, open this directory with VS Code, then select [Tasks]>[Run Build Task...] (C-B).

Building depends on `.vscode/tasks.json`.

I confirmed following condition.

* Ubuntu 16.04
* VS Code v1.24.0
* ms-vscode.cpptools v0.17.4

For intellisense, you need to add your Qt include path to CPATH enviromental variable or "includePath" in `.vscode/c_cpp_properties.json`.

Qt include path is like "$HOME/.local/opt/Qt/Qt5.10.0/5.10.0/gcc_64/include/QtWidgets".

Refer to <https://senooken.jp/blog/2018/06/16/>.