/*
*    Date:    $Date: 2009-09-30 20:28:45 -0400 (Wed, 30 Sep 2009) $
*    Version: $Revision: 243 $
*    Author:  $Author: kanterae@UPHS.PENNHEALTH.PRV $ 
*    ID:      $Id: invertDeformationField.cxx 243 2009-10-01 00:28:45Z kanterae@UPHS.PENNHEALTH.PRV $
*
*    File Description
*        Compute the inverse deformation field
*
*        Copyright 2011 Jihun Hamm and Donghye Ye
*    
*    This software is distributed WITHOUT ANY WARRANTY; without even
*    the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
*    PURPOSE.  See the above copyright notices for more information.
*
**/
#include <iostream>
#include <getopt.h>
#include <sys/stat.h>

#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkNiftiImageIO.h"
#include "itkImageIOFactory.h"
#include "itkVector.h"
#include "itkCommand.h"
#include "itkIterativeInverseDeformationFieldImageFilter.h"

#include "sbiaBasicUtilities.h"

#define INDENT "\t"
#define EXEC_NAME "invertDeformationField"
#define SVN_FILE_VERSION "$Id: $"

#ifndef SVN_REV
#define SVN_REV ""
#endif

#ifndef RELEASE_ID
#define RELEASE_ID "0.0_super_alpha"
#endif

using namespace std;
using namespace sbia;

void echoVersion()
{
  std::cerr << std::endl << EXEC_NAME << std::endl <<
  INDENT << " Release          : " << RELEASE_ID << std::endl <<
  INDENT << " Svn Revision     : " << SVN_REV << std::endl <<
  INDENT << " Svn File versions: " << SVN_FILE_VERSION << std::endl
  << std::endl;
}

static int verbose = 0;
static string default_ext;


class CommandProgressUpdate : public itk::Command
{
public:
  typedef  CommandProgressUpdate   Self;
  typedef  itk::Command             Superclass;
  typedef itk::SmartPointer<Self>  Pointer;
  itkNewMacro( Self );
protected:
  CommandProgressUpdate() {};
public:
  void Execute(itk::Object *caller, const itk::EventObject & event)
    {
      Execute( (const itk::Object *)caller, event);
    }

  void Execute(const itk::Object * object, const itk::EventObject & event)
    {
      const itk::ProcessObject * filter =
        dynamic_cast< const itk::ProcessObject * >( object );
      if( ! itk::ProgressEvent().CheckEvent( &event ) )
        {
        return;
        }
      std::cout << filter->GetProgress() << std::endl;
    }
};

// echoUsage:display usage information
void echoUsage() {
    std::cerr
    << EXEC_NAME << "--\n"
    << INDENT << EXEC_NAME << " Compute the inverse deformation field using the itk filter.\n\n"
    << "Usage: "<< EXEC_NAME<<" [options]\n"
    << "Required Options:\n"
    << INDENT << "[-d --dataFile]     Specify the input deformation field file (required)\n"
    << INDENT << "[-m --MovingFile]   Specify a scalar image file to determine the output geometry (required)\n"
    << INDENT << "[-p --prefix]       Prefix for result file\n"
    << "Options:\n"
    << INDENT << "[--i terations, -i]   Number of iterations\n"
    << INDENT << "[--usage,   -u]     Display this message\n"
    << INDENT << "[--help,    -h]     Display this message\n"
    << INDENT << "[--Version, -V]     Display version information\n"
    << INDENT << "[--verbose, -v]     Turns on verbose output\n\n"
    << INDENT << "[-o --outputDir]    The output directory to write the results\n"
    << INDENT << "                    Defaults to the location of the input file\n\n";
}

template < typename ImageType >
int
runner(string dataFile, string movingImageFile, string outputBasename, unsigned int NumIter)
{

  typedef itk::IterativeInverseDeformationFieldImageFilter<ImageType,ImageType>
                                                  InverseDeformationImageFilter;

  typename InverseDeformationImageFilter::Pointer filter =
                                    InverseDeformationImageFilter::New();

  typedef itk::ImageFileReader< ImageType  >      ImageReaderType;
  typedef itk::ImageFileWriter< ImageType  >      ImageWriterType;

  //Load the moving image to get the geometry!
  typedef itk::ImageFileReader< itk::Image<float,3> >      MovingImageReaderType;
  typename MovingImageReaderType::Pointer mImageReader = MovingImageReaderType::New();
  mImageReader->SetFileName(  movingImageFile );
  mImageReader->Update();
  typename MovingImageReaderType::OutputImageType::Pointer
                                                 mImage = mImageReader->GetOutput();
  
  typename ImageReaderType::Pointer imageReader = ImageReaderType::New();
  imageReader->SetFileName(  dataFile );

  typename ImageWriterType::Pointer imageWriter = ImageWriterType::New();
  imageWriter->SetFileName(  outputBasename + default_ext );
  imageWriter->SetImageIO( itk::NiftiImageIO::New() );
  //~ imageWriter->SetFileName(  outputBasename + ".mhd" );
  
  imageReader->Update();

  filter->SetInput( imageReader->GetOutput() );

  if (verbose)
  {
    std::cout << "Running InverseDeformation filter " << std::endl;
    typedef CommandProgressUpdate CommandIterationUpdateType;
    typename CommandIterationUpdateType::Pointer observer = CommandIterationUpdateType::New();
    filter->AddObserver( itk::IterationEvent(), observer );
  }
  imageWriter->SetInput( filter->GetOutput() ) ;
//  imageWriter->SetInput( imageReader->GetOutput() ) ;
  filter->SetNumberOfIterations(NumIter);
  filter->Update();
  imageWriter->Update();
  
  return EXIT_SUCCESS;
  
}

int main(int argc, char** argv)
{
  string outputDir="";
  string dataFile,movingFile,prefix;
  int outputDir_flag = 0;
  int prefix_flag = 0;
  unsigned int NumIter = 5;

  static struct option long_options[] =
  {
    {"usage",       no_argument,            0, 'u'},
    {"help",        no_argument,            0, 'h'},
    {"Version",     no_argument,            0, 'V'},
    {"verbose",     no_argument,            0, 'v'},
    {"outputDir",   required_argument,      0, 'o'},
    {"dataFile",    required_argument,      0, 'd'},
    {"movingFile",  required_argument,      0, 'm'},
    {"prefix",      required_argument,      0, 'p'},
    {"iterations",  required_argument,      0, 'i'}
  };

  int c, option_index = 0;
  int reqParams = 0;
  while ( (c = getopt_long (argc, argv, "uhVvno:d:p:m:i:",
              long_options,&option_index)) != -1)
  {
    switch (c)
    {
      case 'u':
        echoUsage();
        return EXIT_SUCCESS;

      case 'h':
        echoUsage();
        return EXIT_SUCCESS;

      case 'V':
        echoVersion();
        return EXIT_SUCCESS;

      case 'v':
        verbose++;
        break;

      case 'i':
        NumIter = atoi(optarg);

      case 'o':
        outputDir = optarg;
        outputDir_flag = 1;
        outputDir += "/";
        break;

      case 'd':
        dataFile = optarg;
        ++reqParams;
        break;

      case 'm':
        movingFile = optarg;
        ++reqParams;
        break;
        
      case 'p':
        prefix = optarg;
        prefix_flag = 1;
        ++reqParams;
        break;

      case '?':
        /* getopt_long already printed an error message. */
        break;

      default:
        abort ();

    }
  }

  if ( reqParams < 3)
  {
    echoUsage();
    cerr << "Please specify all required parameters!\n";
     cerr << reqParams << endl;
   return EXIT_FAILURE;
  }

  // filename parsing
  std::string extension;
  std::string bName;
  std::string path;
  sbia::splitFileName(dataFile,bName,extension,path);
  if (extension == ".img")
  {
    std::cerr << "Please supply a header as input, not an .img !" << std::endl;
    return EXIT_FAILURE;
  }

  std::string outputBasename = "";
  if (outputDir_flag)
    outputBasename += outputDir;
  else
    outputBasename += path;

  if (prefix_flag)
    outputBasename += prefix;
  else
    outputBasename += bName;
  
  default_ext = extension;

  //check for the existence of the input files.
  if (! sbia::fileExists(dataFile))
  {
    std::cerr << dataFile << " Doesn't exist!!!\nExiting!\n\n" << std::endl;
    echoUsage();
    return EXIT_FAILURE;
  }

  if (verbose)
  {
    std::cerr << "dataFile        : " << dataFile << std::endl;
    std::cerr << "outputBaseName  : " << outputBasename << std::endl;
  }

  //read in deformationField and figure out the pixeltype, imageDimension and Order
  itk::ImageIOBase::Pointer imageIO;
  imageIO = itk::ImageIOFactory::CreateImageIO( dataFile.c_str(),
                                        itk::ImageIOFactory::ReadMode);

  if ( imageIO )
  {
    imageIO->SetFileName(dataFile);
    imageIO->ReadImageInformation();

 //Unused
 //   itk::ImageIOBase::IOPixelType pixelType = imageIO->GetPixelType();
    itk::ImageIOBase::IOComponentType componentType = imageIO->GetComponentType();

//    unsigned int imageDimensions = 3; //Will need to get this out somehow?
    ///TODO should error if not 3

    //Get the number of componants per pixel and compute the Order.
    unsigned int nComps = imageIO->GetNumberOfComponents();
    
    if (nComps != 3)
    {
      std::cout << "Unsupported number of componants : " << nComps << std::endl;
      std::cout << "Deformation fields should have 3 components" << std::endl;
      return EXIT_FAILURE;
    }
    
    switch ( componentType )
    {
      case itk::ImageIOBase::FLOAT:
      {
        return runner<itk::Image< itk::Vector<float,3>, 3> >(dataFile, movingFile, outputBasename, NumIter);
      }
      case itk::ImageIOBase::DOUBLE:
      {
        return runner<itk::Image<itk::Vector<double,3>, 3> >(dataFile, movingFile, outputBasename, NumIter);
      }
      default:
      {
        std::cout << "Unsupported componant Type : " << std::endl;
        return EXIT_FAILURE;
      }
    }

  }
  else
  {
    std::cout << "Could not read the input image information from " <<
        dataFile << std::endl;
    return EXIT_FAILURE;
  }
  
}

