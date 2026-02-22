cmake_minimum_required(VERSION 3.16)
project(Finera VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql Charts)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appFinera
    cpp/main.cpp
)

qt_add_qml_module(appFinera
    URI Finera
    VERSION 1.0
    QML_FILES
        Main.qml

        qml/pages/addOrDelPage.qml
        qml/pages/devPage.qml
        qml/pages/statisticIncomePage.qml
        qml/pages/targetPage.qml
        qml/pages/TargetElement.qml
    SOURCES
        cpp/main.cpp
        cpp/listmodel.cpp header/listmodel.h
        cpp/sqlmodelincome.cpp header/sqlmodelincome.h
        header/applicationengine.h cpp/applicationengine.cpp
        header/sqlmodeltarget.h cpp/sqlmodeltarget.cpp
        header/sqlmanager.h cpp/sqlmanager.cpp
    RESOURCES
        # Иконки страниц
        qml/pages/icon/add.png
        qml/pages/icon/chart.png
        qml/pages/icon/rept.png
        qml/pages/icon/statistic.png
        qml/pages/icon/table.png
        qml/pages/icon/trash.png
        qml/pages/icon/income.png
        qml/pages/icon/note.png
        qml/pages/icon/save.png
        # Иконки приложения
        icon/about.png
        icon/addOrDel.png
        icon/appIcon.png
        icon/dev.png
        icon/home.png
        icon/menu.png
        icon/settings.png
        icon/statistic.png
        # Шрифт
        font/Montserrat-Regular.ttf
        # Android файлы
        android/AndroidManifest.xml
        android/build.gradle
        android/res/values/libs.xml
        android/res/xml/qtprovider_paths.xml
)

set_target_properties(appFinera PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Объединил все три target_link_libraries в один — чище
target_link_libraries(appFinera
    PRIVATE
        Qt6::Quick
        Qt6::Sql
        Qt6::Charts
)

include(GNUInstallDirs)
install(TARGETS appFinera
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
