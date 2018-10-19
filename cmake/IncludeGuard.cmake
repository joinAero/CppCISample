# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.

# include_guard: https://cmake.org/cmake/help/latest/command/include_guard.html

macro(cmake_include_guard)
  get_property(INCLUDE_GUARD GLOBAL PROPERTY "_INCLUDE_GUARD_${CMAKE_CURRENT_LIST_FILE}")
  if(INCLUDE_GUARD)
    return()
  endif()
  set_property(GLOBAL PROPERTY "_INCLUDE_GUARD_${CMAKE_CURRENT_LIST_FILE}" TRUE)
endmacro()
