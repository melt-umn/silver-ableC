
# Path from current directory to top level Silver repository
SILVER_BASE?=../../silver
# Path from current directory to top level ableC repository
ABLEC_BASE?=../../ableC
# Path from current directory to top level extensions directory
EXTS_BASE?=../../extensions

# The location where jars will be stored
JAR_DIR=jars
# The location where temporary files will be stored
BUILD_DIR=build
# The jar file to be built
SILVER_JAR=$(JAR_DIR)/edu.umn.cs.melt.exts.silver.ableC.composed.with_all.jar
# All directories containing grammars that may be included
GRAMMAR_DIRS=$(SILVER_BASE)/grammars $(ABLEC_BASE)/grammars $(wildcard $(EXTS_BASE)/*/grammars)
# All silver files in included grammars, to be included as dependancies
GRAMMAR_SOURCES=$(shell find $(GRAMMAR_DIRS) -name *.sv -print0 | xargs -0)

all: $(SILVER_JAR)

$(SILVER_JAR): $(GRAMMAR_SOURCES)
ifeq (,$(wildcard $(SILVER_JAR)))
	./bootstrap-compile
else
	./self-compile
endif

clean:
	rm -rf *~ *.copperdump.html build.xml $(JAR_DIR) $(BUILD_DIR)

.PHONY: all clean
