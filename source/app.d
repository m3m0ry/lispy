import std.stdio;
import std.format;
import std.algorithm: reduce, map, each, any;
import std.conv : to, ConvException, text;
import std.range : drop;
import std.exception : enforce;
import std.container : DList;

import pegged.grammar;

import types;
import transform;
import func;

//void main(string[] args){
//writeln("Test");
//auto cons = new LispCons(new LispNumber(1));
//outer: switch(args[1]){
//foreach(memberName; __traits(allMembers, LispT)){
//case memberName:
//writeln((__traits(getMember, func, memberName)(cons)));
//break outer;
//}
//default:
//write("No such function");
//break;
//}
//}

void main()
{
  writeln("Lispy Version 0.0.1");
  writeln("Press Ctrl+c to Exit");


  mixin(grammar(`
  Lispy:
    expr     < number / symbol / sexpr / qexpr
    sexpr    < :'(' expr* :')'
    qexpr    < :"'" :'(' expr* :')'
    symbol   <~ [a-zA-Z]+
    number   <~ '-'? [0-9]+
  `));

  while(true){
    write("Lispy> ");
    auto line = readln().strip();
    auto tree = Lispy(line);
    writeln("Execution:");
    writef("%s", tree);
    auto lispObject = transform.transform(tree);
    writeln("Transformed:", lispObject.toString);
    writeln("Prin1:", prin1(lispObject));
    writeln("Eval:", eval(lispObject).toString);
  }
}
