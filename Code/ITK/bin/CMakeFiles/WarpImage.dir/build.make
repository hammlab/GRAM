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
include CMakeFiles/WarpImage.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/WarpImage.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/WarpImage.dir/flags.make

CMakeFiles/WarpImage.dir/WarpImage.cxx.o: CMakeFiles/WarpImage.dir/flags.make
CMakeFiles/WarpImage.dir/WarpImage.cxx.o: ../WarpImage.cxx
	$(CMAKE_COMMAND) -E cmake_progress_report /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/WarpImage.dir/WarpImage.cxx.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/WarpImage.dir/WarpImage.cxx.o -c /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/WarpImage.cxx

CMakeFiles/WarpImage.dir/WarpImage.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/WarpImage.dir/WarpImage.cxx.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/WarpImage.cxx > CMakeFiles/WarpImage.dir/WarpImage.cxx.i

CMakeFiles/WarpImage.dir/WarpImage.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/WarpImage.dir/WarpImage.cxx.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/WarpImage.cxx -o CMakeFiles/WarpImage.dir/WarpImage.cxx.s

CMakeFiles/WarpImage.dir/WarpImage.cxx.o.requires:
.PHONY : CMakeFiles/WarpImage.dir/WarpImage.cxx.o.requires

CMakeFiles/WarpImage.dir/WarpImage.cxx.o.provides: CMakeFiles/WarpImage.dir/WarpImage.cxx.o.requires
	$(MAKE) -f CMakeFiles/WarpImage.dir/build.make CMakeFiles/WarpImage.dir/WarpImage.cxx.o.provides.build
.PHONY : CMakeFiles/WarpImage.dir/WarpImage.cxx.o.provides

CMakeFiles/WarpImage.dir/WarpImage.cxx.o.provides.build: CMakeFiles/WarpImage.dir/WarpImage.cxx.o
.PHONY : CMakeFiles/WarpImage.dir/WarpImage.cxx.o.provides.build

# Object files for target WarpImage
WarpImage_OBJECTS = \
"CMakeFiles/WarpImage.dir/WarpImage.cxx.o"

# External object files for target WarpImage
WarpImage_EXTERNAL_OBJECTS =

WarpImage: CMakeFiles/WarpImage.dir/WarpImage.cxx.o
WarpImage: /usr/lib/libuuid.so
WarpImage: CMakeFiles/WarpImage.dir/build.make
WarpImage: CMakeFiles/WarpImage.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable WarpImage"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/WarpImage.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/WarpImage.dir/build: WarpImage
.PHONY : CMakeFiles/WarpImage.dir/build

CMakeFiles/WarpImage.dir/requires: CMakeFiles/WarpImage.dir/WarpImage.cxx.o.requires
.PHONY : CMakeFiles/WarpImage.dir/requires

CMakeFiles/WarpImage.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/WarpImage.dir/cmake_clean.cmake
.PHONY : CMakeFiles/WarpImage.dir/clean

CMakeFiles/WarpImage.dir/depend:
	cd /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin/CMakeFiles/WarpImage.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/WarpImage.dir/depend

