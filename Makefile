# (1)Compiler
# g++
CXX = g++

# (2)Compile options
# -Wall -Wextra -std=c++11 -g
CXX_FLAGS = -Wall -Wextra -std=c++11 -g

# (3)Build task directory path
# I do care about out-of-source builds
# ./build
BUILD_DIR ?= ./build

# (4)Source files directory path
# ./src
SRC_DIRS ?= ./source

# (5)Library files directory path
LIBDIR := 

# (6)Add library files
LIBS :=

# (7)Target file, excutable file.
# main
TARGET ?= main

# (8)Source files(code), to be compiled
# Find source files we want to compile 
# *expression must around by single quotos
# # ./src/bank.cpp ./src/main.cpp
SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')

# (9)Object files
# String substituion for every C/C++ file
# e.g: ./src/bank.cpp turns into ./build/bank.cpp.o
# ./build/bank.cpp.o  ./build/main.cpp.o
OBJS := $(patsubst %.cpp, ${BUILD_DIR}/%.cpp.o, $(notdir $(SRCS)))

# (10)Dependency files
# which will generate a .d file next to the .o file. Then to use the .d files,
# you just need to find them all:
# DEPS := $(OBJS:.o=.d)
#
# (11)Include files directory path
# Every folder in ./src find include files to be passed via clang 
# ./include
INC_DIRS := ./include

# (12)Include files add together a prefix, gcc make sense that -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))
# (13)Make Makefiles output Dependency files
# That -MMD and -MP flags together to generate Makefiles 
# That generated Makefiles will take .o as .d to the output
# That "-MMD" and "-MP" To generate the dependency files, all you have to do is
# add some flags to the compile command (supported by both Clang and GCC):
CPP_FLAGS ?= $(INC_FLAGS) -MMD -MP
# (14)Link: Generate executable file from object file
# make your target depend on the objects files:
${BUILD_DIR}/${TARGET} : $(OBJS)
	$(CXX) $(OBJS) -o $@ 
# (15)Compile: Generate object files from source files
# $@ := {TARGET}
# $< := THE first file
# $^ all the dependency
# C++ Sources
$(BUILD_DIR)/%.cpp.o: $(SRC_DIRS)/%.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPP_FLAGS) $(CXX_FLAGS) -c $< -o $@

#(16)Delete dependency files, object files and the target file
.PHONY: all clean 
all: ${BUILD_DIR}/${TARGET} 
clean:
	$(RM) $(DEPS) $(OBJS) ${BUILD_DIR}/${TARGET}

-include $(DEPS)

MKDIR_P ?= mkdir -p
