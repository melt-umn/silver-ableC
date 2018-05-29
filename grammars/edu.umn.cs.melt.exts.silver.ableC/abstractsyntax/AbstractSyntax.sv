grammar edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;

imports silver:langutil;
imports silver:langutil:pp;

imports silver:definition:core;
imports silver:definition:env;
imports silver:extension:list;

imports edu:umn:cs:melt:ableC:abstractsyntax:host as ableC;

-- Silver-to-ableC bridge productions
abstract production ableCDeclsLiteral
top::Expr ::= ast::ableC:Decls
{
  top.pp = s"ableC_Decls {${sconcat(explode("\n", show(80, ppImplode(line(), ast.pps))))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production ableCDeclLiteral
top::Expr ::= ast::ableC:Decl
{
  top.pp = s"ableC_Decl {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production ableCParametersLiteral
top::Expr ::= ast::ableC:Parameters
{
  top.pp = s"ableC_Parameters {${sconcat(explode("\n", show(80, ppImplode(pp", ", ast.pps))))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production ableCStmtLiteral
top::Expr ::= ast::ableC:Stmt
{
  top.pp = s"ableC_Stmt {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

abstract production ableCExprLiteral
top::Expr ::= ast::ableC:Expr
{
  top.pp = s"ableC_Expr {${sconcat(explode("\n", show(80, ast.pp)))}}";
  forwards to translate(top.location, reflect(new(ast)));
}

-- AbleC-to-Silver bridge productions
abstract production escapeDecls
top::ableC:Decl ::= e::Expr
{
  top.pp = pp"$$Decls{${text(e.pp)}}";
  forwards to ableC:warnDecl([]);
}

abstract production escapeDecl
top::ableC:Decl ::= e::Expr
{
  top.pp = pp"$$Decl{${text(e.pp)}}";
  forwards to ableC:warnDecl([]);
}

abstract production escapeStmt
top::ableC:Stmt ::= e::Expr
{
  top.pp = pp"$$Stmt{${text(e.pp)}}";
  forwards to ableC:warnStmt([]);
}

abstract production escapeInitializer
top::ableC:Initializer ::= e::Expr
{
  top.pp = pp"$$Initializer{${text(e.pp)}}";
  forwards to ableC:objectInitializer(ableC:nilInit());
}

abstract production escapeExprs
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$Exprs{${text(e.pp)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production escapeExpr
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$Expr{${text(e.pp)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production escapeIntLiteralExpr
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$intLiteralExpr{${text(e.pp)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production escapeStringLiteralExpr
top::ableC:Expr ::= e::Expr
{
  top.pp = pp"$$stringLiteralExpr{${text(e.pp)}}";
  forwards to ableC:errorExpr([], location=builtin);
}

abstract production escapeName
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$Name{${text(e.pp)}}";
  forwards to ableC:name("<unknown>", location=builtin);
}

abstract production escapeTName
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$TName{${text(e.pp)}}";
  forwards to ableC:name("<unknown type name>", location=builtin);
}

abstract production escape_name
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$name{${text(e.pp)}}";
  forwards to ableC:name("<unknown>", location=builtin);
}

abstract production escape_tname
top::ableC:Name ::= e::Expr
{
  top.pp = pp"$$tname{${text(e.pp)}}";
  forwards to ableC:name("<unknown type name>", location=builtin);
}

abstract production escapeStorageClasses
top::ableC:StorageClass ::= e::Expr loc::Location
{
  top.pp = pp"$$Parameters{${text(e.pp)}}";
  forwards to error("TODO: forward value for escapeStorageClasses");
}

abstract production escapeParameters
top::ableC:ParameterDecl ::= e::Expr loc::Location
{
  top.pp = pp"$$Parameters{${text(e.pp)}}";
  forwards to error("TODO: forward value for escapeParameters");
}

abstract production escapeTypeName
top::ableC:TypeName ::= e::Expr
{
  top.pp = pp"$$TypeName{${text(e.pp)}}";
  forwards to ableC:typeName(ableC:errorTypeExpr([]), ableC:baseTypeExpr());
}

abstract production escapeBaseTypeExpr
top::ableC:BaseTypeExpr ::= e::Expr
{
  top.pp = pp"$$BaseTypeExpr{${text(e.pp)}}";
  forwards to ableC:errorTypeExpr([]);
}

abstract production escapeDirectTypeExpr
top::ableC:BaseTypeExpr ::= givenQualifiers::ableC:Qualifiers e::Expr loc::Location
{
  top.pp = pp"$$directTypeExpr{${text(e.pp)}}";
  forwards to ableC:errorTypeExpr([]);
}

abstract production escapeAttrib
top::ableC:Attrib ::= e::Expr
{
  top.pp = pp"$$Attrib{${text(e.pp)}}";
  forwards to ableC:emptyAttrib();
}

global builtin::Location = txtLoc("silver-ableC");
