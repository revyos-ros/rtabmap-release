# - Find ORB_SLAM2 OR ORB_SLAM3
#
# It sets the following variables:
#  ORB_SLAM_FOUND         - Set to false, or undefined, if ORB_SLAM isn't found.
#  ORB_SLAM_INCLUDE_DIRS  - The ORB_SLAM include directory.
#  ORB_SLAM_LIBRARIES     - The ORB_SLAM library to link against.
#  ORB_SLAM_VERSION       - The ORB_SLAM major version.
#
#  Set ORB_SLAM_ROOT_DIR environment variable as the path to ORB_SLAM2 or ORB_SLAM3 root folder.

find_path(ORB_SLAM_INCLUDE_DIR NAMES System.h PATHS $ENV{ORB_SLAM_ROOT_DIR}/include)
find_library(ORB_SLAM2_LIBRARY NAMES ORB_SLAM2 PATHS $ENV{ORB_SLAM_ROOT_DIR}/lib)
find_library(ORB_SLAM3_LIBRARY NAMES ORB_SLAM3 PATHS $ENV{ORB_SLAM_ROOT_DIR}/lib)
find_path(g2o_INCLUDE_DIR NAMES g2o/core/sparse_optimizer.h PATHS $ENV{ORB_SLAM_ROOT_DIR}/Thirdparty/g2o NO_DEFAULT_PATH)
find_path(sophus_INCLUDE_DIR NAMES sophus/se3.hpp PATHS $ENV{ORB_SLAM_ROOT_DIR}/Thirdparty/Sophus NO_DEFAULT_PATH)
find_library(g2o_LIBRARY NAMES g2o PATHS $ENV{ORB_SLAM_ROOT_DIR}/Thirdparty/g2o/lib NO_DEFAULT_PATH)
find_library(DBoW2_LIBRARY NAMES DBoW2 PATHS $ENV{ORB_SLAM_ROOT_DIR}/Thirdparty/DBoW2/lib NO_DEFAULT_PATH)

IF(ORB_SLAM2_LIBRARY)
   SET(ORB_SLAM_VERSION 2)
   SET(ORB_SLAM_LIBRARY ${ORB_SLAM2_LIBRARY})
ELSEIF(ORB_SLAM3_LIBRARY)
   SET(ORB_SLAM_VERSION 3)
   SET(ORB_SLAM_LIBRARY ${ORB_SLAM3_LIBRARY})
   IF(g2o_INCLUDE_DIR AND sophus_INCLUDE_DIR) # ORB_SLAM3 v1
      SET(g2o_INCLUDE_DIR ${g2o_INCLUDE_DIR} ${sophus_INCLUDE_DIR})
   ENDIF(g2o_INCLUDE_DIR AND sophus_INCLUDE_DIR)
ENDIF()

IF (ORB_SLAM_INCLUDE_DIR AND ORB_SLAM_LIBRARY AND DBoW2_LIBRARY AND g2o_INCLUDE_DIR AND g2o_LIBRARY)
   SET(ORB_SLAM_FOUND TRUE)
   SET(ORB_SLAM_INCLUDE_DIRS ${ORB_SLAM_INCLUDE_DIR} ${ORB_SLAM_INCLUDE_DIR}/CameraModels ${g2o_INCLUDE_DIR} $ENV{ORB_SLAM_ROOT_DIR})
   SET(ORB_SLAM_LIBRARIES ${g2o_LIBRARY} ${ORB_SLAM_LIBRARY} ${DBoW2_LIBRARY})
ENDIF (ORB_SLAM_INCLUDE_DIR AND ORB_SLAM_LIBRARY AND DBoW2_LIBRARY AND g2o_INCLUDE_DIR AND g2o_LIBRARY)

FIND_PACKAGE(Pangolin QUIET)
IF(NOT Pangolin_FOUND)
  SET(ORB_SLAM_FOUND FALSE)
  MESSAGE(STATUS "Found ORB_SLAM but not Pangolin, disabling ORB_SLAM.")
ELSE()
  MESSAGE(STATUS "Found Pangolin: ${Pangolin_INCLUDE_DIRS}")
  SET(ORB_SLAM_INCLUDE_DIRS ${ORB_SLAM_INCLUDE_DIRS} ${Pangolin_INCLUDE_DIRS})
  SET(ORB_SLAM_LIBRARIES ${ORB_SLAM_LIBRARIES} ${Pangolin_LIBRARIES})
ENDIF()

IF (ORB_SLAM_FOUND)
   # show which ORB_SLAM was found only if not quiet
   IF (NOT ORB_SLAM_FIND_QUIETLY)
      MESSAGE(STATUS "Found ORB_SLAM${ORB_SLAM_VERSION}: ${ORB_SLAM_LIBRARIES}")
   ENDIF (NOT ORB_SLAM_FIND_QUIETLY)
ELSE (ORB_SLAM_FOUND)
   # fatal error if ORB_SLAM is required but not found
   IF (ORB_SLAM_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find ORB_SLAM")
   ENDIF (ORB_SLAM_FIND_REQUIRED)
ENDIF (ORB_SLAM_FOUND)

