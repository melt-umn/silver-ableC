grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax:quotation;

imports silver:definition:core
  hiding LCurly_t, RCurly_t; -- We only use the ones from ableC, makes '{' terminal syntax unambigous
imports silver:extension:patternmatching;
imports edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;
imports edu:umn:cs:melt:ableC:concretesyntax;
imports edu:umn:cs:melt:ableC:concretesyntax:construction;

-- Silver-to-ableC bridge productions
concrete productions top::Expr
| 'ableC_Decls' '{' cst::TranslationUnit_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDecls(foldDecl(cst.ast), location=top.location); }
| 'ableC_Decl' '{' cst::ExternalDeclaration_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDecl(cst.ast, location=top.location); }
| 'ableC_Decl' '{' ProtoTypedef_c cst::ExternalDeclaration_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDecl(cst.ast, location=top.location); }
| 'ableC_Parameters' '{' cst::ParameterList_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteParameters(foldParameterDecl(cst.ast), location=top.location); }
| 'ableC_BaseTypeExpr' '{' cst::DeclarationSpecifiers_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  {
    cst.givenQualifiers = cst.typeQualifiers;
    forwards to quoteBaseTypeExpr(figureOutTypeFromSpecifiers(cst.location, cst.typeQualifiers, cst.preTypeSpecifiers, cst.realTypeSpecifiers, cst.mutateTypeSpecifiers), location=top.location);
  }
| 'ableC_Stmt' '{' cst::BlockItemList_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteStmt(foldStmt(cst.ast), location=top.location); }
| 'ableC_Expr' '{' cst::Expr_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExpr(cst.ast, location=top.location); }
| 'ableC_Expr' '{' ProtoTypedef_c cst::Expr_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExpr(cst.ast, location=top.location); }

concrete productions top::Pattern
| 'ableC_Decls' BeginPattern_t '{' cst::TranslationUnit_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDeclsPattern(foldDecl(cst.ast), location=top.location); }
  action { inPattern = false; }
| 'ableC_Decl' BeginPattern_t '{' cst::ExternalDeclaration_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDeclPattern(cst.ast, location=top.location); }
  action { inPattern = false; }
| 'ableC_Decl' BeginPattern_t '{' ProtoTypedef_c cst::ExternalDeclaration_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteDeclPattern(cst.ast, location=top.location); }
  action { inPattern = false; }
| 'ableC_Parameters' BeginPattern_t '{' cst::ParameterList_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteParametersPattern(foldParameterDecl(cst.ast), location=top.location); }
  action { inPattern = false; }
| 'ableC_BaseTypeExpr' BeginPattern_t '{' cst::DeclarationSpecifiers_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  {
    cst.givenQualifiers = cst.typeQualifiers;
    forwards to quoteBaseTypeExprPattern(figureOutTypeFromSpecifiers(cst.location, cst.typeQualifiers, cst.preTypeSpecifiers, cst.realTypeSpecifiers, cst.mutateTypeSpecifiers), location=top.location);
  }
  action { inPattern = false; }
| 'ableC_Stmt' BeginPattern_t '{' cst::BlockItemList_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteStmtPattern(foldStmt(cst.ast), location=top.location); }
  action { inPattern = false; }
| 'ableC_Expr' BeginPattern_t '{' cst::Expr_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExprPattern(cst.ast, location=top.location); }
  action { inPattern = false; }
| 'ableC_Expr' BeginPattern_t '{' ProtoTypedef_c cst::Expr_c '}'
  layout {LineComment_t, BlockComment_t, Spaces_t, NewLine_t}
  { forwards to quoteExprPattern(cst.ast, location=top.location); }
  action { inPattern = false; }
