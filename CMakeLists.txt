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

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pedantic -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wall")

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

## glfw3

find_package(GLEW REQUIRED)
#status("GLEW_INCLUDE_DIRS: ${GLEW_INCLUDE_DIRS}")
#status("GLEW_LIBRARIES: ${GLEW_LIBRARIES}")

include_directories(
  ${GLEW_INCLUDE_DIRS}
)

## nuklear

set(NUKLEAR_ROOT "${CPPCISAMPLE_ROOT}/third_party/nuklear")
include_directories(
  #${NUKLEAR_ROOT}
  ${NUKLEAR_ROOT}/demo/glfw_opengl3
)

## cppcisample

add_executable(cppcisample
  ${NUKLEAR_ROOT}/demo/glfw_opengl3/main.c
)

target_include_directories(cppcisample PUBLIC
  "$<BUILD_INTERFACE:${CPPCISAMPLE_ROOT}/src>"
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>"
)

#target_link_libraries(cppcisample OpenGL::GL GLEW::GLEW)

if(HOST_OS STREQUAL "Win")
  target_link_libraries(cppcisample
    -lglfw3 -lopengl32 -lm -lGLU32 -lGLEW32
  )
else()
  execute_process(COMMAND pkg-config --libs glfw3 COMMAND tr -d '\n' OUTPUT_VARIABLE GLFW3)
  #status("GLFW3: ${GLFW3}")
  if(HOST_OS STREQUAL "Mac")
    target_link_libraries(cppcisample
      ${GLFW3} "-framework OpenGL" "-framework Cocoa" "-framework IOKit" "-framework CoreVideo" -lm -lGLEW -L/usr/local/lib
    )
  else()
    target_link_libraries(cppcisample
      ${GLFW3} -lGL -lm -lGLU -lGLEW
    )
  endif()
endif()

# install

set(CPPCISAMPLE_CMAKE_INCLUDE_DIR "${CMAKE_INSTALL_PREFIX}/include/${CPPCISAMPLE_NAME}")
set(CPPCISAMPLE_CMAKE_BINDIR "${CMAKE_INSTALL_PREFIX}/bin")
set(CPPCISAMPLE_CMAKE_LIBDIR "${CMAKE_INSTALL_PREFIX}/lib")
set(CPPCISAMPLE_CMAKE_INSTALLDIR "${CPPCISAMPLE_CMAKE_LIBDIR}/cmake/${CPPCISAMPLE_NAME}")

install(TARGETS cppcisample
  #EXPORT cppcisample-targets
  #PUBLIC_HEADER DESTINATION ${CPPCISAMPLE_CMAKE_INCLUDE_DIR}
  ARCHIVE DESTINATION ${CPPCISAMPLE_CMAKE_LIBDIR}
  LIBRARY DESTINATION ${CPPCISAMPLE_CMAKE_LIBDIR}
  RUNTIME DESTINATION ${CPPCISAMPLE_CMAKE_BINDIR}
)

# summary

status("")
status("Platform:")
status("  HOST_OS: ${HOST_OS}")
status("  HOST_NAME: ${HOST_NAME}")
status("  HOST_ARCH: ${HOST_ARCH}")
status("  HOST_COMPILER: ${CMAKE_CXX_COMPILER_ID}")
status("    COMPILER_VERSION: ${CMAKE_CXX_COMPILER_VERSION}")
status("")
