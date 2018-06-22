grammar edu:umn:cs:melt:exts:silver:ableC:composed:with_ableC;

import silver:host;
import silver:host:env;
import silver:translation:java;
import silver:driver;

import silver:extension:doc;
import silver:analysis:warnings:defs;
import silver:analysis:warnings:exporting;

parser svParse::Root {
  silver:host;

  silver:extension:convenience;
  silver:extension:list;
  silver:extension:easyterminal;
  silver:extension:deprecation;
  silver:extension:testing;
  silver:extension:auto_ast;
  silver:extension:templating;
  silver:extension:patternmatching;
  silver:extension:treegen;
  silver:extension:doc;
  silver:extension:functorattrib;
  silver:extension:monad;
  silver:extension:reflection;
  silver:extension:silverconstruction;
  
  silver:modification:let_fix;
  silver:modification:lambda_fn;
  silver:modification:collection;
  silver:modification:primitivepattern;
  silver:modification:autocopyattr;
  silver:modification:ffi;
  silver:modification:typedecl;
  silver:modification:copper;
  silver:modification:defaultattr;
  silver:modification:copper_mda;
  silver:modification:impide;
  
  edu:umn:cs:melt:exts:silver:ableC;
}

function main 
IOVal<Integer> ::= args::[String] ioin::IO
{
  return cmdLineRun(args, svParse, ioin);
}
