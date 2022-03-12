include(FetchContent)
function(Download_SFML)
  option(SFML_LINK_STATIC "Use static linking with SFML" FALSE)
  option(SFML_BUILD_AUDIO "Build SFML audio module" FALSE)
  option(SFML_BUILD_NETWORK "Build SFML network module" FALSE)

  set(FETCHCONTENT_QUIET FALSE)

  FetchContent_Declare(
    SFML
    URL "https://github.com/SFML/SFML/archive/2.5.1.zip"
  )
  FetchContent_GetProperties(SFML)

  if(NOT SFML_POPULATED)
    if (LINK_DEPS_STATIC)
      set(SFML_STATIC_LIBRARIES FALSE CACHE BOOL "Use static libraries")
    endif()

    set(SFML_INSTALL_PKGCONFIG_FILES OFF CACHE BOOL "Install pkgconfig files")

    if (USE_SYSTEM_DEPS)
      find_package(SFML ${SFML_VERSION} COMPONENTS graphics QUIET)
    else()
      FetchContent_Populate(SFML)

      # No need to build audio and network modules
      set(SFML_BUILD_AUDIO FALSE CACHE BOOL "Build audio")
      set(SFML_BUILD_NETWORK FALSE CACHE BOOL "Build network")
      add_subdirectory(${sfml_SOURCE_DIR} ${sfml_BINARY_DIR} EXCLUDE_FROM_ALL)
    endif()
  endif()
endfunction(Download_SFML)

function(LinkSFML project_name)
  target_link_libraries(${project_name}
  PRIVATE
      sfml-graphics
      sfml-system
      sfml-window
  )

  if(SFML_BUILD_AUDIO)
    target_link_libraries(${project_name} sfml-audio)
  endif()

  if(SFML_BUILD_NETWORK)
    target_link_libraries(${project_name} sfml‑network)
  endif()
  
endfunction(LinkSFML project_name)








