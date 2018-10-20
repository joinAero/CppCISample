
## imgui

set(IMGUI_ROOT "${CPPCISAMPLE_ROOT}/third_party/imgui")

file(GLOB IMGUI_SRCS "${CPPCISAMPLE_ROOT}/third_party/imgui/*.cpp")
#${IMGUI_ROOT}/imgui.cpp
#${IMGUI_ROOT}/imgui_demo.cpp
#${IMGUI_ROOT}/imgui_draw.cpp
#${IMGUI_ROOT}/imgui_widgets.cpp

add_library(imgui STATIC ${IMGUI_SRCS})

target_include_directories(imgui PUBLIC
  "$<BUILD_INTERFACE:${IMGUI_ROOT}>"
)

## imgui_demo

add_executable(imgui_demo
  ${IMGUI_ROOT}/examples/imgui_impl_glfw.cpp
  ${IMGUI_ROOT}/examples/imgui_impl_opengl3.cpp
  ${IMGUI_ROOT}/examples/libs/gl3w/GL/gl3w.c
  ${IMGUI_ROOT}/examples/example_glfw_opengl3/main.cpp
)

target_include_directories(imgui_demo PUBLIC
  "$<BUILD_INTERFACE:${CPPCISAMPLE_ROOT}/src>"
  "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>"
  "$<BUILD_INTERFACE:${IMGUI_ROOT}/examples>"
  "$<BUILD_INTERFACE:${IMGUI_ROOT}/examples/libs/gl3w>"
)

target_link_libraries(imgui_demo imgui)

if(HOST_OS STREQUAL "Linux")
  execute_process(COMMAND pkg-config --cflags glfw3 OUTPUT_VARIABLE _glfw3_cflags OUTPUT_STRIP_TRAILING_WHITESPACE)
  target_compile_options(imgui_demo PUBLIC ${_glfw3_cflags})

  execute_process(COMMAND pkg-config --static --libs glfw3 OUTPUT_VARIABLE _glfw3_libs OUTPUT_STRIP_TRAILING_WHITESPACE)
  target_link_libraries(imgui_demo -lGL ${_glfw3_libs})

  unset(_glfw3_cflags)
  unset(_glfw3_libs)
endif()

if(HOST_OS STREQUAL "Mac")
  target_include_directories(imgui_demo PUBLIC
    "$<BUILD_INTERFACE:/usr/local/include>"
  )

  execute_process(COMMAND pkg-config --libs glfw3 OUTPUT_VARIABLE _glfw3_libs OUTPUT_STRIP_TRAILING_WHITESPACE)
  target_link_libraries(imgui_demo
    ${_glfw3_libs} "-framework OpenGL" "-framework Cocoa" "-framework IOKit" "-framework CoreVideo" -L/usr/local/lib
  )
  unset(_glfw3_libs)
endif()

if(MINGW)  # MSYS2/MINGW
  execute_process(COMMAND pkg-config --cflags glfw3 OUTPUT_VARIABLE _glfw3_cflags OUTPUT_STRIP_TRAILING_WHITESPACE)
  target_compile_options(imgui_demo PUBLIC ${_glfw3_cflags})

  target_link_libraries(imgui_demo
    -lglfw3 -lgdi32 -lopengl32 -limm32
  )

  unset(_glfw3_cflags)
endif()


# install

install(TARGETS imgui_demo
  ARCHIVE DESTINATION ${CPPCISAMPLE_CMAKE_LIBDIR}
  LIBRARY DESTINATION ${CPPCISAMPLE_CMAKE_LIBDIR}
  RUNTIME DESTINATION ${CPPCISAMPLE_CMAKE_BINDIR}
)
