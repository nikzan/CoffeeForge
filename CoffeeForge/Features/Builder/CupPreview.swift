import SwiftUI

// MARK: - CupPreview
/// Анимированное превью стакана с «живой жидкостью».
/// Уровень напитка и его оттенок реагируют на выбранные параметры.
/// Минимальные 2 фигуры (ZStack) по ТЗ — здесь их 4-5 для выразительности.
struct CupPreview: View {
    let config: DrinkConfig

    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Пар (декоративный оверлей — вторая фигура)
            steamView
                .offset(y: -cupHeight * liquidFillRatio - 20)
                .opacity(liquidFillRatio > 0.3 ? 0.6 : 0)

            // 2. Силуэт стакана (основная фигура)
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .frame(width: cupWidth, height: cupHeight)
                .overlay(alignment: .bottom) {
                    // 3. Жидкость
                    liquidView
                }
                .overlay {
                    // 4. Ободок стакана
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.cfCupOutline, lineWidth: 1.5)
                }

            // 5. Подставка-тень
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cfLatte.opacity(0.3))
                .frame(width: cupWidth * 1.1, height: 6)
                .blur(radius: 4)
                .offset(y: cupHeight * 0.55)
        }
        .frame(width: cupWidth, height: cupHeight * 0.65)
        .padding(.top, 16)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: config)
    }

    // MARK: - Cup Metrics

    private var cupWidth: CGFloat { 140 }
    private var cupHeight: CGFloat { 220 }

    private var cupTopInset: CGFloat { 20 } // ободок

    // MARK: - Liquid

    private var liquidFillRatio: CGFloat {
        switch config.cupSize {
        case .small:  return 0.55
        case .medium: return 0.75
        case .large:  return 0.95
        }
    }

    private var liquidColor: Color {
        if config.milkType == .none {
            switch config.coffeeBase {
            case .espresso:  return .cfEspressoShot
            case .americano: return .cfEspressoShot.opacity(0.7)
            case .cappuccino: return .cfCoffeeLiquid
            case .latte:     return .cfCoffeeLiquid.opacity(0.6)
            case .raf:       return .cfCoffeeLiquid.opacity(0.55)
            }
        }
        switch config.milkType {
        case .regular:  return .cfMilk
        case .oat:      return .cfOatMilk
        case .coconut:  return .cfCoconutMilk
        case .none:     return .cfCoffeeLiquid
        }
    }

    private var foamColor: Color {
        guard config.milkType != .none else { return .clear }
        return .cfMilkFoam
    }

    private var syrupTint: Color {
        switch config.syrup {
        case .none:     return .clear
        case .caramel:  return .cfSyrupCaramel
        case .vanilla:  return .cfSyrupVanilla
        case .hazelnut: return .cfSyrupHazelnut
        }
    }

    // MARK: - Shapes

    private var cupShape: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(width: cupWidth, height: cupHeight)
    }

    private var liquidView: some View {
        VStack(spacing: 0) {
            // Сироп (верхний слой, если выбран)
            if config.syrup != .none {
                syrupTint
                    .frame(height: max(4, cupHeight * liquidFillRatio * 0.15))
            }

            // Жидкость
            liquidColor
                .frame(height: max(8, cupHeight * liquidFillRatio - (config.syrup != .none ? cupHeight * liquidFillRatio * 0.15 : 0)))

            // Пенка (только с молоком)
            if config.milkType != .none {
                foamColor
                    .frame(height: 20)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 8, bottomTrailingRadius: 8, topTrailingRadius: 0))
            }
        }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 12, bottomTrailingRadius: 12, topTrailingRadius: 0))
        .shadow(color: liquidColor.opacity(0.3), radius: 4, x: 0, y: -2)
    }

    private var steamView: some View {
        HStack(spacing: 12) {
            ForEach(0..<3) { i in
                Capsule()
                    .fill(Color.cfLatte.opacity(0.35))
                    .frame(width: 3, height: 20 + CGFloat(i * 8))
                    .offset(y: CGFloat(i * 4) - 8)
                    .animation(
                        .easeInOut(duration: 2.0 + Double(i) * 0.5).repeatForever(autoreverses: true),
                        value: config
                    )
            }
        }
    }
}

#Preview("S — Без молока") {
    CupPreview(config: DrinkConfig(
        coffeeBase: .espresso, cupSize: .small, milkType: .none, syrup: .none, quantity: 1
    ))
    .padding().background(Color.cfPaper)
}

#Preview("L — Латте овсяное карамель") {
    CupPreview(config: DrinkConfig(
        coffeeBase: .latte, cupSize: .large, milkType: .oat, syrup: .caramel, quantity: 2
    ))
    .padding().background(Color.cfPaper)
}

#Preview("M — Раф кокосовый ваниль") {
    CupPreview(config: DrinkConfig(
        coffeeBase: .raf, cupSize: .medium, milkType: .coconut, syrup: .vanilla, quantity: 1
    ))
    .padding().background(Color.cfPaper)
}