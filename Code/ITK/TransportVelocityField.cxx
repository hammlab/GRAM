//#include <itkVector.h>
//#include <itkImage.h>
//#include <itkMatrix.h>
#include <itkImageFileReader.h>
#include <itkImageFileWriter.h> 
#include <itkWarpVectorImageFilter.h>
#include <itkDiscreteGaussianImageFilter.h>
#include "itkDisplacementFieldJacobianFilter.h"
#include <itkIterativeInverseDeformationFieldImageFilter.h>
#include <itkInverseDeformationFieldImageFilter.h>
#include "itkFixedPointInverseDeformationFieldImageFilter.h"
#include <vnl/vnl_math.h>
#include <vnl/vnl_vector.h>
#include <vnl/vnl_matrix.h>
#include <vnl/vnl_inverse.h>
#include <vnl/vnl_trace.h>
//#include "itkNumericTraits.h"
//#include "itkNiftiImageIO.h"
//#include <vnl/vnl_cross.h>

// function TransportVelocityField

template <unsigned int Dimension>
void TransportVelocityField( int argc, char *argv[] )
{
  // Input Velocity field
  typedef float VectorComponentType;
  typedef itk::Vector< VectorComponentType, Dimension > VectorPixelType;
  typedef itk::Image< VectorPixelType,  Dimension > ImageType;

  // Read input displacement field
  typedef itk::ImageFileReader< ImageType > ImageReaderType;
  typename ImageReaderType::Pointer VectorFieldReader = ImageReaderType::New( );
  VectorFieldReader->SetFileName( argv[1] );
  try 
  {
    VectorFieldReader->Update();
  }
  catch(itk::ExceptionObject & e)
  {
    std::cout << "Reader Exception caught ! " << e << std::endl;
    exit( EXIT_FAILURE );
  }  

  // Read input displacement field
  typename ImageReaderType::Pointer DisplacementFieldReader = ImageReaderType::New( );
  DisplacementFieldReader->SetFileName( argv[2] );
  try 
  {
    DisplacementFieldReader->Update();
  }
  catch(itk::ExceptionObject & e)
  {
    std::cout << "Reader Exception caught ! " << e << std::endl;
    exit( EXIT_FAILURE );
  }  

  // 1. Warp VelocityFieldImage using input displacement field

  //typedef ImageType::PixelType  PixelType;
  typedef itk::WarpVectorImageFilter<ImageType,ImageType,ImageType> WarperType;
  typename WarperType::Pointer warper = WarperType::New();
  warper->SetInput( VectorFieldReader->GetOutput() );
  warper->SetDeformationField( DisplacementFieldReader->GetOutput() );
  warper->SetEdgePaddingValue(0.0);
  warper->SetOutputSpacing( DisplacementFieldReader->GetOutput()->GetSpacing() );
  warper->SetOutputOrigin( DisplacementFieldReader->GetOutput()->GetOrigin() );
  warper->SetOutputDirection( DisplacementFieldReader->GetOutput()->GetDirection() );
  warper->Update();

  // 2. Invert the input displacement field
  typedef itk::FixedPointInverseDeformationFieldImageFilter<ImageType,ImageType>                                                   InverseDeformationImageFilter;
  //typedef itk::IterativeInverseDeformationFieldImageFilter<ImageType,ImageType>                                                   InverseDeformationImageFilter;
  //typedef itk::InverseDeformationFieldImageFilter<ImageType,ImageType>                                                   InverseDeformationImageFilter;
  typename InverseDeformationImageFilter::Pointer invFilter = InverseDeformationImageFilter::New();
  invFilter->SetInput( DisplacementFieldReader->GetOutput() );

  invFilter->SetOutputOrigin(DisplacementFieldReader->GetOutput()->GetOrigin());
  invFilter->SetSize(DisplacementFieldReader->GetOutput()->GetLargestPossibleRegion().GetSize());
  invFilter->SetOutputSpacing(DisplacementFieldReader->GetOutput()->GetSpacing());
  invFilter->SetNumberOfIterations(20);
  //invFilter->SetOutputSpacing( DisplacementFieldReader->GetOutput()->GetSpacing() );
  //invFilter->SetOutputOrigin( DisplacementFieldReader->GetOutput()->GetOrigin() );
  //invFilter->SetSubsamplingFactor(16u);
  invFilter->Update();
 

/*
  // 2. Smooth displacement field
  typedef itk::DiscreteGaussianImageFilter<ImageType, ImageType> GaussFilterType;
  typename GaussFilterType::Pointer gaussFilter = GaussFilterType::New();
  //gaussFilter->SetInput(DisplacementFieldReader->GetOutput());
  //gaussFilter->SetUseImageSpacing(false);
  //gaussFilter->SetVariance(4.0f);
  //gaussFilter->SetMaximumKernelWidth( 10u );
  //gaussFilter->Update();
*/

  // 3. Create Jacobian image (MatrixPixelType) Image from the inverse displacement field

  typedef itk::DisplacementFieldJacobianFilter< ImageType > JacobianFilterType;
  typename JacobianFilterType::Pointer jacobianFilter = JacobianFilterType::New();
  
  //jacobianFilter->SetInput( DisplacementFieldReader->GetOutput() );
  //jacobianFilter->SetInput( gaussFilter->GetOutput() );
  jacobianFilter->SetInput( invFilter->GetOutput() );
  jacobianFilter->SetUseImageSpacing( false );
  jacobianFilter->Update();

  // 3. Multiply Warped VelocityFieldImage with Jacobian matrix Image
   
  typename ImageType::Pointer image_vec = warper->GetOutput();   
  //typedef itk::Matrix<float,Dimension,Dimension> MatrixPixelType;
  typedef vnl_matrix_fixed<float, Dimension, Dimension> MatrixPixelType;
  typedef itk::Image<MatrixPixelType, Dimension> MatrixImageType;
  typename MatrixImageType::Pointer image_mat = jacobianFilter->GetOutput(); //(MatrixImageType::Pointer) 
  typename ImageType::Pointer output = ImageType::New();  
  
  output->SetRegions( image_vec->GetLargestPossibleRegion() );
  output->SetSpacing( image_vec->GetSpacing() );
  output->SetOrigin( image_vec->GetOrigin() );
  output->SetDirection( image_vec->GetDirection() );
  output->Allocate();
 
  //Iterator
  typedef itk::ImageRegionIterator< ImageType > IteratorType;
  typedef itk::ImageRegionConstIterator< ImageType > ConstIteratorType;
  typedef itk::ImageRegionConstIterator< MatrixImageType > MatrixConstIteratorType;
  ConstIteratorType it_vec( image_vec,image_vec->GetRequestedRegion() );
  MatrixConstIteratorType it_mat( image_mat,image_mat->GetRequestedRegion() );
  IteratorType ot( output, output->GetRequestedRegion() );
 
  vnl_vector_fixed< float, Dimension > vec;
  VectorPixelType out; 
  MatrixPixelType mat, mat_id;
  mat_id.set_identity();
  
  for (ot.GoToBegin(),it_vec.GoToBegin(),it_mat.GoToBegin(); !ot.IsAtEnd(); ++ot, ++it_vec, ++it_mat)
  {
    vec = it_vec.Get().Get_vnl_vector();
    mat = it_mat.Get();
    //out.Set_vnl_vector(vec);
    //out.Set_vnl_vector(vnl_det(mat)*vec);
    //out.Set_vnl_vector(mat.transpose()*vec);
    //mat = mat_id;//mat + 0.1f*vnl_trace(mat)*mat_id;
    //out.Set_vnl_vector(vnl_inverse(mat)*vec);
    //out.Set_vnl_vector(1.0f/vnl_det(mat)*mat*vec);
    out.Set_vnl_vector(mat*vec);
    ot.Set(out);
  }
  
  // 4. Write output Velocity field
  typedef itk::ImageFileWriter<  ImageType  > WriterType;
  typename WriterType::Pointer writer = WriterType::New();
  writer->SetInput(output);
  writer->SetFileName( argv[3] );

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
  if( argc < 4 )
    {
    std::cerr << "Missing Parameters " << std::endl;
    std::cerr << "Usage: " << argv[0];
    std::cerr << " inputVelocityField inputDisplacmentField outputVelocityField" << std::endl;
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
     std::cout << "Could not read the input displacement field." << std::endl;
     std::cout << err << std::endl;
     exit( EXIT_FAILURE );
  }

  // Define dimension on the fly
  switch ( imageIO->GetNumberOfDimensions() )
  {
  case 2:
     TransportVelocityField<2>(argc,argv);
     break;
  case 3:
     TransportVelocityField<3>(argc,argv);
     break;
  default:
     std::cout << "Unsuported dimension" << std::endl;
     exit( EXIT_FAILURE );
  }

  return EXIT_SUCCESS;
}
  

