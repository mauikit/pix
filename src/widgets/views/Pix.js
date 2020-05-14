.import org.kde.mauikit 1.0 as Maui

function refreshViews()
{

}

function addTagToPic(myTag, url)
{
    return tag.tagUrl(url, myTag)
}

function addTagToAlbum(tag, url)
{
    return dba.albumTag(tag, url)
}

function addTagsToPic(tags, url)
{
    for(var i in tags)
        addTagToPic(tags[i], url)
}

//function searchFor(query)
//{
//    if(currentView !== views.search)
//        currentView = views.search

//    searchView.runSearch(query)
//}

function selectItem(item)
{
    if(selectionBox.contains(item.url))
    {
        selectionBox.removeAtUri(item.url)
        return
    }

    selectionBox.append(item.url, item)
}


