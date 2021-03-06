import std.stdio;
import std.format;
import std.algorithm: reduce, map, each, any;
import std.algorithm.iteration;
import std.conv : to, ConvException, text;
import std.range : drop;
import std.exception : enforce;
import std.container : DList;

interface LispT{
  string toString();
}

interface LispSequence: LispT{};
interface LispList: LispSequence{};

class LispCons: LispList{
  LispT car;
  LispT cdr;
  this(LispT car = lispNil, LispT cdr = lispNil){
    this.car = car;
    this.cdr = cdr;
  }
  override string toString(){
    return format!"( %s . %s )"(car, cdr);
  }
}

class LispNumber: LispT
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
  LispNumber opBinary(string op)(LispNumber rhs){
    static if ( op == "+") return new LispNumber(num + rhs.num);
    else static if (op == "-") return num - rhs.num;
    else static assert(0, "Operator" ~ op ~ " is not yet implemented");
  }
  LispNumber opBinary(string op)(int rhs){
    static if ( op == "+") return num + rhs;
    else static if (op == "-") return num - rhs;
    else static assert(0, "Operator" ~ op ~ " is not yet implemented");
  }
}

class LispError: LispT{
  string err;
  this(){}
  this(string e){
    err = e;
  }
  override string toString(){
    return err;
  }
}

class LispSymbol: LispT{
  string sym;
  this(){}
  this(string s){
    sym = s;
  }
  override string toString(){
    return sym;
  }
}

class LispTrue: LispSymbol{
  string sym = "true";
}

class LispNil: LispSymbol, LispList{
  string sym = "nil";
}


LispTrue lispTrue;
LispNil lispNil;

static this(){
  lispTrue = new LispTrue();
  lispNil = new LispNil();
}
