
## glew

find_package(GLEW REQUIRED)
#status("GLEW_INCLUDE_DIRS: ${GLEW_INCLUDE_DIRS}")
#status("GLEW_LIBRARIES: ${GLEW_LIBRARIES}")

include_directories(
  ${GLEW_INCLUDE_DIRS}
)

## nuklear

set(NUKLEAR_ROOT "${CPPCISAMPLE_ROOT}/third_party/nuklear")
#include_directories(${NUKLEAR_ROOT})

## nuklear_demo

add_executable(nuklear_demo
  ${NUKLEAR_ROOT}/demo/glfw_opengl3/main.c
)

target_include_directories(nuklear_demo PUBLIC
  "$<BUILD_INTERFACE:${CPPCISAMPLE_ROOT}/src>"
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>"
  "$<BUILD_INTERFACE:${NUKLEAR_ROOT}/demo/glfw_opengl3>"
)

#target_link_libraries(nuklear_demo OpenGL::GL GLEW::GLEW)

if(HOST_OS STREQUAL "Win")
  target_link_libraries(nuklear_demo
    -lglfw3 -lopengl32 -lm -lGLU32 -lGLEW32
  )
else()
  execute_process(COMMAND pkg-config --libs glfw3 OUTPUT_VARIABLE _glfw3_libs OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(HOST_OS STREQUAL "Mac")
    target_link_libraries(nuklear_demo
      ${_glfw3_libs} "-framework OpenGL" "-framework Cocoa" "-framework IOKit" "-framework CoreVideo" -lm -lGLEW -L/usr/local/lib
    )
  else()
    target_link_libraries(nuklear_demo
      ${_glfw3_libs} -lGL -lm -lGLU -lGLEW
    )
  endif()
  unset(_glfw3_libs)
endif()


# install

install(TARGETS nuklear_demo
  ARCHIVE DESTINATION ${CPPCISAMPLE_CMAKE_LIBDIR}
  LIBRARY DESTINATION ${CPPCISAMPLE_CMAKE_LIBDIR}
  RUNTIME DESTINATION ${CPPCISAMPLE_CMAKE_BINDIR}
)
