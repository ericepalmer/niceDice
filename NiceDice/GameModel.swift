import Foundation
import Observation

enum Pip: Equatable, Hashable {
    case hit
    case miss
}

struct DrawResult: Equatable {
    let hitsInBag: Int
    let drawCount: Int
    let drawn: [Pip]
    let remaining: [Pip]

    var drawnHits: Int { drawn.filter { $0 == .hit }.count }
    var drawnMisses: Int { drawn.filter { $0 == .miss }.count }
    var remainingHits: Int { remaining.filter { $0 == .hit }.count }
    var remainingMisses: Int { remaining.filter { $0 == .miss }.count }
}

@MainActor
@Observable
final class GameModel {
    private(set) var lastResult: DrawResult?
    private(set) var revealedDrawn: Int = 0
    private(set) var shakingBag: Int?
    private var revealTask: Task<Void, Never>?

    static let pipTotal = 6
    static let bagHits = 1...5
    static let drawCounts = 1...5

    func draw(hitsInBag: Int, count: Int) {
        precondition(Self.bagHits.contains(hitsInBag))
        precondition(Self.drawCounts.contains(count))

        var pips = [Pip]()
        pips.append(contentsOf: Array(repeating: .hit, count: hitsInBag))
        pips.append(contentsOf: Array(repeating: .miss, count: Self.pipTotal - hitsInBag))
        pips.shuffle()

        let drawn = Array(pips.prefix(count))
        let remaining = Array(pips.dropFirst(count))
        let result = DrawResult(
            hitsInBag: hitsInBag,
            drawCount: count,
            drawn: drawn,
            remaining: remaining
        )

        revealTask?.cancel()
        lastResult = result
        revealedDrawn = 0
        shakingBag = hitsInBag

        revealTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(180))
            guard let self, !Task.isCancelled else { return }
            self.shakingBag = nil
            for index in 1...count {
                try? await Task.sleep(for: .milliseconds(95))
                guard !Task.isCancelled else { return }
                self.revealedDrawn = index
            }
        }
    }
}
