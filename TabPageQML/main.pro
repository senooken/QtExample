QT       += quick

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
CONFIG += c++11

TARGET = main.exe
TEMPLATE = app

OTHER_FILES = main.qml
SOURCES = main.cpp
