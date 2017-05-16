#!/usr/bin/env python3.5
# -*- coding: utf-8 -*-

import sys

from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine


def main():
    app = QApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.setOfflineStoragePath("./Databases/")
    engine.load(QUrl("./qml/Window.qml"))

    app.exec_()


if __name__ == "__main__":
    main()
