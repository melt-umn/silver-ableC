grammar edu:umn:cs:melt:exts:silver:ableC:mda_test;

imports silver:composed:Default;
imports edu:umn:cs:melt:ableC:host;

copper_mda testQuote(svParse) {
  edu:umn:cs:melt:exts:silver:ableC:concretesyntax:quotation;
  edu:umn:cs:melt:ableC:concretesyntax;
  edu:umn:cs:melt:ableC:concretesyntax:construction;
}

copper_mda testAntiquote(ablecParser) {
  edu:umn:cs:melt:exts:silver:ableC:concretesyntax:antiquotation;
  silver:host:core;
  silver:extension:patternmatching;
  silver:extension:list;
  silver:modification:let_fix;
}

copper_mda testHostOperators(ablecParser) {
  edu:umn:cs:melt:exts:silver:ableC:concretesyntax:host_operators;
}
