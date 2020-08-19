grammar edu:umn:cs:melt:exts:silver:ableC:concretesyntax:host_operators;

{-
  The concrete syntax productions for ableC operators construct the overloaded
  versions of the operator abstract syntax productions.
  However when specifying terms or patterns with concrete syntax, sometimes we
  instead want the non-overloaded "host" versions.
  Here we specify an extension to ableC that provides concrete syntax for these
  abstract productions.
  TODO: Consider introducing a similar extension for the "injectable" operator
  productions, if needed.
-}

imports silver:langutil;
imports edu:umn:cs:melt:ableC:concretesyntax;
imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

concrete productions top::AssignOp_c
| '='   { top.ast = eqExpr(top.leftExpr, top.rightExpr); }
| '*='  { top.ast = mulEqExpr(top.leftExpr, top.rightExpr); }
| '/='  { top.ast = divEqExpr(top.leftExpr, top.rightExpr); }
| '%='  { top.ast = modEqExpr(top.leftExpr, top.rightExpr); }
| '+='  { top.ast = addEqExpr(top.leftExpr, top.rightExpr); }
| '-='  { top.ast = subEqExpr(top.leftExpr, top.rightExpr); }
| '<<=' { top.ast = lshEqExpr(top.leftExpr, top.rightExpr); }
| '>>=' { top.ast = rshEqExpr(top.leftExpr, top.rightExpr); }
| '&='  { top.ast = andEqExpr(top.leftExpr, top.rightExpr); }
| '^='  { top.ast = xorEqExpr(top.leftExpr, top.rightExpr); }
| '|='  { top.ast = orEqExpr(top.leftExpr, top.rightExpr); }

concrete productions top::LogicalOrOp_c
| '||'   { top.ast = orExpr(top.leftExpr, top.rightExpr); }

concrete productions top::LogicalAndOp_c
| '&&'   { top.ast = andExpr(top.leftExpr, top.rightExpr); }

concrete productions top::InclusiveOrOp_c
| '|'   { top.ast = orBitExpr(top.leftExpr, top.rightExpr); }

concrete productions top::ExclusiveOrOp_c
| '^'   { top.ast = xorExpr(top.leftExpr, top.rightExpr); }

concrete productions top::AndOp_c
| '&'   { top.ast = andBitExpr(top.leftExpr, top.rightExpr); }

concrete productions top::EqualityOp_c
| '=='   { top.ast = equalsExpr(top.leftExpr, top.rightExpr); }
| '!='   { top.ast = notEqualsExpr(top.leftExpr, top.rightExpr); }

concrete productions top::RelationalOp_c
| '<'   { top.ast = ltExpr(top.leftExpr, top.rightExpr); }
| '>'   { top.ast = gtExpr(top.leftExpr, top.rightExpr); }
| '<='   { top.ast = lteExpr(top.leftExpr, top.rightExpr); }
| '>='   { top.ast = gteExpr(top.leftExpr, top.rightExpr); }

concrete productions top::ShiftOp_c
| '<<'   { top.ast = lshExpr(top.leftExpr, top.rightExpr); }
| '>>'   { top.ast = rshExpr(top.leftExpr, top.rightExpr); }

concrete productions top::AdditiveOp_c
| '+'
    { top.ast = addExpr(top.leftExpr, top.rightExpr); }
| '-'
    { top.ast = subExpr(top.leftExpr, top.rightExpr); }

concrete productions top::MultiplicativeOp_c
| '*'   { top.ast = mulExpr(top.leftExpr, top.rightExpr); }
| '/'   { top.ast = divExpr(top.leftExpr, top.rightExpr); }
| '%'   { top.ast = modExpr(top.leftExpr, top.rightExpr); }

concrete productions top::CastExpr_c
| '(' tn::TypeName_c ')' e::CastExpr_c
    { top.ast = explicitCastExpr(tn.ast, e.ast); }

concrete productions top::UnaryExpr_c
| '++' e::UnaryExpr_c
    { top.ast = preIncExpr(e.ast); }
| '--' e::UnaryExpr_c
    { top.ast = preDecExpr(e.ast); }
concrete productions top::UnaryOp_c
| '&'  { top.ast = addressOfExpr(top.expr); }
| '*'  { top.ast = dereferenceExpr(top.expr); }
| '+'  { top.ast = positiveExpr(top.expr); }
| '-'  { top.ast = negativeExpr(top.expr); }
| '~'  { top.ast = bitNegateExpr(top.expr); }
| '!'  { top.ast = notExpr(top.expr); }

concrete productions top::PostfixOp_c
| '[' index::Expr_c ']'
    { top.ast = arraySubscriptExpr(top.expr, index.ast); }
| '(' args::ArgumentExprList_c ')'
    { top.ast = callExpr(top.expr, foldExpr(args.ast)); }
| '(' args::ArgumentExprList_c ',' ')'
    { top.ast = callExpr(top.expr, foldExpr(args.ast)); }
| '(' ')'
    { top.ast = callExpr(top.expr, nilExpr()); }
| '.' id::Identifier_c
    { top.ast = memberExpr(top.expr, false, id.ast); }
| '->' id::Identifier_c
    { top.ast = memberExpr(top.expr, true, id.ast); }
| '++'   { top.ast = postIncExpr(top.expr); }
| '--'   { top.ast = postDecExpr(top.expr); }

concrete productions top::PrimaryExpr_c
| HostId_t id::Identifier_c
  { top.ast = declRefExpr(id.ast);
    top.directName = nothing(); }
