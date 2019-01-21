import std.format;

import helper;
import std.stdio;
import types;


alias BuiltinStaticFuncType = LispT function(LispT[] o ...);
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
    cons.car = eval(cell.car);
    cons.cdr = eval(cell.cdr);
    if (isCell!LispSymbol(cell)){
      return apply([cons.car] ~ [cons.cdr]);
    }
    return cons;
  }
  else{
    return cell;
  }
}

LispT apply(LispT[] o ...){
  verifyArgsCount(o, 2);
  if (isCell!LispSymbol(o[0])){
    auto symbol = castCell!LispSymbol(o[0]);
    writeln("apply" ~ symbol.sym);
    return core[symbol.sym](o[1..$]);
  }
  return new LispError(format!"%s is not a LispSymbol"(o[0]));
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

LispT list(LispT[] o ...){
  //TODO traverse list and lookup variables
  return o[0];
}

LispT car(LispT[] o ...){
  verifyArgsCount(o, 1);
  if (isCell!LispCons(o[0])){
    auto cons = castCell!LispCons(o[0]);
    return cons.car;
  }
  else
    return new LispError(format!"%s is not a LispCons"(o[0]));
}

LispT cdr(LispT[] o ...){
  verifyArgsCount(o, 1);
  if (isCell!LispCons(o[0])){
    auto cons = castCell!LispCons(o[0]);
    return cons.cdr;
  }
  else
    return new LispError(format!"%s is not a LispCons"(o[0]));
}

LispT rplaca(LispT[] o ...){
  verifyArgsCount(o, 2);
  if (isCell!LispCons(o[0])){
    auto cons = castCell!LispCons(o[0]);
    cons.car = o[1];
    return cons;
  }
  else
    return new LispError(format!"%s is not a LispCons"(o[0]));
}

LispT rplacd(LispT[] o ...){
  verifyArgsCount(o, 2);
  if (isCell!LispCons(o[0])){
    auto cons = castCell!LispCons(o[0]);
    cons.cdr = o[1];
    return cons;
  }
  else
    return new LispError(format!"%s is not a LispCons"(o[0]));
}

LispT cons(LispT[] o ...){
  verifyArgsCount(o, 2);
  return new LispCons(o[0], o[1]);
}

LispT consp(LispT[] o ...){
  verifyArgsCount(o, 1);
  return boolToSymbol(isCell!LispCons(o[0]));
}

