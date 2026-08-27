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

macro(regen termname)
  set(OUT_STATIC_FILE "static_${termname}.c")
  add_custom_target(regen-${termname}
    COMMAND gen-static-test "${termname}" > "${CMAKE_CURRENT_BINARY_DIR}/${OUT_STATIC_FILE}")
  add_custom_target(copy-${termname}
    DEPENDS regen-${termname}
    COMMAND cmake -E copy "${CMAKE_CURRENT_BINARY_DIR}/${OUT_STATIC_FILE}" ${CMAKE_CURRENT_SOURCE_DIR})
  add_dependencies(regenerate-tests regen-${termname})
endmacro()

add_custom_target(regenerate-tests)
regen(screen-256color)
regen(screen)
regen(tmux)
regen(xterm-256color)
regen(xterm)
