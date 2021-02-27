# this script adds all subprojects to a single build to allow IDEs understand the full project
# structure.

cmake_minimum_required(VERSION 3.14...3.19)

project(BuildAll LANGUAGES CXX)

include(../cmake/tools.cmake)

# needed to generate test target
enable_testing()

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../standalone standalone)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../test test)
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/../documentation documentation)
