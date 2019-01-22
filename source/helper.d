import types;
import std.conv;

import object : TypeInfo_Class;
import std.format;

import std.exception;


class InterpreterException: Exception
{
  ///
  mixin basicExceptionCtors;
}

string generateCars(){
  string[] cars = ["car", "cdr", "caar", "cadr", "cdar", "cddr", "caaar", "caadr", "cadar", "caddr", "cdaar", "cdadr", "cddar", "cdddr", "caaaar", "caaadr", "caadar", "caaddr", "cadaar", "cadadr", "caddar", "cadddr", "cdaaar", "cdaadr", "cdadar", "cdaddr", "cddaar", "cddadr", "cdddar", "cddddr"];
  string output;
  foreach(car; cars){
    output ~= "LispT " ~ car ~"(LispT cell){
if (isCell!ConsCell(cell))
return cell;
else
return new LispError(format!\"" ~ car ~ "on %s is not allowed\"(cell));}";
  }
  return output;
}


bool isCell(T)(LispT cell){
  return !(cast(T) cell is null);
}

T castCell(T)(LispT cell){
  T res = cast(T) cell;
  if (res is null) throw new InterpreterException("Expected " ~ typeid(T).name);
  return res;
}

void verifyArgsCount(LispT o, int l){
  auto cons = castCell!LispCons(o);
  if (cons.cdr !is null){
    return verifyArgsCount(cons.cdr, l-1);
  }
  else if(0 == l){
    return;
  }
  throw new InterpreterException("Expected " ~ to!string(l) ~ " arguments");
}

LispT boolToSymbol(bool b){
  return b ? lispTrue : lispNil;
}
