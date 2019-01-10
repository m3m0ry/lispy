import std.stdio;
import std.format;
import std.algorithm: reduce, map, each, any;
import std.algorithm.iteration;
import std.conv : to, ConvException, text;
import std.range : drop;
import std.exception : enforce;
import std.container : DList;


string generateCars(){
  string[] cars = ["car", "cdr", "caar", "cadr", "cdar", "cddr", "caaar", "caadr", "cadar", "caddr", "cdaar", "cdadr", "cddar", "cdddr", "caaaar", "caaadr", "caadar", "caaddr", "cadaar", "cadadr", "caddar", "cadddr", "cdaaar", "cdaadr", "cdadar", "cdaddr", "cddaar", "cddadr", "cdddar", "cddddr"];
  string output;
  foreach(car; cars){
    output ~= format!"LispObject %s(){return new LispError(format!\"%s on %%s is not allowed\"(this));}\n"(car,car);
  }
  return output;
}




abstract class LispObject{
  override string toString();
  mixin(generateCars());
}

//TODO implement car function/property
class ConsCell: LispObject{
  LispObject car_;
  LispObject cdr_;
  this(LispObject car = null, LispObject cdr = null){
    this.car_ = car;
    this.cdr_ = cdr;
  }
  override string toString(){
    return format!"( %s . %s )"(car, cdr);
  }
  override LispObject car(){
    return car_;
  }
}

class Number: LispObject
{
  int num;
  this(int x){
    num = x;
  }
  this(string s){
    num = to!int(s);
  }
  override string toString(){
    return to!string(num);
  }
}

class LispError: LispObject{
  string err;
  this(string e){
    err = e;
  }
  override string toString(){
    return err;
  }
}

class Symbol: LispObject{
  string sym;
  this(string s){
    sym = s;
  }
  override string toString(){
    return sym;
  }
}


