// Formatting string representation of a number

import Foundation

let formatter = NumberFormatter()

formatter.numberStyle = .decimal
formatter.maximumFractionDigits = 2
formatter.roundingMode = .down
formatter.groupingSize = 3
formatter.groupingSeparator = ","

print(formatter.string(from: 123456.789) ?? "0")
