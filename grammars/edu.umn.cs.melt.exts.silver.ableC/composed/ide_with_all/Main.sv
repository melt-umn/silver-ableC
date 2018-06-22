grammar edu:umn:cs:melt:exts:silver:ableC:composed:ide_with_all;
-- TODO: This file was copied from silver:composed:idetest.  
-- It depends on Analyze.sv and Folding.sv from that grammar, so we import it here, although that
-- means that we also import (and build) those parser specs.
-- This is annoying and should be refactored.     
imports silver:composed:idetest;

import silver:host;
import silver:host:env;
import silver:translation:java;
import silver:driver;

import silver:analysis:warnings:defs;
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

  wizard new file {
    stub generator getStubForNewFile; --a function whose signature must be "String ::= args::[IdeProperty]"
    property declared_grammar string required display="Grammar";
  }

  name "Silver-ableC";
  version "0.1.1";
  resource grammars "../../../../../../silver/grammars/";
  resource jars     "../../../../../../silver/jars/";
}

-- Declarations of IDE functions referred in decl block.

function analyze
IOVal<[IdeMessage]> ::= project::IdeProject  args::[IdeProperty]  i::IO
{
  local argio :: IOVal<[String]> = getArgStrings(args, project, i);

  local ru :: IOVal<[IdeMessage]> = ideAnalyze(argio.iovalue, svParse, argio.io);

  return ru;
}

function generate
IOVal<[IdeMessage]> ::= project::IdeProject  args::[IdeProperty]  i::IO
{
  local argio :: IOVal<[String]> = getArgStrings(args, project, i);

  local ru :: IOVal<[IdeMessage]> = ideGenerate(argio.iovalue, svParse, argio.io);

  return ru;

}

function export
IOVal<[IdeMessage]> ::= project::IdeProject  args::[IdeProperty]  i::IO
{
  local proj_path :: IOVal<String> = getProjectPath(project, i);
  local gen_path :: IOVal<String> = getGeneratedPath(project, proj_path.io);

  local pkgName :: String = makeName(head(getGrammarToCompile(args)));
  local buildFile :: String = gen_path.iovalue ++ "/build.xml";
  local jarFile :: String = gen_path.iovalue ++ "/" ++ pkgName ++ ".jar";
  local targetFile :: String = proj_path.iovalue ++ "/" ++ pkgName ++ ".jar";

  local fileExists :: IOVal<Boolean> = isFile(buildFile, gen_path.io);

  local jarExists :: IOVal<Boolean> = isFile(jarFile, ant(buildFile, "", "", fileExists.io));

  return if !fileExists.iovalue then
    ioval(fileExists.io, [makeSysIdeMessage(ideMsgLvError, "build.xml doesn't exist. Has the project been successfully built before?")])
  else if !jarExists.iovalue then
    ioval(jarExists.io, [makeSysIdeMessage(ideMsgLvError, "Ant failed to generate the jar.")])
  else
    ioval(refreshProject(project, copyFile(jarFile, targetFile, jarExists.io)), []);
}

function fold
[Location] ::= cst::Root
{
    return cst.foldableRanges; -- see ./Folding.sv
}

function getStubForNewFile
String ::= args::[IdeProperty]
{
    local gram :: Maybe<String> = lookupIdeProperty("declared_grammar", args);
    return if gram.isJust
    then "grammar " ++ gram.fromJust ++ ";\n\n"
    else "";
}

function getArgStrings
IOVal<[String]> ::= args::[IdeProperty] project::IdeProject io::IO
{
  local jarsio :: IOVal<String> = getIdeResource("jars", io);
  local grammarsio :: IOVal<String> = getIdeResource("grammars", jarsio.io);
  local proj_path :: IOVal<String> = getProjectPath(project, grammarsio.io);
  local gen_path :: IOVal<String> = getGeneratedPath(project, proj_path.io);
  
  local compile_args :: [String] =
    [
     "--silver-home", jarsio.iovalue ++ "..",
     "-G", gen_path.iovalue,
     "-I", proj_path.iovalue,
     --"-I", grammarsio.iovalue, -- This actually get automatically added, by virtue of silver home finding grammars under it
     "--build-xml-location", gen_path.iovalue ++ "/build.xml"] ++
     getGrammarToCompile(args);
  
  return ioval(gen_path.io, compile_args);
}

function getGrammarToCompile
[String] ::= args::[IdeProperty]
{
  return
    if(null(args))
    then []
    else if head(args).propName == "grammar_to_compile"
	    then [head(args).propValue]
	    else getGrammarToCompile(tail(args));
}

