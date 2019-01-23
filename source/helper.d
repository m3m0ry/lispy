import types;
import std.conv;

import object : TypeInfo_Class;
import std.algorithm : map, cartesianProduct;
import std.format;
import std.range;

import std.exception;

import func;


class InterpreterException: Exception
{
  ///
  mixin basicExceptionCtors;
}

string generateCarsCore(){
  auto cars = generateCars();
  string output;
  foreach(car; cars){
    output ~= format!"core[\"c%sr\"] = &c%sr;"(car, car);
  }
  return output;
}

string[] generateCars(){
  auto cars = ["a", "d"];
  auto new_cars = cars;
  foreach(i; iota(3)){
    new_cars = cartesianProduct(["a", "d"], new_cars).map!(a => format!"%s%s"(a.expand)).array;
    cars ~= new_cars;
  }
  return cars;
}

string generateCarsFunction(){
  auto cars = generateCars();
  string output;
  foreach(car; cars){
    output ~= "LispT c" ~ car ~"r(LispT o){\n\t\tLispT c = o;\n";
    foreach_reverse(c; car){
      output ~= format!"\tc = castCell!LispCons(c).c%sr;\n"(c);
    }
    output ~= "\treturn c;}\n";
  }
  return output;
}

bool isCell(T)(LispT cell){
  return ((cast(T) cell) !is null);
}

T castCell(T)(LispT cell){
  T res = cast(T) cell;
  if (res is null) throw new InterpreterException("Expected " ~ typeid(T).name ~ "    Recieved " ~ cell.toString);
  return res;
}

void verifyListLength(LispT o, int l){
  auto n = castCell!LispNumber(length(o));
  if (n.num != l)
    throw new InterpreterException("Expected " ~ to!string(l) ~ " arguments but " ~ n.toString ~ " given");
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
