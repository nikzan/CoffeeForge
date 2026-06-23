import SwiftUI

// MARK: - CoffeeForge Color Tokens
// Тёплая спешелти-кофейня: крафт, охра/эспрессо/латте, уютная палитра

extension Color {
    // --- Основные ---
    static let cfEspresso    = Color(red: 0.231, green: 0.165, blue: 0.125) // #3B2A20
    static let cfCrema       = Color(red: 0.961, green: 0.922, blue: 0.867) // #F5EBDD
    static let cfLatte       = Color(red: 0.910, green: 0.831, blue: 0.722) // #E8D4B8
    static let cfCaramel     = Color(red: 0.784, green: 0.592, blue: 0.353) // #C8975A
    static let cfCinnamon    = Color(red: 0.647, green: 0.420, blue: 0.239) // #A56B3D
    static let cfPaper       = Color(red: 0.984, green: 0.969, blue: 0.945) // #FBF7F1

    // --- Специфические UI ---
    static let cfMilk        = Color(red: 0.988, green: 0.973, blue: 0.929) // для превью молока
    static let cfOatMilk     = Color(red: 0.957, green: 0.925, blue: 0.843) // для превью овсяного
    static let cfCoconutMilk = Color(red: 0.980, green: 0.957, blue: 0.910) // для превью кокосового
    static let cfSyrupCaramel   = Color(red: 0.851, green: 0.486, blue: 0.118) // насыщенная карамель
    static let cfSyrupVanilla   = Color(red: 0.957, green: 0.835, blue: 0.467) // тёплая ваниль
    static let cfSyrupHazelnut  = Color(red: 0.616, green: 0.357, blue: 0.184) // глубокий фундук
    static let cfEspressoShot   = Color(red: 0.165, green: 0.094, blue: 0.055) // #2A180E
    static let cfCoffeeLiquid   = Color(red: 0.365, green: 0.212, blue: 0.122) // #5D361F
    static let cfMilkFoam       = Color(red: 0.949, green: 0.914, blue: 0.867)
    static let cfCupGlass       = Color(red: 0.937, green: 0.945, blue: 0.957).opacity(0.5)
    static let cfCupOutline     = Color(red: 0.788, green: 0.796, blue: 0.820)
    static let cfGlassHighlight  = Color(red: 1.0, green: 1.0, blue: 1.0)        // блик на стекле
    static let cfGlassShade      = Color(red: 0.557, green: 0.569, blue: 0.612)  // тень-кромка стекла

    // --- Accent Gradient ---
    static let cfWarmAccent    = LinearGradient(
        colors: [.cfCaramel, .cfCinnamon],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension UIColor {
    static let cfEspresso    = UIColor(Color.cfEspresso)
    static let cfCaramel     = UIColor(Color.cfCaramel)
    static let cfPaper       = UIColor(Color.cfPaper)
    static let cfCrema       = UIColor(Color.cfCrema)
    static let cfLatte       = UIColor(Color.cfLatte)
    static let cfCinnamon    = UIColor(Color.cfCinnamon)
}