#include <itkImageFileReader.h>
#include <itkImageFileWriter.h> 
#include <itkExponentialDeformationFieldImageFilter.h>

// VelocityToDeformationField.cxx

template <unsigned int Dimension>
void VelocityToDeformationField( int argc, char *argv[] )
{
  // Input velocity field
  typedef float VectorComponentType;
  typedef itk::Vector< VectorComponentType, Dimension > VectorPixelType;
  typedef itk::Image< VectorPixelType,  Dimension > ImageType;

  // Read input velocity field
  typedef itk::ImageFileReader< ImageType > ImageReaderType;
  typename ImageReaderType::Pointer VelocityFieldReader = ImageReaderType::New( );
  VelocityFieldReader->SetFileName( argv[1] );
  try 
  {
    VelocityFieldReader->Update();
  }
  catch(itk::ExceptionObject & e)
  {
    std::cout << "Reader Exception caught ! " << e << std::endl;
    exit( EXIT_FAILURE );
  }  

  // Exponentiate
  typedef itk::ExponentialDeformationFieldImageFilter< ImageType, ImageType > FieldExponentiatorType;
  typename FieldExponentiatorType::Pointer filter = FieldExponentiatorType::New();
  filter->SetInput(VelocityFieldReader->GetOutput() );
  filter->ComputeInverseOff();
  filter->Update();

  // Write output deformation field

  // 4. Write output vector field
  typedef itk::ImageFileWriter<  ImageType  > WriterType;
  typename WriterType::Pointer writer = WriterType::New();
  writer->SetInput(filter->GetOutput());
  writer->SetFileName( argv[2] );

  try
    {
    writer->Update();
    }
  catch(itk::ExceptionObject & e)
  {
    std::cout << "Reader Exception caught ! " << e << std::endl;
    exit( EXIT_FAILURE );
  }  

}

int main( int argc, char *argv[] )
{
  if( argc < 3 )
    {
    std::cerr << "Missing Parameters " << std::endl;
    std::cerr << "Usage: " << argv[0];
    std::cerr << " inputVelocityField outputDeformationField" << std::endl;
    return EXIT_FAILURE;
    }

  // Input Velocity Field
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
        std::cout << "Could not read the input velocity field." << std::endl;
        exit( EXIT_FAILURE );
     }
  }
  catch( itk::ExceptionObject& err )
  {
     std::cout << "Could not read the input velocity field." << std::endl;
     std::cout << err << std::endl;
     exit( EXIT_FAILURE );
  }

  // Define dimension on the fly
  switch ( imageIO->GetNumberOfDimensions() )
  {
  case 2:
     VelocityToDeformationField<2>(argc,argv);
     break;
  case 3:
     VelocityToDeformationField<3>(argc,argv);
     break;
  default:
     std::cout << "Unsuported dimension" << std::endl;
     exit( EXIT_FAILURE );
  }

  return EXIT_SUCCESS;
}
  

