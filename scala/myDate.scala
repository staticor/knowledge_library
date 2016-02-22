/*
* @Author: Jinyong.Yang
* @Date:   2015-12-03 23:18:54
* @Last Modified by:   Jinyong.Yang
* @Last Modified time: 2015-12-03 23:44:44
*/

object Date(y: Int, m: Int, d: Int) extends Ord {
    def year = y
    def month = m
    def day = d

    override def toString(): String = year + "-" + month + "-" + day



}