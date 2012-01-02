package com.mindrocks.functional.monads;

import haxe.macro.Expr;
import haxe.macro.Context;

import com.mindrocks.functional.Functional;
import com.mindrocks.macros.MonadSugarMacro;

/**
 * ...
 * @author sledorze
 */
 
@:native("Option_Monad") class OptionM {
    
  @:macro public static function Do(body : Expr) return
    Monad.Do("OptionM", body, Context)

  inline public static function ret<T>(x : T) return
    Some(x)
  
  inline public static function map < T, U > (x : Option<T>, f : T -> U) : Option<U> {
    switch (x) {
      case Some(x) : return Some(f(x));
      default : return None;
    }
  }

  inline public static function flatMap<T, U>(x : Option<T>, f : T -> Option<U>) : Option<U> {
    switch (x) {
      case Some(x) :
        var xx = f(x);
        return xx;
      default : return None;
    }
  }
}

@:native("Array_Monad") class ArrayM {
  @:macro public static function Do(body : Expr) return
  Monad.Do("ArrayM", body, Context)

  inline public static function ret<T>(x : T) return
    [x]
  
  inline public static function flatMap<T, U>(xs : Array<T>, f : T -> Array<U>) : Array<U> {
    var res = [];
    for (x in xs) {
      for (y in f(x)) {
        res.push(y);  
      }      
    }
    return res;
  }
  
  inline public static function map<T, U>(xs : Array<T>, f : T -> U) : Array<U> {
    var res = [];
    for (x in xs) {
      res.push(f(x));
    }
    return res;
  }
}

typedef State<S,T> = S -> {state:S, value:T};

@:native("ST_Monad") class StateM {

  @:macro public static function Do(body : Expr) return
    Monad.Do("StateM", body, Context, Monad.noOpt)

  static public function ret <S,T>(i:T):State<S,T> {
    return function(s:S){ return {state:s, value:i}; };
  }

  static public function flatMap <S,T,SU, U>(a:State<S,T>, f: T -> State<S,U>):State<S,U>{
    return function(state){
      var s = a(state);
      var res = f(s.value)(s.state);
      return res;
    }
  }

  static public function gets <S>():State<S,S>{
    return function(s:S){
        return {
          state: s,
          value: s
        };
    };
  }

  static public function puts <S,T>(s:S):State<S,T>{
    return function(_:S){
        return {
          state: s,
          value: null
        };
    };
  }

  static public inline function runState <S,T>(f:State<S,T>, s:S):T{
    return f(s).value;
  }
  
}


typedef RC<R,A> = (A -> R) -> R

@:native("Cont_Monad") class ContM {

  @:macro public static function Do(body : Expr) return
    Monad.Do("ContM", body, Context)

  static public function ret <A,R>(i:A):RC<R,A>
    return function(cont) return cont(i)

  static public function flatMap <A, B, R>(m:RC<R,A>, k: A -> RC<R,B>): RC<R,B>
    return function(cont : B -> R)
      return m(function(a) return k(a)(cont))

  static public function map <A, B, R>(m:RC<R,A>, k: A -> B): RC<R,B>
    return function(cont : B -> R)
      return m(function (a) return cont(k(a)))
}