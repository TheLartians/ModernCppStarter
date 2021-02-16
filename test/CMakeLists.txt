cmake_minimum_required(VERSION 3.14...3.19)

project(
  GreeterTests
  VERSION 1
  LANGUAGES CXX
)

# ---- Options ----

option(ENABLE_TEST_COVERAGE "Enable test coverage" OFF)
option(TEST_INSTALLED_VERSION "Test the version found by find_package" OFF)

# --- Import tools ----

include(../cmake/tools.cmake)

# ---- Dependencies ----

include(../cmake/CPM.cmake)
CPMUsePackageLock(package-lock.cmake)

CPMAddPackage(
  NAME doctest
  GITHUB_REPOSITORY onqtam/doctest
  GIT_TAG 2.4.5
)

if(TEST_INSTALLED_VERSION)
  find_package(Greeter ${PROJECT_VERSION} REQUIRED)
else()
  CPMAddPackage(NAME Greeter SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)
endif()

CPMAddPackage(
  NAME Format.cmake
  GITHUB_REPOSITORY TheLartians/Format.cmake
  VERSION 1.6
  OPTIONS # enable cmake formatting
          "FORMAT_CHECK_CMAKE ON"
)

# ---- Create binary ----

file(GLOB sources CONFIGURE_DEPENDS source/*.cpp)
add_executable(GreeterTests ${sources})
target_link_libraries(GreeterTests doctest::doctest Greeter::Greeter)
set_target_properties(GreeterTests PROPERTIES CXX_STANDARD ${CMAKE_CXX_STANDARD})

# enable compiler warnings
if(NOT TEST_INSTALLED_VERSION)
  if(CMAKE_CXX_COMPILER_ID MATCHES "(Apple)?[Cc]lang" OR CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    target_compile_options(Greeter PUBLIC -Wall -Wextra -Werror)
  elseif(MSVC)
    target_compile_options(Greeter PUBLIC /W4 /WX)
    target_compile_definitions(GreeterTests PUBLIC DOCTEST_CONFIG_USE_STD_HEADERS)
  endif()
endif()

# ---- Add GreeterTests ----

enable_testing()

add_test(NAME greeterTests COMMAND GreeterTests)

# ---- code coverage ----

if(ENABLE_TEST_COVERAGE AND NOT Greeter_FOUND)
  target_compile_options(Greeter PUBLIC -O0 -g -fprofile-arcs -ftest-coverage)
  target_link_options(Greeter PUBLIC -fprofile-arcs -ftest-coverage)
endif()
