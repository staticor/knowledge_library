
import java.util.{Date, Locale}
import java.text.DateFormat
import java.text.DateFormat._

object FrenchDate {
    def main(args: Array[String]) {
    val now = new Date
    val df = getDateInstance(LONG, Locale.US)

    println(df format now)

    }


    def isEqual(x:int, y:int){

    }
}



def error(msg: String):
    Nothing = throw new RuntimeError("sdjalfasjfklad;s")



