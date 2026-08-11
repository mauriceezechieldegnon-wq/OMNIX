cmake_minimum_required(VERSION 3.14)

# 1. ANTIDOTE GLOBAL
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# 2. INITIALISATION FLUTTER
set(FLUTTER_MANAGED_SOURCES "")

# 3. CRÉATION DE L'EXÉCUTABLE ✅
# On le crée ICI à la racine pour que les plugins le voient
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

# 4. CHARGEMENT DES PLUGINS
# Maintenant que 'wizzy' existe, l'include ne fera plus d'erreur !
include(flutter/generated_plugins.cmake)

# On injecte les sources gérées par Flutter
if (FLUTTER_MANAGED_SOURCES)
  target_sources(${BINARY_NAME} PRIVATE ${FLUTTER_MANAGED_SOURCES})
endif()

# 5. RÉGLAGES ET LIAISONS
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIBRARY})
add_dependencies(${BINARY_NAME} flutter_assemble)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  if(TARGET ${plugin})
    target_link_libraries(${BINARY_NAME} PRIVATE ${plugin})
    if(TARGET ${plugin}_assemble)
      add_dependencies(${BINARY_NAME} ${plugin}_assemble)
    endif()
  endif()
endforeach()
