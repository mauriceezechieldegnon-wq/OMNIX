cmake_minimum_required(VERSION 3.14)

# ANTIDOTE GLOBAL
macro(apply_standard_settings TARGET)
    target_compile_features(${TARGET} PRIVATE cxx_std_17)
endmacro()
add_definitions(-D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

project(wizzy LANGUAGES CXX)
set(BINARY_NAME "wizzy")

# ON N'INCLUT RIEN ICI, ON VA DANS LE RUNNER ✅
add_subdirectory(runner)
