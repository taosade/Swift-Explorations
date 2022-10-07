// Class equitability definition

class Dot
{
    var x: Int
    var y: Int

    init(_ xValue: Int, _ yValue: Int)
    {
        x = xValue
        y = yValue
    }
    
    static func == (Dot_1: Dot, Dot_2: Dot) -> Bool
    {
        return (Dot_1.x == Dot_2.x) && (Dot_1.y == Dot_2.y)
    }
}

let Dot_1 = Dot(1, 1)
let Dot_2 = Dot(1, 1)
let Dot_3 = Dot(1, 2)

print(Dot_1 == Dot_2)
print(Dot_1 == Dot_3)
