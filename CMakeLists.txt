cmake_minimum_required(VERSION 3.16)

project(Finera VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

find_package(Qt6 REQUIRED COMPONENTS Sql)

find_package(Qt6 REQUIRED COMPONENTS Charts)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appFinera
    main.cpp
)

qt_add_qml_module(appFinera
    URI Finera
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES listmodel.cpp listmodel.h main.cpp sqlmodelincome.cpp sqlmodelincome.h
    RESOURCES pages/icon/add.png pages/icon/chart.png pages/icon/rept.png pages/icon/statistic.png pages/icon/table.png pages/icon/trash.png
    QML_FILES pages/aboutPage.qml pages/addOrDelPage.qml pages/devPage.qml pages/settingsPage.qml pages/statisticIncomePage.qml
    RESOURCES icon/about.png icon/addOrDel.png icon/appIcon.png icon/dev.png icon/home.png icon/menu.png icon/settings.png icon/statistic.png
    RESOURCES icon/about.png icon/addOrDel.png icon/appIcon.png  icon/dev.png icon/home.png  icon/menu.png icon/settings.png icon/statistic.png
    RESOURCES pages/icon/expenses.png pages/icon/income.png
    RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml
    RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml
    SOURCES applicationengine.h applicationengine.cpp
    SOURCES sqlmodelexpenses.h sqlmodelexpenses.cpp
    QML_FILES pages/statisticExpensesPage.qml
    RESOURCES
    RESOURCES fontApp.qrc
    RESOURCES font/Montserrat-Regular.ttf
    QML_FILES pages/targetPage.qml
    SOURCES sqlmodeltarget.h sqlmodeltarget.cpp
    QML_FILES pages/TargetElement.qml
    RESOURCES pages/icon/add.png pages/icon/chart.png pages/icon/expenses.png pages/icon/income.png pages/icon/note.png pages/icon/rept.png pages/icon/save.png pages/icon/statistic.png pages/icon/table.png pages/icon/trash.png
    RESOURCES pages/icon/note.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appFinera PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appFinera
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appFinera
    PRIVATE Qt6::Quick
)
target_link_libraries(appFinera
    PRIVATE Qt6::Sql
)
target_link_libraries(appFinera
    PRIVATE Qt6::Charts
)

include(GNUInstallDirs)
install(TARGETS appFinera
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
