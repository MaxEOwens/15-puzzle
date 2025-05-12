import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var viewModel = LeaderboardViewModel()

    var body: some View {
        List {
            Section(header: Text("Top 30 Times")) {
                ForEach(viewModel.bestTimes.prefix(30)) { entry in
                    Text("\(Int(entry.time))s on \(entry.date.formatted())")
                }
            }
            Section(header: Text("Top 30 Moves")) {
                ForEach(viewModel.lowestMoves.prefix(30)) { entry in
                    Text("\(entry.moves) moves on \(entry.date.formatted())")
                }
            }
        }
        .navigationTitle("Leaderboard")
    }
}
