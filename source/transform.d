import pegged.peg;

import conscell;

LispObject transform(ParseTree p){
  switch(p.name){
  case "Lispy.number":
    return new Number(p.matches[0]);
  case "Lispy.symbol":
    return new Symbol(p.matches[0]);
  case "Lispy.sexpr":
    auto head = new ConsCell;
    auto x = head;
    foreach(i, child; p.children){
      x.car = transform(child);
      if (i+1 < p.children.length){
        x.cdr = new ConsCell;
        x = cast(ConsCell) x.cdr;
      }
    }
    return head;
  default: // aka expr or lispy
    return transform(p.children[0]);
  }
}

