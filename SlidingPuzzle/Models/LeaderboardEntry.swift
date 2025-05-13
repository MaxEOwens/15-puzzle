import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    var id = UUID()
    let time: TimeInterval
    let moves: Int
    let date: Date
}
