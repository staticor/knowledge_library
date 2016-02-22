import org.apache.spark._
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date

object GenConciseLog {

  val BASE_EXPRESS     = "/user/root/flume/express"
  
  val BASE_EXPRESS_BID = "/user/root/flume/express_bid"
  
  val BASE_PRIVATE     = "/user/ming.zhao/cvr_boost"
  
  val MILLIS_INDAY     = 86400000
  
  val Z                = "\u0002Z\u0002"

  def dateMinus(num: Int, date: String): String = {
    val insdf = new SimpleDateFormat("yyyyMMdd")
    val outsdf = new SimpleDateFormat("yyyy/MM/dd")

    val dt = insdf.parse(date)
    val rightNow = Calendar.getInstance
    rightNow.setTime(dt)
    rightNow.add(Calendar.DAY_OF_YEAR, -num)

    outsdf.format(rightNow.getTime)
  }


  def isNumber(s: String): Boolean = s.matches("[+-]?\\d+\\.?\\d+") && (s.toDouble < 1.0)

  def main(args: Array[String]) {

    val TEST_DATE     = args(0)
    val TEST_DATE_DIR = dateMinus(0, args(0))
    val COMPANY_LIST  = List("1095", "1123", "2878", "1352", "1052", "1157", "1371")

    val ADV_PATH = BASE_EXPRESS + "/" + TEST_DATE_DIR + "/*/adv*"
    val CLK_PATH = BASE_EXPRESS + "/" + TEST_DATE_DIR + "/*/click*"
    val IMP_PATH = BASE_EXPRESS + "/" + TEST_DATE_DIR + "/*/imp*"
    val CVT_PATH = BASE_EXPRESS + "/" + TEST_DATE_DIR + "/*/cvt*"
    val BID_PATH = BASE_EXPRESS_BID + "/" + TEST_DATE_DIR + "/*/bid*"
    val CM_PATH  = "/user/root/flume/cookie_mapping/cmadv/" + TEST_DATE_DIR + "/*/*"

    val ADV_RESULT_PATH = BASE_PRIVATE + "/concise_log/adv/" + TEST_DATE_DIR
    val CLK_RESULT_PATH = BASE_PRIVATE + "/concise_log/clk/" + TEST_DATE_DIR
    val IMP_RESULT_PATH = BASE_PRIVATE + "/concise_log/imp/" + TEST_DATE_DIR
    val CVT_RESULT_PATH = BASE_PRIVATE + "/concise_log/cvt/" + TEST_DATE_DIR
    val BID_RESULT_PATH = BASE_PRIVATE + "/concise_log/bid/" + TEST_DATE_DIR
    val CM_RESULT_PATH  = BASE_PRIVATE + "/concise_log/cmadv/" + TEST_DATE_DIR


    val sparkConf = new SparkConf().setAppName("online-bt-concise-log").set("spark.akka.frameSize", "15")
    val sc        = new SparkContext(sparkConf)


    val conciseBid = sc.newAPIHadoopFile(BID_PATH, classOf[com.hadoop.mapreduce.LzoTextInputFormat], classOf[org.apache.hadoop.io.LongWritable], classOf[org.apache.hadoop.io.Text])
      .map { tp =>
        val parts = tp._2.toString.split("\t")

        if (parts.length > 88) {
          val actionid      = parts(0)
          val time          = parts(6)
          val pyid          = parts(15)
          val companyid     = parts(64)
          val bidextenddata = parts(88)

          if (pyid.length != 0 && bidextenddata.contains("algo") &&
            time.length != 0 && COMPANY_LIST.contains(companyid)) {

            val algo = bidextenddata.split("algo")(1)
            val cvr  = algo.split(",")(1)

            if (isNumber(cvr)) List(actionid, cvr).mkString("\t") else Z
          } else Z
        } else Z
      }
      .filter(!_.equalsIgnoreCase(Z))
      // .coalesce(10)
    // conciseBid.saveAsTextFile(BID_RESULT_PATH)

    val conciseClk = sc.textFile(CLK_PATH)
      .map { line =>
        val parts = line.split("\t")
        if(parts.length > 64){
          val pyid          = parts(15) 
          val clktime       = parts(6)
          val companyid     = parts(64)
          val actionfirstid = parts(4)
          val strategyid    = parts(53)

          if(pyid.length != 0 && clktime.length != 0 && actionfirstid.length != 0 &&
            strategyid.length != 0 && COMPANY_LIST.contains(companyid)){
            List(pyid, clktime, companyid, actionfirstid, strategyid).mkString("\t")
          } else Z
        } else Z
      }
      .filter(!_.equalsIgnoreCase(Z))
      // .coalesce(10)
    conciseClk.saveAsTextFile(CLK_RESULT_PATH)

    val conciseAdv = sc.textFile(ADV_PATH)
      .map { line =>
          val parts = line.split("\t")
          if(parts.length > 50){
            val pyid      = parts(15)
            val advtime   = parts(6)
            val companyid = parts(50)
            val agenturl  = parts(21)

            if(pyid.length != 0 && advtime.length != 0 && COMPANY_LIST.contains(companyid)) {
              List(pyid, advtime, companyid, agenturl).mkString("\t")
            } else Z
          } else Z
      }
      .filter(!_.equalsIgnoreCase(Z))
      // .coalesce(10)
    conciseAdv.saveAsTextFile(ADV_RESULT_PATH)

    val conciseCvt = sc.textFile(CVT_PATH)
      .map { line => 
          val parts = line.split("\t")
          if(parts.length > 51){
            val pyid      = parts(15)
            val cvttime   = parts(6)
            val companyid = parts(50)
            val target    = parts(51)

            if(pyid.length != 0 && cvttime.length != 0 && COMPANY_LIST.contains(companyid)) {
              List(pyid, cvttime, companyid, target).mkString("\t")
            } else Z
          } else Z
      }
      .filter(!_.equalsIgnoreCase(Z))
      // .coalesce(10)
    conciseCvt.saveAsTextFile(CVT_RESULT_PATH)

    // val conciseCookieMapping = 


    sc.stop
    exit

  }
}
