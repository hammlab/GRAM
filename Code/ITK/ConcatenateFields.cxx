/*
 *      	File:	 ConcatenateFields.cxx
 *          Date:    4/12/2010
 *          Version: 0.0.1
 *          Author:  Dong Hye Ye
 *      
 *          File Description
 *          Concatenate deformation fields
 *      
 *          Copyright (c) 2010 Dong Hye Ye
 *          
 *          This software is distributed WITHOUT ANY WARRANTY; without even
 *          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 *          PURPOSE.  See the above copyright notices for more information.
 */

#include <itkImage.h>
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h>

#include "itkDisplacementFieldCompositionFilter.h"

template <unsigned int Dimension>
void ConcatenateFields( int argc, char *argv[] )
{
  typedef float PixelType;
  typedef itk::Vector< PixelType, Dimension >    VectorPixelType;
  typedef itk::Image<  VectorPixelType, Dimension > DeformationFieldType;
  typedef itk::ImageFileReader< DeformationFieldType > FieldReaderType;

  typename FieldReaderType::Pointer FixToInterFieldReader = FieldReaderType::New();
  FixToInterFieldReader->SetFileName( argv[1] );      
      
  try
  {
	  FixToInterFieldReader->Update();
  }
  catch( itk::ExceptionObject& err )
  {
	  std::cout << "Could not read the field from moving to intermediate." << std::endl;
	  std::cout << err << std::endl;
	  exit( EXIT_FAILURE );
  }
  
  typename FieldReaderType::Pointer InterToMovFieldReader = FieldReaderType::New();
  InterToMovFieldReader->SetFileName( argv[2] );      
      
  try
  {
	  InterToMovFieldReader->Update();
  }
  catch( itk::ExceptionObject& err )
  {
	  std::cout << "Could not read the input field from intermediate to fixed." << std::endl;
	  std::cout << err << std::endl;
	  exit( EXIT_FAILURE );
  }  
  
  typedef itk::DisplacementFieldCompositionFilter<DeformationFieldType,DeformationFieldType> ComposerType;
  typename ComposerType::Pointer composer = ComposerType::New();

  composer->SetInput( 0, FixToInterFieldReader->GetOutput() );
  composer->SetInput( 1, InterToMovFieldReader->GetOutput() );  
      
  composer->Update();
  
  typedef itk::ImageFileWriter< DeformationFieldType > FieldWriterType;
  typename FieldWriterType::Pointer fieldWriter = FieldWriterType::New();
  fieldWriter->SetFileName(  argv[3] );
  fieldWriter->SetInput( composer->GetOutput() );
  fieldWriter->SetUseCompression( false );
      
  try
  {
    fieldWriter->Update();
  }
  catch( itk::ExceptionObject& err )
  {
    std::cout << "Unexpected error." << std::endl;
    std::cout << err << std::endl;
    exit( EXIT_FAILURE );
  }    
}


int main( int argc, char * argv[] )
{
  if( argc < 3 ) 
    { 
    std::cerr << "Usage: " << std::endl;
    std::cerr << argv[0] << " FixToInter-Def InterToMov-Def FixToMov-Def(Output) " << std::endl;
    return EXIT_FAILURE;
    }
    
  // Get the image dimension
  itk::ImageIOBase::Pointer imageIO;
  try
  {
     imageIO = itk::ImageIOFactory::CreateImageIO(
        argv[1], itk::ImageIOFactory::ReadMode);
     if ( imageIO )
     {
        imageIO->SetFileName(argv[1]);
        imageIO->ReadImageInformation();
     }
     else
     {
        std::cout << "Could not read the FixToInter field information." << std::endl;
        exit( EXIT_FAILURE );
     }
  }
  catch( itk::ExceptionObject& err )
  {
     std::cout << "Could not read the FixToInter image information." << std::endl;
     std::cout << err << std::endl;
     exit( EXIT_FAILURE );
  }

  switch ( imageIO->GetNumberOfDimensions() )
  {
  case 2:
     ConcatenateFields<2>(argc,argv);
     break;
  case 3:
     ConcatenateFields<3>(argc,argv);
     break;
  default:
     std::cout << "Unsuported dimension" << std::endl;
     exit( EXIT_FAILURE );
  }
	
  return EXIT_SUCCESS;
 }