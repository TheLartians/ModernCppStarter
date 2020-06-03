cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(GreeterDocs)

# ---- Dependencies ----

include(../cmake/CPM.cmake)

CPMAddPackage(
  NAME Greeter
  SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..
)

CPMAddPackage(
  NAME StableCoder-cmake-scripts
  GITHUB_REPOSITORY StableCoder/cmake-scripts
  GIT_TAG 3d2d5a9fb26f0ce24e3e4eaeeff686ec2ecfb3fb
)

# ---- Doxygen ----

set(BUILD_DOCUMENTATION ON CACHE INTERNAL "")
include(${StableCoder-cmake-scripts_SOURCE_DIR}/doxygen.cmake)

# set Doxyfile variables
set(DOXYGEN_PROJECT_NAME Greeter)
set(DOXYGEN_PROJECT_VERSION ${Greeter_VERSION})
set(DOXYGEN_PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")

# see https://github.com/StableCoder/cmake-scripts#doxygen-doxygencmake for additional options
build_docs(
  TARGET_NAME GenerateDocs
  DOXYFILE_PATH ${CMAKE_CURRENT_LIST_DIR}/Doxyfile
  OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/doxygen
  PROCESS_DOXYFILE ON
)
