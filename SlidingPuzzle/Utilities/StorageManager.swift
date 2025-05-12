import Foundation

struct StorageManager {
    static func saveSettings(_ settings: Settings) {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "settings")
        }
    }

    static func loadSettings() -> Settings {
        if let data = UserDefaults.standard.data(forKey: "settings"),
           let settings = try? JSONDecoder().decode(Settings.self, from: data) {
            return settings
        }
        return Settings.default
    }

    static func saveLeaderboard(_ entries: [LeaderboardEntry], for key: String) {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: "leaderboard_\(key)")
        }
    }

    static func loadLeaderboard(for key: String) -> [LeaderboardEntry] {
        if let data = UserDefaults.standard.data(forKey: "leaderboard_\(key)"),
           let entries = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            return entries
        }
        return []
    }
}
