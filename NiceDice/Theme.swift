import SwiftUI

enum Palette {
    static let felt = Color(red: 0.08, green: 0.14, blue: 0.11)
    static let feltCenter = Color(red: 0.13, green: 0.22, blue: 0.16)
    static let feltButton = Color(red: 0.10, green: 0.19, blue: 0.14)
    static let feltLift = Color(red: 0.16, green: 0.28, blue: 0.20)
    static let feltEdge = Color(red: 0.22, green: 0.34, blue: 0.26)
    static let stage = Color(red: 0.07, green: 0.12, blue: 0.10)

    static let leather = Color(red: 0.48, green: 0.30, blue: 0.17)
    static let leatherLite = Color(red: 0.66, green: 0.45, blue: 0.26)
    static let leatherDark = Color(red: 0.30, green: 0.17, blue: 0.09)
    static let cord = Color(red: 0.78, green: 0.62, blue: 0.36)

    static let brass = Color(red: 0.84, green: 0.66, blue: 0.30)
    static let hit = Color(red: 0.93, green: 0.78, blue: 0.30)
    static let hitCore = Color(red: 0.98, green: 0.90, blue: 0.55)
    static let miss = Color(red: 0.32, green: 0.38, blue: 0.42)
    static let missRim = Color(red: 0.48, green: 0.54, blue: 0.58)

    static let ivory = Color(red: 0.94, green: 0.90, blue: 0.82)
    static let ivoryDeep = Color(red: 0.80, green: 0.74, blue: 0.62)
    static let cream = Color(red: 0.96, green: 0.93, blue: 0.86)
    static let muted = Color(red: 0.68, green: 0.75, blue: 0.69)
    static let ink = Color(red: 0.12, green: 0.10, blue: 0.08)
}

enum Typeface {
    static func display(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static func rounded(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
