# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.
cmake_minimum_required(VERSION 3.0)

project(cppcisample VERSION 1.0.0 LANGUAGES C CXX)

include(cmake/Common.cmake)

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

if(MSVC OR MSYS OR MINGW)  # Win
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
else()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c++11")
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

set_outdir(
  ARCHIVE "${CPPCISAMPLE_OUTPUT}/lib"
  LIBRARY "${CPPCISAMPLE_OUTPUT}/lib"
  RUNTIME "${CPPCISAMPLE_OUTPUT}/bin"
)

include_directories(
  ${CPPCISAMPLE_ROOT}/include
)

## imgui

set(IMGUI_ROOT "${CPPCISAMPLE_ROOT}/third_party/imgui")

file(GLOB IMGUI_SRCS "third_party/imgui/*.cpp")

add_library(imgui STATIC ${IMGUI_SRCS})

target_include_directories(imgui PUBLIC
  "$<BUILD_INTERFACE:${IMGUI_ROOT}>"
)

## cppcisample

add_executable(cppcisample
  src/cppcisample/main.cpp
)

target_include_directories(imgui PUBLIC
  "$<BUILD_INTERFACE:${CPPCISAMPLE_ROOT}/src>"
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>"
)

target_link_libraries(cppcisample imgui)

# summary

status("")
status("Platform:")
status("  HOST_OS: ${HOST_OS}")
status("  HOST_NAME: ${HOST_NAME}")
status("  HOST_ARCH: ${HOST_ARCH}")
status("  HOST_COMPILER: ${CMAKE_CXX_COMPILER_ID}")
status("    COMPILER_VERSION: ${CMAKE_CXX_COMPILER_VERSION}")
status("")
