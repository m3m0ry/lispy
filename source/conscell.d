import std.stdio;
import std.format;
import std.algorithm: reduce, map, each, any;
import std.conv : to, ConvException, text;
import std.range : drop;
import std.exception : enforce;
import std.container : DList;


//TODO abstract class or interface should be Object
interface LispObject{
  string toString();
}

class ConsCell: LispObject{
  LispObject car;
  LispObject cdr;
  this(LispObject car = null, LispObject cdr = null){
    this.car = car;
    this.cdr = cdr;
  }
  override string toString(){
    return format!"( %s . %s )"(car, cdr);
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


