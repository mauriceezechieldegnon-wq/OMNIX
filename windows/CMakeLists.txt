cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE GLOBAL
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 2. CHARGER LES OUTILS FLUTTER D'ABORD ✅
include(flutter/generated_plugins.cmake)

# 3. APPELER LE DOSSIER RUNNER ✅
# C'est ici que 'flutter_assemble' est créé par Flutter
add_subdirectory(runner)
