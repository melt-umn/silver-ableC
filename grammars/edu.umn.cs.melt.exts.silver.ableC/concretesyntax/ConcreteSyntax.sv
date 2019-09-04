grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax;

--imports silver:langutil;

imports silver:definition:core;
imports silver:extension:patternmatching;
imports edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

exports edu:umn:cs:melt:ableC:concretesyntax;
exports edu:umn:cs:melt:ableC:concretesyntax:construction;

-- Silver-to-ableC bridge productions
concrete productions top::Expr
| 'ableC_Decls' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::TranslationUnit_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteDecls(foldDecl(cst.ast), location=top.location); }
| 'ableC_Decl' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteDecl(cst.ast, location=top.location); }
| 'ableC_Decl' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteDecl(cst.ast, location=top.location); }
| 'ableC_Parameters' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ParameterList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteParameters(foldParameterDecl(cst.ast), location=top.location); }
| 'ableC_BaseTypeExpr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::DeclarationSpecifiers_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  {
    cst.givenQualifiers = cst.typeQualifiers;
    forwards to quoteBaseTypeExpr(figureOutTypeFromSpecifiers(cst.location, cst.typeQualifiers, cst.preTypeSpecifiers, cst.realTypeSpecifiers, cst.mutateTypeSpecifiers), location=top.location);
  }
| 'ableC_Stmt' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::BlockItemList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteStmt(foldStmt(cst.ast), location=top.location); }
| 'ableC_Expr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteExpr(cst.ast, location=top.location); }
| 'ableC_Expr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteExpr(cst.ast, location=top.location); }

concrete productions top::Pattern
| 'ableC_Decls' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::TranslationUnit_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteDeclsPattern(foldDecl(cst.ast), location=top.location); }
| 'ableC_Decl' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteDeclPattern(cst.ast, location=top.location); }
| 'ableC_Decl' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteDeclPattern(cst.ast, location=top.location); }
| 'ableC_Parameters' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ParameterList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteParametersPattern(foldParameterDecl(cst.ast), location=top.location); }
| 'ableC_BaseTypeExpr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::DeclarationSpecifiers_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  {
    cst.givenQualifiers = cst.typeQualifiers;
    forwards to quoteBaseTypeExprPattern(figureOutTypeFromSpecifiers(cst.location, cst.typeQualifiers, cst.preTypeSpecifiers, cst.realTypeSpecifiers, cst.mutateTypeSpecifiers), location=top.location);
  }
| 'ableC_Stmt' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::BlockItemList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteStmtPattern(foldStmt(cst.ast), location=top.location); }
| 'ableC_Expr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteExprPattern(cst.ast, location=top.location); }
| 'ableC_Expr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to quoteExprPattern(cst.ast, location=top.location); }

-- AbleC-to-Silver bridge productions
concrete productions top::Declaration_c
| '$Decls' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteDecls(e); }
| '$Decl' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteDecl(e); }
| '$Decl' n::Identifier_t
  { top.ast = varDecl(name(n.lexeme, n.location)); }
| '$Decl' '_'
  { top.ast = wildDecl(); }
concrete productions top::Stmt_c
| '$Stmt' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteStmt(e); }
| '$Stmt' n::Identifier_t
  { top.ast = varStmt(name(n.lexeme, n.location)); }
| '$Stmt' '_'
  { top.ast = wildStmt(); }
concrete productions top::Initializer_c
| '$Initializer' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteInitializer(e); }
concrete productions top::PrimaryExpr_c
| '$Exprs' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteExprs(e, location=top.location); }
| '$Expr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteExpr(e, location=top.location); }
| '$Expr' n::Identifier_t
  { top.ast = varExpr(name(n.lexeme, n.location), location=top.location); }
| '$Expr' '_'
  { top.ast = wildExpr(location=top.location); }
| '$intLiteralExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteIntLiteralExpr(e, location=top.location); }
| '$stringLiteralExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteStringLiteralExpr(e, location=top.location); }
concrete productions top::Identifier_c
| '$Names' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteNames(e, location=top.location); }
| '$Name' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteName(e, location=top.location); }
| '$Name' n::Identifier_t
  { top.ast = varName(name(n.lexeme, n.location), location=top.location); }
| '$Name' '_'
  { top.ast = wildName(location=top.location); }
| '$name' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquote_name(e, location=top.location); }
concrete productions top::TypeIdName_c
| '$TName' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteTName(e, location=top.location); }
| '$tname' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquote_tname(e, location=top.location); }
concrete productions top::StorageClassSpecifier_c
| '$StorageClasses' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    top.isTypedef = false;
    top.storageClass = [antiquoteStorageClasses(e, top.location)];
  }
concrete productions top::ParameterDeclaration_c
| '$Parameters' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    top.declaredIdents = [];
    top.ast = antiquoteParameters(e, top.location);
  }
concrete productions top::StructDeclaration_c
| '$StructItemList' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = [antiquoteStructItemList(e, top.location)]; }
concrete productions top::Enumerator_c
| '$EnumItemList' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = [antiquoteEnumItemList(e, top.location)]; }
concrete productions top::TypeName_c
| '$TypeNames' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteTypeNames(e); }
| '$TypeName' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteTypeName(e); }
concrete productions top::TypeSpecifier_c
| '$BaseTypeExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [antiquoteBaseTypeExpr(e)];
    top.preTypeSpecifiers = [];
  }
| '$BaseTypeExpr' n::Identifier_t
  { -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [varBaseTypeExpr(name(n.lexeme, n.location))];
    top.preTypeSpecifiers = [];
  }
| '$BaseTypeExpr' '_'
  { -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [wildBaseTypeExpr()];
    top.preTypeSpecifiers = [];
  }
concrete productions top::TypeSpecifier_c
| '$directTypeExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    top.realTypeSpecifiers = [antiquoteDirectTypeExpr(top.givenQualifiers, e, top.location)];
    top.preTypeSpecifiers = [];
  }
concrete productions top::Attrib_c
| '$Attrib' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = antiquoteAttrib(e); }
