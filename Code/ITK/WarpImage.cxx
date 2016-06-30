/*
 *      	File:	 WarpImage.cxx
 *          Date:    4/12/2010
 *          Version: 0.0.1
 *          Author:  Dong Hye Ye
 *      
 *          File Description
 *          Apply Deformation field to moving image
 *      
 *          Copyright (c) 2010 Dong Hye Ye
 *          
 *          This software is distributed WITHOUT ANY WARRANTY; without even
 *          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 *          PURPOSE.  See the above copyright notices for more information.
 */
 
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h> 

#include <itkCastImageFilter.h>
#include <itkWarpImageFilter.h>
#include <itkNearestNeighborInterpolateImageFunction.h>
#include <itkBSplineInterpolateImageFunction.h>

template <unsigned int Dimension>
void WarpImage( int argc, char *argv[] )
{
  typedef float PixelType;

  typedef itk::Image< PixelType, Dimension >  ImageType;

  typedef itk::Image< PixelType, Dimension >  FixedImageType;
  typedef itk::Image< PixelType, Dimension >  MovingImageType;
  
  typedef itk::ImageFileReader< FixedImageType  > FixedImageReaderType;
  typedef itk::ImageFileReader< MovingImageType > MovingImageReaderType;

  typename FixedImageReaderType::Pointer fixedImageReader   = FixedImageReaderType::New();
  typename MovingImageReaderType::Pointer movingImageReader = MovingImageReaderType::New();

  fixedImageReader->SetFileName( argv[1] );
  movingImageReader->SetFileName( argv[2] );

  try
   {
      fixedImageReader->Update();
      movingImageReader->Update();
   }
   catch( itk::ExceptionObject& err )
   {
      std::cout << "Could not read one of the input images." << std::endl;
      std::cout << err << std::endl;
      exit( EXIT_FAILURE );
   }

  typedef itk::Vector< float, Dimension >    VectorPixelType;
  typedef itk::Image<  VectorPixelType, Dimension > DeformationFieldType;
  typedef itk::ImageFileReader< DeformationFieldType > FieldReaderType;

  typename FieldReaderType::Pointer fieldReader = FieldReaderType::New();
  fieldReader->SetFileName(  argv[3] );      
      
  try
  {
	  fieldReader->Update();
  }
  catch( itk::ExceptionObject& err )
  {
	  std::cout << "Could not read the input field." << std::endl;
	  std::cout << err << std::endl;
	  exit( EXIT_FAILURE );
  }
  
  typedef itk::WarpImageFilter<
                          FixedImageType, 
                          MovingImageType,
                          DeformationFieldType  >     WarperType;

  typename FixedImageType::Pointer fixedImage = fixedImageReader->GetOutput();
  typename WarperType::Pointer warper = WarperType::New();

  if (argc > 5)
  {
	  if (!strcmp(argv[5],"0")){}
	  else if (!strcmp(argv[5],"1"))
	  {
		  typedef itk::NearestNeighborInterpolateImageFunction<
									   MovingImageType,
									   double          >  InterpolatorType;
		  typename InterpolatorType::Pointer interpolator = InterpolatorType::New();
		  warper->SetInterpolator( interpolator );
	  }
	  else if (!strcmp(argv[5],"2"))
	  {
		  typedef itk::BSplineInterpolateImageFunction<
									   MovingImageType,
									   double          >  InterpolatorType;
		  typename InterpolatorType::Pointer interpolator = InterpolatorType::New();
		  warper->SetInterpolator( interpolator );
	  }
	  else
	  {
		  std::cout << "Interpoloation Method is Not Supported" << std::endl;
		  exit( EXIT_FAILURE );
	  }
  }
  warper->SetInput( movingImageReader->GetOutput() );
  warper->SetOutputSpacing( fixedImage->GetSpacing() );
  warper->SetOutputOrigin( fixedImage->GetOrigin() );
  warper->SetOutputDirection( fixedImage->GetDirection() );
  warper->SetDeformationField( fieldReader->GetOutput() );

  typedef PixelType OutputPixelType;
  typedef itk::Image< OutputPixelType, Dimension > OutputImageType;
  typedef itk::CastImageFilter< 
                        MovingImageType,
                        OutputImageType > CastFilterType;
  
  typedef itk::ImageFileWriter< OutputImageType >  WriterType;

  typename WriterType::Pointer      writer =  WriterType::New();
  typename CastFilterType::Pointer  caster =  CastFilterType::New();

  writer->SetFileName( argv[4] );
  
  caster->SetInput( warper->GetOutput() );
  writer->SetInput( caster->GetOutput() );
  writer->SetUseCompression( true );
  writer->Update();

  double finalSSD = 0.0;
  typedef itk::ImageRegionConstIterator<ImageType> ImageConstIterator;

  ImageConstIterator iterfix = ImageConstIterator(
     fixedImage, fixedImage->GetRequestedRegion() );
  
  ImageConstIterator itermovwarp = ImageConstIterator(
     warper->GetOutput(), fixedImage->GetRequestedRegion() );
  
  for (iterfix.GoToBegin(), itermovwarp.GoToBegin(); !iterfix.IsAtEnd(); ++iterfix, ++itermovwarp)
  {
     finalSSD += vnl_math_sqr( iterfix.Get() - itermovwarp.Get() );
  }

  const double finalMSE = finalSSD / static_cast<double>(
     fixedImage->GetRequestedRegion().GetNumberOfPixels() );
  std::cout<<finalMSE<<std::endl;
  
}
 

int main( int argc, char *argv[] )
{
  if( argc < 5 )
    {
    std::cerr << "Missing Parameters " << std::endl;
    std::cerr << "Usage: " << argv[0];
    std::cerr << " fixedImageFile movingImageFile";
    std::cerr << " deformationFieldFile outputImageFile";
	std::cerr << " [InterpolationMethod:0->Linear(default),1->NearestNeighbor,2->BSpline]" << std::endl;
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
        std::cout << "Could not read the fixed image information." << std::endl;
        exit( EXIT_FAILURE );
     }
  }
  catch( itk::ExceptionObject& err )
  {
     std::cout << "Could not read the fixed image information." << std::endl;
     std::cout << err << std::endl;
     exit( EXIT_FAILURE );
  }

  switch ( imageIO->GetNumberOfDimensions() )
  {
  case 2:
     WarpImage<2>(argc,argv);
     break;
  case 3:
     WarpImage<3>(argc,argv);
     break;
  default:
     std::cout << "Unsuported dimension" << std::endl;
     exit( EXIT_FAILURE );
  }
  
  return EXIT_SUCCESS;
}
  

