// Classic game of Snakes&Ladders inspired by the official Swift Language Guide

var currentRoll: Int = 0
var currentSquare: Int = 0
let finalSquare: Int = 25
var message: String = ""
var rollCount: Int = 0
var squares = [Int](repeating: 0, count: finalSquare)

squares[03] = +08
squares[06] = +11
squares[09] = +09
squares[10] = +02
squares[14] = -10
squares[19] = -11
squares[22] = -02
squares[24] = -08

while true
{
    rollCount += 1

    currentRoll = Int.random(in: 1...6)

    message = "Roll #\(rollCount): \(currentRoll)"

    if currentRoll + currentSquare == finalSquare
    {
        print("\(message) - Finally! I'm on square #\(finalSquare)")

        break
    }
    
    if currentRoll + currentSquare > finalSquare
    {
        print("\(message) - Damn it! Too much. Gotta roll again.")

        continue
    }

    currentSquare += currentRoll

    message += " - Got to square #\(currentSquare)."

    if squares[currentSquare] != 0
    {
        message += squares[currentSquare] > 0 ?
            " Great! The ladder moves me \(squares[currentSquare]) squares up!" :
            " Fucking snake moves me \(-squares[currentSquare]) squares down."

        currentSquare += squares[currentSquare]

        message += " Now I'm on square #\(currentSquare)."
    }

    print(message)
}
