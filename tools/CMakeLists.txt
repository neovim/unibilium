macro(unibi_tool basename)
  add_executable(${basename} "${basename}.c")
  target_link_libraries(${basename} unibilium)
  target_include_directories(${basename} PRIVATE ${PROJECT_SOURCE_DIR})
endmacro()

unibi_tool(unibi-dump)
unibi_tool(unibi-put)
unibi_tool(gen-static-test)
