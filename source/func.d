import std.format;

import helper;
import std.stdio;
import types;


alias BuiltinStaticFuncType = LispT function(LispT o);
BuiltinStaticFuncType[string] core;

static this(){
  core["car"] = &car;
  core["cdr"] = &cdr;
  core["rplaca"] = &rplaca;
  core["rplacd"] = &rplacd;
  core["cons"] = &cons;
  core["consp"] = &consp;
  core["list"] = &list;
}

LispT eval(LispT cell){
  if (isCell!LispCons(cell)){
    auto cons = castCell!LispCons(cell);
    auto f = eval(cell.car);
    auto c = evlist(cell.cdr);
    if (isCell!LispSymbol(f)){
      return apply(new LispCons(f, c));
    }
    return new LispError(format!"%s is not a LispSymbol"(f));
  }
  else{
    return cell;
  }
}

LispT apply(LispT o){
  try{
    verifyArgsCount(o, 2);
    auto symbol = castCell!LispSymbol(first(o));
    writeln("apply", symbol.sym);
    return core[symbol.sym](second(o));
  }
  catch(InterpreterException e){
    return new LispError(e.msg);
  }
}

LispT evlist(LispT o){
  try{
    //TODO last element
    verifyArgsCount(o, 1);
    auto cons = castCell!LispCons(first(o));
    return new LispCons(eval(cons.car), evlist(cons.cdr));
  }
  catch(InterpreterException e){
    return new LispError(e.msg);
  }
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
  try{
    verifyArgsCount(o, 2);
    auto n = castCell!LispNumber(o);
    auto l = castCell!LispCons(o);
    if(n > 0)
      return nth(n-1, c.cdr);
    return c.car;
  }
  catch(InterpreterException e){
    return new LispError("Not enough elements!");
  }
}

LispT list(LispT o){
  //TODO traverse list and lookup variables
  return o;
}

alias first = car;
//alias second = cadr;
//alias third = caddr;
//alias third = cadddr;
//...tenth
alias rest = cdr;

LispT car(LispT o){
  try{
    verifyArgsCount(o, 1);
    auto cons = castCell!LispCons(first(o));
    return cons.car;
  }
  catch(InterpreterException e){
    return new LispError(format!"%s is not a LispCons"(o));
  }
}

LispT cdr(LispT o){
  try{
    verifyArgsCount(o, 1);
    auto cons = castCell!LispCons(o);
    return cons.cdr;
  }
  catch(InterpreterException e){
    return new LispError(format!"%s is not a LispCons"(o));
  }
}

LispT rplaca(LispT o){
  try{
    verifyArgsCount(o, 2);
    auto c = castCell!LispCons(first(o));
    c.car = second(o);
    return c;
  }
  catch(InterpreterException e){
    return new LispError(format!"%s is not a LispCons"(o));
  }
}

LispT rplacd(LispT o){
  try{
    verifyArgsCount(o, 2);
    auto c = castCell!LispCons(first(o));
    c.cdr = second(o);
    return c;
  }
  catch(InterpreterException e){
    return new LispError(format!"%s is not a LispCons"(o));
  }
}

LispT cons(LispT o){
  try{
    verifyArgsCount(o, 2);
    return new LispCons(first(o), second(o));
  }
  catch(InterpreterException e){
    return new LispError(e.msg);
  }
}

LispT consp(LispT o){
  try{
    verifyArgsCount(o, 1);
    return boolToSymbol(isCell!LispCons(first(o)));
  }
  catch(InterpreterException e){
    return new LispError(e.msg);
  }
}

