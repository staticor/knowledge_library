/*
* @Author: Jinyong.Yang
* @Date:   2015-12-03 23:44:55
* @Last Modified by:   staticor
* @Last Modified time: 2016-01-17 00:34:24
*/

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.Map

object Foobar  {
    def main(args: Array[String])
    {
        // yield
        // for (i <- 1 to 10) yield println(i % 3)


        // array
        val nums = new Array[Int](10)
        println(nums(3))
        println(nums(9)) // index from 0.

        // arraybuffer
        val b = ArrayBuffer[Int]()
        b += 1
        b += (1,2,3,5)
        println(b.mkString("@"))
        b ++= Array(999, 1000)
        println(b.mkString("@"))

        // dict
        val scores = Map("a" -> 10, "b" -> 30, "Cindy" -> 12)
    }
}
