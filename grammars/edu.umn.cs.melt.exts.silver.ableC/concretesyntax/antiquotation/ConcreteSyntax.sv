grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax:antiquotation;

imports silver:definition:core;
imports edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;
imports edu:umn:cs:melt:ableC:concretesyntax;

-- AbleC-to-Silver bridge productions
concrete productions top::Declaration_c
| '$Decls' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteDecls(e); }
| '$Decl' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteDecl(e); }
| '$Decl' n::IdLower_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = varDecl(nameIdLower(n, location=n.location)); }
| '$Decl' '_'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = wildDecl(); }
concrete productions top::Stmt_c
| '$Stmt' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteStmt(e); }
| '$Stmt' n::IdLower_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = varStmt(nameIdLower(n, location=n.location)); }
| '$Stmt' '_'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = wildStmt(); }
concrete productions top::Initializer_c
| '$Initializer' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteInitializer(e); }
concrete productions top::PrimaryExpr_c
| '$Exprs' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteExprs(e, location=top.location); }
| '$Expr' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteExpr(e, location=top.location); }
| '$Expr' n::IdLower_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = varExpr(nameIdLower(n, location=n.location), location=top.location); }
| '$Expr' '_'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = wildExpr(location=top.location); }
| '$intLiteralExpr' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteIntLiteralExpr(e, location=top.location); }
| '$stringLiteralExpr' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteStringLiteralExpr(e, location=top.location); }
concrete productions top::Identifier_c
| '$Names' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteNames(e, location=top.location); }
| '$Name' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteName(e, location=top.location); }
| '$Name' n::IdLower_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = varName(nameIdLower(n, location=n.location), location=top.location); }
| '$Name' '_'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = wildName(location=top.location); }
| '$name' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquote_name(e, location=top.location); }
concrete productions top::TypeIdName_c
| '$TName' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteTName(e, location=top.location); }
| '$tname' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquote_tname(e, location=top.location); }
concrete productions top::StorageClassSpecifier_c
| '$StorageClasses' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    top.isTypedef = false;
    top.storageClass = [antiquoteStorageClasses(e, top.location)];
  }
concrete productions top::ParameterDeclaration_c
| '$Parameters' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    top.declaredIdents = [];
    top.ast = antiquoteParameters(e, top.location);
  }
concrete productions top::StructDeclaration_c
| '$StructItemList' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = [antiquoteStructItemList(e, top.location)]; }
concrete productions top::Enumerator_c
| '$EnumItemList' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = [antiquoteEnumItemList(e, top.location)]; }
concrete productions top::TypeName_c
| '$TypeNames' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteTypeNames(e); }
| '$TypeName' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteTypeName(e); }
concrete productions top::TypeSpecifier_c
| '$BaseTypeExpr' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [antiquoteBaseTypeExpr(e)];
    top.preTypeSpecifiers = [];
  }
| '$BaseTypeExpr' n::IdLower_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [varBaseTypeExpr(nameIdLower(n, location=n.location))];
    top.preTypeSpecifiers = [];
  }
| '$BaseTypeExpr' '_'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [wildBaseTypeExpr()];
    top.preTypeSpecifiers = [];
  }
concrete productions top::TypeSpecifier_c
| '$directTypeExpr' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    top.realTypeSpecifiers = [antiquoteDirectTypeExpr(top.givenQualifiers, e, top.location)];
    top.preTypeSpecifiers = [];
  }
concrete productions top::Attrib_c
| '$Attrib' silver:definition:core:LCurly_t e::Expr silver:definition:core:RCurly_t
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteAttrib(e); }
