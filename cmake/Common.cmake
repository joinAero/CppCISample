# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.
include(${CMAKE_CURRENT_LIST_DIR}/IncludeGuard.cmake)
cmake_include_guard()

include(CMakeParseArguments)

if(MSVC OR MSYS OR MINGW)
  set(HOST_OS Win)
elseif(APPLE)
  set(HOST_OS Mac)
elseif(UNIX)
  set(HOST_OS Linux)
else()
  message(FATAL_ERROR "Unsupported OS.")
endif()

set(HOST_NAME "${HOST_OS}")
if(HOST_OS STREQUAL "Linux")
  execute_process(COMMAND uname -a OUTPUT_VARIABLE UNAME_A OUTPUT_STRIP_TRAILING_WHITESPACE)
  string(TOLOWER "${UNAME_A}" UNAME_A)
  if(${UNAME_A} MATCHES ".*(tegra|jetsonbot).*")
    set(HOST_NAME Tegra)
  elseif(${UNAME_A} MATCHES ".*ubuntu.*")
    set(HOST_NAME Ubuntu)
  endif()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/TargetArch.cmake)
target_architecture(HOST_ARCH)

# status(TEXT [IF cond text [ELIF cond text] [ELSE cond text]])
macro(status TEXT)
  set(options)
  set(oneValueArgs)
  set(multiValueArgs IF ELIF ELSE)
  cmake_parse_arguments(THIS "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})

  #message(STATUS "TEXT: ${TEXT}")
  #message(STATUS "THIS_IF: ${THIS_IF}")
  #message(STATUS "THIS_ELIF: ${THIS_ELIF}")
  #message(STATUS "THIS_ELSE: ${THIS_ELSE}")

  set(__msg_list "")
  set(__continue TRUE)

  if(__continue AND DEFINED THIS_IF)
    #message(STATUS "-- THIS_IF: ${THIS_IF}")
    list(LENGTH THIS_IF __if_len)
    if(${__if_len} GREATER 1)
      list(GET THIS_IF 0 __if_cond)
      if(${__if_cond})
        list(REMOVE_AT THIS_IF 0)
        list(APPEND __msg_list ${THIS_IF})
        set(__continue FALSE)
      endif()
    else()
      message(FATAL_ERROR "status() IF must have cond and text, >= 2 items")
    endif()
  endif()

  if(__continue AND DEFINED THIS_ELIF)
    #message(STATUS "-- THIS_ELIF: ${THIS_ELIF}")
    list(LENGTH THIS_ELIF __elif_len)
    if(${__elif_len} GREATER 1)
      list(GET THIS_ELIF 0 __elif_cond)
      if(${__elif_cond})
        list(REMOVE_AT THIS_ELIF 0)
        list(APPEND __msg_list ${THIS_ELIF})
        set(__continue FALSE)
      endif()
    else()
      message(FATAL_ERROR "status() ELIF must have cond and text, >= 2 items")
    endif()
  endif()

  if(__continue AND DEFINED THIS_ELSE)
    #message(STATUS "-- THIS_ELSE: ${THIS_ELSE}")
    list(LENGTH THIS_ELSE __else_len)
    if(${__else_len} GREATER 0)
      list(APPEND __msg_list ${THIS_ELSE})
    else()
      message(FATAL_ERROR "status() ELSE must have text, >= 1 items")
    endif()
  endif()

  string(REPLACE ";" "" __msg_list "${__msg_list}")
  message(STATUS "${TEXT}${__msg_list}")
endmacro()

# set_outdir(ARCHIVE outdir LIBRARY outdir RUNTIME outdir)
macro(set_outdir)
  set(options KEEP_CONFIG)
  set(oneValueArgs ARCHIVE LIBRARY RUNTIME)
  set(multiValueArgs)
  cmake_parse_arguments(THIS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(THIS_ARCHIVE)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${THIS_ARCHIVE})
  endif()
  if(THIS_LIBRARY)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${THIS_LIBRARY})
  endif()
  if(THIS_RUNTIME)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${THIS_RUNTIME})
  endif()

  if(NOT THIS_KEEP_CONFIG)
    foreach(CONFIG ${CMAKE_CONFIGURATION_TYPES})
      string(TOUPPER ${CONFIG} CONFIG)
      set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONFIG} ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})
      set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONFIG} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONFIG} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
    endforeach()
  endif()
endmacro()
