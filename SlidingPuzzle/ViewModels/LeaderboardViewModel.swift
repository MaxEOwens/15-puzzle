import Foundation

class LeaderboardViewModel: ObservableObject {
    @Published var bestTimes: [LeaderboardEntry] = []
    @Published var lowestMoves: [LeaderboardEntry] = []

    init() {
        bestTimes = StorageManager.loadLeaderboard(for: "time")
        lowestMoves = StorageManager.loadLeaderboard(for: "moves")
    }

    func addEntry(_ entry: LeaderboardEntry) {
        bestTimes.append(entry)
        bestTimes.sort { $0.time < $1.time }

        lowestMoves.append(entry)
        lowestMoves.sort { $0.moves < $1.moves }

        StorageManager.saveLeaderboard(bestTimes, for: "time")
        StorageManager.saveLeaderboard(lowestMoves, for: "moves")
    }
}
