import std.format;

import helper;
import std.stdio;
import types;


alias BuiltinStaticFuncType = LispT function(LispT o);
BuiltinStaticFuncType[string] core;

static this(){
  mixin(generateCarsCore());
  core["rplaca"] = &rplaca;
  core["rplacd"] = &rplacd;
  core["cons"] = &cons;
  core["consp"] = &consp;
  core["list"] = &list;
}

LispT eval(LispT cell){
  if (isCell!LispCons(cell)){
    auto cons = castCell!LispCons(cell);
    auto f = eval(first(cell));
    auto c = evlist(rest(cell));
    if (isCell!LispSymbol(f)){
      return apply(new LispCons(f, new LispCons(c)));
    }
    return new LispError(format!"%s is not a LispSymbol"(f));
  }
  else{
    return cell;
  }
}

LispT apply(LispT o){
  verifyListLength(o, 2);
  auto symbol = castCell!LispSymbol(first(o));
  return core[symbol.sym](second(o));
}

LispT evlist(LispT o){
  if (o is lispNil)
    return o;
  auto c = castCell!LispCons(o);
  return new LispCons(eval(first(c)), evlist(rest(c)));
}


//TODO rework prin1
string prin1(LispT cell, bool beginning = true){
  //TODO cycles
  string output;
  if(beginning)
    output ~= "(";
  auto consCell = cast(LispCons) cell;
  if(consCell !is null){
    bool tree = cast(LispCons)consCell.car !is null;
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

LispT nth(LispT o){
  verifyListLength(o, 2);
  auto n = castCell!LispNumber(o);
  auto c = castCell!LispCons(o);
  if(n.num > 0)
    return nth(new LispCons(new LispNumber(n.num-1), c.cdr));
  return c.car;
}

LispT list(LispT o){
  //TODO traverse list and lookup variables
  return o;
}


LispT length(LispT o){
  auto c = castCell!LispCons(o);
  if (c.cdr is lispNil)
    return new LispNumber(1);
  else
    return new LispNumber(1) + castCell!LispNumber(length(c.cdr));
}


mixin(generateCarsFunction());
alias first = car;
alias second = cadr;
alias third = caddr;
alias fourth = cadddr;
//...tenth
alias rest = cdr;

LispT rplaca(LispT o){
  verifyListLength(o, 2);
  auto c = castCell!LispCons(first(o));
  c.car = second(o);
  return c;
}

LispT rplacd(LispT o){
  verifyListLength(o, 2);
  auto c = castCell!LispCons(first(o));
  c.cdr = second(o);
  return c;
}

LispT cons(LispT o){
  verifyListLength(o, 2);
  return new LispCons(first(o), second(o));
}

LispT consp(LispT o){
  verifyListLength(o, 1);
  return boolToSymbol(isCell!LispCons(first(o)));
}

