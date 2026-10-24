cmake_minimum_required(VERSION 3.14...3.22)

project(GreeterStandalone LANGUAGES CXX)

# --- Import tools ----

include(../cmake/tools.cmake)

# ---- Dependencies ----

include(../cmake/CPM.cmake)

CPMAddPackage(
  GITHUB_REPOSITORY jarro2783/cxxopts
  VERSION 3.3.1
  OPTIONS "CXXOPTS_BUILD_EXAMPLES NO" "CXXOPTS_BUILD_TESTS NO" "CXXOPTS_ENABLE_INSTALL YES"
)

CPMAddPackage(NAME Greeter SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

# ---- Create standalone executable ----

file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp)

add_executable(${PROJECT_NAME} ${sources})

set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 17 OUTPUT_NAME "Greeter")

target_link_libraries(${PROJECT_NAME} Greeter::Greeter cxxopts)

# ---- Test standalone command-line behavior ----

include(CTest)

if(BUILD_TESTING)
  add_test(NAME GreeterDefault COMMAND ${PROJECT_NAME})
  set_tests_properties(GreeterDefault PROPERTIES PASS_REGULAR_EXPRESSION "Hello, World!")

  add_test(NAME GreeterHelp COMMAND ${PROJECT_NAME} --help)
  set_tests_properties(GreeterHelp PROPERTIES PASS_REGULAR_EXPRESSION "Show help")

  add_test(NAME GreeterVersion COMMAND ${PROJECT_NAME} --version)
  set_tests_properties(GreeterVersion PROPERTIES PASS_REGULAR_EXPRESSION "Greeter, version")

  foreach(language IN ITEMS en de es fr)
    add_test(NAME GreeterLanguage_${language} COMMAND ${PROJECT_NAME} --lang ${language})
  endforeach()

  set_tests_properties(
    GreeterLanguage_en PROPERTIES PASS_REGULAR_EXPRESSION "Hello, World!"
  )
  set_tests_properties(GreeterLanguage_de PROPERTIES PASS_REGULAR_EXPRESSION "Hallo World!")
  set_tests_properties(GreeterLanguage_es PROPERTIES PASS_REGULAR_EXPRESSION "¡Hola World!")
  set_tests_properties(GreeterLanguage_fr PROPERTIES PASS_REGULAR_EXPRESSION "Bonjour World!")

  add_test(NAME GreeterUnknownLanguage COMMAND ${PROJECT_NAME} --lang unknown)
  set_tests_properties(GreeterUnknownLanguage PROPERTIES WILL_FAIL TRUE)
endif()
