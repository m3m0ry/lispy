import types;
import std.conv;

import object : TypeInfo_Class;
import std.format;

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
  return (typeid(cell) == typeid(T));
}

T castCell(T)(LispT cell){
  T res = cast(T) cell;
  if (res is null) throw new Exception("Expected " ~ typeid(T).name);
  return res;
}

LispT[] verifyArgsCount(LispT[] o, int l){
  if (o.length != l)
    throw new Exception("Expected " ~ to!string(l) ~ " arguments");
  return o;
}

LispT boolToSymbol(bool b){
  return b ? lispTrue : lispNil;
}
