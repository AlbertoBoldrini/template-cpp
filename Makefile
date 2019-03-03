# Generic Makefile for small projects
# Author: Alberto Boldrini
# ------------------------------------------------------------------------------

# Select the type of compilation (debug or release)
TARGET = debug
OUTPUT = out

# Directories of the project
INCDIR = include
SRCDIR = src
LIBDIR = lib
BINDIR = bin

# Compilator used
COMPILER = g++

# Common flags between debug and release targets
LFLAGS = 
CFLAGS = -Wall -std=c++17 -I$(SRCDIR) -I$(INCDIR) -march=native

# Debug Flags
LFLAGS_DEBUG = $(LFLAGS) -ggdb #-pg
CFLAGS_DEBUG = $(CFLAGS) -ggdb #-pg 

# Release Flags
LFLAGS_RELEASE = $(LFLAGS) -flto
CFLAGS_RELEASE = $(CFLAGS) -Ofast -flto 


# Fixed part of the Makefile
# ------------------------------------------------------------------------------

ifeq ($(TARGET),debug)
  LFLAGS_FINAL = $(LFLAGS_DEBUG)
  CFLAGS_FINAL = $(CFLAGS_DEBUG)
else ifeq ($(TARGET),release)
  LFLAGS_FINAL = $(LFLAGS_RELEASE)
  CFLAGS_FINAL = $(CFLAGS_RELEASE)
else
  $(error Only release or debug Targets are supported)
endif

# Executable filename
EXECUTABLE = $(BINDIR)/$(OUTPUT)

# Retrive and compute the filenames of sources and targets
SOURCENAMES = $(notdir $(wildcard ls $(SRCDIR)/*.c) $(wildcard ls $(SRCDIR)/*.cpp))
OBJECTFILES = $(addprefix $(BINDIR)/$(TARGET)/, $(addsuffix .o, $(SOURCENAMES)))
DEPENDFILES = $(addprefix $(BINDIR)/$(TARGET)/, $(addsuffix .d, $(SOURCENAMES)))

# Create the executable linking the objects
$(EXECUTABLE): $(BINDIR)/$(TARGET) $(OBJECTFILES)
	$(COMPILER) $(LFLAGS_FINAL) $(OBJECTFILES) -o $@
	
# Compile each source unit
$(OBJECTFILES): $(BINDIR)/$(TARGET)/%.o: $(SRCDIR)/%
	$(COMPILER) $(CFLAGS_FINAL) -MMD -MP -c $< -o $@

# Create the directory for the outputs
$(BINDIR)/$(TARGET):
	mkdir -p $(BINDIR)/$(TARGET)

# Include depencences of all sources
-include $(DEPENDFILES)

# Remove the binary folder
clean:
	rm -f $(EXECUTABLE) $(BINDIR)/$(TARGET)/*.o $(BINDIR)/$(TARGET)/*.d
