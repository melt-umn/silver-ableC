grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax;

imports silver:definition:regex;

marking terminal AbleCDecls_t        'ableC_Decls'        lexer classes {KEYWORD, RESERVED};
marking terminal AbleCDecl_t         'ableC_Decl'         lexer classes {KEYWORD, RESERVED};
marking terminal AbleCParameters_t   'ableC_Parameters'   lexer classes {KEYWORD, RESERVED};
marking terminal AbleCBaseTypeExpr_t 'ableC_BaseTypeExpr' lexer classes {KEYWORD, RESERVED};
marking terminal AbleCStmt_t         'ableC_Stmt'         lexer classes {KEYWORD, RESERVED};
marking terminal AbleCExpr_t         'ableC_Expr'         lexer classes {KEYWORD, RESERVED};

temp_imp_ide_font font_escape color(123, 0, 82) bold italic;
lexer class Escape font=font_escape;

terminal EscapeDecls_t             '$Decls'             lexer classes {Escape, Ckeyword};
terminal EscapeDecl_t              '$Decl'              lexer classes {Escape, Ckeyword};
terminal EscapeStmt_t              '$Stmt'              lexer classes {Escape, Ckeyword};
terminal EscapeInitializer_t       '$Initializer'       lexer classes {Escape, Ckeyword};
terminal EscapeExprs_t             '$Exprs'             lexer classes {Escape, Ckeyword};
terminal EscapeExpr_t              '$Expr'              lexer classes {Escape, Ckeyword};
terminal EscapeIntLiteralExpr_t    '$intLiteralExpr'    lexer classes {Escape, Ckeyword};
terminal EscapeStringLiteralExpr_t '$stringLiteralExpr' lexer classes {Escape, Ckeyword};
terminal EscapeName_t              '$Name'              lexer classes {Escape, Ckeyword};
terminal EscapeTName_t             '$TName'             lexer classes {Escape, Ckeyword};
terminal Escape_name_t             '$name'              lexer classes {Escape, Ckeyword};
terminal Escape_tname_t            '$tname'             lexer classes {Escape, Ckeyword};
terminal EscapeNames_t             '$Names'             lexer classes {Escape, Ckeyword};
terminal EscapeStorageClasses      '$StorageClasses'    lexer classes {Escape, Ckeyword};
terminal EscapeParameters_t        '$Parameters'        lexer classes {Escape, Ckeyword};
terminal EscapeStructItemList_t    '$StructItemList'    lexer classes {Escape, Ckeyword};
terminal EscapeEnumItemList_t      '$EnumItemList'      lexer classes {Escape, Ckeyword};
terminal EscapeTypeNames_t         '$TypeNames'         lexer classes {Escape, Ckeyword};
terminal EscapeTypeName_t          '$TypeName'          lexer classes {Escape, Ckeyword};
terminal EscapeBaseTypeExpr_t      '$BaseTypeExpr'      lexer classes {Escape, Ckeyword};
--terminal EscapeTypeModifierExpr_t  '$TypeModifierExpr'  lexer classes {Escape, Ckeyword};
terminal EscapeType_t              '$directTypeExpr'    lexer classes {Escape, Ckeyword};
terminal EscapeAttrib_t            '$Attrib'            lexer classes {Escape, Ckeyword}, dominates {AttributeNameUnfetterdByKeywords_t};
-- Workarounds for weirdness with ignore terminals
parser attribute inAbleC::Boolean action { inAbleC = false; };
terminal InAbleC '' action { inAbleC = true; };
terminal NotInAbleC '' action { inAbleC = false; };

disambiguate NewLine_t, RegexChar_t, WhiteSpace
{
  pluck if inAbleC then NewLine_t else WhiteSpace;
}
disambiguate NewLine_t, WhiteSpace
{
  pluck if inAbleC then NewLine_t else WhiteSpace;
}
disambiguate Spaces_t, RegexChar_t, WhiteSpace
{
  pluck if inAbleC then Spaces_t else WhiteSpace;
}
disambiguate Spaces_t, WhiteSpace
{
  pluck if inAbleC then Spaces_t else WhiteSpace;
}
disambiguate DEC_OP, Comments
{
  pluck if inAbleC then DEC_OP else Comments;
}
