#include <QCoreApplication>

class SingleDerivedQObject : public QObject
{
    Q_OBJECT
};

// This is required for derived QObject class in .cpp after class declaration.
#include "main.moc"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    SingleDerivedQObject object;
    return 0;
}
