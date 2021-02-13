cmake_minimum_required(VERSION 3.14...3.19)

project(GreeterStandalone LANGUAGES CXX)

# --- Import tools ----

include(../cmake/tools.cmake)

# ---- Dependencies ----

include(../cmake/CPM.cmake)
CPMUsePackageLock(package-lock.cmake)

CPMAddPackage(
  NAME cxxopts
  GITHUB_REPOSITORY jarro2783/cxxopts
  VERSION 2.2.0
  OPTIONS "CXXOPTS_BUILD_EXAMPLES Off" "CXXOPTS_BUILD_TESTS Off"
)

CPMAddPackage(NAME Greeter SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

# ---- Create standalone executable ----

file(GLOB sources CONFIGURE_DEPENDS source/*.cpp)

add_executable(GreeterStandalone ${sources})

# TODO: why rename in this way? Seems only for CI with GitHub actions! CK
set_target_properties(
  GreeterStandalone PROPERTIES CXX_STANDARD ${CMAKE_CXX_STANDARD} OUTPUT_NAME "Greeter"
)

# WORKAROUND missing ALIAS target error! CK
if(NOT TARGET cxxopts::cxxopts)
  add_library(cxxopts::cxxopts ALIAS cxxopts)
endif()
target_link_libraries(GreeterStandalone Greeter::Greeter cxxopts::cxxopts)
