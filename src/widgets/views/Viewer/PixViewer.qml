import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../../../view_models"
import "../../../widgets/views/Viewer/Viewer.js" as VIEWER
import "../../../widgets/views/Pix.js" as PIX
import "../../../db/Query.js" as Q
import "../.."
import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui
import org.maui.pix 1.0 as Pix
import GalleryList 1.0

Maui.Page
{
    id: control

    property alias viewer : viewer
    property alias holder : holder
    property alias tagBar : tagBar
    property alias roll : galleryRoll

    property bool currentPicFav: false
    property var currentPic : ({})
    property int currentPicIndex : 0
    property alias model :viewer.model
    property bool tagBarVisible : Maui.FM.loadSettings("TAGBAR", "PIX", true) === "true" ? true : false
    property bool previewBarVisible: Maui.FM.loadSettings("PREVIEWBAR", "PIX", true) === "true" ? true : false

    padding: 0
    Kirigami.Theme.colorSet: Kirigami.Theme.View

    PixMenu
    {
        id: _picMenu
        index: viewer.currentIndex
        model:control.model
    }

    footBar.visible: !holder.visible
    footBar.rightContent: [
        ToolButton
        {
            icon.name: "document-share"
            onClicked:
            {
                dialogLoader.sourceComponent = shareDialogComponent
                dialog.urls = [control.currentPic.url]
                dialog.open()
            }
        },

        ToolButton
        {
            icon.name: "object-rotate-left"
            onClicked: viewer.currentItem.item.rotateLeft()
        },

        ToolButton
        {
            icon.name: "object-rotate-right"
            onClicked: viewer.currentItem.item.rotateRight()
        }
    ]
    footBar.leftContent: [

        ToolButton
        {
            icon.name: "go-previous"
            onClicked: VIEWER.previous()
        },

        ToolButton
        {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.highlightColor: "#ff5a86"
            icon.name: "love"
            checked: pixViewer.currentPicFav
            icon.color: pixViewer.currentPicFav ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
            onClicked:
            {
                if(pixViewer.currentPicFav)
                    tagBar.list.removeFromUrls("fav")
                else
                    tagBar.list.insertToUrls("fav")

                pixViewer.currentPicFav = !pixViewer.currentPicFav
            }
        },

        ToolButton
        {
            icon.name: "go-next"
            onClicked: VIEWER.next()
        }
    ]

    Maui.Holder
    {
        id: holder
        visible: viewer.count === 0 /*|| viewer.currentItem.status !== Image.Ready*/

        emoji: viewer.count === 0 ? "qrc:/img/assets/add-image.svg" : "qrc:/img/assets/animat-image-color.gif"
        isMask: true
        isGif : viewer.currentItem.status !== Image.Ready
        title : viewer.count === 0 ? qsTr("No Pics!") : qsTr("Loading...")
        body: viewer.count === 0 ? qsTr("Open an image from your collection") : qsTr("Your pic is almost ready")
        emojiSize: isGif ? Maui.Style.iconSizes.enormous : Maui.Style.iconSizes.huge
    }

    ColumnLayout
    {
        height: parent.height
        width: parent.width

        Viewer
        {
            id: viewer
            visible: !holder.visible
            Layout.fillHeight: true
            Layout.fillWidth: true

            MouseArea
            {
                width: parent.width
                height: parent.height * 0.3
                anchors.bottom: parent.bottom
                propagateComposedEvents: true

                onPressed:
                {
                    galleryRollBg.toogle()
                     mouse.accepted = false
                }

                onReleased:
                {
                    mouse.accepted = false
                }
            }

            Rectangle
            {
                id: galleryRollBg
                width: parent.width
                anchors.bottom: parent.bottom
                height: Math.min(100, Math.max(parent.height * 0.12, 60))
                visible: control.previewBarVisible && galleryRoll.rollList.count > 0
                color: Qt.rgba(control.Kirigami.Theme.backgroundColor.r, control.Kirigami.Theme.backgroundColor.g, control.Kirigami.Theme.backgroundColor.b, 0.4)

                 Behavior on opacity
                 {
                     NumberAnimation
                     {
                         duration: Kirigami.Units.longDuration
                         easing.type: Easing.InOutQuad
                     }
                 }

                 GalleryRoll
                 {
                     id: galleryRoll
                     height: parent.height -Maui.Style.space.small
                     width: parent.width
                     anchors.centerIn: parent
                     onPicClicked: VIEWER.view(index)
                 }

                function toogle()
                {
                    galleryRollBg.opacity = !galleryRollBg.opacity
                }
            }


        }      

        Maui.TagsBar
        {
            id: tagBar
            visible: !holder.visible && tagBarVisible && !fullScreen
            Layout.fillWidth: true
            position: ToolBar.Footer
            allowEditMode: true
            list.urls: [currentPic.url]
            list.strict: false
            onTagClicked: PIX.searchFor(tag)
            onAddClicked:
            {
                dialogLoader.sourceComponent = tagsDialogComponent
                dialog.composerList.urls = [currentPic.url]
                dialog.open()
            }

            onTagRemovedClicked: list.removeFromUrls(index)
            onTagsEdited: list.updateToUrls(tags)

            Connections
            {
                target: dialog
                ignoreUnknownSignals: true
                enabled: dialogLoader.sourceComponent === tagsDialogComponent
                onTagsReady: tagBar.list.refresh()
            }
        }
    }

    function toogleTagbar()
    {
        control.tagBarVisible = !control.tagBarVisible
        Maui.FM.saveSettings("TAGBAR", tagBarVisible, "PIX")
    }

    function tooglePreviewBar()
    {
        control.previewBarVisible = !control.previewBarVisible
        Maui.FM.saveSettings("PREVIEWBAR", previewBarVisible, "PIX")
    }
}
