grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax;

--imports silver:langutil;

imports silver:definition:core;
imports edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

exports edu:umn:cs:melt:ableC:concretesyntax;
exports edu:umn:cs:melt:ableC:concretesyntax:construction;

-- Silver-to-ableC bridge productions
concrete productions top::Expr
| 'ableC_Decls' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::TranslationUnit_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to ableCDeclsLiteral(foldDecl(cst.ast), location=top.location); }
| 'ableC_Decl' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to ableCDeclLiteral(cst.ast, location=top.location); }
| 'ableC_Decl' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::ExternalDeclaration_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to ableCDeclLiteral(cst.ast, location=top.location); }
| 'ableC_Parameters' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::ParameterList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to ableCParametersLiteral(foldParameterDecl(cst.ast), location=top.location); }
| 'ableC_BaseTypeExpr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::DeclarationSpecifiers_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { cst.givenQualifiers = cst.typeQualifiers;
    forwards to ableCBaseTypeExprLiteral(figureOutTypeFromSpecifiers(cst.location, cst.typeQualifiers, cst.preTypeSpecifiers, cst.realTypeSpecifiers, cst.mutateTypeSpecifiers), location=top.location); }
| 'ableC_Stmt' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::BlockItemList_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to ableCStmtLiteral(foldStmt(cst.ast), location=top.location); }
| 'ableC_Expr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to ableCExprLiteral(cst.ast, location=top.location); }
| 'ableC_Expr' InAbleC edu:umn:cs:melt:ableC:concretesyntax:LCurly_t ProtoTypedef_c cst::Expr_c edu:umn:cs:melt:ableC:concretesyntax:RCurly_t NotInAbleC
  { forwards to ableCExprLiteral(cst.ast, location=top.location); }

-- AbleC-to-Silver bridge productions
concrete productions top::Declaration_c
| '$Decls' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeDecls(e); }
| '$Decl' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeDecl(e); }
concrete productions top::BlockItem_c
| '$Stmt' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = [escapeStmt(e)]; }
concrete productions top::Initializer_c
| '$Initializer' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeInitializer(e); }
concrete productions top::PrimaryExpr_c
| '$Exprs' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeExprs(e, location=top.location); }
| '$Expr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeExpr(e, location=top.location); }
| '$intLiteralExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeIntLiteralExpr(e, location=top.location); }
| '$stringLiteralExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeStringLiteralExpr(e, location=top.location); }
concrete productions top::Identifier_c
| '$Name' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeName(e, location=top.location); }
| '$name' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escape_name(e, location=top.location); }
concrete productions top::TypeIdName_c
| '$TName' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeTName(e, location=top.location); }
| '$tname' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escape_tname(e, location=top.location); }
concrete productions top::StorageClassSpecifier_c
| '$StorageClasses' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    top.isTypedef = false;
    top.storageClass = [escapeStorageClasses(e, top.location)];
  }
concrete productions top::ParameterDeclaration_c
| '$Parameters' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    top.declaredIdents = [];
    top.ast = escapeParameters(e, top.location);
  }
concrete productions top::TypeName_c
| '$TypeName' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeTypeName(e); }
concrete productions top::TypeSpecifier_c
| '$BaseTypeExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [escapeBaseTypeExpr(e)];
    top.preTypeSpecifiers = [];
  }
concrete productions top::TypeSpecifier_c
| '$directTypeExpr' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  {
    top.realTypeSpecifiers = [escapeDirectTypeExpr(top.givenQualifiers, e, top.location)];
    top.preTypeSpecifiers = [];
  }
concrete productions top::Attrib_c
| '$Attrib' NotInAbleC silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t InAbleC
  { top.ast = escapeAttrib(e); }
