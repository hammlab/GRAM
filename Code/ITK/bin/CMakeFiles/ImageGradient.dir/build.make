# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canoncical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin

# Include any dependencies generated for this target.
include CMakeFiles/ImageGradient.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/ImageGradient.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ImageGradient.dir/flags.make

CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o: CMakeFiles/ImageGradient.dir/flags.make
CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o: ../ImageGradient.cxx
	$(CMAKE_COMMAND) -E cmake_progress_report /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o -c /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/ImageGradient.cxx

CMakeFiles/ImageGradient.dir/ImageGradient.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ImageGradient.dir/ImageGradient.cxx.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/ImageGradient.cxx > CMakeFiles/ImageGradient.dir/ImageGradient.cxx.i

CMakeFiles/ImageGradient.dir/ImageGradient.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ImageGradient.dir/ImageGradient.cxx.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/ImageGradient.cxx -o CMakeFiles/ImageGradient.dir/ImageGradient.cxx.s

CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.requires:
.PHONY : CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.requires

CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.provides: CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.requires
	$(MAKE) -f CMakeFiles/ImageGradient.dir/build.make CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.provides.build
.PHONY : CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.provides

CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.provides.build: CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o
.PHONY : CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.provides.build

# Object files for target ImageGradient
ImageGradient_OBJECTS = \
"CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o"

# External object files for target ImageGradient
ImageGradient_EXTERNAL_OBJECTS =

ImageGradient: CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o
ImageGradient: /usr/lib/libuuid.so
ImageGradient: CMakeFiles/ImageGradient.dir/build.make
ImageGradient: CMakeFiles/ImageGradient.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable ImageGradient"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ImageGradient.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ImageGradient.dir/build: ImageGradient
.PHONY : CMakeFiles/ImageGradient.dir/build

CMakeFiles/ImageGradient.dir/requires: CMakeFiles/ImageGradient.dir/ImageGradient.cxx.o.requires
.PHONY : CMakeFiles/ImageGradient.dir/requires

CMakeFiles/ImageGradient.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ImageGradient.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ImageGradient.dir/clean

CMakeFiles/ImageGradient.dir/depend:
	cd /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin/CMakeFiles/ImageGradient.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/ImageGradient.dir/depend
