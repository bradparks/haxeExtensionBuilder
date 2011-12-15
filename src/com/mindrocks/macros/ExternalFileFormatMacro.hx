package com.mindrocks.macros;

#if macro
import neko.io.File;
using com.mindrocks.macros.Staged;
#end
/**
 * ...
 * @author sledorze
 */

class ExternalFileFormatMacro {

  @:macro public static function format(src : String, params : Dynamic) {
    #if macro
    var content = File.read(src).readAll().toString();
    
    var newExpr = "{
      var context = $params;
      Std.format($content);
    }
    ".staged();    
    return newExpr;
    #end
  }
  
}