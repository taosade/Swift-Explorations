/*

    Example of a function documentation with:

    1. Summary
    2. Discussion
    3. Code snippet
    4. Warning
    5. Parameter descriptions
    
    Hint: Option+Click function name to view documentation sheet.

*/

/// Gets a String and a Double, returns 42.
///
/// This function is basically useliess since it always returns 42.
/// ```
/// someFunction("Hello World!", 31.337) -> 42
/// ```
/// - Warning: Don't use this function. Ever. Seriously.
/// - Parameter firstParam: This is a String!
/// - Parameter secondParam: And this is just a Double.
func someFunction(firstParam: String, secondParam: Double) -> Int
{
    return 42
}
