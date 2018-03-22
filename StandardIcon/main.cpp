#include <QApplication>
#include <QtWidgets>
#include <QStyle>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QTextBrowser editor;
    editor.show();

    auto metaEnum = QMetaEnum::fromType<QStyle::StandardPixmap>();
    auto cursor = editor.textCursor();
    auto table = cursor.insertTable(metaEnum.keyCount()+1, 2, QTextTableFormat());

    table->cellAt(0, 0).firstCursorPosition().insertText("enum QStyle::StandardPixmap");
    table->cellAt(0, 1).firstCursorPosition().insertText("Image");

    QTextBlockFormat format;
    format.setAlignment(Qt::AlignCenter);
    table->cellAt(0, 0).firstCursorPosition().setBlockFormat(format);
    table->cellAt(0, 1).firstCursorPosition().setBlockFormat(format);

    for (int icon_i = 0; icon_i < metaEnum.keyCount(); ++icon_i) {
        auto icon = QApplication::style()->standardPixmap(static_cast<QStyle::StandardPixmap>(icon_i));
        QBuffer buffer;
        icon.save(&buffer, "PNG");
        auto url = QString("<img src='data:image/png;base64,") + buffer.data().toBase64() + "'/>";
        table->cellAt(icon_i+1, 0).firstCursorPosition().insertText(metaEnum.key(icon_i));
        table->cellAt(icon_i+1, 1).firstCursorPosition().insertHtml(url);
        table->cellAt(icon_i+1, 1).firstCursorPosition().setBlockFormat(format);
        /// \warn Images inserted by insertImage are cannot copy to clipboard.
        // table->cellAt(icon_i+1, 1).firstCursorPosition().insertImage(QImage::fromData(buffer.data()));
    }

    return app.exec();
}
