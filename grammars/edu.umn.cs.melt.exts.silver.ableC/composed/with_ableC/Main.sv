grammar edu:umn:cs:melt:exts:silver:ableC:composed:with_ableC;

import silver:host;

parser svParse::Root {
  silver:host;
  
  edu:umn:cs:melt:exts:silver:ableC;
}

function main 
IOVal<Integer> ::= args::[String] ioin::IO
{
  return cmdLineRun(args, svParse, ioin);
}
