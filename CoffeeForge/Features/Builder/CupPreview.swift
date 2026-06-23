import SwiftUI

// MARK: - CupPreview
/// Анимированное превью стакана с «живой жидкостью».
/// - Форма стакана — настоящий бумажный стаканчик, сужающийся книзу (`CupShape`),
///   с разной высотой/шириной под размеры S / M / L.
/// - Жидкость — волнистая поверхность (`WaveShape` с `animatableData`),
///   уровень налива зависит от размера, цвет — от основы/молока/сиропа.
/// - Слои напитка смешиваются вертикальным градиентом (без резких границ).
struct CupPreview: View {
    let config: DrinkConfig

    // Фаза волны на поверхности жидкости (бесконечная анимация колыхания).
    @State private var wavePhase: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .bottom) {
            // Пар над напитком
            steamView
                .frame(width: cupTopWidth * 0.6)
                .offset(y: -cupHeight - 6)
                .opacity(liquidFillRatio > 0.25 ? 1 : 0)

            // Стакан + жидкость внутри
            ZStack(alignment: .bottom) {
                // Тело стакана (стекло)
                CupShape(topWidth: cupTopWidth, bottomWidth: cupBottomWidth)
                    .fill(glassGradient)

                // Жидкость, обрезанная по форме стакана
                liquidView
                    .clipShape(CupShape(topWidth: cupTopWidth, bottomWidth: cupBottomWidth))

                // Вертикальный блик на стекле
                CupShape(topWidth: cupTopWidth, bottomWidth: cupBottomWidth)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.cfGlassHighlight.opacity(0.35),
                                .clear,
                                .clear,
                                Color.cfGlassShade.opacity(0.18)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                // Контур стакана + ободок
                CupShape(topWidth: cupTopWidth, bottomWidth: cupBottomWidth)
                    .stroke(Color.cfCupOutline.opacity(0.7), lineWidth: 1.5)

                // Утолщённый ободок сверху
                rimView
            }
            .frame(width: cupTopWidth, height: cupHeight)
            .compositingGroup()
            .shadow(color: Color.cfEspresso.opacity(0.18), radius: 10, x: 0, y: 8)

            // Подставка-тень под стаканом
            Ellipse()
                .fill(Color.cfEspresso.opacity(0.12))
                .frame(width: cupBottomWidth * 1.25, height: 10)
                .blur(radius: 4)
                .offset(y: 8)
        }
        // Фиксированная высота контейнера: стакан растёт ВНУТРЬ (по низу),
        // не сдвигая остальной контент формы при смене размера.
        // 280 (макс. высота L) + 90 на пар и тень.
        .frame(width: 180, height: 370, alignment: .bottom)
        .animation(.spring(response: 0.45, dampingFraction: 0.7), value: config)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 3.5).repeatForever(autoreverses: false)) {
                wavePhase = .pi * 2
            }
        }
    }

    // MARK: - Cup Metrics (геометрия зависит от размера)

    /// Высота стакана растёт от S к L.
    private var cupHeight: CGFloat {
        switch config.cupSize {
        case .small:  return 200
        case .medium: return 240
        case .large:  return 280
        }
    }

    /// Ширина верха стакана.
    private var cupTopWidth: CGFloat {
        switch config.cupSize {
        case .small:  return 120
        case .medium: return 136
        case .large:  return 150
        }
    }

    /// Низ всегда уже верха — характерный конус стаканчика.
    private var cupBottomWidth: CGFloat { cupTopWidth * 0.66 }

    // MARK: - Liquid Fill

    /// Доля высоты, занятая напитком (немного «не доливаем» до края).
    private var liquidFillRatio: CGFloat { 0.86 }

    // MARK: - Liquid View

    /// Жидкость = градиент слоёв + волнистая поверхность сверху.
    private var liquidView: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let fillHeight = h * liquidFillRatio

            ZStack(alignment: .bottom) {
                WaveShape(
                    phase: reduceMotion ? 0 : wavePhase,
                    amplitude: reduceMotion ? 0 : 5,
                    fillHeight: fillHeight
                )
                .fill(liquidGradient)

                // Лёгкий блик-мениск на поверхности напитка
                WaveShape(
                    phase: reduceMotion ? 0 : wavePhase,
                    amplitude: reduceMotion ? 0 : 5,
                    fillHeight: fillHeight
                )
                .stroke(surfaceTint.opacity(0.55), lineWidth: 2)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }

    // MARK: - Rim (ободок)

    private var rimView: some View {
        Capsule()
            .stroke(Color.cfCupOutline, lineWidth: 3)
            .frame(width: cupTopWidth + 4, height: 16)
            .frame(maxHeight: .infinity, alignment: .top)
            .offset(y: -3) // приподнимаем крышку чуть выше краёв стакана
            .overlay(alignment: .top) {
                Capsule()
                    .fill(Color.cfGlassHighlight.opacity(0.5))
                    .frame(width: cupTopWidth - 8, height: 6)
                    .offset(y: 0)
            }
    }

    // MARK: - Colors / Gradients

    /// Стекло: лёгкий вертикальный градиент, чтобы не было плоской заливки.
    private var glassGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.cfCupGlass.opacity(0.35),
                Color.cfCupGlass.opacity(0.7)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Основной цвет кофе по выбранной основе.
    private var coffeeColor: Color {
        switch config.coffeeBase {
        case .espresso:   return .cfEspressoShot
        case .americano:  return .cfEspressoShot.opacity(0.8)
        case .cappuccino: return .cfCoffeeLiquid
        case .latte:      return .cfCoffeeLiquid.opacity(0.7)
        case .raf:        return .cfCoffeeLiquid.opacity(0.6)
        }
    }

    /// Цвет молока (или прозрачный, если без молока).
    private var milkColor: Color {
        switch config.milkType {
        case .regular: return .cfMilk
        case .oat:     return .cfOatMilk
        case .coconut: return .cfCoconutMilk
        case .none:    return .clear
        }
    }

    /// Цвет сиропа.
    private var syrupColor: Color {
        switch config.syrup {
        case .none:     return .clear
        case .caramel:  return .cfSyrupCaramel
        case .vanilla:  return .cfSyrupVanilla
        case .hazelnut: return .cfSyrupHazelnut
        }
    }

    /// Оттенок поверхности (верх жидкости): пенка при молоке, иначе крема.
    private var surfaceTint: Color {
        if config.milkType != .none { return .cfMilkFoam }
        return .cfCrema
    }

    /// Плавный вертикальный градиент напитка.
    /// Снизу — насыщенный кофе, вверх постепенно подмешивается молоко,
    /// а у самой поверхности — выраженный слой сиропа. Никаких резких границ.
    private var liquidGradient: LinearGradient {
        var stops: [Gradient.Stop] = []

        if config.milkType == .none {
            // Чистый кофе: лёгкое затемнение ко дну для глубины.
            stops = [
                .init(color: coffeeColor.opacity(0.95), location: 0.0),
                .init(color: coffeeColor, location: 0.5),
                .init(color: coffeeColor.opacity(0.85), location: 1.0)
            ]
        } else {
            // Кофе снизу → молочный переход → пенка сверху.
            let blended = blend(coffeeColor, milkColor, ratio: 0.5)
            stops = [
                .init(color: coffeeColor, location: 0.0),
                .init(color: coffeeColor, location: 0.25),
                .init(color: blended, location: 0.6),
                .init(color: milkColor, location: 0.85),
                .init(color: surfaceTint, location: 1.0)
            ]
        }

        // Сироп — выраженный акцентный слой у поверхности (верхняя ~35% напитка),
        // с плавным переходом от тела напитка к насыщенному цвету сиропа.
        if config.syrup != .none {
            let base = stops.last!.color
            // обрезаем существующие стопы, чтобы освободить верхнюю зону под сироп
            stops = stops.filter { $0.location < 0.65 }
            stops.append(.init(color: base, location: 0.65))
            stops.append(.init(color: blend(base, syrupColor, ratio: 0.6), location: 0.82))
            stops.append(.init(color: syrupColor, location: 1.0))
        }

        return LinearGradient(
            gradient: Gradient(stops: stops),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    /// Линейное смешивание двух цветов в RGB.
    private func blend(_ a: Color, _ b: Color, ratio: CGFloat) -> Color {
        let ua = UIColor(a), ub = UIColor(b)
        var ar: CGFloat = 0, ag: CGFloat = 0, ab: CGFloat = 0, aa: CGFloat = 0
        var br: CGFloat = 0, bg: CGFloat = 0, bb: CGFloat = 0, ba: CGFloat = 0
        ua.getRed(&ar, green: &ag, blue: &ab, alpha: &aa)
        ub.getRed(&br, green: &bg, blue: &bb, alpha: &ba)
        let t = max(0, min(1, ratio))
        return Color(
            red: Double(ar + (br - ar) * t),
            green: Double(ag + (bg - ag) * t),
            blue: Double(ab + (bb - ab) * t),
            opacity: Double(aa + (ba - aa) * t)
        )
    }

    // MARK: - Steam

    private var steamView: some View {
        HStack(spacing: 14) {
            ForEach(0..<3) { i in
                SteamWisp(delay: Double(i) * 0.6, animate: !reduceMotion)
            }
        }
    }
}

// MARK: - CupShape
/// Трапеция стаканчика: верх шире низа, низ скруглён.
struct CupShape: Shape {
    var topWidth: CGFloat
    var bottomWidth: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(topWidth, bottomWidth) }
        set { topWidth = newValue.first; bottomWidth = newValue.second }
    }

    func path(in rect: CGRect) -> Path {
        let topInset = (rect.width - topWidth) / 2
        let bottomInset = (rect.width - bottomWidth) / 2
        let corner: CGFloat = 14

        var p = Path()
        // старт: верхний-левый угол
        p.move(to: CGPoint(x: rect.minX + topInset, y: rect.minY))
        // верхняя кромка вправо
        p.addLine(to: CGPoint(x: rect.maxX - topInset, y: rect.minY))
        // правый бок вниз (сужается к низу)
        p.addLine(to: CGPoint(x: rect.maxX - bottomInset, y: rect.maxY - corner))
        // скругление правого низа
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX - bottomInset - corner, y: rect.maxY),
            control: CGPoint(x: rect.maxX - bottomInset, y: rect.maxY)
        )
        // дно
        p.addLine(to: CGPoint(x: rect.minX + bottomInset + corner, y: rect.maxY))
        // скругление левого низа
        p.addQuadCurve(
            to: CGPoint(x: rect.minX + bottomInset, y: rect.maxY - corner),
            control: CGPoint(x: rect.minX + bottomInset, y: rect.maxY)
        )
        // левый бок вверх
        p.addLine(to: CGPoint(x: rect.minX + topInset, y: rect.minY))
        p.closeSubpath()
        return p
    }
}

// MARK: - WaveShape
/// Поверхность жидкости с синусоидальной волной.
/// `fillHeight` — высота столба напитка от дна; `phase` анимируется бесконечно.
struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var fillHeight: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let surfaceY = rect.maxY - fillHeight
        let width = rect.width
        let wavelength = width / 1.5

        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: surfaceY))

        var x: CGFloat = rect.minX
        while x <= rect.maxX {
            let relativeX = x / wavelength
            let y = surfaceY + amplitude * sin(relativeX * .pi * 2 + phase)
            p.addLine(to: CGPoint(x: x, y: y))
            x += 2
        }

        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - SteamWisp
/// Одна струйка пара, плавно поднимающаяся и тающая.
private struct SteamWisp: View {
    let delay: Double
    let animate: Bool
    @State private var rise = false

    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [Color.cfLatte.opacity(0.0), Color.cfLatte.opacity(0.5), Color.cfLatte.opacity(0.0)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 4, height: 30)
            .scaleEffect(y: rise ? 1.3 : 0.7, anchor: .bottom)
            .opacity(rise ? 0.0 : 0.7)
            .offset(y: rise ? -18 : 0)
            .onAppear {
                guard animate else { return }
                withAnimation(.easeOut(duration: 2.2).repeatForever(autoreverses: false).delay(delay)) {
                    rise = true
                }
            }
    }
}

#Preview("S — Эспрессо без молока") {
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
