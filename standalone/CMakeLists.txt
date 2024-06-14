cmake_minimum_required(VERSION 3.14...3.22)

project(
  GreeterStandalone
  DESCRIPTION "A standalone minimal webapi application using the Crow framework"
  LANGUAGES CXX
)

# --- Import tools ----

include(../cmake/tools.cmake)

# ---- Dependencies ----

include(../cmake/CPM.cmake)

# Crow needs Boost 1.64 and does not provide CPM.cmake integration itself, so we have to get Boost
# first
find_package(Boost 1.64 QUIET)
if(NOT Boost_FOUND)
  # Use CPM.cmake to get Boost from the official repo if not provided as system lib
  message(STATUS "GreeterStandalone: Boost system lib NOT found")
  CPMAddPackage(
    NAME Boost
    GITHUB_REPOSITORY boostorg/boost
    GIT_TAG boost-1.78.0
    VERSION 1.78.0
  )
  # Ugly workaround: Boost cmake support is still experimental, the Boost::boost target is not
  # provided if downloaded via FetchContent_declare / CPM.cmake. Crow uses it for asio, so we fake
  # the Boost:boost target as asio
  if(NOT TARGET Boost::boost)
    add_library(Boost::boost INTERFACE IMPORTED)
    target_link_libraries(Boost::boost INTERFACE Boost::asio)
  endif()
else()
  message(STATUS "GreeterStandalone: Boost system lib found")
endif()
# add Crow
CPMAddPackage(
  NAME Crow
  GITHUB_REPOSITORY CrowCpp/Crow
  GIT_TAG v1.0+1
  VERSION 1.0.1
  OPTIONS "CROW_INSTALL OFF"
)

# get the Greeter lib
CPMAddPackage(NAME Greeter SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

# ---- Create standalone executable ----

file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp)

add_executable(${PROJECT_NAME} ${sources})
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_11)
target_link_libraries(${PROJECT_NAME} PRIVATE Greeter::Greeter Crow::Crow)
