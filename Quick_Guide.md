# Quick Guide to silver-ableC

This extension to Silver allows ableC extension writers to express complex ASTs by writing C code directly, instead of manually writing complex expressions.  For example, the new Silver expression

```
ableC_Stmt {
  int a = 1;
  int b = 2;
  return a + b;
}
```
is equivalent to writing
```
seqStmt(declStmt(variableDecls(...)), seqStmt(declStmt(variableDecls(...)), returnStmt(addExpr(...))))
```
except that the locations in the resulting AST correspond to the location of the constructs within the Silver source file.  These "bridge productions" from Silver to ableC syntax are provided for the nonterminals `Decls`, `Decl`, `Parameters`, `BaseTypeExpr`,`Stmt`, and `Expr`.  

It is frequently the case that we may wish to construct a complex AST, with some portions that are non-constant; for example, in defining the forward of an ableC extension production, the children of the production will likely need to be "plugged in" at some point in a more complex translation.  To remedy this, we introduce bridge productions from ableC back to Silver syntax, for example
```
ableC_Stmt {
  $BaseTypeExpr{...} a = $Initializer{e1};
  int b = $Expr{e2};
  int c = sizeof(a) + b;
  $Stmt{s}
}
```
Such constructs are provided for the `Decls`, `Decl`, `Stmt`, `Initializer`, `Exprs`, `Expr`, `Names`, `Name`, `StorageClasses`, `Parameters`, `StructItemList`, `EnumItemList`, `TypeNames`, `TypeName`, `BaseTypeExpr`, and `Attrib` nonterminals.  In addition, the `$TName{}` antiquote also accepts a `Name` and may be used where a type identifier is expected (this is distinct from `$Name` due to the syntactic ambiguity present in C.)  

Antiquote productions are also provided for several "collection" nonterminals, `Exprs`, `StorageClasses`, and `Parameters` - these antiquotes are written as a single member of the collection, and code is generated to allow for the appropriate append operations:
```
ableC_Decl {
  int foo(int a, float b, $Parameters{params}, int c, $Parameters{moreParams}) {
    ...
    int res = foo(1, 2, $Exprs{args}, 3, ${moreArgs});
    ...
  }
}
```
Note that no append is needed when the collection antiquote is the last item in the list, as with `moreParams` above.

A number of common antiquote idioms have been found, for which short-hands have been introduced (also providing more accurate locations):

Idiom                                                                                                 | Shorthand
----------------------------------------------------------------------------------------------------- | --------------------
`$Expr{realConstant(integerConstant(toString(i), false, noIntSuffix(), location=...), location=...)}` | `$intLiteralExpr{i}`
`$Expr{stringLiteral("\"" ++ escapeString(s) ++ "\"", location=...)}`                                 | `$stringLiteralExpr{s}`
`$Name{name(n, location=...)}`                                                                        | `$name{n}`
`$TName{name(n, location=...)}`                                                                       | `$tname{n}`
`$BaseTypeExpr{directTypeExpr(t)}`                                                                    | `$directTypeExpr{t}`

## Pattern matching
Instead of constructing abstract syntax trees, occasionally we instead wish to deconstruct them by pattern matching, for example to perform a transformation on a particular combination of host-langauge features
```
case s of
| ableC_Stmt {
    for ($BaseTypeExpr{_} $Name{i1} = 0; $Name{i2} < $Expr{limit}; $Name{i3} ++) {
      $Stmt{body}
    }
  } -> if i1.name == i2.name && i1.name == i3.name then ... else s
| _ -> s
end;
```

Here pattern variables and wildcards of various types may be written as antiquotes.
Also note that Silver does not support non-linear pattern matching, which means that a particular pattern variable may only appear once in a pattern.
This may require additional equality checking on the right side of the pattern rule.

## Typedef Prototypes
Due to the ambiguous nature of the C grammar and the infamous "lexer hack", knowledge of whether an identifier has previously been defined as a value or a typedef is often required during parsing.  As fragments of code involved in definitions may reference types defined in header files, some method of informing the lexer of all externally defined typedefs is needed.  To do this, the syntax `proto_typedef foo, bar, baz;` may be used at the start of any ableC block.  This has no semantic meaning, and only has an effect on how identifiers are parsed.  

## Additional Extensions
When building an extension on other ableC extensions, it is useful to use their syntax in a similar way when constructing ASTs.  This can be done simply by including ableC extensions in the parser along side silver and silver-ableC.  The default composed version of Silver built by this repository contains several commonly useful extensions, including ableC-closure, ableC-refcount-closure (transparent prefix `refcount`), ableC-templating, and ableC-algebraic-data-types (for the full list, see [the composed artifact specification file](grammars/edu.umn.cs.melt.exts.silver.ableC/composed/with_all/Main.sv).)  However, it is possible to write a custom artifact for Silver to build silver-ableC with a different set of extensions.  
