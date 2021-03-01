cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

project(GreeterDocs)

# ---- Dependencies ----

include(../cmake/CPM.cmake)

CPMAddPackage("gh:mosra/m.css#42d4a9a48f31f5df6e246c948403b54b50574a2a")
CPMAddPackage(NAME Greeter SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

# ---- Doxygen variables ----

# set Doxyfile variables
set(DOXYGEN_PROJECT_NAME Greeter)
set(DOXYGEN_PROJECT_VERSION ${Greeter_VERSION})
set(DOXYGEN_PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
set(DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/doxygen")

configure_file(${CMAKE_CURRENT_LIST_DIR}/Doxyfile ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

configure_file(${CMAKE_CURRENT_LIST_DIR}/conf.py ${CMAKE_CURRENT_BINARY_DIR}/conf.py)

add_custom_target(
  GenerateDocs
  ${CMAKE_COMMAND} -E make_directory "${DOXYGEN_OUTPUT_DIRECTORY}"
  COMMAND "${MCSS_SOURCE_DIR}/documentation/doxygen.py" "${CMAKE_CURRENT_BINARY_DIR}/conf.py"
  COMMAND echo "Docs written to: ${DOXYGEN_OUTPUT_DIRECTORY}"
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)
