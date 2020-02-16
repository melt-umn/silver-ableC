grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax:quotation;

imports silver:definition:core;
imports silver:extension:patternmatching;
imports edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;
imports edu:umn:cs:melt:ableC:concretesyntax;
imports edu:umn:cs:melt:ableC:concretesyntax:construction;

-- Silver-to-ableC bridge productions
concrete productions top::Expr
| 'ableC_Decls' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::TranslationUnit_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDecls(foldDecl(cst.ast), location=top.location); }
| 'ableC_Decl' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDecl(cst.ast, location=top.location); }
| 'ableC_Decl' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDecl(cst.ast, location=top.location); }
| 'ableC_Parameters' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ParameterList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteParameters(foldParameterDecl(cst.ast), location=top.location); }
| 'ableC_BaseTypeExpr' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::DeclarationSpecifiers_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  {
    cst.givenQualifiers = cst.typeQualifiers;
    forwards to quoteBaseTypeExpr(figureOutTypeFromSpecifiers(cst.location, cst.typeQualifiers, cst.preTypeSpecifiers, cst.realTypeSpecifiers, cst.mutateTypeSpecifiers), location=top.location);
  }
| 'ableC_Stmt' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::BlockItemList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteStmt(foldStmt(cst.ast), location=top.location); }
| 'ableC_Expr' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExpr(cst.ast, location=top.location); }
| 'ableC_Expr' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExpr(cst.ast, location=top.location); }

concrete productions top::Pattern
| 'ableC_Decls' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::TranslationUnit_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDeclsPattern(foldDecl(cst.ast), location=top.location); }
| 'ableC_Decl' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDeclPattern(cst.ast, location=top.location); }
| 'ableC_Decl' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDeclPattern(cst.ast, location=top.location); }
| 'ableC_Parameters' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ParameterList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteParametersPattern(foldParameterDecl(cst.ast), location=top.location); }
| 'ableC_BaseTypeExpr' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::DeclarationSpecifiers_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  {
    cst.givenQualifiers = cst.typeQualifiers;
    forwards to quoteBaseTypeExprPattern(figureOutTypeFromSpecifiers(cst.location, cst.typeQualifiers, cst.preTypeSpecifiers, cst.realTypeSpecifiers, cst.mutateTypeSpecifiers), location=top.location);
  }
| 'ableC_Stmt' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::BlockItemList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteStmtPattern(foldStmt(cst.ast), location=top.location); }
| 'ableC_Expr' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExprPattern(cst.ast, location=top.location); }
| 'ableC_Expr' edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExprPattern(cst.ast, location=top.location); }
