import pegged.grammar;
import std.stdio;

import conscell;

ConsCell transform(ParseTree p){
  switch(p.name){
  case "Lispy.number":
    return new NumberCell(p.matches[0]);
  case "Lispy.symbol":
    return new SymbolCell(p.matches[0]);
  case "Lispy.sexpr":
    auto head = new ConsCell;
    auto x = head;
    foreach(child; p.children){
      x.car = transform(child);
      x.cdr = new ConsCell;
      x = x.cdr;
    }
    return head;
  default: // aka expr or lispy
    return transform(p.children[0]);
  }
}
