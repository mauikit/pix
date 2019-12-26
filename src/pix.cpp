/***
Pix  Copyright (C) 2018  Camilo Higuita
This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type `show c' for details.

 This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
***/

#include "pix.h"
#include "db/fileloader.h"
#include <QFileSystemWatcher>
#include <QTimer>
#include <QApplication>
#include <QDesktopWidget>
#include <QDirIterator>
#include <QtQml>
#include <QPalette>
#include <QWidget>
#include <QColor>
#include <QDesktopServices>

using namespace PIX;
#ifdef STATIC_MAUIKIT
#include "tagging.h"
#else
#include <MauiKit/tagging.h>
#endif

Pix::Pix(QObject *parent) : QObject(parent)
{
    qDebug() << "Getting settings info from: " << PIX::SettingPath;
    this->refreshCollection();
}

bool Pix::fav(const QUrl &url)
{
    if(Pix::isFav(url))
       return Tagging::getInstance()->removeUrlTag(url.toString(), "fav");

    return Tagging::getInstance()->tagUrl(url.toString(), "fav");
}

bool Pix::isFav(const QUrl &url)
{
    return  Tagging::getInstance()->urlTagExists(url.toString(), "fav", false);
}

void Pix::openPics(const QStringList &pics)
{   
    emit this->viewPics(pics);
}

void Pix::refreshCollection()
{
    const auto sources = PIX::getSourcePaths();
    qDebug()<< "getting default sources to look up" << sources;
    this->populateDB(sources);
}

void Pix::populateDB(const QList<QUrl> &urls)
{
    qDebug() << "Function Name: " << Q_FUNC_INFO
             << "new path for database action: " << urls << QThread::currentThread();

    const auto fileLoader = new FileLoader; //is moved to another thread and deletion happens there
    connect(fileLoader, &FileLoader::finished,[this](uint size)
    {
        Q_UNUSED(size)
        emit this->refreshViews({
                              {PIX::TABLEMAP[TABLE::ALBUMS], true},
                              {PIX::TABLEMAP[TABLE::TAGS], true},
                              {PIX::TABLEMAP[TABLE::IMAGES], true}
                          });
    });
    fileLoader->requestPath(urls);
}

void Pix::showInFolder(const QStringList &urls)
{
    for(const auto &url : urls)
        QDesktopServices::openUrl(FMH::fileDir(url));
}

void Pix::addSources(const QStringList &paths)
{
    PIX::saveSourcePath(paths);
    this->populateDB(std::accumulate(paths.constBegin(), paths.constEnd(), QList<QUrl> {}, [](QList<QUrl> &urls, const QString &path)  {
                         urls << QUrl::fromUserInput(path);
                         return urls;
                     }));
}
