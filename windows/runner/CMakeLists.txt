cmake_minimum_required(VERSION 3.15)

project(runner LANGUAGES CXX)

set(BINARY_NAME "omnix")

add_executable(${BINARY_NAME} WIN32
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "flutter_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "runner.rc"
)

apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")

add_dependencies(${BINARY_NAME} flutter_assemble)
if(DEFINED PLUGIN_BUNDLED_LIBRARIES)
  target_link_libraries(${BINARY_NAME} PRIVATE ${PLUGIN_BUNDLED_LIBRARIES})
endif()
