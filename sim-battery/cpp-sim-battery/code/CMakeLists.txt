cmake_minimum_required(VERSION 2.6)
project(TPZ-Battery-Simulator)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

###
# custom library
###
set(HEADER_FILES ./lib/fakebattery.h)
add_library(fakebattery ./lib/fakebattery.cpp ${HEADER_FILES})
target_include_directories(fakebattery PRIVATE .)

###
# executable
###
add_executable(RunSimulation RunSimulation.cpp)
target_link_libraries(RunSimulation cpp_redis tacopie fakebattery)

###
# link libs
###
target_link_libraries(RunSimulation pthread)
