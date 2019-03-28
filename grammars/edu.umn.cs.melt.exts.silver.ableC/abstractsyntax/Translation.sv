grammar edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;

imports silver:reflect;
imports silver:langutil:hostEmbedding;
imports core:monad;

aspect production nonterminalAST
top::AST ::= prodName::String children::ASTs annotations::NamedASTs
{
  directEscapeProductions <-
    ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStmt",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDecl",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeInitializer",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeExpr",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeName",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeTName",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeTypeName",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeBaseTypeExpr",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeAttrib"];
  
  collectionEscapeProductions <-
    [pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDecls",
       pair("Decls",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consDecl",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendDecls"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeExprs",
       pair("Exprs",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consExpr",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendExprs"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeNames",
       pair("Names",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consName",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendNames"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeTypeNames",
       pair("TypeNames",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consTypeName",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendTypeNames"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStorageClasses",
       pair("StorageClasses",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consStorageClass",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendStorageClasses"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeParameters",
       pair("Parameters",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consParameters",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendParameters"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStructItemList",
       pair("StructItemList",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consStructItem",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendStructItemList"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeEnumItemList",
       pair("EnumItemList",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consEnumItem",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendEnumItemList")))];
  
  -- "Indirect" escape productions
  escapeTranslation <-
    if
      -- These 2 are split out seperate to avoid duplicating code, because they
      -- are handled in the same way.
      containsBy(
        stringEq, prodName,
        ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escape_name",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escape_tname"])
    then
      case children, annotations of
      | consAST(a, nilAST()), consNamedAST(namedAST("core:location", locAST), nilNamedAST()) ->
          case reify(a) of
          | right(e) ->
            just(
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
                ')', location=givenLocation))
          | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
          end
      | _, _ -> error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
      end
    else case prodName, children, annotations of
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeIntLiteralExpr",
      consAST(a, nilAST()), consNamedAST(namedAST("core:location", locAST), nilNamedAST()) ->
        case reify(a) of
        | right(e) ->
          just(
            mkStrFunctionInvocation(
              givenLocation,
              "edu:umn:cs:melt:ableC:abstractsyntax:construction:mkIntConst",
              [e, locAST.translation]))
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeIntLiteralExpr", _, _ ->
        error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStringLiteralExpr",
      consAST(a, nilAST()), consNamedAST(namedAST("core:location", locAST), nilNamedAST()) ->
        case reify(a) of
        | right(e) ->
          just(
            mkStrFunctionInvocation(
              givenLocation,
              "edu:umn:cs:melt:ableC:abstractsyntax:construction:mkStringConst",
              [e, locAST.translation]))
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeStringLiteralExpr", _, _ ->
        error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDirectTypeExpr",
      consAST(qualifiersAST, consAST(a, consAST(locAST, nilAST()))), nilNamedAST() ->
        case reify(a) of
        | right(e) ->
          just(
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
                  e])]))
        | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
        end
    | "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:escapeDirectTypeExpr", _, _ ->
        error(s"Unexpected escape production arguments: ${show(80, top.pp)}")
    | _, _, _ -> nothing()
    end;
}
