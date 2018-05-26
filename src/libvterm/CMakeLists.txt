add_library(libvterm "")

target_sources(
  libvterm
  PRIVATE
    src/encoding.c
    src/keyboard.c
    src/mouse.c
    src/parser.c
    src/pen.c
    src/rect.h
    src/screen.c
    src/state.c
    src/unicode.c
    src/utf8.h
    src/vterm.c
    src/vterm_internal.h
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/include/vterm.h
    ${CMAKE_CURRENT_LIST_DIR}/include/vterm_keycodes.h
  )

target_include_directories(
  libvterm
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/include
  )

target_compile_definitions(
  libvterm
  PRIVATE
    -DHAVE_CONFIG_H
    -DINLINE=
    -DVSNPRINTF=vim_vsnprintf
    -DIS_COMBINING_FUNCTION=utf_iscomposing_uint
    -DWCWIDTH_FUNCTION=utf_uint2cells
  )
