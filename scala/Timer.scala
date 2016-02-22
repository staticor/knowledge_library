object Timer {
    def oncePerSecond(callback: () => Unit){


        for (i <- 1 to 5 ){
            callback()
            Thread sleep 1000;
        }
    }
    def timeFlies(){
        println("time flies like an arrow ...")
    }

    def main(args: Array[String]) {
        println("Hello, world!")
        oncePerSecond(timeFlies)

        // Anomymouse Function

        // oncePerSecond( () => println("blah blah blah"))
    }
}


