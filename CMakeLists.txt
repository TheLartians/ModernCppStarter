cmake_minimum_required(VERSION 3.21...3.27)

# ---- Project ----

# Note: update this to your new project's name and version
project(
  Greeter
  VERSION 1.0
  LANGUAGES CXX
)

# ---- Include guards ----

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

if(NOT PROJECT_IS_TOP_LEVEL)
  option(CMAKE_SKIP_INSTALL_RULES "Whether to disable generation of installation rules" YES)
endif()

option(OPTION_ENABLE_UNITY "Enable Unity builds of project" ON)

# ---- Add dependencies via CPM ----
# see https://github.com/TheLartians/CPM.cmake for more info

include(cmake/CPM.cmake)

# PackageProject.cmake will be used to make our target installable
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.10.0")

CPMAddPackage(
  NAME fmt
  GIT_TAG 9.1.0
  GITHUB_REPOSITORY fmtlib/fmt
  SYSTEM ON # used in case of cmake v3.25
  OPTIONS "FMT_INSTALL YES" # create an installable target
)

# ---- Add source files ----

# Note: globbing sources is considered bad practice as CMake's generators may not detect new files
# automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")

# ---- Create library ----

# Note: for header-only libraries change all PUBLIC flags to INTERFACE and create an interface
# target: add_library(${PROJECT_NAME} INTERFACE)
add_library(${PROJECT_NAME} ${headers} ${sources})
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)
set_target_properties(${PROJECT_NAME} PROPERTIES UNITY_BUILD ${OPTION_ENABLE_UNITY})

if(PROJECT_IS_TOP_LEVEL)
  # enable compiler warnings
  include(cmake/WarningsAsErrors.cmake)

  # being a cross-platform target, we enforce standards conformance on MSVC
  target_compile_options(${PROJECT_NAME} PRIVATE "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive->")
endif()

# Link dependencies
target_link_libraries(${PROJECT_NAME} PUBLIC fmt::fmt)

target_include_directories(
  ${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
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
  COMPATIBILITY SameMajorVersion
  DEPENDENCIES "fmt 9.1.0"
)

include(CPack)
