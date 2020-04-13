cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(GreeterTests
  LANGUAGES CXX
)

# ---- Options ----

option(ENABLE_TEST_COVERAGE "Enable test coverage" OFF)
option(TEST_INSTALLED_VERSION "Test the version found by find_package" OFF)

# ---- Dependencies ----

include(../cmake/CPM.cmake)

CPMAddPackage(
  NAME doctest
  GITHUB_REPOSITORY onqtam/doctest
  VERSION 2.3.2
  GIT_TAG 2.3.2
)

if (TEST_INSTALLED_VERSION)
  find_package(Greeter)
else()
  CPMAddPackage(
    NAME Greeter
    SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..
  )
endif()

CPMAddPackage(
  NAME Format.cmake
  GITHUB_REPOSITORY TheLartians/Format.cmake
  VERSION 1.0
)

# ---- Create binary ----

file(GLOB sources ${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp)
add_executable(GreeterTests ${sources})
target_link_libraries(GreeterTests doctest Greeter)

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  set_target_properties(GreeterTests PROPERTIES CXX_STANDARD 17 COMPILE_FLAGS "-Wall -pedantic -Wextra -Werror")
else()
  set_target_properties(GreeterTests PROPERTIES CXX_STANDARD 17)
endif()

# ---- Add GreeterTests ----

ENABLE_TESTING() 
ADD_TEST(GreeterTests GreeterTests)

# ---- code coverage ----

if (${ENABLE_TEST_COVERAGE})
  set_target_properties(Greeter PROPERTIES CXX_STANDARD 17 COMPILE_FLAGS "-O0 -g -fprofile-arcs -ftest-coverage --coverage")
  target_link_options(Greeter PUBLIC "--coverage")
endif()
