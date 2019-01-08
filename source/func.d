import std.format;

import conscell;

string prin1(LispObject cell, bool beginning = true){
  //TODO cycles
  string output;
  if(beginning)
    output ~= "(";
  auto consCell = cast(ConsCell) cell;
  if(consCell !is null){
    bool tree = cast(ConsCell)consCell.car !is null;
    output ~= format!" %s"(prin1(consCell.car, tree));
    if (consCell.cdr is null)
      output ~= " )";
    else{
      output ~= format!" %s"(prin1(consCell.cdr, false));
    }
  }
  else
    output ~= cell.toString();
  return output;
}

ConsCell list(ConsCell cell){
  //TODO traverse list and lookup variables
  return cell;
}

//Cons concepts
//TODO caar, cadr, cdar, cddr, ..., cddddr
LispObject car(ConsCell cell){
  return cell.car;
}

ConsCell rplaca(ConsCell cell, LispObject car){
  cell.car = car;
  return cell;
}

LispObject cdr(ConsCell cell){
  return cell.cdr;
}

LispObject rplacd(LispObject cell, LispObject cdr){
  //TODO need checkCellType first
  auto consCell = cast(ConsCell)cell;
  if (consCell is null)
    return new LispError("")
  cell.cdr = cdr;
  return cell;
}

ConsCell cons(LispObject car, LispObject cdr){
  return new ConsCell(car, cdr);
}

bool consp(LispObject cell){
  return cast(ConsCell)cell !is null;
}


