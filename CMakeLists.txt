cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

# Note: update this to your new project's name and version
project(
  Greeter
  VERSION 1.1
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

if(NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_EXTENSIONS NO)
endif()

# ---- Add dependencies via CPM ----
# see https://github.com/TheLartians/CPM.cmake for more info

include(cmake/CPM.cmake)

# PackageProject.cmake will be used to make our target installable
CPMAddPackage(
  NAME PackageProject.cmake
  GITHUB_REPOSITORY TheLartians/PackageProject.cmake
  VERSION 1.4.1
)

# Note: If fmt is not imported, this is needed to prevent: CMake Error: install(EXPORT
# "GreeterTargets" ...) includes target "Greeter" which requires target "fmt" that is not in any
# export set.  see too https://gitlab.kitware.com/cmake/cmake/-/issues/15415
set(FMT_VERSION 7.1.3)
CPMAddPackage(
  NAME fmt
  GIT_TAG ${FMT_VERSION}
  GITHUB_REPOSITORY fmtlib/fmt
  # XXX OPTION "FMT_INSTALL YES"
)

# ---- Add source files ----

# Note: globbing sources is considered bad practice as CMake's generators may not detect new files
# automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")

# ---- Create library ----

# Note: for header-only libraries change all PUBLIC flags to INTERFACE and create an interface
# target: add_library(Greeter INTERFACE)
add_library(Greeter)
target_compile_features(Greeter PUBLIC cxx_std_17)

target_sources(Greeter PRIVATE ${headers} ${sources})

# being a cross-platform target, we enforce standards conformance on MSVC
if(MSVC)
  target_compile_options(Greeter PUBLIC /permissive)
endif()

# Link dependencies (if required)
target_link_libraries(Greeter PRIVATE $<BUILD_INTERFACE:fmt::fmt-header-only>)
# XXX target_link_libraries(Greeter PUBLIC fmt::fmt)

target_include_directories(
  Greeter PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                 $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
)

# ---- Create an installable target ----
# this allows users to install and find the library via `find_package()`.

# the location where the project's version header will be placed should match the project's regular
# header paths
string(TOLOWER ${PROJECT_NAME}/version.h VERSION_HEADER_LOCATION)

packageProject(
  NAME ${PROJECT_NAME}
  VERSION ${PROJECT_VERSION}
  NAMESPACE ${PROJECT_NAME}
  BINARY_DIR ${PROJECT_BINARY_DIR}
  INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include
  INCLUDE_DESTINATION include/${PROJECT_NAME}-${PROJECT_VERSION}
  VERSION_HEADER "${VERSION_HEADER_LOCATION}"
  # XXX DEPENDENCIES "fmt ${FMT_VERSION}"
)
