grammar edu:umn:cs:melt:exts:silver:ableC:composed:ide_with_all;
-- TODO: This file was copied from silver:composed:idetest.  
-- It depends on functions defined in that grammar, so we import it here, although that
-- means that we also import (and build) those parser specs.
-- This is annoying and should be refactored.     
imports silver:composed:idetest;

import silver:host;
import silver:translation:java;
import silver:driver;

import silver:analysis:warnings:flow;
import silver:analysis:warnings:exporting;

-- NOTE: this is needed for the correct generation of IDE, 
-- even if we just use an empty IDE declaration block.
import ide;

-- Just re-use these parser declarations, instead of duplicating them here.
import edu:umn:cs:melt:exts:silver:ableC:composed:with_all only svParse;

-- This function is not used by IDE
function main 
IOVal<Integer> ::= args::[String] ioin::IO
{
  return cmdLineRun(args, svParse, ioin);
}

-- IDE declaration block
temp_imp_ide_dcl svParse ".sv" { 
  builder analyze;
  postbuilder generate;
  exporter export;
  folder fold;

  property grammar_to_compile string required display="Grammar";
  property enable_mwda string default="false" display="Enable MWDA";

  wizard new file {
    stub generator getStubForNewFile; --a function whose signature must be "String ::= args::[IdeProperty]"
    property declared_grammar string required display="Grammar";
  }

  name "Silver-ableC";
  version "0.1.2";
  resource grammars "../../../../../../silver/grammars/";
  resource jars     "../../../../../../silver/jars/";
}

-- Declarations of IDE functions referred in decl block, that are NOT reused
-- from silver:composed:idetest.

function analyze
IOVal<[Message]> ::= project::IdeProject  args::[IdeProperty]  i::IO
{
  local argio :: IOVal<[String]> = getArgStrings(args, project, i);

  local ru :: IOVal<[Message]> = ideAnalyze(argio.iovalue, svParse, argio.io);

  return ru;
}

function generate
IOVal<[Message]> ::= project::IdeProject  args::[IdeProperty]  i::IO
{
  local argio :: IOVal<[String]> = getArgStrings(args, project, i);

  local ru :: IOVal<[Message]> = ideGenerate(argio.iovalue, svParse, argio.io);

  return ru;

}
