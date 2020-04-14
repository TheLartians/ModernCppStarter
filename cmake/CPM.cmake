# TheLartians/CPM - A simple Git dependency manager
# =================================================
# See https://github.com/TheLartians/CPM for usage and update instructions.
#
# MIT License
# ----------- 
#[[
  Copyright (c) 2019 Lars Melchior

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
]]

cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(CURRENT_CPM_VERSION 0.18)

if(CPM_DIRECTORY)
  if(NOT ${CPM_DIRECTORY} MATCHES ${CMAKE_CURRENT_LIST_DIR})
    if (${CPM_VERSION} VERSION_LESS ${CURRENT_CPM_VERSION})
      message(AUTHOR_WARNING "${CPM_INDENT} \
A dependency is using a more recent CPM version (${CURRENT_CPM_VERSION}) than the current project (${CPM_VERSION}). \
It is recommended to upgrade CPM to the most recent version. \
See https://github.com/TheLartians/CPM.cmake for more information."
      )
    endif()
    return()
  endif()
endif()

option(CPM_USE_LOCAL_PACKAGES "Always try to use `find_package` to get dependencies" $ENV{CPM_USE_LOCAL_PACKAGES})
option(CPM_LOCAL_PACKAGES_ONLY "Only use `find_package` to get dependencies" $ENV{CPM_LOCAL_PACKAGES_ONLY})
option(CPM_DOWNLOAD_ALL "Always download dependencies from source" $ENV{CPM_DOWNLOAD_ALL})

set(CPM_VERSION ${CURRENT_CPM_VERSION} CACHE INTERNAL "")
set(CPM_DIRECTORY ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "")
set(CPM_PACKAGES "" CACHE INTERNAL "")
set(CPM_DRY_RUN OFF CACHE INTERNAL "Don't download or configure dependencies (for testing)")

if(DEFINED ENV{CPM_SOURCE_CACHE})
  set(CPM_SOURCE_CACHE_DEFAULT $ENV{CPM_SOURCE_CACHE})
else()
  set(CPM_SOURCE_CACHE_DEFAULT OFF)
endif()

set(CPM_SOURCE_CACHE ${CPM_SOURCE_CACHE_DEFAULT} CACHE PATH "Directory to downlaod CPM dependencies")

include(FetchContent)
include(CMakeParseArguments)

# Initialize logging prefix
if(NOT CPM_INDENT)
  set(CPM_INDENT "CPM:")
endif()

function(cpm_find_package NAME VERSION)
  string(REPLACE " " ";" EXTRA_ARGS "${ARGN}")
  find_package(${NAME} ${VERSION} ${EXTRA_ARGS} QUIET)
  if(${CPM_ARGS_NAME}_FOUND)
    message(STATUS "${CPM_INDENT} using local package ${CPM_ARGS_NAME}@${${CPM_ARGS_NAME}_VERSION}")
    CPMRegisterPackage(${CPM_ARGS_NAME} "${${CPM_ARGS_NAME}_VERSION}")
    set(CPM_PACKAGE_FOUND YES PARENT_SCOPE)
  else()
    set(CPM_PACKAGE_FOUND NO PARENT_SCOPE)
  endif()
endfunction()

# Find a package locally or fallback to CPMAddPackage
function(CPMFindPackage)
  set(oneValueArgs
    NAME
    VERSION
    FIND_PACKAGE_ARGUMENTS
  )

  cmake_parse_arguments(CPM_ARGS "" "${oneValueArgs}" "" ${ARGN})
  
  if (CPM_DOWNLOAD_ALL)
    CPMAddPackage(${ARGN})
    cpm_export_variables()
    return()
  endif()

  cpm_find_package(${CPM_ARGS_NAME} "${CPM_ARGS_VERSION}" ${CPM_ARGS_FIND_PACKAGE_ARGUMENTS})

  if(NOT CPM_PACKAGE_FOUND)
    CPMAddPackage(${ARGN})
    cpm_export_variables()
  endif()

endfunction()

# Download and add a package from source
function(CPMAddPackage)

  set(oneValueArgs
    NAME
    VERSION
    GIT_TAG
    DOWNLOAD_ONLY
    GITHUB_REPOSITORY
    GITLAB_REPOSITORY
    SOURCE_DIR
    DOWNLOAD_COMMAND
    FIND_PACKAGE_ARGUMENTS
  )

  set(multiValueArgs
    OPTIONS
  )

  cmake_parse_arguments(CPM_ARGS "" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}")

  if(CPM_USE_LOCAL_PACKAGES OR CPM_LOCAL_PACKAGES_ONLY)
    cpm_find_package(${CPM_ARGS_NAME} "${CPM_ARGS_VERSION}" ${CPM_ARGS_FIND_PACKAGE_ARGUMENTS})

    if(CPM_PACKAGE_FOUND)
      return()
    endif()

    if(CPM_LOCAL_PACKAGES_ONLY) 
      message(SEND_ERROR "CPM: ${CPM_ARGS_NAME} not found via find_package(${CPM_ARGS_NAME} ${CPM_ARGS_VERSION})")
    endif()
  endif()

  if (NOT DEFINED CPM_ARGS_VERSION)
    if (DEFINED CPM_ARGS_GIT_TAG) 
      cpm_get_version_from_git_tag("${CPM_ARGS_GIT_TAG}" CPM_ARGS_VERSION)
    endif()
    if (NOT DEFINED CPM_ARGS_VERSION) 
      set(CPM_ARGS_VERSION 0)
    endif()
  endif()

  if (NOT DEFINED CPM_ARGS_GIT_TAG)
    set(CPM_ARGS_GIT_TAG v${CPM_ARGS_VERSION})
  endif()

  list(APPEND CPM_ARGS_UNPARSED_ARGUMENTS GIT_TAG ${CPM_ARGS_GIT_TAG})

  if(CPM_ARGS_DOWNLOAD_ONLY)
    set(DOWNLOAD_ONLY ${CPM_ARGS_DOWNLOAD_ONLY})
  else()
    set(DOWNLOAD_ONLY NO)
  endif()

  if (CPM_ARGS_GITHUB_REPOSITORY)
    list(APPEND CPM_ARGS_UNPARSED_ARGUMENTS GIT_REPOSITORY "https://github.com/${CPM_ARGS_GITHUB_REPOSITORY}.git")
  endif()

  if (CPM_ARGS_GITLAB_REPOSITORY)
    list(APPEND CPM_ARGS_UNPARSED_ARGUMENTS GIT_REPOSITORY "https://gitlab.com/${CPM_ARGS_GITLAB_REPOSITORY}.git")
  endif()

  if (${CPM_ARGS_NAME} IN_LIST CPM_PACKAGES)
    CPMGetPackageVersion(${CPM_ARGS_NAME} CPM_PACKAGE_VERSION)
    if(${CPM_PACKAGE_VERSION} VERSION_LESS ${CPM_ARGS_VERSION})
      message(WARNING "${CPM_INDENT} requires a newer version of ${CPM_ARGS_NAME} (${CPM_ARGS_VERSION}) than currently included (${CPM_PACKAGE_VERSION}).")
    endif()
    if (CPM_ARGS_OPTIONS)
      foreach(OPTION ${CPM_ARGS_OPTIONS})
        cpm_parse_option(${OPTION})
        if(NOT "${${OPTION_KEY}}" STREQUAL ${OPTION_VALUE})
          message(WARNING "${CPM_INDENT} ignoring package option for ${CPM_ARGS_NAME}: ${OPTION_KEY} = ${OPTION_VALUE} (${${OPTION_KEY}})")
        endif()
      endforeach()
    endif()
    cpm_fetch_package(${CPM_ARGS_NAME} ${DOWNLOAD_ONLY})
    cpm_get_fetch_properties(${CPM_ARGS_NAME})
    SET(${CPM_ARGS_NAME}_SOURCE_DIR "${${CPM_ARGS_NAME}_SOURCE_DIR}")
    SET(${CPM_ARGS_NAME}_BINARY_DIR "${${CPM_ARGS_NAME}_BINARY_DIR}")  
    SET(${CPM_ARGS_NAME}_ADDED NO)
    cpm_export_variables()
    return()
  endif()

  CPMRegisterPackage(${CPM_ARGS_NAME} ${CPM_ARGS_VERSION})

  if (CPM_ARGS_OPTIONS)
    foreach(OPTION ${CPM_ARGS_OPTIONS})
      cpm_parse_option(${OPTION})
      set(${OPTION_KEY} ${OPTION_VALUE} CACHE INTERNAL "")
    endforeach()
  endif()

  set(FETCH_CONTENT_DECLARE_EXTRA_OPTS "")

  if (DEFINED CPM_ARGS_GIT_TAG)
    set(PACKAGE_INFO "${CPM_ARGS_GIT_TAG}")
  else()
    set(PACKAGE_INFO "${CPM_ARGS_VERSION}")
  endif()

  if (DEFINED CPM_ARGS_DOWNLOAD_COMMAND)
    set(FETCH_CONTENT_DECLARE_EXTRA_OPTS DOWNLOAD_COMMAND ${CPM_ARGS_DOWNLOAD_COMMAND})
  elseif(DEFINED CPM_ARGS_SOURCE_DIR)
    set(FETCH_CONTENT_DECLARE_EXTRA_OPTS SOURCE_DIR ${CPM_ARGS_SOURCE_DIR})
  elseif (CPM_SOURCE_CACHE)
    string(TOLOWER ${CPM_ARGS_NAME} lower_case_name)
    set(origin_parameters ${CPM_ARGS_UNPARSED_ARGUMENTS})
    list(SORT origin_parameters)
    string(SHA1 origin_hash "${origin_parameters}")
    set(download_directory ${CPM_SOURCE_CACHE}/${lower_case_name}/${origin_hash})
    list(APPEND FETCH_CONTENT_DECLARE_EXTRA_OPTS SOURCE_DIR ${download_directory})
    if (EXISTS ${download_directory})
      list(APPEND FETCH_CONTENT_DECLARE_EXTRA_OPTS DOWNLOAD_COMMAND ":")
      set(PACKAGE_INFO "${download_directory}")
    else()
      # remove timestamps so CMake will re-download the dependency
      file(REMOVE_RECURSE ${CMAKE_BINARY_DIR}/_deps/${lower_case_name}-subbuild)
      set(PACKAGE_INFO "${PACKAGE_INFO} -> ${download_directory}")
    endif()
  endif()

  cpm_declare_fetch(${CPM_ARGS_NAME} ${CPM_ARGS_VERSION} ${PACKAGE_INFO} "${CPM_ARGS_UNPARSED_ARGUMENTS}" ${FETCH_CONTENT_DECLARE_EXTRA_OPTS})
  cpm_fetch_package(${CPM_ARGS_NAME} ${DOWNLOAD_ONLY})
  cpm_get_fetch_properties(${CPM_ARGS_NAME})
  SET(${CPM_ARGS_NAME}_ADDED YES)
  cpm_export_variables()
endfunction()

# export variables available to the caller to the parent scope
# expects ${CPM_ARGS_NAME} to be set
macro(cpm_export_variables)
  SET(${CPM_ARGS_NAME}_SOURCE_DIR "${${CPM_ARGS_NAME}_SOURCE_DIR}" PARENT_SCOPE)
  SET(${CPM_ARGS_NAME}_BINARY_DIR "${${CPM_ARGS_NAME}_BINARY_DIR}" PARENT_SCOPE)
  SET(${CPM_ARGS_NAME}_ADDED "${${CPM_ARGS_NAME}_ADDED}" PARENT_SCOPE)
endmacro()

# declares that a package has been added to CPM
function(CPMRegisterPackage PACKAGE VERSION)
  list(APPEND CPM_PACKAGES ${PACKAGE})
  set(CPM_PACKAGES ${CPM_PACKAGES} CACHE INTERNAL "")
  set("CPM_PACKAGE_${PACKAGE}_VERSION" ${VERSION} CACHE INTERNAL "")
endfunction()

# retrieve the current version of the package to ${OUTPUT}
function(CPMGetPackageVersion PACKAGE OUTPUT)
  set(${OUTPUT} "${CPM_PACKAGE_${PACKAGE}_VERSION}" PARENT_SCOPE)
endfunction()

# declares a package in FetchContent_Declare 
function (cpm_declare_fetch PACKAGE VERSION INFO)
  message(STATUS "${CPM_INDENT} adding package ${PACKAGE}@${VERSION} (${INFO})")

  if (${CPM_DRY_RUN}) 
    message(STATUS "${CPM_INDENT} package not declared (dry run)")
    return()
  endif()

  FetchContent_Declare(
    ${PACKAGE}
    ${ARGN}
  )
endfunction()

# returns properties for a package previously defined by cpm_declare_fetch
function (cpm_get_fetch_properties PACKAGE)
  if (${CPM_DRY_RUN}) 
    return()
  endif()
  FetchContent_GetProperties(${PACKAGE})
  string(TOLOWER ${PACKAGE} lpackage)
  SET(${PACKAGE}_SOURCE_DIR "${${lpackage}_SOURCE_DIR}" PARENT_SCOPE)
  SET(${PACKAGE}_BINARY_DIR "${${lpackage}_BINARY_DIR}" PARENT_SCOPE)
endfunction()

# downloads a previously declared package via FetchContent
function (cpm_fetch_package PACKAGE DOWNLOAD_ONLY)  

  if (${CPM_DRY_RUN}) 
    message(STATUS "${CPM_INDENT} package ${PACKAGE} not fetched (dry run)")
    return()
  endif()

  set(CPM_OLD_INDENT "${CPM_INDENT}")
  set(CPM_INDENT "${CPM_INDENT} ${PACKAGE}:")
  if(${DOWNLOAD_ONLY})
    if(NOT "${PACKAGE}_POPULATED")
      FetchContent_Populate(${PACKAGE})
    endif()
  else()
    FetchContent_MakeAvailable(${PACKAGE})
  endif()
  set(CPM_INDENT "${CPM_OLD_INDENT}")
endfunction()

# splits a package option
function(cpm_parse_option OPTION)
  string(REGEX MATCH "^[^ ]+" OPTION_KEY ${OPTION})
  string(LENGTH ${OPTION} OPTION_LENGTH)
  string(LENGTH ${OPTION_KEY} OPTION_KEY_LENGTH)
  if (OPTION_KEY_LENGTH STREQUAL OPTION_LENGTH)
    # no value for key provided, assume user wants to set option to "ON"
    set(OPTION_VALUE "ON")
  else()
    math(EXPR OPTION_KEY_LENGTH "${OPTION_KEY_LENGTH}+1")
    string(SUBSTRING ${OPTION} "${OPTION_KEY_LENGTH}" "-1" OPTION_VALUE)
  endif()
  set(OPTION_KEY "${OPTION_KEY}" PARENT_SCOPE)
  set(OPTION_VALUE "${OPTION_VALUE}" PARENT_SCOPE)
endfunction()

# guesses the package version from a git tag
function(cpm_get_version_from_git_tag GIT_TAG RESULT)
  string(LENGTH ${GIT_TAG} length)
  if (length EQUAL 40) 
    # GIT_TAG is probably a git hash
    SET(${RESULT} 0 PARENT_SCOPE)
  else()
    string(REGEX MATCH "v?([0123456789.]*).*" _ ${GIT_TAG})
    SET(${RESULT} ${CMAKE_MATCH_1} PARENT_SCOPE)
  endif()
endfunction()
