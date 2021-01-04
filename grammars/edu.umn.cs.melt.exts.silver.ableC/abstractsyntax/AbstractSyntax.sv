grammar edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;

--imports silver:langutil;
imports silver:langutil:pp;

imports silver:compiler:definition:core;
imports silver:compiler:extension:patternmatching;

imports edu:umn:cs:melt:ableC:abstractsyntax:host as ableC;

-- Silver-to-ableC bridge productions
abstract production quoteDecls
top::Expr ::= ast::ableC:Decls
{
  top.unparse = s"ableC_Decls {${sconcat(explode("\n", show(80, ppImplode(line(), ast.pps))))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production quoteDecl
top::Expr ::= ast::ableC:Decl
{
  top.unparse = s"ableC_Decl {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production quoteParameters
top::Expr ::= ast::ableC:Parameters
{
  top.unparse = s"ableC_Parameters {${sconcat(explode("\n", show(80, ppImplode(pp", ", ast.pps))))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production quoteBaseTypeExpr
top::Expr ::= ast::ableC:BaseTypeExpr
{
  top.unparse = s"ableC_BaseTypeExpr {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production quoteStmt
top::Expr ::= ast::ableC:Stmt
{
  top.unparse = s"ableC_Stmt {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production quoteExpr
top::Expr ::= ast::ableC:Expr
{
  top.unparse = s"ableC_Expr {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production quoteDeclsPattern
top::Pattern ::= ast::ableC:Decls
{
  top.unparse = s"ableC_Decls {${sconcat(explode("\n", show(80, ppImplode(line(), ast.pps))))}}";
  forwards to translatePattern(top.location, reflect(new(ast)));
}

abstract production quoteDeclPattern
top::Pattern ::= ast::ableC:Decl
{
  top.unparse = s"ableC_Decl {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translatePattern(top.location, reflect(new(ast)));
}

abstract production quoteParametersPattern
top::Pattern ::= ast::ableC:Parameters
{
  top.unparse = s"ableC_Parameters {${sconcat(explode("\n", show(80, ppImplode(pp", ", ast.pps))))}}";
  forwards to translatePattern(top.location, reflect(new(ast)));
}

abstract production quoteBaseTypeExprPattern
top::Pattern ::= ast::ableC:BaseTypeExpr
{
  top.unparse = s"ableC_BaseTypeExpr {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translatePattern(top.location, reflect(new(ast)));
}

abstract production quoteStmtPattern
top::Pattern ::= ast::ableC:Stmt
{
  top.unparse = s"ableC_Stmt {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translatePattern(top.location, reflect(new(ast)));
}

abstract production quoteExprPattern
top::Pattern ::= ast::ableC:Expr
{
  top.unparse = s"ableC_Expr {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translatePattern(top.location, reflect(new(ast)));
}

-- AbleC-to-Silver bridge productions
abstract production antiquoteDecls
top::ableC:Decl ::= e::Expr
{
  top.pp = pp"$$Decls{${text(e.unparse)}}";
  forwards to ableC:warnDecl([]);
}

abstract production antiquoteDecl
top::ableC:Decl ::= e::Expr
{
  top.pp = pp"$$Decl{${text(e.unparse)}}";
  forwards to ableC:warnDecl([]);
}

abstract production antiquotePatternDecl
top::ableC:Decl ::= p::Pattern
{
  top.pp = pp"$$Decl{${text(p.unparse)}}";
  forwards to ableC:warnDecl([]);
}

abstract production antiquoteStmt
top::ableC:Stmt ::= e::Expr
{
  top.pp = pp"$$Stmt{${text(e.unparse)}}";
  forwards to ableC:warnStmt([]);
}

abstract production antiquotePatternStmt
top::ableC:Stmt ::= p::Pattern
{
  top.pp = pp"$$Stmt{${text(p.unparse)}}";
  forwards to ableC:warnStmt([]);
}

abstract production antiquoteInitializer
top::ableC:Initializer ::= e::Expr
{
  top.pp = pp"$$Initializer{${text(e.unparse)}}";
  forwards to ableC:objectInitializer(ableC:nilInit(), location=builtin);
}

abstract production antiquoteExprs
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$Exprs{${text(e.unparse)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production antiquoteExpr
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$Expr{${text(e.unparse)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production antiquotePatternExpr
top::ableC:Expr ::= p::Pattern
{
  top.pp = pp"$$Expr{${text(p.unparse)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production antiquoteIntLiteralExpr
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$intLiteralExpr{${text(e.unparse)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production antiquoteStringLiteralExpr
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$stringLiteralExpr{${text(e.unparse)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production antiquoteNames
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$Names{${text(e.unparse)}}";
  forwards to ableC:name("<unknown>", location=builtin);
}

abstract production antiquoteName
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$Name{${text(e.unparse)}}";
  forwards to ableC:name("<unknown>", location=builtin);
}

abstract production antiquotePatternName
top::ableC:Name ::= p::Pattern
{
  top.pp = pp"$$Name{${text(p.unparse)}}";
  forwards to ableC:name("<unknown>", location=builtin);
}

abstract production antiquoteTName
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$TName{${text(e.unparse)}}";
  forwards to ableC:name("<unknown type name>", location=builtin);
}

abstract production antiquote_name
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$name{${text(e.unparse)}}";
  forwards to ableC:name("<unknown>", location=builtin);
}

abstract production antiquote_tname
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$tname{${text(e.unparse)}}";
  forwards to ableC:name("<unknown type name>", location=builtin);
}
abstract production antiquoteStorageClasses
top::ableC:StorageClass ::= e::Expr loc::Location
{
  top.pp = pp"$$Parameters{${text(e.unparse)}}";
  forwards to error("TODO: forward value for antiquoteStorageClasses");
}

abstract production antiquoteParameters
top::ableC:ParameterDecl ::= e::Expr loc::Location
{
  top.pp = pp"$$Parameters{${text(e.unparse)}}";
  -- TODO: forward value for antiquoteParameters
  -- This needs to be an actual value since we pattern match on Parameters while
  -- constructing the AST.
  forwards to ableC:parameterDecl(ableC:nilStorageClass(), ableC:errorTypeExpr([]), ableC:baseTypeExpr(), ableC:nothingName(), ableC:nilAttribute());
}

abstract production antiquoteStructItemList
top::ableC:StructItem ::= e::Expr loc::Location
{
  top.pp = pp"$$StructItemList{${text(e.unparse)}}";
  forwards to error("TODO: forward value for antiquoteStructItemList");
}

abstract production antiquoteEnumItemList
top::ableC:EnumItem ::= e::Expr loc::Location
{
  top.pp = pp"$$EnumItemList{${text(e.unparse)}}";
  forwards to error("TODO: forward value for antiquoteEnumItemList");
}

abstract production antiquoteTypeNames
top::ableC:TypeName ::= e::Expr
{
  top.pp = pp"$$TypeNames{${text(e.unparse)}}";
  forwards to error("TODO: forward value for antiquoteTypeNames");
}

abstract production antiquoteTypeName
top::ableC:TypeName ::= e::Expr
{
  top.pp = pp"$$TypeName{${text(e.unparse)}}";
  forwards to ableC:typeName(ableC:errorTypeExpr([]), ableC:baseTypeExpr());
}

abstract production antiquoteBaseTypeExpr
top::ableC:BaseTypeExpr ::= e::Expr
{
  top.pp = pp"$$BaseTypeExpr{${text(e.unparse)}}";
  forwards to ableC:errorTypeExpr([]);
}

abstract production antiquotePatternBaseTypeExpr
top::ableC:BaseTypeExpr ::= p::Pattern
{
  top.pp = pp"$$BaseTypeExpr{${text(p.unparse)}}";
  forwards to ableC:errorTypeExpr([]);
}

abstract production antiquoteDirectTypeExpr
top::ableC:BaseTypeExpr ::= givenQualifiers::ableC:Qualifiers e::Expr loc::Location
{
  top.pp = pp"$$directTypeExpr{${text(e.unparse)}}";
  forwards to ableC:errorTypeExpr([]);
}

abstract production antiquoteAttrib
top::ableC:Attrib ::= e::Expr
{
  top.pp = pp"$$Attrib{${text(e.unparse)}}";
  forwards to ableC:emptyAttrib();
}

global builtin::Location = txtLoc("silver-ableC");
