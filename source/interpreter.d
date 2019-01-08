/*
import conscell;

ConsCell eval(){
  foreach(ref child; cell)
    child = child.eval;
  foreach(child; cell){
    if ( cast(LError)child !is null)
      return child;
  }
  if (cell.length == 0)
    return this;
  if (cell.length == 1)
    return cell[0];

  if( cast(LSymbol)cell[0] is null)
    return new LError(format!"S-expression does not start with symbol, instead: %s"(cell[0]));

  return builtinOp;
}

ConsCell builtinOp(){
  auto op = cell[0].toString;
  auto numbers = cell[1..$];
  auto x = numbers[0];
  foreach(child; numbers){
    if( cast(LNumber) child is null)
      return new LError("Cannot operate on non-number!");
  }
  if( op == "-" && numbers.length == 1){
    x.num *= -1;
    return x;
  }
  switch (op){
  case "+":
    numbers.drop(1).each!(a => x.num += a.num);
    break;
  case "-":
    numbers.drop(1).each!(a => x.num -= a.num);
    break;
  case "*":
    numbers.drop(1).each!(a => x.num *= a.num);
    break;
  case "/":
    if (numbers.drop(1).any!"a.num == 0")
      return new ErrorCell("Division by 0");
    numbers.drop(1).each!(a => x.num /= a.num);
    break;
  default:
    assert(0);
  }
  return x;
}

*/
