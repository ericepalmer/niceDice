import SwiftUI

struct DiceCluster: View {
    let count: Int
    var highlighted: Bool = false

    private var dieSize: CGFloat {
        switch count {
        case 1: 22
        case 2: 18
        case 3: 15
        case 4: 15
        default: 13
        }
    }

    var body: some View {
        Group {
            switch count {
            case 1:
                DieFace(size: dieSize, highlighted: highlighted)
            case 2:
                HStack(spacing: 5) {
                    DieFace(size: dieSize, highlighted: highlighted)
                    DieFace(size: dieSize, highlighted: highlighted)
                }
            case 3:
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { _ in
                        DieFace(size: dieSize, highlighted: highlighted)
                    }
                }
            case 4:
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        DieFace(size: dieSize, highlighted: highlighted)
                        DieFace(size: dieSize, highlighted: highlighted)
                    }
                    HStack(spacing: 4) {
                        DieFace(size: dieSize, highlighted: highlighted)
                        DieFace(size: dieSize, highlighted: highlighted)
                    }
                }
            default:
                VStack(spacing: 3) {
                    DieFace(size: dieSize, highlighted: highlighted)
                    HStack(spacing: 3) {
                        DieFace(size: dieSize, highlighted: highlighted)
                        DieFace(size: dieSize, highlighted: highlighted)
                    }
                    HStack(spacing: 3) {
                        DieFace(size: dieSize, highlighted: highlighted)
                        DieFace(size: dieSize, highlighted: highlighted)
                    }
                }
            }
        }
        .accessibilityHidden(true)
    }
}

struct DieFace: View {
    let size: CGFloat
    var highlighted: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.18, style: .continuous)
                .fill(highlighted ? Palette.ivory : Palette.ivory.opacity(0.92))
            RoundedRectangle(cornerRadius: size * 0.18, style: .continuous)
                .stroke(Palette.ivoryDeep, lineWidth: 1)
            DiePips(size: size)
                .foregroundStyle(Palette.ink.opacity(0.78))
        }
        .frame(width: size, height: size)
        .rotationEffect(.degrees(-6))
    }
}

private struct DiePips: View {
    let size: CGFloat

    var body: some View {
        let pip = max(1.6, size * 0.14)
        let inset = size * 0.22
        ZStack {
            Circle().frame(width: pip, height: pip).offset(x: -inset, y: -inset)
            Circle().frame(width: pip, height: pip).offset(x: inset, y: inset)
            Circle().frame(width: pip, height: pip)
        }
    }
}
