import SwiftUI

struct CodableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        red = Double(r)
        green = Double(g)
        blue = Double(b)
        opacity = Double(a)
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}



struct Settings: Codable {
    var controlStyle: String
    var inspectionTime: Int
    var warningTime: Int
    var backgroundColor: CodableColor
    
    static let `default` = Settings(controlStyle: "Tap", inspectionTime: 5, warningTime: 3, backgroundColor: CodableColor(color: .white))
}
