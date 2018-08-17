# we run only the first test since this is only proof of concept
# we collect the multi-step COMMAND in test.cmake for portability

add_test(
  NAME
    test1
  COMMAND
    ${CMAKE_COMMAND} -D VIM_EXECUTABLE=$<TARGET_FILE:vim>
                     -D WORKING_DIR=${CMAKE_CURRENT_LIST_DIR}
                     -D TEST_SCRIPT=test1
                     -P ${CMAKE_CURRENT_LIST_DIR}/test.cmake
  WORKING_DIRECTORY
    ${PROJECT_BINARY_DIR}
  )
