import std.stdio;
import std.format;
import std.algorithm: reduce, map, each, any;
import std.conv : to, ConvException, text;
import std.range : drop;
import std.exception : enforce;
import std.container : DList;

import pegged.grammar;

import conscell;
import transform;

void main()
{
  writeln("Lispy Version 0.0.1");
  writeln("Press Ctrl+c to Exit");


  mixin(grammar(`
  Lispy:
    expr     < number / symbol / sexpr / qexpr
    sexpr    < :'(' expr* :')'
    qexpr    < :"'" :'(' expr* :')'
    symbol   < '+' / '-' / '*' / '/'
    number   <~ '-'? [0-9]+
  `));

  while(true){
    write("Lispy> ");
    auto line = readln().strip();
    auto tree = Lispy(line);
    writeln("Execution:");
    writef("%s", tree);
    auto consTree = transform.transform(tree);
    writeln(consTree.toString);
    writeln(prin1(consTree));
    //writeln(ConsTree.eval);
  }
}
