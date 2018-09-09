/// \file main.qml

import QtQuick 2.10
import QtQuick.Controls 2.0

// Close button and tab drag.
// MouseHover: Enable close Button
// Signle Clicked: Enabled TabButton
// Double Clicked: Enabled TextField

ApplicationWindow {
    function addTab() {
        tabBar.insertItem(tabBar.currentIndex, tabButton.createObject(tabBar, {text: "Tab"+(tabBar.currentIndex+1)}))
        tabBar.setCurrentIndex(tabBar.currentIndex-1)
        view.insertItem(tabBar.currentIndex, tabContent.createObject(view, {text: "Text"+ (tabBar.currentIndex+1)}))
        view.setCurrentIndex(view.currentIndex-1)
    }

    Component.onCompleted: addTab()

    id: window
    visible: true
    title: "Tab Page"

    width: 300
    height: 300

    header: TabBar {
        id: tabBar
        currentIndex: view.currentIndex
        TabButton {
            id: addButton
            text: "+"
            onClicked: addTab()
        }
    }

    SwipeView {
        id: view
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        interactive: false
        TextArea {
         placeholderText: "Input here"
        }
    }

    Component {
        id: tabContent
        TextArea {
            placeholderText: "Input here"
        }
    }

    Component {
        id: tabButton
        TabButton {
            // Avoid moving right focus to add tab button.
            Keys.onRightPressed: {
                if ( tabBar.currentIndex+2 < tabBar.count ) tabBar.incrementCurrentIndex()
            }

            // Rename tab page title
            TextField {
                id: textField
                anchors.fill: parent
                horizontalAlignment: TextInput.AlignHCenter
                visible: false
                text: parent.text

                onEditingFinished: {
                    parent.text = text
                    textField.visible = false
                    mouseArea.visible = true
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                visible: true
                hoverEnabled: true

                property int nowIndex: 0
                property int hoveredIndex : 0
                property int newIndex : 0

                // After drag, update position is wrong
                function updateTabX() {
                    // Update x position.
                    // If no update x position and tab dragged to first position, mouse clicked position is wrong.
                    // Also if tab is dragged highly speed, tab alignment is wrong.
                    // Is this Qt bug? Because width is automatically updated.
                    for (var i = 0, len = tabBar.contentChildren.length, width = tabBar.width/len; i < len; ++i) {
                        tabBar.contentChildren[i].x =  i * width
                    }
                    // Updating window size for alignment tab button.
                    window.width += 1
                    var start = new Date().getTime()
                    var stop = new Date().getTime()
                    while (stop < start + 20) {
                        stop = new Date().getTime()
                    }
                    window.width -= 1
                }

                function closeTab(parent) {
                    view.removeItem(view.itemAt(mouseArea.hoveredIndex))
                    tabBar.removeItem(tabBar.itemAt(mouseArea.hoveredIndex))
                    if (hoveredIndex == 0) tabBar.setCurrentIndex(0)
                    updateTabX()
                }

                function updateTabPosition() {
                    newIndex = tabBar.currentIndex

                    if ((mouseX < 0) && (tabBar.currentIndex > 0)) {
                        newIndex = tabBar.currentIndex - 1;
                    } else if ((mouseX > width-1) && (tabBar.currentIndex+2 < tabBar.count)) {
                        newIndex = tabBar.currentIndex + 1;
                    }

                    // Save current hovered tab index
                    var windowPosition = mapToItem(tabBar, mouseX, mouseY)
                    for (var i in tabBar.contentChildren) {
                        var tab = tabBar.contentChildren[i]
                        if ((tab.x <= windowPosition.x) && (windowPosition.x <= (tab.x+tab.width))) {
                            hoveredIndex = i;
                        }
                    }

                    if (drag.active) {
                        // Tab position switching condition
                        if ((nowIndex > 0) && (tabBar.contentChildren[nowIndex].x <= tabBar.contentChildren[nowIndex-1].x)) {
                            newIndex = nowIndex - 1
                        } else if ((nowIndex < tabBar.count-2) && (tabBar.contentChildren[nowIndex].x >= tabBar.contentChildren[nowIndex+1].x)) {
                            newIndex = nowIndex + 1
                        }

                        // Update tab position
                        if (nowIndex != newIndex) {
                            tabBar.moveItem(nowIndex, newIndex)
                            view.moveItem(nowIndex, newIndex)
                            tabBar.setCurrentIndex(newIndex)
                            view.setCurrentIndex(newIndex)
                            nowIndex = newIndex
                        }
                    }
                }

                drag.target: parent
                drag.axis: Drag.XAxis

                // Drag and move tab
                onPositionChanged: {
                    updateTabPosition()
                }

                // When released drag, fixing tab position.
                onReleased: {
                    if (!drag.active) return

                    // var rightItem = tabBar.itemAt(nowIndex+1)
                    // tabBar.currentItem.x = rightItem.x - tabBar.currentItem.width
                    updateTabX()
                }

                onPressed: {
                    tabBar.setCurrentIndex(hoveredIndex)
                    nowIndex = hoveredIndex
                }

                // Change focus
                onDoubleClicked: {
                    tabBar.setCurrentIndex(hoveredIndex)
                    mouseArea.visible = false
                    textField.visible = true
                    textField.focus = true
                }

                // Show close button
                onEntered: {
                    updateTabPosition()
                    closeButton.visible = true
                }

                onExited: closeButton.visible = false
                Button {
                    id: closeButton
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    FontMetrics {id: fm}
                    width: fm.height * closeButton.text.length
                    height: fm.height
                    text: "×"
                    onClicked: {
                        parent.closeTab(parent)
                    }
                }
            }
        }
    }
}
