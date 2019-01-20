import pegged.peg;

import types;

LispT transform(ParseTree p){
  switch(p.name){
  case "Lispy.number":
    return new LispNumber(p.matches[0]);
  case "Lispy.symbol":
    return new LispSymbol(p.matches[0]);
  case "Lispy.sexpr":
    auto head = new LispCons;
    auto x = head;
    foreach(i, child; p.children){
      x.car = transform(child);
      if (i+1 < p.children.length){
        x.cdr = new LispCons;
        x = cast(LispCons) x.cdr;
      }
    }
    return head;
  default: // aka expr or lispy
    return transform(p.children[0]);
  }
}

