file(GLOB mains *.sysu.c)
project(sysu-functiona1-3)
foreach(mainfile ${mains})
  # Get file name without directory
  get_filename_component(mainname ${mainfile} NAME_WE)
  add_executable(${PROJECT_NAME}_${mainname} ${mainfile})
  target_link_libraries(${PROJECT_NAME}_${mainname} sysy)
  target_include_directories(
    ${PROJECT_NAME}_${mainname}
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../librarian/include)
  install(TARGETS ${PROJECT_NAME}_${mainname})
endforeach()
