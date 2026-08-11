cmake_minimum_required(VERSION 3.14)

# FIX POUR AUDIOPLAYERS
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

# DÉFINITION DU NOM (Indispensable pour generated_plugins.cmake)
set(BINARY_NAME "wizzy")

# On charge les réglages Flutter
include(flutter/generated_plugins.cmake)

# On appelle le dossier qui crée l'exécutable
add_subdirectory(runner)
