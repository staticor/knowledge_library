/*
* @Author: Jinyong.Yang
* @Date:   2015-12-03 23:03:50
* @Last Modified by:   Jinyong.Yang
* @Last Modified time: 2015-12-03 23:14:35
*/

abstract class Tree

case class Sum(l: Tree, r: Tree) extends Tree

case class Var(n: String) extends Tree
case class Const(v:Int) extends Tree
