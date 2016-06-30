//#include <itkVector.h>
//#include <itkImage.h>
//#include <itkMatrix.h>
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h> 
#include <itkGradientImageFilter.h>

// function TransportVectorField

template <unsigned int Dimension>
void ImageGradient( int argc, char *argv[] )
{
  // Input iamge
  typedef float PixelType;
  typedef itk::Image< PixelType,  Dimension > ImageType;

  // Read input image
  typedef itk::ImageFileReader< ImageType > ImageReaderType;
  typename ImageReaderType::Pointer reader = ImageReaderType::New( );
  reader->SetFileName( argv[1] );
  try 
  {
    reader->Update();
  }
  catch(itk::ExceptionObject & e)
  {
    std::cout << "Reader Exception caught ! " << e << std::endl;
    exit( EXIT_FAILURE );
  }  

  // Set up gradient filter
  typedef itk::GradientImageFilter< ImageType, PixelType > FilterType;
  typename FilterType::Pointer filter = FilterType::New();
  filter->SetInput( reader->GetOutput() );
  //filter->SetOutputSpacing( reader->GetOutput()->GetSpacing() );
  //filter->SetOutputOrigin( reader->GetOutput()->GetOrigin() );
  //filter->SetOutputDirection( reader->GetOutput()->GetDirection() );
  filter->Update();

  // write output

  typedef float VectorComponentType;
  typedef itk::CovariantVector< VectorComponentType, Dimension > VectorPixelType;
  typedef itk::Image< VectorPixelType, Dimension > FieldType;
  typedef itk::ImageFileWriter<  FieldType  > WriterType;
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
    std::cerr << " inputImage outputField" << std::endl;
    return EXIT_FAILURE;
    }

  // Input Tangent Vector Field
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
        std::cout << "Could not read the input image." << std::endl;
        exit( EXIT_FAILURE );
     }
  }
  catch( itk::ExceptionObject& err )
  {
     std::cout << "Could not read the input image." << std::endl;
     std::cout << err << std::endl;
     exit( EXIT_FAILURE );
  }

  // Define dimension on the fly
  switch ( imageIO->GetNumberOfDimensions() )
  {
  case 2:
     ImageGradient<2>(argc,argv);
     break;
  case 3:
     ImageGradient<3>(argc,argv);
     break;
  default:
     std::cout << "Unsuported dimension" << std::endl;
     exit( EXIT_FAILURE );
  }

  return EXIT_SUCCESS;
}
  

