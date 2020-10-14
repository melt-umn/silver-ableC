grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax:antiquotation;

imports silver:definition:core;
imports silver:extension:patternmatching;
imports edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;
imports edu:umn:cs:melt:ableC:concretesyntax
  hiding LCurly_t, RCurly_t; -- We only use the ones from Silver, makes '{' terminal syntax unambigous

-- AbleC-to-Silver bridge productions
concrete productions top::Declaration_c
| '$Decls' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteDecls(e); }
| AntiquoteDecl_t '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteDecl(e); }
| AntiquoteDeclPattern_t '{' p::Pattern '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquotePatternDecl(p); }
concrete productions top::Stmt_c
| AntiquoteStmt_t '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteStmt(e); }
| AntiquoteStmtPattern_t '{' p::Pattern '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquotePatternStmt(p); }
concrete productions top::Initializer_c
| '$Initializer' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteInitializer(e, location=top.location); }
concrete productions top::PrimaryExpr_c
| '$Exprs' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteExprs(e, location=top.location); }
| AntiquoteExpr_t '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteExpr(e, location=top.location); }
| AntiquoteExprPattern_t '{' p::Pattern '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquotePatternExpr(p, location=top.location); }
| '$intLiteralExpr' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteIntLiteralExpr(e, location=top.location); }
| '$stringLiteralExpr' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteStringLiteralExpr(e, location=top.location); }
concrete productions top::Identifier_c
| '$Names' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteNames(e, location=top.location); }
| AntiquoteName_t '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteName(e, location=top.location); }
| AntiquoteNamePattern_t '{' p::Pattern '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquotePatternName(p, location=top.location); }
| '$name' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquote_name(e, location=top.location); }
concrete productions top::TypeIdName_c
| '$TName' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteTName(e, location=top.location); }
| '$tname' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquote_tname(e, location=top.location); }
concrete productions top::StorageClassSpecifier_c
| '$StorageClasses' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    top.isTypedef = false;
    top.storageClass = [antiquoteStorageClasses(e, top.location)];
  }
concrete productions top::ParameterDeclaration_c
| '$Parameters' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    top.declaredIdents = [];
    top.ast = antiquoteParameters(e, top.location);
  }
concrete productions top::StructDeclaration_c
| '$StructItemList' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = [antiquoteStructItemList(e, top.location)]; }
concrete productions top::Enumerator_c
| '$EnumItemList' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = [antiquoteEnumItemList(e, top.location)]; }
concrete productions top::TypeName_c
| '$TypeNames' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteTypeNames(e); }
| '$TypeName' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteTypeName(e); }
concrete productions top::TypeSpecifier_c
| AntiquoteBaseTypeExpr_t '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [antiquoteBaseTypeExpr(e)];
    top.preTypeSpecifiers = [];
  }
| AntiquoteBaseTypeExprPattern_t '{' p::Pattern '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { -- TODO: Discarding qualifiers here!
    top.realTypeSpecifiers = [antiquotePatternBaseTypeExpr(p)];
    top.preTypeSpecifiers = [];
  }
concrete productions top::TypeSpecifier_c
| '$directTypeExpr' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  {
    top.realTypeSpecifiers = [antiquoteDirectTypeExpr(top.givenQualifiers, e, top.location)];
    top.preTypeSpecifiers = [];
  }
concrete productions top::Attrib_c
| '$Attrib' '{' e::Expr '}'
  layout {silver:definition:core:WhiteSpace, BlockComments, Comments}
  { top.ast = antiquoteAttrib(e); }
