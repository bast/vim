include(CheckTypeSize)
include(CheckFunctionExists)
include(CheckIncludeFiles)
include(CheckLibraryExists)
include(CheckCSourceCompiles)

function(generate_config_h)
  set(TERMINFO 1)
  set(UNIX 1)

  # FIXME this is hardcoded to keep the discussion in the book chapter
  # which describes the migration to CMake simpler
  set(TIME_WITH_SYS_TIME 1)
  set(RETSIGTYPE void)
  set(SIGRETURN return)

  find_package(X11)
  set(HAVE_X11 ${X11_FOUND})

  check_type_size("int" VIM_SIZEOF_INT)
  check_type_size("long" VIM_SIZEOF_LONG)
  check_type_size("time_t" SIZEOF_TIME_T)
  check_type_size("off_t" SIZEOF_OFF_T)

  foreach(
    _function
    fchdir fchown fchmod fsync getcwd getpseudotty
    getpwent getpwnam getpwuid getrlimit gettimeofday getwd lstat
    memset mkdtemp nanosleep opendir putenv qsort readlink select setenv
    getpgid setpgid setsid sigaltstack sigstack sigset sigsetjmp sigaction
    sigprocmask sigvec strcasecmp strerror strftime stricmp strncasecmp
    strnicmp strpbrk strtol towlower towupper iswupper
    usleep utime utimes mblen ftruncate
    )

    string(TOUPPER "${_function}" _function_uppercase)
    check_function_exists(${_function} HAVE_${_function_uppercase})
  endforeach()

  check_library_exists(tinfo tgetent "" HAVE_TGETENT)

  if(NOT HAVE_TGETENT)
    message(FATAL_ERROR "Could not find the tgetent() function. You need to install a terminal library; for example ncurses.")
  endif()

  foreach(
    _header
    setjmp.h dirent.h
    stdint.h stdlib.h string.h
    sys/select.h sys/utsname.h termcap.h fcntl.h
    sgtty.h sys/ioctl.h sys/time.h sys/types.h
    termio.h iconv.h inttypes.h langinfo.h math.h
    unistd.h stropts.h errno.h sys/resource.h
    sys/systeminfo.h locale.h sys/stream.h termios.h
    libc.h sys/statfs.h poll.h sys/poll.h pwd.h
    utime.h sys/param.h libintl.h libgen.h
    util/debug.h util/msg18n.h frame.h sys/acl.h
    sys/access.h sys/sysinfo.h wchar.h wctype.h
    )

    string(TOUPPER "${_header}" _header_uppercase)
    string(REPLACE "/" "_" _header_normalized "${_header_uppercase}")
    string(REPLACE "." "_" _header_normalized "${_header_normalized}")
    check_include_files(${_header} HAVE_${_header_normalized})
  endforeach()

  string(TOUPPER "${FEATURES}" _features_upper)
  set(FEAT_${_features_upper} 1)

  set(FEAT_NETBEANS_INTG ${ENABLE_NETBEANS})
  set(FEAT_JOB_CHANNEL ${ENABLE_CHANNEL})
  set(FEAT_TERMINAL ${ENABLE_TERMINAL})

  check_c_source_compiles(
    "
    #include <sys/types.h>
    #include <sys/stat.h>
    int
    main ()
    {
            struct stat st;
            int n;

            stat(\"/\", &st);
            n = (int)st.st_blksize;
      ;
      return 0;
    }
    "
    HAVE_ST_BLKSIZE
    )

  configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/config.h.cmake.in
    ${CMAKE_CURRENT_LIST_DIR}/auto/config.h
    )
endfunction()

function(generate_pathdef_c)
  set(_default_vim_dir ${CMAKE_INSTALL_PREFIX})
  set(_default_vimruntime_dir ${_default_vim_dir})

  set(_all_cflags "${CMAKE_C_COMPILER} ${CMAKE_C_FLAGS}")
  if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(_all_cflags "${_all_cflags} ${CMAKE_C_FLAGS_RELEASE}")
  else()
    set(_all_cflags "${_all_cflags} ${CMAKE_C_FLAGS_DEBUG}")
  endif()

  # it would require a bit more work and execute commands at build time
  # to get the link line into the binary
  set(_all_lflags "undefined")

  if(WIN32)
    set(_compiled_user $ENV{USERNAME})
  else()
    set(_compiled_user $ENV{USER})
  endif()

  cmake_host_system_information(RESULT _compiled_sys QUERY HOSTNAME)

  configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/pathdef.c.in
    ${CMAKE_CURRENT_LIST_DIR}/auto/pathdef.c
    )
endfunction()

function(generate_osdef_h)
  find_program(BASH_EXECUTABLE bash)

  execute_process(
    COMMAND ${BASH_EXECUTABLE} osdef.sh
    WORKING_DIRECTORY
      ${CMAKE_CURRENT_LIST_DIR}
    )
endfunction()
