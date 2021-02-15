cmake_minimum_required(VERSION 3.14...3.19)

# ---- Project ----

# Note: update this to your new project's name and version
project(
  Greeter
  VERSION 1.0.1
  LANGUAGES CXX
)

# ---- Include guards ----

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

# ---- Project settings ----

if(NOT MSVC)
  option(BUILD_SHARED_LIBS "Create shared libraries if ON" YES)
endif()

if(NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_EXTENSIONS NO)
endif()

# Set default visibility to hidden for all targets
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

# ---- Add dependencies via CPM ----
# see https://github.com/cpm-cmake/CPM.cmake for more info

include(cmake/CPM.cmake)
CPMUsePackageLock(package-lock.cmake)

# PackageProject.cmake will be used to make our target installable
CPMAddPackage(
  NAME PackageProject.cmake
  GITHUB_REPOSITORY TheLartians/PackageProject.cmake
  VERSION 1.4.1
)

# Note: If fmt is not imported, this is needed to prevent: CMake Error: install(EXPORT
# "GreeterTargets" ...) includes target "Greeter" which requires target "fmt" that is not in any
# export set.  see too https://gitlab.kitware.com/cmake/cmake/-/issues/15415
CPMAddPackage(
  NAME fmt
  GIT_TAG 7.1.3
  GITHUB_REPOSITORY fmtlib/fmt # to get an installable target
  OPTIONS "FMT_INSTALL YES"
)

# ---- Add source files ----

# Note: globbing sources is considered bad practice as CMake's generators may not detect new files
# automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS include/*.h)
file(GLOB_RECURSE sources CONFIGURE_DEPENDS source/*.cpp)

# ---- Create library ----

# Note: for header-only libraries change all PUBLIC flags to INTERFACE and create an interface
# target! EITHER: add_library(Greeter INTERFACE) OR:
add_library(Greeter ${headers} ${sources})
set_target_properties(Greeter PROPERTIES SOVERSION 1 VERSION ${PROJECT_VERSION})

# EITHER:
set_target_properties(Greeter PROPERTIES CXX_STANDARD ${CMAKE_CXX_STANDARD})
# OR: target_compile_features(Greeter PUBLIC cxx_std_20)

# being a cross-platform target, we enforce standards conformance on MSVC EITHER:
target_compile_options(Greeter PUBLIC "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive>")
# OR: if(MSVC) target_compile_options(Greeter PUBLIC /permissive) endif()

# Link dependencies EITHER:
target_link_libraries(Greeter PRIVATE $<BUILD_INTERFACE:fmt::fmt-header-only>)
# OR: target_link_libraries(Greeter PUBLIC fmt::fmt)

set(INCLUDE_INSTALL_DIR include/${PROJECT_NAME}-${PROJECT_VERSION})
target_include_directories(
  Greeter BEFORE PUBLIC $<BUILD_INTERFACE: ${PROJECT_SOURCE_DIR}/include>
                        $<INSTALL_INTERFACE:${INCLUDE_INSTALL_DIR}>
)

# ---- Create an installable target ----
# this allows users to install and find the library via `find_package()`.

# the location where the project's version header will be placed should match the project's regular
# header paths
string(TOLOWER ${PROJECT_NAME}/version.h VERSION_HEADER_LOCATION)
string(TOLOWER ${PROJECT_NAME}/greeter_export.h EXPORT_HEADER_LOCATION)

# TODO: should be done in packageProject()
include(GenerateExportHeader)
generate_export_header(
  ${PROJECT_NAME} EXPORT_FILE_NAME PackageProjectInclude/${EXPORT_HEADER_LOCATION}
)
# Note: the export header will be installed while installing the version header! CK

packageProject(
  NAME ${PROJECT_NAME}
  VERSION ${PROJECT_VERSION}
  NAMESPACE ${PROJECT_NAME}
  BINARY_DIR ${PROJECT_BINARY_DIR}
  INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include
  INCLUDE_DESTINATION ${INCLUDE_INSTALL_DIR}
  VERSION_HEADER "${VERSION_HEADER_LOCATION}"
  COMPATIBILITY SameMajorVersion
  # Note: not needed DEPENDENCIES "fmt 7.1.3"
)
