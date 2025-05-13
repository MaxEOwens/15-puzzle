import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var viewModel = LeaderboardViewModel()
    @ObservedObject var gameViewModel = GameViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Top 30 Times")) {
                ForEach(viewModel.bestTimes.prefix(30)) { entry in
                    let formattedTime = gameViewModel.formattedTime(entry.time)
                    let formattedDate = entry.date.formatted()

                    VStack(alignment: .leading) {
                        Text("\(formattedTime)s")
                            .font(.headline)
                        Text("on \(formattedDate)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Section(header: Text("Top 30 Moves")) {
                ForEach(viewModel.lowestMoves.prefix(30)) { entry in
                    let formattedDate = entry.date.formatted()

                    VStack(alignment: .leading) {
                        Text("\(entry.moves) moves")
                            .font(.headline)
                        Text("on \(formattedDate)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Leaderboard")
    }
}
