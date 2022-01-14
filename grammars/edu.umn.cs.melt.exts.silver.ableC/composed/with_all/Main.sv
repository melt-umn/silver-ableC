grammar edu:umn:cs:melt:exts:silver:ableC:composed:with_all;

import silver:compiler:host;

parser svParse::Root {
  silver:compiler:host;
  
  edu:umn:cs:melt:exts:silver:ableC;
  edu:umn:cs:melt:exts:silver:ableC:concretesyntax:host_operators prefix with "host";
  
  edu:umn:cs:melt:exts:ableC:closure;
  edu:umn:cs:melt:exts:ableC:refCountClosure prefix with "refcount";
  prefer edu:umn:cs:melt:exts:ableC:closure:concretesyntax:typeExpr:Closure_t
    over edu:umn:cs:melt:exts:ableC:refCountClosure:concretesyntax:typeExpr:Closure_t,
         edu:umn:cs:melt:ableC:concretesyntax:Identifier_t,
         edu:umn:cs:melt:ableC:concretesyntax:TypeName_t,
         edu:umn:cs:melt:exts:ableC:templating:concretesyntax:instantiationExpr:TemplateIdentifier_t,
         edu:umn:cs:melt:exts:ableC:templating:concretesyntax:instantiationTypeExpr:TemplateTypeName_t;
  prefer edu:umn:cs:melt:exts:ableC:closure:concretesyntax:lambdaExpr:Lambda_t
    over edu:umn:cs:melt:exts:ableC:refCountClosure:concretesyntax:lambdaExpr:Lambda_t,
         edu:umn:cs:melt:ableC:concretesyntax:Identifier_t,
         edu:umn:cs:melt:ableC:concretesyntax:TypeName_t,
         edu:umn:cs:melt:exts:ableC:templating:concretesyntax:instantiationExpr:TemplateIdentifier_t,
         edu:umn:cs:melt:exts:ableC:templating:concretesyntax:instantiationTypeExpr:TemplateTypeName_t;
  
  edu:umn:cs:melt:exts:ableC:templating;
  edu:umn:cs:melt:exts:ableC:templating:silverconstruction;
  edu:umn:cs:melt:exts:ableC:string;
  edu:umn:cs:melt:exts:ableC:constructor;
  edu:umn:cs:melt:exts:ableC:algebraicDataTypes;
  edu:umn:cs:melt:exts:ableC:algebraicDataTypes:silverconstruction;
  edu:umn:cs:melt:exts:ableC:templateAlgebraicDataTypes;
}

function main 
IOVal<Integer> ::= args::[String] ioin::IOToken
{
  return cmdLineRun(args, svParse, ioin);
}
