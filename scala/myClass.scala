



object ComplexNumbers {

class Complex(real: Double, imaginary: Double) {
    def re() = real

    def im() = imaginary

    override def toString() =
        "" + re + (if (im < 0) "" else "+" ) + im + "i"
}


    def main(args: Array[String]){
        val c = new Complex(1.2, 4.3)
        println("imaginary part:" + c.im())

        println(c)
    }
}