# Implementation
There are several implementation issues that must be handled for this extension

## Concrete Syntax
Due to the modular nature of Silver programs, it is possible to reuse the entire concrete syntax of ableC as an "embedded DSL" by exporting it from within the extension.  Concrete "bridge productions" from Silver to ableC are supplied, defining the various new Silver constructs for embedding ableC.  These productions demand the `ast` of the wrapped ableC concrete syntax, forwarding to abstract counterparts that perform the actual translation.  

The escape constructs are effectively an extension to ableC, in turn treating Silver as an embedded DSL.  For each escape there is a corresponding concrete and abstract ableC-to-Silver bridge production.  Note that the abstract bridge productions have no real forward, as they will be translated away in the undecorated tree, and thus forward to an error message to avoid errors with the modular well-definedness analysis.  

## Translation
Once an ableC AST has been produced, we must somehow generate a translation into the Silver `Expr` AST that, when evaluated at run-time, will construct this ableC AST.  To do this, Silver has a general purpouse reflection library that can transform any tree into a generic tree representation, the nonterminal `AST`: 

```
nonterminal AST;

abstract production nonterminalAST
top::AST ::= prodName::String children::ASTs annotations::NamedASTs
{}

abstract production listAST
top::AST ::= vals::ASTs
{}

abstract production stringAST
top::AST ::= s::String
{}

abstract production integerAST
top::AST ::= i::Integer
{}

...

```

The library also supplies a (foreign) function `reflect :: (AST ::= a)` that transform a value of an arbitrary type, in this case an ableC AST nonterminal, into its corresponding `AST` representation.  A new analysis (synthesized attribute) to compute the translation into a Silver `Expr` constructing this tree is defined on `AST`, using aspect productions.  

### Escapes
Translating escape bridge productions from ableC back to Silver present a challenge: we must somehow embed the contained tree directly within the translated Silver `Expr`, but reflecting the entire ableC AST will also reflect contained Silver `Expr`s into `AST`s.  Attempting to extract these `Exprs` from the ableC tree prior to reflection is unfeasible, as some set of attributes would need to be written for the entire abstract syntax of ableC.  Thus, a method of reifying an `AST` back into an actual value is needed; to do this, a function `reify :: (Either<a String> ::= AST)` is built into Silver, that either constructs a value of its result type, or returns an error if the `AST` is not valid for that type.  Thus when translating an `AST` into a Silver `Expr` and an escape production is encountered, its child can be reifyed back to a Silver `Expr` and used in the translation.  Variations on this basic idea are also possible for more complex types of escape productions.  

## Further Information
Early design discussion may be found in the following github issues:
* https://github.com/melt-umn/silver/issues/194
* https://github.com/melt-umn/silver/issues/212
