/*
 *      	File:	 JacobianField.cxx
 *          Date:    4/12/2010
 *          Version: 0.0.1
 *          Author:  Dong Hye Ye
 *      
 *          File Description
 *          Compute Jacobian Determinant from Deformation Field
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
#include <itkCastImageFilter.h>

#include <itkDeformationFieldJacobianDeterminantFilter.h>
#include <itkMinimumMaximumImageCalculator.h>
#include <itkWarpHarmonicEnergyCalculator.h>

template <unsigned int Dimension>
void JacobianField( int argc, char *argv[] )
{
  typedef float PixelType;
  typedef itk::Vector< PixelType, Dimension >    VectorPixelType;
  typedef itk::Image<  VectorPixelType, Dimension > DeformationFieldType;
  typedef itk::ImageFileReader< DeformationFieldType > FieldReaderType;

  typename FieldReaderType::Pointer fieldReader = FieldReaderType::New();
  fieldReader->SetFileName( argv[1] );      
      
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

  typedef itk::DisplacementFieldJacobianDeterminantFilter
	  <DeformationFieldType, PixelType> JacobianFilterType;
  typename JacobianFilterType::Pointer jacobianFilter = JacobianFilterType::New();
  jacobianFilter->SetInput( fieldReader->GetOutput() );
  jacobianFilter->SetUseImageSpacing( true );

  typedef itk::Image< PixelType, Dimension > ImageType;
  typedef itk::CastImageFilter< 
                        ImageType,
                        ImageType > CastFilterType;
  typedef itk::ImageFileWriter< ImageType >  WriterType;

  typename WriterType::Pointer      writer =  WriterType::New();
  typename CastFilterType::Pointer  caster =  CastFilterType::New();

  writer->SetFileName( argv[2] );
  caster->SetInput( jacobianFilter->GetOutput() );
  writer->SetInput( caster->GetOutput() );
  writer->SetUseCompression( true );
  
  try
  {
	  writer->Update();
  }
  catch( itk::ExceptionObject& err )
  {
	  std::cout << "Unexpected error." << std::endl;
      std::cout << err << std::endl;
      exit( EXIT_FAILURE );
  }


  typedef itk::MinimumMaximumImageCalculator<ImageType> MinMaxFilterType;
  typename MinMaxFilterType::Pointer minmaxfilter = MinMaxFilterType::New();
  minmaxfilter->SetImage( jacobianFilter->GetOutput() );
  minmaxfilter->Compute();
    
  /*std::string title(argv[1]);
  title = title.erase(title.rfind("."),4);

  std::ofstream MinJacfile;
  std::string titleMinJac;
  char MinJacstr[10] = "";
  sprintf(MinJacstr,"%.3f",minmaxfilter->GetMinimum());
  titleMinJac = title + "-MinJac" + MinJacstr + ".txt";
  
  MinJacfile.open (titleMinJac.c_str(),std::ios::app);
  MinJacfile <<minmaxfilter->GetMinimum()<<std::endl;
  MinJacfile.close();
  
  std::ofstream MaxJacfile;
  std::string titleMaxJac;
  char MaxJacstr[10] = "";
  sprintf(MaxJacstr,"%.3f",minmaxfilter->GetMaximum());
  titleMaxJac = title + "-MaxJac" + MaxJacstr + ".txt";
  
  MaxJacfile.open (titleMaxJac.c_str(),std::ios::app);
  MaxJacfile <<minmaxfilter->GetMaximum()<<std::endl;
  MaxJacfile.close();*/
  
  typedef itk::WarpHarmonicEnergyCalculator< DeformationFieldType > HarmonicEnergyCalculatorType;

  typename HarmonicEnergyCalculatorType::Pointer HarmonicEnergyCalculator = HarmonicEnergyCalculatorType::New();
  HarmonicEnergyCalculator->SetImage( fieldReader->GetOutput() );
  HarmonicEnergyCalculator->Compute();
  const double harmonicEnergy	= HarmonicEnergyCalculator->GetHarmonicEnergy();
  std::cout<<harmonicEnergy<<' '<<std::endl;
  std::cout<<minmaxfilter->GetMinimum()<<' '<<std::endl;
  std::cout<<minmaxfilter->GetMaximum()<<' '<<std::endl;
  
  /*std::ofstream HEfile;
  std::string titleHE;
  char HEstr[10] = "";
  sprintf(HEstr,"%.3f",harmonicEnergy);
  titleHE = title + "-HE" + HEstr + ".txt";
  
  HEfile.open (titleHE.c_str(),std::ios::app);
  HEfile <<harmonicEnergy<<std::endl;
  HEfile.close();*/
  
}



int main( int argc, char * argv[] )
{
  if( argc < 3 ) 
    { 
    std::cerr << "Usage: " << std::endl;
    std::cerr << argv[0] << " inputFiledFile outputJacobianImage " << std::endl;
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
     JacobianField<2>(argc,argv);
     break;
  case 3:
     JacobianField<3>(argc,argv);
     break;
  default:
     std::cout << "Unsuported dimension" << std::endl;
     exit( EXIT_FAILURE );
  }
	
  return EXIT_SUCCESS;
 }
