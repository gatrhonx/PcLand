#!/usr/bin/env python3
import sys
import os
import subprocess
from PyQt6.QtWidgets import (
    QApplication, QWidget, QScrollArea, QHBoxLayout,
    QVBoxLayout, QLabel, QSpacerItem, QSizePolicy
)
from PyQt6.QtCore import Qt, QSize, QEvent
from PyQt6.QtGui import QPixmap, QWheelEvent

WALLPAPER_DIR = os.path.expanduser("~/.config/awww")
SET_SCRIPT    = os.path.expanduser("~/.config/wallpaper-selector/set_wallpaper.sh")
EXTENSIONS    = (".jpg", ".jpeg", ".png", ".webp")

# Sensibilidad del scroll — más alto = más rápido
SCROLL_SPEED = 190


def do_scroll(delta_y):
    """Mueve TODAS las filas juntas la misma cantidad absoluta"""
    if delta_y == 0:
        return
    # Calcula el desplazamiento proporcional al delta real
    step = int(delta_y / 120 * SCROLL_SPEED) * -1

    # Busca el máximo scroll alcanzable entre todas las filas
    # para que nunca una fila se adelante a la otra
    max_val = max(
        sa.horizontalScrollBar().maximum()
        for sa in HorizontalScrollArea.instances
    )

    for sa in HorizontalScrollArea.instances:
        sb = sa.horizontalScrollBar()
        # Escala el valor para que ambas filas lleguen al final juntas
        if max_val > 0:
            ratio = sb.maximum() / max_val
            sb.setValue(sb.value() + int(step * ratio))
        else:
            sb.setValue(sb.value() + step)


class HorizontalScrollArea(QScrollArea):
    instances = []

    def __init__(self):
        super().__init__()
        HorizontalScrollArea.instances.append(self)
        self.viewport().installEventFilter(self)

    def eventFilter(self, obj, event):
        if event.type() == QEvent.Type.Wheel:
            do_scroll(event.angleDelta().y())
            return True
        return False

    def wheelEvent(self, event: QWheelEvent) -> None:
        do_scroll(event.angleDelta().y())
        event.accept()


class Thumbnail(QLabel):
    def __init__(self, path, parent=None):
        super().__init__(parent)
        self.path = path
        pixmap = QPixmap(path).scaled(
            320, 180, Qt.AspectRatioMode.KeepAspectRatioByExpanding,
            Qt.TransformationMode.SmoothTransformation
        )
        self.setPixmap(pixmap)
        self.setFixedSize(QSize(320, 180))
        self.setScaledContents(False)
        self.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.setCursor(Qt.CursorShape.PointingHandCursor)
        self.setStyleSheet("""
            QLabel {
                border: 2px solid transparent;
                border-radius: 8px;
            }
            QLabel:hover {
                border: 2px solid #cdd6f4;
            }
        """)

    def mousePressEvent(self, event):
        subprocess.Popen(["bash", SET_SCRIPT, self.path])
        QApplication.instance().quit()

    def wheelEvent(self, event: QWheelEvent) -> None:
        do_scroll(event.angleDelta().y())
        event.accept()


class WallpaperContainer(QWidget):
    def wheelEvent(self, event: QWheelEvent) -> None:
        do_scroll(event.angleDelta().y())
        event.accept()


class WallpaperSelector(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(
            Qt.WindowType.FramelessWindowHint |
            Qt.WindowType.WindowStaysOnTopHint
        )
        self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
        self.setStyleSheet("background: rgba(30, 30, 46, 210); border-radius: 12px;")

        images = sorted([
            os.path.join(WALLPAPER_DIR, f)
            for f in os.listdir(WALLPAPER_DIR)
            if f.lower().endswith(EXTENSIONS)
        ])

        mid = (len(images) + 1) // 2
        row1 = images[:mid]
        row2 = images[mid:]

        main_layout = QVBoxLayout(self)
        main_layout.setContentsMargins(16, 16, 16, 16)
        main_layout.setSpacing(8)

        for row in [row1, row2]:
            scroll = HorizontalScrollArea()
            scroll.setHorizontalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAlwaysOff)
            scroll.setVerticalScrollBarPolicy(Qt.ScrollBarPolicy.ScrollBarAlwaysOff)
            scroll.setWidgetResizable(True)
            scroll.setFixedHeight(196)
            scroll.setStyleSheet("background: transparent; border: none;")
            scroll.setFocusPolicy(Qt.FocusPolicy.StrongFocus)

            container = WallpaperContainer()
            container.setStyleSheet("background: transparent;")
            hbox = QHBoxLayout(container)
            hbox.setContentsMargins(0, 0, 0, 0)
            hbox.setSpacing(8)

            for img in row:
                hbox.addWidget(Thumbnail(img))

            # Si esta fila tiene menos imágenes, agrega un spacer
            # del ancho exacto de un thumbnail para equilibrar el scroll máximo
            if len(row) < mid:
                spacer = QSpacerItem(320, 180, QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
                hbox.addItem(spacer)

            scroll.setWidget(container)
            main_layout.addWidget(scroll)

        screen = QApplication.primaryScreen().geometry()
        self.adjustSize()
        self.move(
            (screen.width()  - self.width())  // 2,
            (screen.height() - self.height()) // 2
        )

    def keyPressEvent(self, event):
        if event.key() in (Qt.Key.Key_Escape, Qt.Key.Key_Super_L):
            QApplication.instance().quit()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    app.setApplicationName("wallpaper-selector")
    win = WallpaperSelector()
    win.show()
    sys.exit(app.exec())
