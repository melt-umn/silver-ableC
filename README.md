# silver-ableC
This extension to Silver allows for ableC extension writers to express complex ASTs by writing C code directly, instead of manually writing complex expressions.  For example, the new Silver expression
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
except that the locations in the resulting AST correspond to the location of the constructs within the Silver source file.  These "bridge productions" from Silver to ableC syntax are provided for the nonterminals `Decls`, `Decl`, `Parameters`, `Stmt`, and `Expr`.  

It is frequently the case that we may wish to construct a complex AST, with some portions that are non-constant; for example, in defining the forward of an ableC extension production, the children of the production will likely need to be "plugged in" at some point in a more complex translation.  To remedy this, we introduce bridge productions from ableC back to Silver syntax, for example
```
ableC_Stmt {
  $BaseTypeExpr{...} a = $Initializer{e1};
  int b = $Expr{e2};
  int c = sizeof(a) + b;
  $Stmt{s}
}
```
Such constructs are provided for the `Decls`, `Decl`, `Parameters`, `Stmt`, `Initializer`, `Expr`, `Name`, `TypeName`, `BaseTypeExpr`, and `Attrib` nonterminals.  In addition, the `$TName{}` escape also accepts a `Name` and may be used where a type identifier is expected (this is distinct from `$Name` due to the syntactic ambiguity present in C.)  

Escape productions are also provided for several "collection" nonterminals, `Exprs`, `StorageClasses`, and `Parameters` - these escapes are written as a single member of the collection, and code is generated to allow for the appropriate append operations:
```
ableC_Decl {
  int foo(int a, float b, $Parameters{params}, int c, $Parameters{moreParams}) {
    ...
    int res = foo(1, 2, $Exprs{args}, 3, ${moreArgs});
    ...
  }
}
```

A number of common escape idioms have been found, for which short-hands have been introduced (also providing more accurate locations):

Idiom                                                                                                 | Shorthand
----------------------------------------------------------------------------------------------------- | --------------------
`$Expr{realConstant(integerConstant(toString(i), false, noIntSuffix(), location=...), location=...)}` | `$intLiteralExpr{i}`
`$Expr{stringLiteral("\"" ++ escapeString(s) ++ "\"", location=...)}`                                 | `$stringLiteralExpr{s}`
`$Name{name(n, location=...)}`                                                                        | `$name{n}`
`$TName{name(n, location=...)}`                                                                       | `$tname{n}`
`$BaseTypeExpr{directTypeExpr(t)}`                                                                    | `directTypeExpr{t}`

## Typedef prototypes
Due to the ambiguous nature of the C grammar and the infamous "lexer hack", knowledge of whether an identifier has previously been defined as a value or a typedef is often required during parsing.  As fragments of code involved in definitions may reference types defined in header files, some method of informing the lexer of all externally defined typedefs is needed.  To do this, the syntax `proto_typedef foo, bar, baz;` may be used at the start of any ableC block.  This has no semantic meaning, and only has an effect on how identifiers are parsed.  

## Additional extensions
When building an extension on other ableC extensions, it is useful to use their syntax in a similar way when constructing ASTs.  This can be done simply by including ableC extensions in the parser along side silver and silver-ableC.  The default composed version of Silver built by this repository contains several commonly useful extensions: ableC-closure, ableC-refcount-closure (transparent prefix `refcount`), and ableC-templating.  However, it is possible to write a custom artifact for Silver to build silver-ableC with a different set of extensions.  

## More information
More documentation:
* [Getting started with using the extension](GETTING_STARTED.md)
* [How it works](IMPLEMENTATION.md)

ableC extensions using this extension:
* [ableC-closure](https://github.com/melt-umn/ableC-closure)
* [ableC-vector](https://github.com/melt-umn/ableC-vector)
* [ableC-nondeterministic-search](https://github.com/melt-umn/ableC-nondeterministic-search)
