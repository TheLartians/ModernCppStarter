# this file contains a list of tools that can be activated and downloaded on-demand
# each tool is enabled during configuration by passing an additional `-DUSE_<TOOL>=<VALUE>` argument to CMake

# only activate tools for top level project
if (NOT PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  return()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

# enables sanitizers support using the the `USE_SANITIZER` flag
# available values are: Address, Memory, MemoryWithOrigins, Undefined, Thread, Leak, 'Address;Undefined'
if (USE_SANITIZER)
  CPMAddPackage(
    NAME StableCoder-cmake-scripts
    GITHUB_REPOSITORY StableCoder/cmake-scripts
    GIT_TAG 3a469d8251660a97dbf9e0afff0a242965d40277
  )
  
  include(${StableCoder-cmake-scripts_SOURCE_DIR}/sanitizers.cmake)
endif()

# enables CCACHE support through the USE_CCACHE flag
# possible values are: YES, NO or equivalent
if (USE_CCACHE)
  CPMAddPackage(
    NAME Ccache.cmake
    GITHUB_REPOSITORY TheLartians/Ccache.cmake
    VERSION 1.1
  )
endif()
