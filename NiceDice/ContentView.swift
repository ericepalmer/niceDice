import SwiftUI

struct ContentView: View {
    @Environment(GameModel.self) private var game

    var body: some View {
        VStack(spacing: 0) {
            HeaderBar()
            ResultStage()
                .frame(height: 248)
            FeltRule()
            HStack(alignment: .top, spacing: 14) {
                ForEach(Array(GameModel.bagHits), id: \.self) { hits in
                    BagColumn(hitsInBag: hits)
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 22)
            .padding(.bottom, 26)
        }
        .background {
            FeltBackdrop()
        }
        .frame(width: 1100, height: 860)
    }
}

private struct HeaderBar: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text("NICE DICE")
                    .font(Typeface.display(23))
                    .tracking(5)
                    .foregroundStyle(Palette.cream)
                Text("Each bag holds six pips. Pulling without replacement makes extreme results less likely than rolling separate dice.")
                    .font(Typeface.rounded(12, weight: .regular))
                    .foregroundStyle(Palette.muted)
            }
            Spacer()
            HStack(spacing: 16) {
                LegendChip(kind: .hit, label: "Hit")
                LegendChip(kind: .miss, label: "Miss")
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 22)
        .padding(.bottom, 14)
    }
}

private struct LegendChip: View {
    let kind: Pip
    let label: String

    var body: some View {
        HStack(spacing: 7) {
            PipDot(kind: kind, size: 12)
            Text(label.uppercased())
                .font(Typeface.rounded(10, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(Palette.muted)
        }
    }
}

private struct FeltRule: View {
    var body: some View {
        Rectangle()
            .fill(Palette.feltEdge.opacity(0.55))
            .frame(height: 1)
            .padding(.horizontal, 28)
    }
}

private struct FeltBackdrop: View {
    var body: some View {
        ZStack {
            Palette.felt
            RadialGradient(
                colors: [Palette.feltCenter.opacity(0.95), Palette.felt.opacity(0)],
                center: .center,
                startRadius: 40,
                endRadius: 520
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
        .environment(GameModel())
}
