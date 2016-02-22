

object YourData {
    def main(args: Array[String]){
        println( 1 + 2 * 3 / 10.0)  // 1.6
        println( 1 + 2 * 3 / 10)   // 1

        println(1 to 10)    // 1 - 10     Range object
        println(1 until 5)  // 1 2 3 4



        println( 1 == 1.0)   // true
        println( 1 == 1)     // true

        println( 1 equals 1.0)   // false
        println( 1 equals 1)     // true

    }
}