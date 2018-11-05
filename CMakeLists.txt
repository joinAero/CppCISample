# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.
cmake_minimum_required(VERSION 3.0)

project(cppcisample VERSION 1.0.0 LANGUAGES C CXX)

include(cmake/Common.cmake)

if(NOT CMAKE_DEBUG_POSTFIX)
  set(CMAKE_DEBUG_POSTFIX d)
endif()

# config

set(CPPCISAMPLE_NAME "${PROJECT_NAME}")
set(CPPCISAMPLE_ROOT "${PROJECT_SOURCE_DIR}")
set(CPPCISAMPLE_OUTPUT "${CPPCISAMPLE_ROOT}/_output")

if(NOT CPPCISAMPLE_NAMESPACE)
  set(CPPCISAMPLE_NAMESPACE "${CPPCISAMPLE_NAME}")
endif()

configure_file(
  src/cppcisample/stubs/global_config.h.in
  src/cppcisample/stubs/global_config.h @ONLY
)

#add_definitions(-DCPPCISAMPLE_EXPORTS)

# flags

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pedantic -Wall -Wformat")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wall -Wformat")

if(NOT HOST_OS STREQUAL "Win")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wextra")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wextra")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=native")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")

string(STRIP "${CMAKE_C_FLAGS}" CMAKE_C_FLAGS)
string(STRIP "${CMAKE_CXX_FLAGS}" CMAKE_CXX_FLAGS)
status("C_FLAGS: ${CMAKE_C_FLAGS}")
status("CXX_FLAGS: ${CMAKE_CXX_FLAGS}")

# packages

LIST(APPEND CMAKE_MODULE_PATH cmake)

## threads

find_package(Threads QUIET)

macro(target_link_threads NAME)
  if(THREADS_HAVE_PTHREAD_ARG)
    target_compile_options(PUBLIC ${NAME} "-pthread")
  endif()
  if(CMAKE_THREAD_LIBS_INIT)
    target_link_libraries(${NAME} "${CMAKE_THREAD_LIBS_INIT}")
  endif()
endmacro()

# targets

set(CPPCISAMPLE_CMAKE_INCLUDE_DIR "${CMAKE_INSTALL_PREFIX}/include/${CPPCISAMPLE_NAME}")
set(CPPCISAMPLE_CMAKE_BINDIR "${CMAKE_INSTALL_PREFIX}/bin")
set(CPPCISAMPLE_CMAKE_LIBDIR "${CMAKE_INSTALL_PREFIX}/lib")
set(CPPCISAMPLE_CMAKE_INSTALLDIR "${CPPCISAMPLE_CMAKE_LIBDIR}/cmake/${CPPCISAMPLE_NAME}")

set_outdir(
  ARCHIVE "${CPPCISAMPLE_OUTPUT}/lib"
  LIBRARY "${CPPCISAMPLE_OUTPUT}/lib"
  RUNTIME "${CPPCISAMPLE_OUTPUT}/bin"
)

include_directories(
  ${CPPCISAMPLE_ROOT}/include
)

## opengl

#find_package(OpenGL REQUIRED)
#status("OPENGL_INCLUDE_DIR: ${OPENGL_INCLUDE_DIR}")
#status("OPENGL_LIBRARIES: ${OPENGL_LIBRARIES}")

## demos

if(HOST_OS STREQUAL "Win")
  if(MSVC)
    add_subdirectory(src/nukleardemo)
  elseif(MINGW)
    add_subdirectory(src/imguidemo)
  else()
    message(WARNING "There are no demos on this Windows platform.")
  endif()
else()
  add_subdirectory(src/imguidemo)
  add_subdirectory(src/nukleardemo)
endif()

# summary

status("")
status("Platform:")
status("  HOST_OS: ${HOST_OS}")
status("  HOST_NAME: ${HOST_NAME}")
status("  HOST_ARCH: ${HOST_ARCH}")
status("  HOST_COMPILER: ${CMAKE_CXX_COMPILER_ID}")
status("    COMPILER_VERSION: ${CMAKE_CXX_COMPILER_VERSION}")
status("")
