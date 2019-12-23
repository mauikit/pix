#ifndef GALLERY_H
#define GALLERY_H

#include <QObject>
#include "models/baselist.h"
#include "utils/pic.h"

class DBActions;
class Gallery : public BaseList
{
    Q_OBJECT
    Q_PROPERTY(QString query READ getQuery WRITE setQuery NOTIFY queryChanged())
    Q_PROPERTY(SORTBY sortBy READ getSortBy WRITE setSortBy NOTIFY sortByChanged)

public:
    enum SORTBY : uint_fast8_t
    {
        ADDDATE = FMH::MODEL_KEY::ADDDATE,
        DATE = FMH::MODEL_KEY::DATE,
        PLACE = FMH::MODEL_KEY::PLACE,
        TITLE = FMH::MODEL_KEY::TITLE,
        SIZE = FMH::MODEL_KEY::SIZE,
        FORMAT = FMH::MODEL_KEY::FORMAT,
        FAV = FMH::MODEL_KEY::FAV,
        NONE

    }; Q_ENUM(SORTBY)

    explicit Gallery(QObject *parent = nullptr);
    FMH::MODEL_LIST items() const override;

    void setQuery(const QString &query);
    QString getQuery() const;

    void setSortBy(const Gallery::SORTBY &sort);
    Gallery::SORTBY  getSortBy() const;

private:
    DBActions *dba;
    FMH::MODEL_LIST list;
    void sortList();
    void setList();

    QString query;
    Gallery::SORTBY sort = Gallery::SORTBY::ADDDATE;

    bool addPic(const FMH::MODEL &img);

signals:
    void queryChanged();
    void orderChanged();
    void sortByChanged();

public slots:    
    QVariantMap get(const int &index) const override;
    bool update(const int &index, const QVariant &value, const int &role) override; //deprecrated
    bool update(const QVariantMap &data, const int &index) override;
    bool update(const FMH::MODEL &pic) override;
    bool remove(const int &index) override;
    bool deleteAt(const int &index);
    bool fav(const int &index, const bool &value);
    void append(const QVariantMap &pic);
    void append(const QString &url);
//    void appendAt(const QString &url, const int &pos);
    void refresh();
    void clear();
};

#endif // GALLERY_H
