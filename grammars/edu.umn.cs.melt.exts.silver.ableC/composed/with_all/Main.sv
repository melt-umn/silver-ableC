grammar edu:umn:cs:melt:exts:silver:ableC:composed:with_all;

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
  
  edu:umn:cs:melt:exts:ableC:closure;
  edu:umn:cs:melt:exts:ableC:refCountClosure prefix with "refcount";
  prefer edu:umn:cs:melt:exts:ableC:closure:concretesyntax:typeExpr:Closure_t
    over edu:umn:cs:melt:exts:ableC:refCountClosure:concretesyntax:typeExpr:Closure_t;
  prefer edu:umn:cs:melt:exts:ableC:closure:concretesyntax:lambdaExpr:Lambda_t
    over edu:umn:cs:melt:exts:ableC:refCountClosure:concretesyntax:lambdaExpr:Lambda_t;
  
  edu:umn:cs:melt:exts:ableC:templating;
}

parser sviParse::IRoot {
  silver:host:env;
  silver:definition:flow:env_parser;
  
  silver:modification:collection:env_parser;
  silver:modification:autocopyattr:env_parser;
  silver:modification:ffi:env_parser;
  silver:modification:typedecl:env_parser;
  silver:modification:copper:env_parser;
  silver:modification:impide:env_parser;

  silver:extension:list:env_parser;
}

function main 
IOVal<Integer> ::= args::[String] ioin::IO
{
  return cmdLineRun(args, svParse, sviParse, ioin);
}
