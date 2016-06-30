CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

PROJECT(GRAM_ITK)

FIND_PACKAGE(ITK)
IF(ITK_FOUND)
  INCLUDE(${ITK_USE_FILE})
ELSE(ITK_FOUND)
  MESSAGE(FATAL_ERROR
          "Cannot build without ITK.  Please set ITK_DIR.")
ENDIF(ITK_FOUND)

#ADD_EXECUTABLE(ConcatenateFields ConcatenateFields.cxx )
#TARGET_LINK_LIBRARIES(ConcatenateFields ITKIO ITKCommon ITKStatistics)

#ADD_EXECUTABLE(DemonsRegistration_dong DemonsRegistration.cxx)
#TARGET_LINK_LIBRARIES(DemonsRegistration_dong ITKIO ITKCommon ITKStatistics)

#ADD_EXECUTABLE(DemonsRegistration_dong_n DemonsRegistration_n.cxx)
#TARGET_LINK_LIBRARIES(DemonsRegistration_dong_n ITKIO ITKCommon ITKStatistics)

#ADD_EXECUTABLE(WarpImage WarpImage.cxx)
#TARGET_LINK_LIBRARIES(WarpImage ITKIO ITKCommon ITKStatistics)

#ADD_EXECUTABLE(JacobianField JacobianField.cxx)
#TARGET_LINK_LIBRARIES(JacobianField ITKIO ITKCommon ITKStatistics)

#ADD_EXECUTABLE(TransportVelocityField TransportVelocityField.cxx)
#TARGET_LINK_LIBRARIES(TransportVelocityField ITKIO ITKCommon)

#ADD_EXECUTABLE(VelocityToDeformationField VelocityToDeformationField.cxx)
#TARGET_LINK_LIBRARIES(VelocityToDeformationField ITKIO ITKCommon)

#ADD_EXECUTABLE(GradientField GradientField.cxx)
#TARGET_LINK_LIBRARIES(GradientField ITKIO ITKCommon)
