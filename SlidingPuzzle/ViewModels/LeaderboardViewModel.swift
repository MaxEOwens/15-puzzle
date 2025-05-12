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
        lowestMoves.append(entry)
        StorageManager.saveLeaderboard(bestTimes, for: "time")
        StorageManager.saveLeaderboard(lowestMoves, for: "moves")
    }
}
