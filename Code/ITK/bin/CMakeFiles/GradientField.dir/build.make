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
include CMakeFiles/GradientField.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/GradientField.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/GradientField.dir/flags.make

CMakeFiles/GradientField.dir/GradientField.cxx.o: CMakeFiles/GradientField.dir/flags.make
CMakeFiles/GradientField.dir/GradientField.cxx.o: ../GradientField.cxx
	$(CMAKE_COMMAND) -E cmake_progress_report /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/GradientField.dir/GradientField.cxx.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/GradientField.dir/GradientField.cxx.o -c /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/GradientField.cxx

CMakeFiles/GradientField.dir/GradientField.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GradientField.dir/GradientField.cxx.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/GradientField.cxx > CMakeFiles/GradientField.dir/GradientField.cxx.i

CMakeFiles/GradientField.dir/GradientField.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GradientField.dir/GradientField.cxx.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/GradientField.cxx -o CMakeFiles/GradientField.dir/GradientField.cxx.s

CMakeFiles/GradientField.dir/GradientField.cxx.o.requires:
.PHONY : CMakeFiles/GradientField.dir/GradientField.cxx.o.requires

CMakeFiles/GradientField.dir/GradientField.cxx.o.provides: CMakeFiles/GradientField.dir/GradientField.cxx.o.requires
	$(MAKE) -f CMakeFiles/GradientField.dir/build.make CMakeFiles/GradientField.dir/GradientField.cxx.o.provides.build
.PHONY : CMakeFiles/GradientField.dir/GradientField.cxx.o.provides

CMakeFiles/GradientField.dir/GradientField.cxx.o.provides.build: CMakeFiles/GradientField.dir/GradientField.cxx.o
.PHONY : CMakeFiles/GradientField.dir/GradientField.cxx.o.provides.build

# Object files for target GradientField
GradientField_OBJECTS = \
"CMakeFiles/GradientField.dir/GradientField.cxx.o"

# External object files for target GradientField
GradientField_EXTERNAL_OBJECTS =

GradientField: CMakeFiles/GradientField.dir/GradientField.cxx.o
GradientField: /usr/lib/libuuid.so
GradientField: CMakeFiles/GradientField.dir/build.make
GradientField: CMakeFiles/GradientField.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable GradientField"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/GradientField.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/GradientField.dir/build: GradientField
.PHONY : CMakeFiles/GradientField.dir/build

CMakeFiles/GradientField.dir/requires: CMakeFiles/GradientField.dir/GradientField.cxx.o.requires
.PHONY : CMakeFiles/GradientField.dir/requires

CMakeFiles/GradientField.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/GradientField.dir/cmake_clean.cmake
.PHONY : CMakeFiles/GradientField.dir/clean

CMakeFiles/GradientField.dir/depend:
	cd /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin /home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/ITK/bin/CMakeFiles/GradientField.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/GradientField.dir/depend
