# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later


set(pix_SRCS
    main.cpp
    pix.cpp
    models/gallery/gallery.cpp
    models/folders/folders.cpp
    models/tags/tagsmodel.cpp
    models/picinfomodel.cpp
#    utils/picinfo/exiv2extractor.cpp
#    utils/picinfo/reversegeocoder.cpp
#    utils/picinfo/kdtree.c
    )

set(pix_HDRS
    pix.h
    models/gallery/gallery.h
    models/folders/folders.h
    models/tags/tagsmodel.h
    models/picinfomodel.h
#    utils/picinfo/exiv2extractor.h
#    utils/picinfo/reversegeocoder.h
#    utils/picinfo/kdtree.h
    )

set(pix_ASSETS
    qml.qrc
    imgs.qrc
    )

if(ANDROID)
    add_library(pix SHARED
        ${pix_SRCS}
        ${pix_HDRS}
        ${pix_ASSETS}
        )
else()
    add_executable(pix
        ${pix_SRCS}
        ${pix_HDRS}
        ${pix_ASSETS}
        )
endif()

#target_link_libraries(pix MauiKit Qt5::Sql Qt5::Qml Qt5::Svg Qt5::Positioning KF5::I18n LibExiv2::LibExiv2)

target_compile_definitions(pix
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(pix MauiKit Qt5::Sql Qt5::Qml Qt5::Svg Qt5::Concurrent Qt5::QuickControls2 Qt5::Positioning KF5::I18n)

if(ANDROID)
    target_link_libraries(pix Qt5::AndroidExtras)
    kde_source_files_enable_exceptions(pix pix.cpp)
endif()

if(UNIX AND NOT APPLE AND NOT ANDROID)
    install(TARGETS pix ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
    install(FILES org.kde.pix.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})
    #TODO: port to ecm_install_icons()
    install(FILES assets/pix.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
endif()
