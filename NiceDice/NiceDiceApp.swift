import SwiftUI

@main
struct NiceDiceApp: App {
    @State private var game = GameModel()

    var body: some Scene {
        Window("Nice Dice", id: "main") {
            ContentView()
                .environment(game)
                .preferredColorScheme(.dark)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 1100, height: 860)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
