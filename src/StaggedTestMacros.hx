package ;

import com.mindrocks.macros.Stagged;
using com.mindrocks.macros.Stagged;
import haxe.macro.Expr;
import haxe.macro.Context;

using Lambda;


/**
 * ...
 * @author sledorze
 */

class StaggedTestMacros {

  @:macro public static function forExample2(init : Expr, cond : Expr, inc : Expr, body : Expr, nb : Int = 5) : Expr return {
    
    var localExpr
      = Context.parse('tracze("wow")', Context.currentPos());
      
    var arr = [];
    for (ind in 0...5) {
      arr.push(
        Stagged.stagged("{
          trace('i ' + $ind);
          $localExpr;
          $init;
          function oneTime() {
            if ($cond) {
              $body;
              $inc;
              oneTime();
            }
          }
          oneTime();
        }")
      );
    }
    
    return { expr : EBlock(arr), pos : Context.currentPos() };
  }
  
}