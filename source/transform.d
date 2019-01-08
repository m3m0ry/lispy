import pegged.peg;
import std.stdio;
import std.format;

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
    foreach(i, child; p.children){
      x.car = transform(child);
      if (i+1 < p.children.length)
        x.cdr = new ConsCell;
      x = x.cdr;
    }
    return head;
  default: // aka expr or lispy
    return transform(p.children[0]);
  }
}

string prin1(ConsCell cell, bool beginning = true){
  //TODO cycles
  //TODO (+ 1 2 (3 4))
  string output;
  if(beginning)
    output ~= "(";
  if(cell.classinfo is ConsCell.classinfo){
    if (cell.cdr is null)
      output ~= format!" %s )"(prin1(cell.car,false));
    else{
      bool tree = cell.car.classinfo is ConsCell.classinfo;
      output ~= format!" %s %s"(prin1(cell.car, tree), prin1(cell.cdr, tree));
    }
  }
  else
    output ~= cell.toString();
  return output;
}
