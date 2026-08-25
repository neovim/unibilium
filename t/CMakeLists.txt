macro(unibi_test basename)
  add_executable(${basename} "${basename}.c")
  target_include_directories(${basename} PRIVATE ${PROJECT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
  target_link_libraries(${basename} unibilium)
  add_test(
    NAME ${basename}
    COMMAND prove -f $<TARGET_FILE:${basename}>
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
endmacro()

unibi_test(00_load)
unibi_test(if-then-else)
unibi_test(new-extended-format-static_screen)
unibi_test(static_screen-256color)
unibi_test(static_screen)
unibi_test(static_tmux)
unibi_test(static_xterm-256color)
unibi_test(static_xterm)
unibi_test(wide-format)
