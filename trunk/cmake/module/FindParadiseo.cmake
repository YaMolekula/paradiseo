# File: FindParadiseo.cmake
# Version: 0.0.1
#
# The following variables are filled out:
# - PARADISEO_INCLUDE_DIR : EO, MO and MOEO source dir
# - EO_INCLUDE_DIR :        EO source dir
# - MO_INCLUDE_DIR :        MO source dir
# - MOEO_INCLUDE_DIR :      MOEO source dir. WARNING : You have ton include MO before !
# - PARADISEO_LIBRARIES :   the list of all required modules
# - PARADISEO_XXX_LIBRARY : the name of the library to link for the required module   
# - PARADISEO_XXX_FOUND :   true if the required module is found
# - PARADISEO_FOUND :       true if all required modules are found
#
# Here are the components:
# - eo
# - PyEO
# - es
# - ga
# - cma
# - flowshop
# - moeo
# You can use find_package(Paradiseo COMPONENTS ... ) to enable one or several components. If you not specifie component, all components will be load.
#
# Output
# ------
#
# example:
#   find_package(Paradiseo COMPONENTS eo eoutils cma es flowshop ga moeo REQUIRED)
#   include_directories(${PARADISEO_INCLUDE_DIR})
#   add_executable(example ...)
#   target_link_libraries(examplep ${PARADISEO_LIBRARIES})

if(UNIX)
    set(INSTALL_SUB_DIR /paradiseo)
endif()

# enabled components
if ("${Paradiseo_FIND_COMPONENTS}" STREQUAL "")
    set(PARADISEO_LIBRARIES_TO_FIND eo eoutils cma es flowshop ga moeo)
else()
    set(PARADISEO_LIBRARIES_TO_FIND ${Paradiseo_FIND_COMPONENTS})
endif()

#set the build directory
set(BUILD_DIR build)

# Path
set(PARADISEO_SRC_PATHS
        ${PARADISEO_ROOT}
        $ENV{PARADISEO_ROOT}
        /usr/local/
        /usr/
        /sw # Fink
        /opt/local/ # DarwinPorts
        /opt/csw/ # Blastwave
        /opt/
        [KEY_CURRENT_USER\\Software\\Inria\\ParadisEO]
        [HKEY_LOCAL_MACHINE\\Software\\Inria\\ParadiseEO]
)

find_path(EO_INCLUDE_DIR eo
          PATH_SUFFIXES include${INSTALL_SUB_DIR}/eo eo/src
          PATHS ${PARADISEO_SRC_PATHS})
          
find_path(MO_INCLUDE_DIR mo
          PATH_SUFFIXES include${INSTALL_SUB_DIR}/mo mo/src
          PATHS ${PARADISEO_SRC_PATHS})

find_path(MOEO_INCLUDE_DIR moeo
          PATH_SUFFIXES include${INSTALL_SUB_DIR}/moeo moeo/src
          PATHS ${PARADISEO_SRC_PATHS})
           
set(PARADISEO_INCLUDE_DIR ${EO_INCLUDE_DIR} ${MO_INCLUDE_DIR} ${MOEO_INCLUDE_DIR})

# find the requested modules
set(PARADISEO_FOUND TRUE) # will be set to false if one of the required modules is not found

set(FIND_PARADISEO_LIB_PATHS
        ${PARADISEO_ROOT}/${BUILD_DIR}
        $ENV{PARADISEO_ROOT}
        /usr/local/
        /usr/
        /sw # Fink
        /opt/local/ # DarwinPorts
        /opt/csw/ # Blastwave
        /opt/
        [KEY_CURRENT_USER\\Software\\Inria\\ParadisEO]
        [HKEY_LOCAL_MACHINE\\Software\\Inria\\ParadiseEO]
)

#Suffixes
set(PARADISEO_LIB_PATHS_SUFFIXES
        eo/lib 
        mo/lib 
        moeo/lib 
        moeo/tutorial/examples/flowshop/lib #For flowshop library
        lib 
        lib32 
        lib64
        )
        
foreach(FIND_PARADISEO_COMPONENT ${PARADISEO_LIBRARIES_TO_FIND})
    string(TOUPPER ${FIND_PARADISEO_COMPONENT} FIND_PARADISEO_COMPONENT_UPPER)
    # release library
    find_library(PARADISEO_${FIND_PARADISEO_COMPONENT_UPPER}_LIBRARY
                 NAMES ${FIND_PARADISEO_COMPONENT}
                 PATH_SUFFIXES ${PARADISEO_LIB_PATHS_SUFFIXES}
                 PATHS ${FIND_PARADISEO_LIB_PATHS})
    if (PARADISEO_${FIND_PARADISEO_COMPONENT_UPPER}_LIBRARY)
        # library found
        set(PARADISEO_${FIND_PARADISEO_COMPONENT_UPPER}_FOUND TRUE)
    else()
        # library not found
        set(PARADISEO_FOUND FALSE)
        set(PARADISEO_${FIND_PARADISEO_COMPONENT_UPPER}_FOUND FALSE)
        set(FIND_PARADISEO_MISSING "${FIND_PARADISEO_MISSING} ${FIND_PARADISEO_COMPONENT}")
    endif()
    set(PARADISEO_LIBRARIES ${PARADISEO_LIBRARIES} "${PARADISEO_${FIND_PARADISEO_COMPONENT_UPPER}_LIBRARY}")
endforeach()

# handle result
if(PARADISEO_FOUND)
    message(STATUS "Found ParadisEO includes :")
    message(${EO_INCLUDE_DIR})
    message(${MO_INCLUDE_DIR})
    message(${MOEO_INCLUDE_DIR})
else()
    # include directory or library not found
    message(FATAL_ERROR "Could NOT find ParadisEO (missing : ${FIND_PARADISEO_MISSING})")
endif()
