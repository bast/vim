# define compile flags
# these could be extended to other vendors
# and also localized to the scope of individual targets
if(CMAKE_C_COMPILER_ID MATCHES GNU)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1")
  set(CMAKE_C_FLAGS_RELEASE "-O2")
  set(CMAKE_C_FLAGS_DEBUG "-O0")
endif()

# generate config.h, pathdef.c, and osdef.h
include(autogenerate.cmake)
generate_config_h()
generate_pathdef_c()
generate_osdef_h()

add_executable(
  vim
  main.c
  )

target_compile_definitions(
  vim
  PRIVATE
    "HAVE_CONFIG_H"
  )

add_library(basic_sources "")

target_sources(
  basic_sources
  PRIVATE
    arabic.c beval.c blowfish.c buffer.c charset.c
    crypt.c crypt_zip.c dict.c diff.c digraph.c
    edit.c eval.c evalfunc.c ex_cmds.c ex_cmds2.c
    ex_docmd.c ex_eval.c ex_getln.c farsi.c fileio.c
    fold.c getchar.c hardcopy.c hashtab.c if_cscope.c
    if_xcmdsrv.c json.c list.c main.c mark.c
    memfile.c memline.c menu.c message.c misc1.c
    misc2.c move.c mbyte.c normal.c ops.c
    option.c os_unix.c auto/pathdef.c popupmnu.c pty.c
    quickfix.c regexp.c screen.c search.c sha256.c
    spell.c spellfile.c syntax.c tag.c term.c
    terminal.c ui.c undo.c userfunc.c version.c
    window.c
  )

target_include_directories(
  basic_sources
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/proto
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
  )

target_compile_definitions(
  basic_sources
  PRIVATE
    "HAVE_CONFIG_H"
  )

target_link_libraries(
  vim
  PUBLIC
    basic_sources
  )

add_library(extra_sources "")

if(ENABLE_NETBEANS)
  target_sources(
    extra_sources
    PRIVATE
      netbeans.c
    )
endif()

if(ENABLE_CHANNEL)
  target_sources(
    extra_sources
    PRIVATE
      channel.c
    )
endif()

target_include_directories(
  extra_sources
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/proto
    ${CMAKE_CURRENT_BINARY_DIR}
  )

target_compile_definitions(
  extra_sources
  PRIVATE
    "HAVE_CONFIG_H"
  )

target_link_libraries(
  vim
  PUBLIC
    extra_sources
  )

if(ENABLE_TERMINAL)
  add_subdirectory(libvterm)

  target_link_libraries(
    vim
    PUBLIC
      libvterm
    )
endif()

# find X11 and link to it
find_package(X11 REQUIRED)
if(X11_FOUND)
  target_link_libraries(
    vim
    PUBLIC
      ${X11_LIBRARIES}
    )
endif()

# a couple of more system libraries that the code requires
foreach(_library IN ITEMS Xt SM m tinfo acl gpm dl)
  find_library(_${_library}_found ${_library} REQUIRED)
  if(_${_library}_found)
    target_link_libraries(
      vim
      PUBLIC
        ${_library}
  )
  endif()
endforeach()

install(
  TARGETS
    vim
  RUNTIME DESTINATION
    ${CMAKE_INSTALL_BINDIR}
  )

add_subdirectory(testdir)
