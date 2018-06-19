grammar edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;

imports silver:reflect;

function translate
Expr ::= loc::Location ast::AST
{
  ast.givenLocation = loc;
  return ast.translation;
}

synthesized attribute translation<a>::a;
synthesized attribute foundLocation::Maybe<Location>;
autocopy attribute givenLocation::Location;

synthesized attribute escapeStorageClassesErrors::[silver:definition:core:Message];

attribute givenLocation, translation<Expr>, escapeStorageClassesErrors occurs on AST;

aspect default production
top::AST ::=
{
  top.escapeStorageClassesErrors = [];
}

aspect production nonterminalAST
top::AST ::= prodName::String children::ASTs annotations::NamedASTs
{
  production givenLocation::Location =
    fromMaybe(top.givenLocation, orElse(children.foundLocation, annotations.foundLocation));
  top.translation =
    -- "Direct" escape productions
    if
      containsBy(
        stringEq, prodName,
        ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStmt",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDecl",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeInitializer",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeExpr",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeName",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeTName",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeTypeName",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeBaseTypeExpr",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeAttrib"])
    then
      case children of
      | consAST(a, nilAST()) ->
          case reify(a) of
          | right(e) -> e
          | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
          end
      | _ -> error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
      end
    -- "Indirect" escape productions
    else if
      containsBy(
        stringEq, prodName,
        ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escape_name",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escape_tname"])
    then
      case children, annotations of
      | consAST(a, nilAST()), consNamedAST(namedAST("core:location", locAST), nilNamedAST()) ->
          case reify(a) of
          | right(e) ->
              application(
                baseExpr(
                  makeQName("edu:umn:cs:melt:ableC:abstractsyntax:host:name", givenLocation),
                  location=givenLocation),
                '(',
                foldAppExprs(givenLocation, [e]),
                ',',
                oneAnnoAppExprs(
                  annoExpr(
                    makeQName("location", givenLocation), '=',
                    presentAppExpr(locAST.translation, location=givenLocation),
                    location=givenLocation),
                  location=givenLocation),
                ')', location=givenLocation)
          | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
          end
      | _, _ -> error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
      end
    else case prodName, children, annotations of
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeIntLiteralExpr",
      consAST(a, nilAST()), consNamedAST(namedAST("core:location", locAST), nilNamedAST()) ->
        case reify(a) of
        | right(e) ->
            mkStrFunctionInvocation(
              givenLocation,
              "edu:umn:cs:melt:ableC:abstractsyntax:construction:mkIntConst",
              [e, locAST.translation])
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeIntLiteralExpr", _, _ ->
        error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStringLiteralExpr",
      consAST(a, nilAST()), consNamedAST(namedAST("core:location", locAST), nilNamedAST()) ->
        case reify(a) of
        | right(e) ->
            mkStrFunctionInvocation(
              givenLocation,
              "edu:umn:cs:melt:ableC:abstractsyntax:construction:mkStringConst",
              [e, locAST.translation])
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStringLiteralExpr", _, _ ->
        error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDirectTypeExpr",
      consAST(qualifiersAST, consAST(a, consAST(locAST, nilAST()))), nilNamedAST() ->
        case reify(a) of
        | right(e) ->
            mkStrFunctionInvocation(
              givenLocation, "edu:umn:cs:melt:ableC:abstractsyntax:host:directTypeExpr",
              [mkStrFunctionInvocation(
                 givenLocation,
                 "edu:umn:cs:melt:ableC:abstractsyntax:host:addQualifiers",
                 [access(
                    qualifiersAST.translation, '.',
                    qNameAttrOccur(
                      makeQName("qualifiers", givenLocation), location=givenLocation),
                    location=givenLocation),
                  e])])
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDirectTypeExpr", _, _ ->
        error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
    -- "Collection" escape productions
    | "edu:umn:cs:melt:ableC:abstractsyntax:host:consDecl",
      consAST(
        nonterminalAST(
          "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDecls",
          consAST(a, nilAST()),
          consNamedAST(namedAST("core:location", locAST), nilNamedAST())),
        consAST(rest, nilAST())),
        nilNamedAST() ->
        case reify(a) of
        | right(e) ->
            mkStrFunctionInvocation(
              givenLocation,
              "edu:umn:cs:melt:ableC:abstractsyntax:host:appendDecls",
              [e, rest.translation])
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDecls", _, _ ->
        errorExpr([err(givenLocation, "$Decls may only occur as a member of Decls")], location=givenLocation)
    | "edu:umn:cs:melt:ableC:abstractsyntax:host:consExpr",
      consAST(
        nonterminalAST(
          "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeExprs",
          consAST(a, nilAST()),
          consNamedAST(namedAST("core:location", locAST), nilNamedAST())),
        consAST(rest, nilAST())),
        nilNamedAST() ->
        case reify(a) of
        | right(e) ->
            mkStrFunctionInvocation(
              givenLocation,
              "edu:umn:cs:melt:ableC:abstractsyntax:host:appendExprs",
              [e, rest.translation])
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeExprs", _, _ ->
        errorExpr([err(givenLocation, "$Exprs may only occur as a member of Exprs")], location=givenLocation)
    | "edu:umn:cs:melt:ableC:abstractsyntax:host:consParameters",
      consAST(
        nonterminalAST(
          "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeParameters",
          consAST(a, consAST(locAST, nilAST())),
          nilNamedAST()),
        consAST(rest, nilAST())),
        nilNamedAST() ->
        case reify(a) of
        | right(e) ->
            mkStrFunctionInvocation(
              givenLocation,
              "edu:umn:cs:melt:ableC:abstractsyntax:host:appendParameters",
              [e, rest.translation])
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeParameters", _, _ ->
        errorExpr([err(givenLocation, "$Parameters may only occur as a member of Parameters")], location=givenLocation)
    -- Default
    | _, _, _ ->
        application(
          baseExpr(makeQName(prodName, givenLocation), location=givenLocation),
          '(',
          foldAppExprs(givenLocation, reverse(children.translation)),
          ',',
          foldl(
            snocAnnoAppExprs(_, ',', _, location=givenLocation),
            emptyAnnoAppExprs(location=givenLocation),
            reverse(annotations.translation)),
          ')', location=givenLocation)
    end;
    top.escapeStorageClassesErrors =
      if prodName == "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStorageClasses"
      then [err(givenLocation, "$EscapeStorageClasses must be the only given storage class")]
      else [];
    
    children.givenLocation = givenLocation;
    annotations.givenLocation = givenLocation;
}

aspect production listAST
top::AST ::= vals::ASTs
{
  top.translation =
    case vals of
    -- TODO: Workaround since we don't have a StorageClasses nonterminal yet
    | consAST(
        nonterminalAST(
          "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStorageClasses",
          consAST(a, consAST(locAST, nilAST())),
          nilNamedAST()),
        nilAST()) ->
        case reify(a) of
        | right(e) -> e
        | left(msg) -> error(s"Error in reifying child of production edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStorageClasses:\n${msg}")
        end
    | consAST(
        nonterminalAST(
          "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStorageClasses", _, _),
        nilAST()) ->
        error(s"Unexpected escape production: ${show(80, top.pp)}")
    | _ -> 
      if !null(vals.escapeStorageClassesErrors)
      then errorExpr(vals.escapeStorageClassesErrors, location=top.givenLocation)
      else
        fullList(
          '[',
          foldr(
            exprsCons(_, ',', _, location=top.givenLocation),
            exprsEmpty(location=top.givenLocation),
            vals.translation),
          ']', location=top.givenLocation)
    end;
}

aspect production stringAST
top::AST ::= s::String
{
  top.translation =
    stringConst(
      terminal(String_t, s"\"${escapeString(s)}\"", top.givenLocation),
      location=top.givenLocation);
}

aspect production integerAST
top::AST ::= i::Integer
{
  top.translation =
    intConst(terminal(Int_t, toString(i), top.givenLocation), location=top.givenLocation);
}

aspect production floatAST
top::AST ::= f::Float
{
  top.translation =
    floatConst(terminal(Float_t, toString(f), top.givenLocation), location=top.givenLocation);
}

aspect production booleanAST
top::AST ::= b::Boolean
{
  top.translation =
    if b
    then trueConst('true', location=top.givenLocation)
    else falseConst('false', location=top.givenLocation);
}

aspect production anyAST
top::AST ::= x::a
{
  top.translation =
    case reflectTypeName(x) of
      just(n) -> error(s"Can't translate anyAST (type ${n})")
    | nothing() -> error("Can't translate anyAST")
    end;
}

attribute givenLocation, translation<[Expr]>, foundLocation, escapeStorageClassesErrors occurs on ASTs;

aspect production consAST
top::ASTs ::= h::AST t::ASTs
{
  top.translation = h.translation :: t.translation;
  top.foundLocation =
    -- Try to reify the last child as a location
    case t of
    | nilAST() ->
        case reify(h) of
        | right(l) -> just(l)
        | left(_) -> nothing()
        end
    | _ -> t.foundLocation
    end;
  top.escapeStorageClassesErrors = h.escapeStorageClassesErrors ++ t.escapeStorageClassesErrors; 
}

aspect production nilAST
top::ASTs ::=
{
  top.translation = [];
  top.foundLocation = nothing();
  top.escapeStorageClassesErrors = [];
}

attribute givenLocation, translation<[AnnoExpr]>, foundLocation occurs on NamedASTs;

aspect production consNamedAST
top::NamedASTs ::= h::NamedAST t::NamedASTs
{
  top.translation = h.translation :: t.translation;
  top.foundLocation = orElse(h.foundLocation, t.foundLocation);
}

aspect production nilNamedAST
top::NamedASTs ::=
{
  top.translation = [];
  top.foundLocation = nothing();
}

attribute givenLocation, translation<AnnoExpr>, foundLocation occurs on NamedAST;

aspect production namedAST
top::NamedAST ::= n::String v::AST
{
  top.translation =
    annoExpr(
      qNameId(makeName(last(explode(":", n)), top.givenLocation), location=top.givenLocation),
      '=',
      presentAppExpr(v.translation, location=top.givenLocation),
      location=top.givenLocation);
  top.foundLocation =
    if n == "core:location"
    then
      case reify(v) of
      | right(l) -> just(l)
      | left(msg) -> error(s"Error in reifying location:\n${msg}")
      end
    else nothing();
}

function makeName
Name ::= n::String loc::Location
{
  return
    if isUpper(head(explode("", n)))
    then nameIdUpper(terminal(IdUpper_t, n, loc), location=loc)
    else nameIdLower(terminal(IdLower_t, n, loc), location=loc);
}

function makeQName
QName ::= n::String loc::Location
{
  local ns::[Name] = map(makeName(_, loc), explode(":", n));
  return
    foldr(
      qNameCons(_, ':', _, location=loc),
      qNameId(last(ns), location=loc),
      init(ns));
}
