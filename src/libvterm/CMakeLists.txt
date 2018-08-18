add_library(libvterm "")

target_sources(libvterm
  PRIVATE
    src/encoding.c
    src/keyboard.c
    src/mouse.c
    src/parser.c
    src/pen.c
    src/screen.c
    src/state.c
    src/unicode.c
    src/vterm.c
  )

target_include_directories(libvterm
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/include
  )

target_compile_definitions(libvterm
  PRIVATE
    "HAVE_CONFIG_H"
    "INLINE="
    "VSNPRINTF=vim_vsnprintf"
    "IS_COMBINING_FUNCTION=utf_iscomposing_uint"
    "WCWIDTH_FUNCTION=utf_uint2cells"
  )
