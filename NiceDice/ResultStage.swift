import SwiftUI

struct ResultStage: View {
    @Environment(GameModel.self) private var game

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Palette.stage)
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Palette.feltEdge.opacity(0.7), lineWidth: 1)
                }

            if let result = game.lastResult {
                DrawReadout(result: result, revealed: game.revealedDrawn)
            } else {
                IdlePrompt()
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 8)
    }
}

private struct IdlePrompt: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Choose a bag, then how many pips to pull.")
                .font(Typeface.display(20))
                .foregroundStyle(Palette.cream.opacity(0.88))
            Text("A 3-bag with the double-dice pulls two of its six pips and leaves four behind. Every pull starts from a full bag.")
                .font(Typeface.rounded(13, weight: .regular))
                .foregroundStyle(Palette.muted)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }
}

private struct DrawReadout: View {
    let result: DrawResult
    let revealed: Int

    private var visibleDrawn: [Pip] {
        Array(result.drawn.prefix(revealed))
    }

    private var visibleHits: Int { visibleDrawn.filter { $0 == .hit }.count }
    private var visibleMisses: Int { visibleDrawn.filter { $0 == .miss }.count }

    var body: some View {
        HStack(spacing: 36) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(result.hitsInBag)-BAG  ·  DRAW \(result.drawCount)")
                    .font(Typeface.rounded(12, weight: .bold))
                    .tracking(1.6)
                    .foregroundStyle(Palette.brass)

                HStack(alignment: .firstTextBaseline, spacing: 18) {
                    CountBlock(value: visibleHits, caption: visibleHits == 1 ? "HIT" : "HITS", tint: Palette.hit)
                    CountBlock(value: visibleMisses, caption: visibleMisses == 1 ? "MISS" : "MISSES", tint: Palette.missRim)
                }

                Text("\(result.remaining.count) left in the bag")
                    .font(Typeface.rounded(12, weight: .regular))
                    .foregroundStyle(Palette.muted)
                    .padding(.top, 4)
            }
            .frame(width: 260, alignment: .leading)

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    ForEach(Array(result.drawn.enumerated()), id: \.offset) { index, pip in
                        PipToken(kind: pip, size: 46, labeled: true)
                            .opacity(index < revealed ? 1 : 0.12)
                            .scaleEffect(index < revealed ? 1 : 0.72)
                            .animation(.spring(response: 0.38, dampingFraction: 0.72), value: revealed)
                    }
                }

                VStack(spacing: 6) {
                    Text("LEFT IN THE BAG")
                        .font(Typeface.rounded(9, weight: .bold))
                        .tracking(1.1)
                        .foregroundStyle(Palette.muted.opacity(revealed == result.drawCount ? 1 : 0.35))
                    HStack(spacing: 7) {
                        ForEach(Array(result.remaining.enumerated()), id: \.offset) { _, pip in
                            PipDot(kind: pip, size: 14)
                        }
                    }
                }
                .opacity(revealed == result.drawCount ? 1 : 0.28)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 40)
    }
}

private struct CountBlock: View {
    let value: Int
    let caption: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(value)")
                .font(Typeface.rounded(44, weight: .bold))
                .foregroundStyle(tint)
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.snappy, value: value)
            Text(caption)
                .font(Typeface.rounded(11, weight: .bold))
                .tracking(1.4)
                .foregroundStyle(Palette.muted)
        }
    }
}

struct PipToken: View {
    let kind: Pip
    var size: CGFloat = 40
    var labeled: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            PipDot(kind: kind, size: size)
            if labeled {
                Text(kind == .hit ? "HIT" : "MISS")
                    .font(Typeface.rounded(9, weight: .bold))
                    .tracking(0.8)
                    .foregroundStyle(kind == .hit ? Palette.hit : Palette.missRim)
            }
        }
    }
}

struct PipDot: View {
    let kind: Pip
    var size: CGFloat = 16

    var body: some View {
        ZStack {
            Circle()
                .fill(kind == .hit ? Palette.hit : Palette.miss)
                .overlay {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    (kind == .hit ? Palette.hitCore : Palette.missRim).opacity(0.7),
                                    .clear
                                ],
                                center: UnitPoint(x: 0.32, y: 0.28),
                                startRadius: 0,
                                endRadius: size * 0.55
                            )
                        )
                }
                .overlay {
                    Circle()
                        .stroke(kind == .hit ? Palette.brass.opacity(0.55) : Palette.missRim.opacity(0.8), lineWidth: max(1, size * 0.06))
                }
        }
        .frame(width: size, height: size)
        .accessibilityLabel(kind == .hit ? "Hit" : "Miss")
    }
}
