cmake_minimum_required(VERSION 3.10.2)

#add_library(
#            weather
#            SHARED
#            ../../src/weather.c
#)

add_library(
        stl_android
        SHARED
        IMPORTED
        GLOBAL
)
set_target_properties(stl_android PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libA90JavahCore.so)

