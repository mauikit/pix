#ifndef CLOUD_H
#define CLOUD_H

#include <QObject>
#include "./src/models/baselist.h"

class FM;
class Cloud : public BaseList
{
    Q_OBJECT
    Q_PROPERTY(QString account READ getAccount WRITE setAccount NOTIFY accountChanged)

public:   
    enum SORTBY : uint_fast8_t
    {
        SIZE = FMH::MODEL_KEY::SIZE,
        MODIFIED = FMH::MODEL_KEY::MODIFIED,
        DATE = FMH::MODEL_KEY::DATE,
        LABEL = FMH::MODEL_KEY::LABEL,
        MIME = FMH::MODEL_KEY::MIME

    }; Q_ENUM(SORTBY)

    explicit Cloud(QObject *parent = nullptr);
    FMH::MODEL_LIST items() const override;

    void setAccount(const QString value);
    QString getAccount() const;

private:
    FMH::MODEL_LIST list;
    void setList();
    void formatList();

    QString account;
    FM *fm;

public slots:
    QVariantMap get(const int &index) const override;

signals:
    void accountChanged();
};

#endif // CLOUD_H
