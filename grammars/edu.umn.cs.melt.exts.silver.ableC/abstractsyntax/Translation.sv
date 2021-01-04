grammar edu:umn:cs:melt:exts:silver:ableC:abstractsyntax;

imports silver:reflect;
imports silver:compiler:metatranslation;

aspect production nonterminalAST
top::AST ::= prodName::String children::ASTs annotations::NamedASTs
{
  directAntiquoteProductions <-
    ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteStmt",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteDecl",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteInitializer",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteExpr",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteName",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteTName",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteTypeName",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteBaseTypeExpr",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteAttrib"];
  
  collectionAntiquoteProductions <-
    [pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteDecls",
       pair("Decls",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consDecl",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendDecls"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteExprs",
       pair("Exprs",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consExpr",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendExprs"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteNames",
       pair("Names",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consName",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendNames"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteTypeNames",
       pair("TypeNames",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consTypeName",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendTypeNames"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteStorageClasses",
       pair("StorageClasses",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consStorageClass",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendStorageClasses"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteParameters",
       pair("Parameters",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consParameters",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendParameters"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteStructItemList",
       pair("StructItemList",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consStructItem",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendStructItemList"))),
     pair(
      "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteEnumItemList",
       pair("EnumItemList",
         pair(
           "edu:umn:cs:melt:ableC:abstractsyntax:host:consEnumItem",
           "edu:umn:cs:melt:ableC:abstractsyntax:host:appendEnumItemList")))];
  
  patternAntiquoteProductions <-
    ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquotePatternExpr",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquotePatternName",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquotePatternDecl",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquotePatternStmt",
     "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquotePatternBaseTypeExpr"];
  
  -- "Indirect" antiquote productions
  antiquoteTranslation <-
    if
      -- These 2 are split out seperate to avoid duplicating code, because they
      -- are handled in the same way.
      containsBy(
        stringEq, prodName,
        ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquote_name",
         "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquote_tname"])
    then
      case children, annotations of
      | consAST(a, nilAST()), consNamedAST(namedAST("silver:core:location", locAST), nilNamedAST()) ->
          case reify(a) of
          | right(e) ->
            just(
              mkFullFunctionInvocation(
                givenLocation,
                baseExpr(
                  makeQName("edu:umn:cs:melt:ableC:abstractsyntax:host:name", givenLocation),
                  location=givenLocation),
                [e],
                [pair("location", locAST.translation)]))
          | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
          end
      | _, _ -> error(s"Unexpected antiquote production arguments: ${show(80, top.pp)}")
      end
    else case top of
    | AST {
       edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteIntLiteralExpr(a, silver:core:location=locAST)
      } ->
      case reify(a) of
      | right(e) ->
        just(
          mkStrFunctionInvocation(
            givenLocation,
            "edu:umn:cs:melt:ableC:abstractsyntax:construction:mkIntConst",
            [e, locAST.translation]))
      | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
      end
    | AST {
        edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteStringLiteralExpr(a, silver:core:location=locAST)
      } ->
      case reify(a) of
      | right(e) ->
        just(
          mkStrFunctionInvocation(
            givenLocation,
            "edu:umn:cs:melt:ableC:abstractsyntax:construction:mkStringConst",
            [e, locAST.translation]))
      | left(msg) -> error(s"Error in reifying child of production ${prodName}:\n${msg}")
      end
    | AST {
        edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteDirectTypeExpr(qualifiersAST, a, locAST)
      } ->
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
    | _ ->
      if
        containsBy(
          stringEq, prodName,
          ["edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteIntLiteralExpr",
           "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteStringLiteralExpr",
           "edu:umn:cs:melt:exts:silver:ableC:abstractsyntax:antiquoteDirectTypeExpr"])
      then error(s"Unexpected antiquote production arguments: ${show(80, top.pp)}")
      else nothing()
    end;
}
