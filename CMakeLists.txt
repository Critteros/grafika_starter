cmake_minimum_required(VERSION 3.15)

project(LAB_GRAFIKA_1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_BUILD_TYPE "Debug")
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

include("cmake/StandardProjectSettings.cmake")
include("cmake/PreventInSourceBuilds.cmake")
include("cmake/CompilerWarnings.cmake")
include("cmake/Sanitizers.cmake")
include("cmake/SFML.cmake")

Download_SFML()

#Grouping manually enabled options
add_library(additional_options INTERFACE)
target_compile_features(additional_options INTERFACE cxx_std_17)
enable_sanitizers(additional_options)

option(BUILD_SHARED_LIBS "Enable compilation of shared libraries" OFF)

option(ENABLE_PCH "Enable Precompiled Headers" ON)
if(ENABLE_PCH)
  # This sets a global PCH parameter, each project will build its own PCH, which is a good idea if any #define's change
  #
  # consider breaking this out per project as necessary
  target_precompile_headers(
    additional_options
    INTERFACE
    <vector>
    <string>
    <map>
    <utility>
    <algorithm>
    <SFML/Graphics.hpp>
    <SFML/Window.hpp>
    <SFML/System.hpp>)
endif()


file(GLOB sources "src/*.cpp")
file(GLOB includes "include/*.h")

add_executable(${PROJECT_NAME} ${sources} ${includes})
include_directories("include")
target_link_libraries(${PROJECT_NAME} PRIVATE additional_options)
LinkSFML(${PROJECT_NAME})

set_property(TARGET ${PROJECT_NAME} PROPERTY 
  VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME})
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${PROJECT_SOURCE_DIR}/fonts"
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/fonts)
