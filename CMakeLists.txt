# stop if cmake is below 3.5
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and supported languages
project(vim LANGUAGES C)

# a couple of configure options to the user with defaults
option(ENABLE_NETBEANS "Enable netbeans" ON)
option(ENABLE_CHANNEL "Enable channel" ON)
option(ENABLE_TERMINAL "Enable terminal" ON)

# default to release mode
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

# if no features are set, default to "huge"
if(NOT FEATURES)
  set(FEATURES "huge")
endif()

# make sure the selected features is a valid choice
set(_available_features "tiny" "small" "normal" "big" "huge")
if(NOT "${FEATURES}" IN_LIST _available_features)
  message(FATAL_ERROR "Unknown features: \"${FEATURES}\". Allowed values are: ${_available_features}.")
endif()

# set default prefix path
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/usr/local/share/vim" CACHE PATH "Install path" FORCE)
endif()
message(STATUS "Project will be installed to ${CMAKE_INSTALL_PREFIX}")

# use install directory variables as defined for gnu software
include(GNUInstallDirs)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

# enable the test target
enable_testing()

# process src/CMakeLists.txt in its own scope
add_subdirectory(src)
