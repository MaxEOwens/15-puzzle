import Foundation

struct LeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let time: TimeInterval
    let moves: Int
    let date: Date
}
