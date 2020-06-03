# this file contains a list of tools that can be activated and downloaded on-demand
# each tool is enabled during configuration by passing an additional `-DUSE_<TOOL>=<VALUE>` argument to CMake

# only activate tools for top level project
if (NOT PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  return()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

# enables sanitizers support using the the `USE_SANITIZER` flag
# available values are: Address, Memory, MemoryWithOrigins, Undefined, Thread, Leak, 'Address;Undefined'
if (USE_SANITIZER OR USE_STATIC_ANALYZER)
  CPMAddPackage(
    NAME StableCoder-cmake-scripts
    GITHUB_REPOSITORY StableCoder/cmake-scripts
    GIT_TAG 3d2d5a9fb26f0ce24e3e4eaeeff686ec2ecfb3fb
  )
  
  if (USE_SANITIZER)
    include(${StableCoder-cmake-scripts_SOURCE_DIR}/sanitizers.cmake)
  endif()

  if (USE_STATIC_ANALYZER)
    if ("clang-tidy" IN_LIST USE_STATIC_ANALYZER)
      SET(CLANG_TIDY ON CACHE INTERNAL "")
    else()
      SET(CLANG_TIDY OFF CACHE INTERNAL "")
    endif()
    if ("iwyu" IN_LIST USE_STATIC_ANALYZER)
      SET(IWYU ON CACHE INTERNAL "")
    else()
      SET(IWYU OFF CACHE INTERNAL "")
    endif()
    if ("cppcheck" IN_LIST USE_STATIC_ANALYZER)
      SET(CPPCHECK ON CACHE INTERNAL "")
    else()
      SET(CPPCHECK OFF CACHE INTERNAL "")
    endif()

    include(${StableCoder-cmake-scripts_SOURCE_DIR}/tools.cmake)

    clang_tidy(${CLANG_TIDY_ARGS})
    include_what_you_use(${IWYU_ARGS})
    cppcheck(${CPPCHECK_ARGS})
  endif()
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
