# this file contains a list of tools that can be activated and downloaded on-demand
# each tool is enabled during configuration by passing an additional `-DUSE_<TOOL>=<VALUE>` argument to CMake

# determine if a tool has already been enabled
foreach(TOOL USE_SANITIZER;USE_CCACHE)
  get_property(${TOOL}_ENABLED GLOBAL "" PROPERTY ${TOOL}_ENABLED SET)   
endforeach()

# enables sanitizers support using the the `USE_SANITIZER` flag
# available values are: Address, Memory, MemoryWithOrigins, Undefined, Thread, Leak, 'Address;Undefined'
if (USE_SANITIZER AND NOT USE_SANITIZER_ENABLED)
  set_property(GLOBAL PROPERTY USE_SANITIZER_ENABLED true) 

  CPMAddPackage(
    NAME StableCoder-cmake-scripts
    GITHUB_REPOSITORY StableCoder/cmake-scripts
    GIT_TAG 3a469d8251660a97dbf9e0afff0a242965d40277
  )
  
  include(${StableCoder-cmake-scripts_SOURCE_DIR}/sanitizers.cmake)
endif()

# enables CCACHE support through the USE_CCACHE flag
# possible values are: YES, NO or equivalent
if (USE_CCACHE AND NOT USE_CCACHE_ENABLED)
  set_property(GLOBAL PROPERTY USE_CCACHE_ENABLED true) 

  CPMAddPackage(
    NAME Ccache.cmake
    GITHUB_REPOSITORY TheLartians/Ccache.cmake
    VERSION 1.1
  )
endif()
