// Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
// Copyright 2018-2020 Nitrux Latinoamericana S.C.
//
// SPDX-License-Identifier: GPL-3.0-or-later


import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami
import org.kde.mauikit 1.0 as Maui
import org.maui.pix 1.0

import "../../../view_models"

ScrollView
{
    id: control
    property alias rollList : rollList
    property alias model: rollList.model

    signal picClicked(int index)
    contentHeight: height
    contentWidth: rollList.contentWidth

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOff

    ListView
    {
        id: rollList
        anchors.fill: parent
        currentIndex: currentPicIndex
        orientation: ListView.Horizontal
        clip: true
        spacing: Maui.Style.space.medium

        focus: true
        interactive: true

        delegate: PixPic
        {
            id: delegate
            height: rollList.height
            width: height

            labelsVisible: false
            fit: false
            checkable: false
            isCurrentItem: ListView.isCurrentItem
            radius:  Maui.Style.radiusV
            onClicked:
            {
                rollList.currentIndex = index
                picClicked(index)
            }

            onPressAndHold: _picMenu.popup()
            onRightClicked: _picMenu.popup()
        }
    }

    function position(index)
    {
        rollList.currentIndex = index
        rollList.positionViewAtIndex(index, ListView.Center)
    }
}

