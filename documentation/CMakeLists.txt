cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(GreeterDocumentation
  LANGUAGES CXX
)

# --- Import tools ----

include(../cmake/tools.cmake)

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

# see https://github.com/StableCoder/cmake-scripts#doxygen-doxygencmake for options
build_docs(
  TARGET_NAME GenerateDocs
  DOXYFILE_PATH ${CMAKE_CURRENT_LIST_DIR}/Doxyfile
  OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/doc
  PROCESS_DOXYFILE ON
)
