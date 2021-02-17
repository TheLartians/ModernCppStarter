# only activate options for top level project
if(NOT PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  return()
endif()

option(BUILD_SHARED_LIBS "Create shared libraries" YES)

# Set default visibility to hidden for all targets
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

# build the dynamic libraries and executables together at bin directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

if(NOT DEFINED CMAKE_CXX_STANDARD)
  option(CXX_STANDARD_REQUIRED "Require c++ standard" YES)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_EXTENSIONS NO)
endif()

# this reduce build time if using Nina generators
option(CMAKE_DEPENDS_IN_PROJECT_ONLY "do NOT use system header files for dependency checking" YES)
if(NOT MSVC)
  if(CMAKE_DEPENDS_IN_PROJECT_ONLY)
    set(CMAKE_DEPFILE_FLAGS_C
        "-MMD"
        CACHE STRING "dependency flag" FORCE
    )
    set(CMAKE_DEPFILE_FLAGS_CXX
        "-MMD"
        CACHE STRING "dependency flag" FORCE
    )
  else()
    set(CMAKE_DEPFILE_FLAGS_C
        "-MD"
        CACHE STRING "dependency flag" FORCE
    )
    set(CMAKE_DEPFILE_FLAGS_CXX
        "-MD"
        CACHE STRING "dependency flag" FORCE
    )
  endif()
endif()

option(CMAKE_EXPORT_COMPILE_COMMANDS "support clang-tidy, cppcheck, ..." YES)
if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()
