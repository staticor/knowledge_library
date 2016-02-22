import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date


class FrenchDate {

     def dateMinus(num: Int, date: String): String = {
        val insdf = new SimpleDateFormat("yyyyMMdd")
        val outsdf = new SimpleDateFormat("yyyy/MM/dd")

        val dt = insdf.parse(date)
        val rightNow = Calendar.getInstance

        rightNow.setTime(dt)
        rightNow.add(Calendar.DAY_OF_YEAR, -num)

        outsdf.format(rightNow.getTime)
    }


    def main(args: Array[String]) {

        println(dateMinus(3, "20150412"))
    }
}