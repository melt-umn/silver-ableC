grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax:host_operators;

{-
  The terminals introduced by this extension are the same as those used by
  ableC for the overloadable versions of the operators.
  We resolve the resulting lexical ambiguities in favor of the overloadable
  terminals here with disambiguation functions, and expect the composition site
  to specify a transparent prefix for this grammar.
  References to names present an issue, as these are overloaded but do not have
  an operator that can be duplicated as a marking terminal.
  Instead we introduce an empty marking terminal to prefix the identifier.
  This marking terminal will usually fail to match due to maximal munch, but it
  will still be prefixed by the transparent prefix assigned to this extension
  grammar.
-}

-- Structural symbols
marking terminal HostLParen_t      '('    lexer classes {Operator};
marking terminal HostLBracket_t    '['    lexer classes {Operator};
marking terminal HostLCurly_t      '{'    lexer classes {Operator};

-- Member operators
marking terminal HostDot_t         '.'    lexer classes {Operator};
marking terminal HostPtrDot_t      '->'   lexer classes {Operator};

-- Assignment operators
marking terminal HostAssign_t       '='     lexer classes {Assignment};
marking terminal HostRightAssign_t  '>>='   lexer classes {Assignment};
marking terminal HostLeftAssign_t   '<<='   lexer classes {Assignment};
marking terminal HostAddAssign_t    '+='    lexer classes {Assignment};
marking terminal HostSubAssign_t    '-='    lexer classes {Assignment};
marking terminal HostMulAssign_t    '*='    lexer classes {Assignment};
marking terminal HostDivAssign_t    '/='    lexer classes {Assignment};
marking terminal HostModAssign_t    '%='    lexer classes {Assignment};
marking terminal HostAndAssign_t    '&='    lexer classes {Assignment};
marking terminal HostXorAssign_t    '^='    lexer classes {Assignment};
marking terminal HostOrAssign_t     '|='    lexer classes {Assignment};

-- Bit operators
marking terminal HostAnd_t         '&'    lexer classes {Operator}; -- address of
marking terminal HostOr_t          '|'    lexer classes {Operator};
marking terminal HostTilde_t       '~'    lexer classes {Operator};
marking terminal HostXor_t         '^'    lexer classes {Operator};
marking terminal HostRightShift_t  '>>'   lexer classes {Operator};
marking terminal HostLeftShift_t   '<<'   lexer classes {Operator};

-- Numerical operators
marking terminal HostMinus_t       '-'  precedence = 5, association = left, lexer classes {Operator}; -- negative
marking terminal HostPlus_t        '+'  precedence = 5, association = left, lexer classes {Operator}; -- positive
marking terminal HostStar_t        '*'  precedence = 6, association = left, lexer classes {Operator}; -- pointer, deref
marking terminal HostDivide_t      '/'  precedence = 6, association = left, lexer classes {Operator};
marking terminal HostMod_t         '%'  precedence = 6, association = left, lexer classes {Operator};

-- Logical operators
marking terminal HostNot_t   '!'  lexer classes {Operator};
marking terminal HostAndOp_t '&&' precedence = 4, association = left, lexer classes {Operator};
marking terminal HostOrOp_t  '||' precedence = 4, association = left, lexer classes {Operator};

-- Comparison operators
marking terminal HostLessThan_t         '<'  precedence = 3, association = left, lexer classes {Operator};
marking terminal HostGreaterThan_t      '>'  precedence = 3, association = left, lexer classes {Operator};
marking terminal HostLessThanEqual_t    '<=' precedence = 3, association = left, lexer classes {Operator};
marking terminal HostGreaterThanEqual_t '>=' precedence = 3, association = left, lexer classes {Operator};
marking terminal HostEquality_t         '==' precedence = 3, association = left, lexer classes {Operator};
marking terminal HostNonEquality_t      '!=' precedence = 3, association = left, lexer classes {Operator};

-- *crement operators
marking terminal HostInc_t        '++'    lexer classes {Operator};
marking terminal HostDec_t        '--'    lexer classes {Operator};

-- Identifier references
marking terminal HostId_t ''    lexer classes {Operator};

-- Prefer the overloaded versions of all these by default
disambiguate LParen_t, HostLParen_t { pluck LParen_t; }
disambiguate LBracket_t, HostLBracket_t { pluck LBracket_t; }
disambiguate LCurly_t, HostLCurly_t { pluck HostLCurly_t; }
disambiguate Dot_t, HostDot_t { pluck Dot_t; }
disambiguate PtrDot_t, HostPtrDot_t { pluck PtrDot_t; }
disambiguate Assign_t, HostAssign_t { pluck Assign_t; }
disambiguate RightAssign_t, HostRightAssign_t { pluck RightAssign_t; }
disambiguate LeftAssign_t, HostLeftAssign_t { pluck LeftAssign_t; }
disambiguate AddAssign_t, HostAddAssign_t { pluck AddAssign_t; }
disambiguate SubAssign_t, HostSubAssign_t { pluck SubAssign_t; }
disambiguate MulAssign_t, HostMulAssign_t { pluck MulAssign_t; }
disambiguate DivAssign_t, HostDivAssign_t { pluck DivAssign_t; }
disambiguate ModAssign_t, HostModAssign_t { pluck ModAssign_t; }
disambiguate AndAssign_t, HostAndAssign_t { pluck AndAssign_t; }
disambiguate XorAssign_t, HostXorAssign_t { pluck XorAssign_t; }
disambiguate OrAssign_t, HostOrAssign_t { pluck OrAssign_t; }
disambiguate And_t, HostAnd_t { pluck And_t; }
disambiguate Or_t, HostOr_t { pluck Or_t; }
disambiguate Tilde_t, HostTilde_t { pluck Tilde_t; }
disambiguate Xor_t, HostXor_t { pluck Xor_t; }
disambiguate RightShift_t, HostRightShift_t { pluck RightShift_t; }
disambiguate LeftShift_t, HostLeftShift_t { pluck LeftShift_t; }
disambiguate Minus_t, HostMinus_t { pluck Minus_t; }
disambiguate Plus_t, HostPlus_t { pluck Plus_t; }
disambiguate Star_t, HostStar_t { pluck Star_t; }
disambiguate Divide_t, HostDivide_t { pluck Divide_t; }
disambiguate Mod_t, HostMod_t { pluck Mod_t; }
disambiguate Not_t, HostNot_t { pluck Not_t; }
disambiguate AndOp_t, HostAndOp_t { pluck AndOp_t; }
disambiguate OrOp_t, HostOrOp_t { pluck OrOp_t; }
disambiguate LessThan_t, HostLessThan_t { pluck LessThan_t; }
disambiguate GreaterThan_t, HostGreaterThan_t { pluck GreaterThan_t; }
disambiguate LessThanEqual_t, HostLessThanEqual_t { pluck LessThanEqual_t; }
disambiguate GreaterThanEqual_t, HostGreaterThanEqual_t { pluck GreaterThanEqual_t; }
disambiguate Equality_t, HostEquality_t { pluck Equality_t; }
disambiguate NonEquality_t, HostNonEquality_t { pluck NonEquality_t; }
disambiguate Inc_t, HostInc_t { pluck Inc_t; }
disambiguate Dec_t, HostDec_t { pluck Dec_t; }
