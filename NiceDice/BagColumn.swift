import SwiftUI

struct BagColumn: View {
    @Environment(GameModel.self) private var game
    let hitsInBag: Int

    private var misses: Int { GameModel.pipTotal - hitsInBag }
    private var isActive: Bool { game.lastResult?.hitsInBag == hitsInBag }
    private var isShaking: Bool { game.shakingBag == hitsInBag }

    var body: some View {
        VStack(spacing: 12) {
            LeatherBagView(hits: hitsInBag, isActive: isActive)
                .offset(x: isShaking ? 5 : 0)
                .animation(.spring(response: 0.12, dampingFraction: 0.28).repeatCount(isShaking ? 3 : 0, autoreverses: true), value: isShaking)

            VStack(spacing: 5) {
                HStack(spacing: 4) {
                    ForEach(0..<hitsInBag, id: \.self) { _ in
                        PipDot(kind: .hit, size: 9)
                    }
                    ForEach(0..<misses, id: \.self) { _ in
                        PipDot(kind: .miss, size: 9)
                    }
                }
                Text("\(hitsInBag) of 6 hits")
                    .font(Typeface.rounded(11, weight: .medium))
                    .foregroundStyle(isActive ? Palette.brass : Palette.muted)
            }

            VStack(spacing: 8) {
                ForEach(Array(GameModel.drawCounts), id: \.self) { count in
                    DrawButton(
                        hitsInBag: hitsInBag,
                        drawCount: count,
                        isLastDraw: game.lastResult?.hitsInBag == hitsInBag && game.lastResult?.drawCount == count
                    ) {
                        game.draw(hitsInBag: hitsInBag, count: count)
                    }
                }
            }
            .padding(.top, 6)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(isActive ? Palette.feltLift.opacity(0.55) : Color.clear)
        }
    }
}

private struct LeatherBagView: View {
    let hits: Int
    let isActive: Bool

    var body: some View {
        ZStack {
            BagShape()
                .fill(
                    LinearGradient(
                        colors: [Palette.leatherLite, Palette.leather, Palette.leatherDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    BagShape()
                        .stroke(Palette.leatherDark.opacity(0.7), lineWidth: 1.4)
                }
                .shadow(color: .black.opacity(0.35), radius: 6, y: 4)

            Cinch()

            Text("\(hits)")
                .font(Typeface.rounded(38, weight: .bold))
                .foregroundStyle(Palette.cream)
                .shadow(color: Palette.leatherDark.opacity(0.8), radius: 0, y: 1)
                .offset(y: 10)
        }
        .frame(width: 92, height: 112)
        .overlay(alignment: .top) {
            Circle()
                .stroke(isActive ? Palette.brass : Palette.cord, lineWidth: 2)
                .frame(width: 14, height: 14)
                .offset(y: -2)
        }
        .accessibilityLabel("Bag \(hits), \(hits) hit pips of six")
    }
}

private struct Cinch: View {
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Palette.cord)
                .frame(width: 38, height: 6)
                .offset(y: 16)
            HStack {
                Capsule()
                    .fill(Palette.cord.opacity(0.85))
                    .frame(width: 3, height: 18)
                    .rotationEffect(.degrees(-28))
                Capsule()
                    .fill(Palette.cord.opacity(0.85))
                    .frame(width: 3, height: 18)
                    .rotationEffect(.degrees(28))
            }
            .offset(y: 10)
            Spacer()
        }
        .allowsHitTesting(false)
    }
}

struct BagShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let neckY = h * 0.17
        let neckW = w * 0.23

        path.move(to: CGPoint(x: w * 0.5 - neckW, y: neckY))
        path.addCurve(
            to: CGPoint(x: w * 0.12, y: h * 0.46),
            control1: CGPoint(x: w * 0.20, y: neckY + 8),
            control2: CGPoint(x: w * 0.04, y: h * 0.30)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.98),
            control1: CGPoint(x: w * 0.02, y: h * 0.70),
            control2: CGPoint(x: w * 0.20, y: h * 0.97)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.88, y: h * 0.46),
            control1: CGPoint(x: w * 0.80, y: h * 0.97),
            control2: CGPoint(x: w * 0.98, y: h * 0.70)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5 + neckW, y: neckY),
            control1: CGPoint(x: w * 0.96, y: h * 0.30),
            control2: CGPoint(x: w * 0.80, y: neckY + 8)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.5 - neckW, y: neckY),
            control: CGPoint(x: w * 0.5, y: neckY - h * 0.07)
        )
        path.closeSubpath()
        return path
    }
}

private struct DrawButton: View {
    let hitsInBag: Int
    let drawCount: Int
    let isLastDraw: Bool
    let action: () -> Void

    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            DiceCluster(count: drawCount, highlighted: hovering || isLastDraw)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .contentShape(Rectangle())
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(hovering || isLastDraw ? Palette.feltLift : Palette.feltButton)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isLastDraw ? Palette.brass : (hovering ? Palette.brass.opacity(0.7) : Palette.feltEdge), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .help("Draw \(drawCount) pip\(drawCount == 1 ? "" : "s") from the \(hitsInBag)-hit bag")
        .accessibilityLabel("Draw \(drawCount) from bag \(hitsInBag)")
    }
}
