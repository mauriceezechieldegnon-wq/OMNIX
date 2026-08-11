cmake_minimum_required(VERSION 3.14)

# 1. FIX POUR FIREBASE ET COMPILATEURS RÉCENTS
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)

project(wizzy LANGUAGES CXX)

# 2. DÉFINITION DU NOM
set(BINARY_NAME "wizzy")
set(FLUTTER_MANAGED_SOURCES "")

# 3. CRÉATION DE L'EXÉCUTABLE D'ABORD ✅
# On crée la cible "wizzy" pour que les plugins puissent la trouver
add_executable(${BINARY_NAME}
  "runner/main.cpp"
  "runner/utils.cpp"
  "runner/utils.h"
  "runner/win32_window.cpp"
  "runner/win32_window.h"
  "runner/flutter_window.cpp"
  "runner/flutter_window.h"
  "runner/runner.rc"
  "runner/resource.h"
)

# 4. INCLUSION DES PLUGINS ENSUITE ✅
# Maintenant que "wizzy" existe, le script automatique peut s'y lier
include(flutter/generated_plugins.cmake)

# On injecte les sources gérées par Flutter
if (FLUTTER_MANAGED_SOURCES)
  target_sources(${BINARY_NAME} PRIVATE ${FLUTTER_MANAGED_SOURCES})
endif()

# 5. CONFIGURATION ET LIAISONS
# On définit l'antidote au cas où
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()

apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

# Liaison automatique de tous les plugins
foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_dependencies(${BINARY_NAME} ${plugin}_assemble)
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
endforeach()
