cmake_minimum_required(VERSION 3.15)

# Correctif de rétrocompatibilité CMake 3.30+ pour Firebase C++ SDK
set(CMAKE_POLICY_VERSION_MINIMUM 3.5 CACHE STRING "" FORCE)

project(omnix LANGUAGES CXX)

# Set the Flutter build directory.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Include the Flutter toolchain settings.
include("${FLUTTER_MANAGED_DIR}/ephemeral/generated_config.cmake")

# Configure the plugin system.
include("${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")

# Application build settings.
add_subdirectory("runner")
