cmake_minimum_required(VERSION 3.10)
project(unibilium LANGUAGES C VERSION 2.1.4)

option(BUILD_MAN_PAGES "Build man pages" ON)
option(BUILD_TESTS "Build tests" ON)
option(BUILD_TOOLS "Build unibilium tools" ON)

add_library(unibilium
  unibilium.c
  uninames.c
  uniutil.c
)
set_target_properties(unibilium PROPERTIES
  PUBLIC_HEADER ${PROJECT_SOURCE_DIR}/unibilium.h
  # Keep in sync with Makefile.in
  # "$LT_CURRENT - $LT_AGE.$LT_AGE.$LT_REVISION"
  VERSION "4.0.2"
  # "$LT_CURRENT - $LT_AGE"
  SOVERSION "4")
target_compile_features(unibilium PRIVATE c_std_99)

if(NOT WIN32)
  execute_process(COMMAND sh -c "ncursesw6-config --terminfo-dirs 2>/dev/null || \
      ncurses6-config  --terminfo-dirs 2>/dev/null || \
      ncursesw5-config --terminfo-dirs 2>/dev/null || \
      ncurses5-config  --terminfo-dirs 2>/dev/null || \
      echo '/etc/terminfo:/lib/terminfo:/usr/share/terminfo:/usr/lib/terminfo:/usr/local/share/terminfo:/usr/local/lib/terminfo'"
    OUTPUT_VARIABLE TERMINFO_DIRS_DEFAULT)
  # Remove trailing newline
  string(STRIP "${TERMINFO_DIRS_DEFAULT}" TERMINFO_DIRS_DEFAULT)

  execute_process(COMMAND sh -c "ncursesw6-config --terminfo 2>/dev/null || \
      ncurses6-config  --terminfo 2>/dev/null || \
      ncursesw5-config --terminfo 2>/dev/null || \
      ncurses5-config  --terminfo 2>/dev/null || \
      echo '/usr/share/terminfo'"
    OUTPUT_VARIABLE TERMINFO_DEFAULT)
  # Remove trailing newline
  string(STRIP "${TERMINFO_DEFAULT}" TERMINFO_DEFAULT)
else()
  set(TERMINFO_DIRS_DEFAULT "")
  set(TERMINFO_DEFAULT "")
endif()
set(TERMINFO_DIRS "${TERMINFO_DIRS_DEFAULT}" CACHE STRING "Colon-separated list of directories where unibilium should look for compiled terminfo files at runtime")
target_compile_definitions(unibilium PUBLIC "TERMINFO_DIRS=\"${TERMINFO_DIRS}\"")
set(TERMINFO "${TERMINFO_DEFAULT}" CACHE STRING "Directory where unibilium should look for compiled terminfo files at runtime")
target_compile_definitions(unibilium PUBLIC "TERMINFO=\"${TERMINFO}\"")

include(GNUInstallDirs)

if(NOT WIN32)
  if(BUILD_MAN_PAGES)
    add_subdirectory(doc)
  endif()
  set(LIBDIR ${CMAKE_INSTALL_FULL_LIBDIR})
  set(INCDIR ${CMAKE_INSTALL_FULL_INCLUDEDIR})
  set(VERSION ${PROJECT_VERSION})
  configure_file(unibilium.pc.in unibilium.pc @ONLY)
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/unibilium.pc"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig")
  unset(LIBDIR)
  unset(INCDIR)
  unset(VERSION)
endif()

if(BUILD_TOOLS)
  add_subdirectory(tools)
endif()

if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(t)
endif()

install(TARGETS unibilium
  PUBLIC_HEADER
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
