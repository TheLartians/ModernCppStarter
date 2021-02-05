cmake_minimum_required(VERSION 3.14...3.19)

project(GreeterStandalone LANGUAGES CXX)

# --- Import tools ----

include(../cmake/tools.cmake)

# ---- Dependencies ----

include(../cmake/CPM.cmake)

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

# FIXME: WHY? CK
# set_target_properties(GreeterStandalone PROPERTIES CXX_STANDARD 17 OUTPUT_NAME "Greeter")

target_link_libraries(GreeterStandalone Greeter::Greeter cxxopts)
