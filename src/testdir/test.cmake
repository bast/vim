function(execute_test _vim_executable _working_dir _test_script)
  # generates test.out
  execute_process(
    COMMAND ${_vim_executable} -f -u unix.vim -U NONE --noplugin --not-a-term -s dotest.in ${_test_script}.in
    WORKING_DIRECTORY ${_working_dir}
    )

  # compares test*.ok and test.out
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E compare_files ${_test_script}.ok test.out
    WORKING_DIRECTORY ${_working_dir}
    RESULT_VARIABLE files_differ
    OUTPUT_QUIET
    ERROR_QUIET
    )

  # removes leftovers
  file(REMOVE ${_working_dir}/Xdotest)

  # we let the test fail if the files differ
  if(files_differ)
    message(SEND_ERROR "test ${_test_script} failed")
  endif()
endfunction()

execute_test(${VIM_EXECUTABLE} ${WORKING_DIR} ${TEST_SCRIPT})
