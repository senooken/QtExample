///////////////////////////////////////////////////////////////////////////////
/// \file main.cpp
/// \author SENOO, Ken
///////////////////////////////////////////////////////////////////////////////

#include <QApplication>
#include <QLabel>
#include <QTabBar>
#include <QTabWidget>
#include <QTextEdit>
#include <QToolButton>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    // 1. Create QTabWidget instance.
    QTabWidget widget;
    // 2. Create page widget instance.
    QTextEdit editor1{"EDITOR1", &widget};
    QTextEdit editor2{"EDITOR2", &widget};
    // 3. Insert page widget into tab widget by addTab() or insertTab().
    widget.insertTab(0, &editor1, "TAB1");
    widget.addTab(&editor2, "TAB2");
    // Enable close and drag.c
    widget.setTabsClosable(true);
    widget.setMovable(true);
    // Handle tab close.
    widget.connect(&widget, &QTabWidget::tabCloseRequested, 
        [&](int index) {widget.removeTab(index);}
    );

    // Add new tab button.
    QToolButton tb;
    tb.setText("+");
    tb.setAutoRaise(true);
    tb.connect(&tb, &QToolButton::clicked,
        [&]() {widget.insertTab(widget.count()-1, new QTextEdit(), "New Tab");}
    );
    widget.addTab(new QLabel("You can add tabs by pressing +"), QString());
    widget.setTabEnabled(widget.count()-1, false);
    widget.tabBar()->setTabButton(widget.count()-1, QTabBar::RightSide, &tb);

    widget.show();

    return app.exec();
}
