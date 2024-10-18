cmake_minimum_required(VERSION 3.16)

project(calendar VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(calendar-app
    main.cpp
)

set_source_files_properties(Theme.qml PROPERTIES
  QT_QML_SINGLETON_TYPE TRUE
)


qt_add_qml_module(calendar-app
    URI calendar
    VERSION 1.0
    QML_FILES
        Main.qml
        Theme.qml
        NavigatorButton.qml

    RESOURCES
        arrow-left.svg
        arrow-right.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(calendar-app PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appbirthday
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(calendar-app
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS calendar-app
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
