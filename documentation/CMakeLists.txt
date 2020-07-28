cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(GreeterDocs)

# ---- Dependencies ----

include(../cmake/CPM.cmake)

CPMAddPackage(
  NAME Greeter
  SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..
)

CPMAddPackage(
  NAME MCSS
  GITHUB_REPOSITORY TheLartians/m.css
  # using a local patch until https://github.com/mosra/m.css/pull/171 is resolved
  GIT_TAG 1bf162b96d5bfefc9967a80cef138f1270ffa415
  DOWNLOAD_ONLY YES
)

# ---- Doxygen variables ----

# set Doxyfile variables
set(DOXYGEN_PROJECT_NAME Greeter)
set(DOXYGEN_PROJECT_VERSION ${Greeter_VERSION})
set(DOXYGEN_PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
set(DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/doxygen")

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/Doxyfile
  ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
)

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/conf.py
  ${CMAKE_CURRENT_BINARY_DIR}/conf.py
)

add_custom_target(
  GenerateDocs
  ${CMAKE_COMMAND} -E make_directory "${DOXYGEN_OUTPUT_DIRECTORY}"
  COMMAND "${MCSS_SOURCE_DIR}/documentation/doxygen.py" "${CMAKE_CURRENT_BINARY_DIR}/conf.py"
  COMMAND echo "Docs written to: ${DOXYGEN_OUTPUT_DIRECTORY}"
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)
