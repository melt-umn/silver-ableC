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

`$Expr{realConstant(integerConstant(toString(i), false, noIntSuffix(), location=...), location=...)}` | `$intLiteralExpr{i}`
`$Expr{stringLiteral("\"" ++ escapeString(s) ++ "\"", location=...)}`                                 | `$stringLiteralExpr{s}`
`$Name{name(n, location=...)}`                                                                        | `$name{n}`
`$TName{name(n, location=...)}`                                                                       | `$tname{n}`
`$BaseTypeExpr{directTypeExpr(t)}`                                                                    | `directTypeExpr{t}`

## More information
