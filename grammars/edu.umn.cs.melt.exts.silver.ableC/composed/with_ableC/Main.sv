grammar edu:umn:cs:melt:exts:silver:ableC:composed:with_ableC;

import silver:compiler:host;

parser svParse::Root {
  silver:compiler:host;
  
  edu:umn:cs:melt:exts:silver:ableC;
  edu:umn:cs:melt:exts:silver:ableC:concretesyntax:host_operators prefix with "host";
}

function main 
IOVal<Integer> ::= args::[String] ioin::IOToken
{
  return evalIO(cmdLineRun(args, svParse), ioin);
}
