grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax;

imports silver:definition:regex;
imports silver:reflect:concretesyntax;

marking terminal AbleCDecls_t        'ableC_Decls'        lexer classes {KEYWORD, RESERVED};
marking terminal AbleCDecl_t         'ableC_Decl'         lexer classes {KEYWORD, RESERVED};
marking terminal AbleCParameters_t   'ableC_Parameters'   lexer classes {KEYWORD, RESERVED};
marking terminal AbleCBaseTypeExpr_t 'ableC_BaseTypeExpr' lexer classes {KEYWORD, RESERVED};
marking terminal AbleCStmt_t         'ableC_Stmt'         lexer classes {KEYWORD, RESERVED};
marking terminal AbleCExpr_t         'ableC_Expr'         lexer classes {KEYWORD, RESERVED};

temp_imp_ide_font font_escape color(123, 0, 82) bold italic;
lexer class Escape font=font_escape;

terminal EscapeDecls_t             '$Decls'             lexer classes {Escape, Reserved};
terminal EscapeDecl_t              '$Decl'              lexer classes {Escape, Reserved};
terminal EscapeStmt_t              '$Stmt'              lexer classes {Escape, Reserved};
terminal EscapeInitializer_t       '$Initializer'       lexer classes {Escape, Reserved};
terminal EscapeExprs_t             '$Exprs'             lexer classes {Escape, Reserved};
terminal EscapeExpr_t              '$Expr'              lexer classes {Escape, Reserved};
terminal EscapeIntLiteralExpr_t    '$intLiteralExpr'    lexer classes {Escape, Reserved};
terminal EscapeStringLiteralExpr_t '$stringLiteralExpr' lexer classes {Escape, Reserved};
terminal EscapeNames_t             '$Names'             lexer classes {Escape, Reserved};
terminal EscapeName_t              '$Name'              lexer classes {Escape, Reserved};
terminal EscapeTName_t             '$TName'             lexer classes {Escape, Reserved};
terminal Escape_name_t             '$name'              lexer classes {Escape, Reserved};
terminal Escape_tname_t            '$tname'             lexer classes {Escape, Reserved};
terminal EscapeStorageClasses      '$StorageClasses'    lexer classes {Escape, Reserved};
terminal EscapeParameters_t        '$Parameters'        lexer classes {Escape, Reserved};
terminal EscapeStructItemList_t    '$StructItemList'    lexer classes {Escape, Reserved};
terminal EscapeEnumItemList_t      '$EnumItemList'      lexer classes {Escape, Reserved};
terminal EscapeTypeNames_t         '$TypeNames'         lexer classes {Escape, Reserved};
terminal EscapeTypeName_t          '$TypeName'          lexer classes {Escape, Reserved};
terminal EscapeBaseTypeExpr_t      '$BaseTypeExpr'      lexer classes {Escape, Reserved};
--terminal EscapeTypeModifierExpr_t  '$TypeModifierExpr'  lexer classes {Escape, Reserved};
terminal EscapeType_t              '$directTypeExpr'    lexer classes {Escape, Reserved};
terminal EscapeAttrib_t            '$Attrib'            lexer classes {Escape, Reserved}, dominates {AttributeNameUnfetterdByKeywords_t};
-- Workarounds for weirdness with ignore terminals
parser attribute inAbleC::Boolean action { inAbleC = false; };
terminal InAbleC '' action { inAbleC = true; };
terminal NotInAbleC '' action { inAbleC = false; };

terminal Wild_t '_';

disambiguate Wild_t, Identifier_t {
  pluck Wild_t;
}

disambiguate NewLine_t, RegexChar_t, silver:definition:core:WhiteSpace
{
  pluck if inAbleC then NewLine_t else WhiteSpace;
}
disambiguate NewLine_t, silver:definition:core:WhiteSpace
{
  pluck if inAbleC then NewLine_t else silver:definition:core:WhiteSpace;
}
disambiguate Spaces_t, RegexChar_t, silver:definition:core:WhiteSpace
{
  pluck if inAbleC then Spaces_t else WhiteSpace;
}
disambiguate Spaces_t, silver:definition:core:WhiteSpace
{
  pluck if inAbleC then Spaces_t else WhiteSpace;
}
disambiguate NewLine_t, RegexChar_t, silver:definition:core:WhiteSpace, silver:reflect:concretesyntax:WhiteSpace
{
  pluck if inAbleC then NewLine_t else WhiteSpace;
}
disambiguate NewLine_t, silver:definition:core:WhiteSpace, silver:reflect:concretesyntax:WhiteSpace
{
  pluck if inAbleC then NewLine_t else WhiteSpace;
}
disambiguate Spaces_t, RegexChar_t, silver:definition:core:WhiteSpace, silver:reflect:concretesyntax:WhiteSpace
{
  pluck if inAbleC then Spaces_t else WhiteSpace;
}
disambiguate Spaces_t, silver:definition:core:WhiteSpace, silver:reflect:concretesyntax:WhiteSpace
{
  pluck if inAbleC then Spaces_t else WhiteSpace;
}
disambiguate Dec_t, Comments
{
  pluck if inAbleC then Dec_t else Comments;
}
