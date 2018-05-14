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

attribute givenLocation, translation<Expr> occurs on AST;

aspect production nonterminalAST
top::AST ::= prodName::String children::ASTs annotations::NamedASTs
{
  local givenLocation::Location = fromMaybe(top.givenLocation, annotations.foundLocation);
  top.translation =
    -- "Direct" escape productions
    if
      containsBy(
        stringEq, prodName,
        ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStmt",
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
      consAST(a, consAST(locAST, nilAST())), nilNamedAST() ->
        case reify(a) of
        | right(e) ->
            mkStrFunctionInvocation(
              givenLocation, "edu:umn:cs:melt:ableC:abstractsyntax:host:directTypeExpr", [e])
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDirectTypeExpr", _, _ ->
        error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
    -- "Collection" escape productions
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
        error(s"Unexpected escape production: ${show(80, top.pp)}")
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
        error(s"Unexpected escape production: ${show(80, top.pp)}")
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
    
    children.givenLocation = givenLocation;
    annotations.givenLocation = givenLocation;
}

aspect production listAST
top::AST ::= vals::ASTs
{
  top.translation =
    fullList(
      '[',
      foldr(
        exprsCons(_, ',', _, location=top.givenLocation),
        exprsEmpty(location=top.givenLocation),
        vals.translation),
      ']', location=top.givenLocation);
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

attribute givenLocation, translation<[Expr]> occurs on ASTs;

aspect production consAST
top::ASTs ::= h::AST t::ASTs
{
  top.translation = h.translation :: t.translation;
}

aspect production nilAST
top::ASTs ::=
{
  top.translation = [];
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
