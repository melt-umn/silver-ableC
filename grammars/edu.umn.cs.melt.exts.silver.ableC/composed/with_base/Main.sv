grammar edu:umn:cs:melt:exts:silver:ableC:composed:with_base;

import silver:host;
import silver:translation:java;
import silver:driver;

import silver:extension:doc;
import silver:analysis:warnings:flow;
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
  silver:extension:astconstruction;
  silver:extension:silverconstruction;
  silver:extension:constructparser;
  
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
  edu:umn:cs:melt:exts:ableC:templating:silverconstruction;
  edu:umn:cs:melt:exts:ableC:string;
  edu:umn:cs:melt:exts:ableC:constructor;
}

function main 
IOVal<Integer> ::= args::[String] ioin::IO
{
  return cmdLineRun(args, svParse, ioin);
}
