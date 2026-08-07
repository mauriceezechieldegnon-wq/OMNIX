cmake_minimum_required(VERSION 3.15)

# Correctif de rétrocompatibilité pour CMake 3.30+ (Firebase C++ SDK Windows)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5 CACHE STRING "" FORCE)

project(omnix LANGUAGES CXX)

macro(apply_standard_settings TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
endmacro()

set(BINARY_NAME "omnix")

include(flutter/generated_plugins.cmake)
add_subdirectory(flutter)

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
