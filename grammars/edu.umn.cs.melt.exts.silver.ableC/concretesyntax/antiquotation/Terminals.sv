grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax:antiquotation;

temp_imp_ide_font font_antiquote color(123, 0, 82) bold italic;
lexer class Antiquote font=font_antiquote;

marking terminal AntiquoteDecls_t             '$Decls'             lexer classes {Antiquote, Reserved};
marking terminal AntiquoteDecl_t              '$Decl'              lexer classes {Antiquote, Reserved};
marking terminal AntiquoteStmt_t              '$Stmt'              lexer classes {Antiquote, Reserved};
marking terminal AntiquoteInitializer_t       '$Initializer'       lexer classes {Antiquote, Reserved};
marking terminal AntiquoteExprs_t             '$Exprs'             lexer classes {Antiquote, Reserved};
marking terminal AntiquoteExpr_t              '$Expr'              lexer classes {Antiquote, Reserved};
marking terminal AntiquoteIntLiteralExpr_t    '$intLiteralExpr'    lexer classes {Antiquote, Reserved};
marking terminal AntiquoteStringLiteralExpr_t '$stringLiteralExpr' lexer classes {Antiquote, Reserved};
marking terminal AntiquoteNames_t             '$Names'             lexer classes {Antiquote, Reserved};
marking terminal AntiquoteName_t              '$Name'              lexer classes {Antiquote, Reserved};
marking terminal AntiquoteTName_t             '$TName'             lexer classes {Antiquote, Reserved};
marking terminal Antiquote_name_t             '$name'              lexer classes {Antiquote, Reserved};
marking terminal Antiquote_tname_t            '$tname'             lexer classes {Antiquote, Reserved};
marking terminal AntiquoteStorageClasses      '$StorageClasses'    lexer classes {Antiquote, Reserved};
marking terminal AntiquoteParameters_t        '$Parameters'        lexer classes {Antiquote, Reserved};
marking terminal AntiquoteStructItemList_t    '$StructItemList'    lexer classes {Antiquote, Reserved};
marking terminal AntiquoteEnumItemList_t      '$EnumItemList'      lexer classes {Antiquote, Reserved};
marking terminal AntiquoteTypeNames_t         '$TypeNames'         lexer classes {Antiquote, Reserved};
marking terminal AntiquoteTypeName_t          '$TypeName'          lexer classes {Antiquote, Reserved};
marking terminal AntiquoteBaseTypeExpr_t      '$BaseTypeExpr'      lexer classes {Antiquote, Reserved};
--marking terminal AntiquoteTypeModifierExpr_t  '$TypeModifierExpr'  lexer classes {Antiquote, Reserved};
marking terminal AntiquoteType_t              '$directTypeExpr'    lexer classes {Antiquote, Reserved};
marking terminal AntiquoteAttrib_t            '$Attrib'            lexer classes {Antiquote, Reserved}, dominates {AttributeNameUnfetterdByKeywords_t};

terminal Wild_t '_';

disambiguate Wild_t, Identifier_t {
  pluck Wild_t;
}
