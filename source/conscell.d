import std.stdio;
import std.format;
import std.algorithm: reduce, map, each, any;
import std.conv : to, ConvException, text;
import std.range : drop;
import std.exception : enforce;
import std.container : DList;

class ConsCell{
  ConsCell car;
  ConsCell cdr;
  override string toString(){
    return format!"( %s . %s )"(car, cdr);
  }
}

abstract class LeafCell: ConsCell{
  invariant(){
    assert(car is null);
    assert(cdr is null);
  }
}

class NumberCell: LeafCell
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

class ErrorCell: ConsCell{
  string err;
  this(string e){
    err = e;
  }
  override string toString(){
    return err;
  }
}

class SymbolCell: ConsCell{
  string sym;
  this(string s){
    sym = s;
  }
  override string toString(){
    return sym;
  }
}


