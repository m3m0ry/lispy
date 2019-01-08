
import conscell;

import object : TypeInfo_Class;

//TODO templates, fuck yeah
LispObject checkCellType(LispObject cell, TypeInfo_Class c, string errorMsg = ""){
  if( cell.classinfo is c.classinfo)
    return cell;
  else
    return new LispError(errorMsg);
}
