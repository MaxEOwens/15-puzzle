import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var tiles: [Tile] = []
    @Published var emptyTile: Tile?
    @Published var timer: Timer?
    @Published var timeElapsed: TimeInterval = 0
    @Published var startTime: Date?
    @Published var moveCount: Int = 0
    @Published var isGameRunning: Bool = false
    @Published var inspectionActive: Bool = false
    @Published var inspectionTimeRemaining: Int = 0

    private var inspectionTimer: Timer?

    
    var leaderboardModel: LeaderboardViewModel?

    // MARK: - Show solved board (used before Play is pressed)
    func showGame() {
        tiles = generateSolvedTiles()
        moveCount = 0
        timeElapsed = 0.00
        isGameRunning = false

        timer?.invalidate()
        inspectionTimer?.invalidate()
        inspectionActive = false
        inspectionTimeRemaining = 0
    }


    // MARK: - Start new shuffled game
    func startGame(settings: Settings) {
        tiles = generateShuffledTiles()
        moveCount = 0
        timeElapsed = 0
        isGameRunning = false
        inspectionActive = true
        inspectionTimeRemaining = settings.inspectionTime

        timer?.invalidate()
        inspectionTimer?.invalidate()

        inspectionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.inspectionTimeRemaining > 0 {
                self.inspectionTimeRemaining -= 1
            } else {
                self.inspectionActive = false
                self.inspectionTimer?.invalidate()
                startMainTimer()
            }
        }
    }

    func formattedTime(_ interval: TimeInterval) -> String {
        let totalMilliseconds = Int(interval * 1000)
        let minutes = (totalMilliseconds / 1000) / 60
        let seconds = (totalMilliseconds / 1000) % 60
        let milliseconds = (totalMilliseconds % 1000) / 10
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
    
    private func checkIfSolved() {
        for i in 0..<15 {
            if tiles[i].value != i + 1 {
                return // Not solved
            }
        }

        // The last tile should be empty (value == 0)
        if tiles[15].value == 0 {
            isGameRunning = false
            timer?.invalidate()
            let entry = LeaderboardEntry(
                time: timeElapsed,
                moves: moveCount,
                date: Date()
            )

            leaderboardModel?.addEntry(entry)
            print("🎉 Puzzle solved in \(moveCount) moves and \(formattedTime(timeElapsed))!")
        }
    }
    
    private func startMainTimer() {
        isGameRunning = true
        startTime = Date()
        timeElapsed = 0

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            self.timeElapsed = Date().timeIntervalSince(start)
        }
    }
    
    func move(tile: Tile) {
        if inspectionActive {
            inspectionActive = false
            inspectionTimer?.invalidate()
            startMainTimer()
        } else if !isGameRunning {
            startMainTimer()
        }

        guard isGameRunning else { return }
        guard let emptyIndex = tiles.firstIndex(where: { $0.value == 0 }),
              let tileIndex = tiles.firstIndex(of: tile) else { return }

        var emptyTile = tiles[emptyIndex]
        let selectedTile = tiles[tileIndex]

        let sameRow = emptyTile.row == selectedTile.row
        let sameCol = emptyTile.col == selectedTile.col

        guard sameRow || sameCol else {
            return // Must be in the same row or column
        }

        var affectedTiles: [Tile] = []

        if sameRow {
            let row = emptyTile.row
            let range: [Int] = emptyTile.col < selectedTile.col
                ? Array((emptyTile.col + 1)...selectedTile.col)
                : Array((selectedTile.col..<emptyTile.col).reversed())

            for col in range {
                if let index = tiles.firstIndex(where: { $0.row == row && $0.col == col }) {
                    affectedTiles.append(tiles[index])
                }
            }

            for tile in affectedTiles {
                if let index = tiles.firstIndex(of: tile) {
                    tiles[index].col += (emptyTile.col < selectedTile.col) ? -1 : 1
                }
            }

            tiles[emptyIndex].col = selectedTile.col
        } else if sameCol {
            let col = emptyTile.col
            let range: [Int] = emptyTile.row < selectedTile.row
                ? Array((emptyTile.row + 1)...selectedTile.row)
                : Array((selectedTile.row..<emptyTile.row).reversed())


            for row in range {
                if let index = tiles.firstIndex(where: { $0.col == col && $0.row == row }) {
                    affectedTiles.append(tiles[index])
                }
            }

            for tile in affectedTiles {
                if let index = tiles.firstIndex(of: tile) {
                    tiles[index].row += (emptyTile.row < selectedTile.row) ? -1 : 1
                }
            }

            tiles[emptyIndex].row = selectedTile.row
        }

        // Update tile positions in array
        tiles.sort { $0.row * 4 + $0.col < $1.row * 4 + $1.col }

        // Update reference to new empty tile
        if let newEmpty = tiles.first(where: { $0.value == 0 }) {
            emptyTile = newEmpty
        }

        moveCount += 1
        checkIfSolved()
    }
    
    func handleTouch(at point: CGPoint, tileSize: CGFloat = 80, padding: CGFloat = 8) {
        let totalSize = tileSize + padding
        let col = Int(point.x / totalSize)
        let row = Int(point.y / totalSize)

        guard row >= 0 && row < 4 && col >= 0 && col < 4 else { return }

        if let tile = tiles.first(where: { $0.row == row && $0.col == col }) {
            move(tile: tile)
        }
    }

    // MARK: - Helpers
//    private func generateShuffledTiles() -> [Tile] {
//        var tiles = (1...15).map {
//            Tile(id: $0, row: ($0 - 1) / 4, col: ($0 - 1) % 4, value: $0)
//        } + [Tile(id: 16, row: 3, col: 3, value: 0)]
//
//        tiles.shuffle()
//
//        // Make sure row/col values match the new shuffled positions
//        for (i, _) in tiles.enumerated() {
//            tiles[i].row = i / 4
//            tiles[i].col = i % 4
//        }
//
//        if let blank = tiles.first(where: { $0.value == 0 }) {
//            emptyTile = blank
//        }
//
//        return tiles
//    }
    
    
  
    private func heuristic(_ tiles: [Tile]) -> Int {
        var total = 0
        for tile in tiles where tile.value != 0 {
            let goalRow = (tile.value - 1) / 4
            let goalCol = (tile.value - 1) % 4
            total += abs(tile.row - goalRow) + abs(tile.col - goalCol)
        }
        return total
    }
    
    
    private func generateShuffledTiles(threshold: Int = 50) -> [Tile] {
        // 1: Start from goal state
        var tiles = (1...15).map {
            Tile(id: $0, row: ($0 - 1) / 4, col: ($0 - 1) % 4, value: $0)
        } + [Tile(id: 16, row: 3, col: 3, value: 0)] // blank tile

        // Repeat until heuristic is above threshold
        while true {
            // 2 & 3: Swap two arbitrary tiles twice
            for _ in 0..<2 {
                let i = Int.random(in: 0..<tiles.count)
                var j = Int.random(in: 0..<tiles.count)
                while i == j { j = Int.random(in: 0..<tiles.count) }
                tiles.swapAt(i, j)
            }

            // 4: Update row/col to reflect shuffled positions
            for i in tiles.indices {
                tiles[i].row = i / 4
                tiles[i].col = i % 4
            }

            // 5: Compute heuristic (e.g., Manhattan distance)
            let h = heuristic(tiles)

            // 6: If heuristic is high enough, return
            if h >= threshold {
                if let blank = tiles.first(where: { $0.value == 0 }) {
                    emptyTile = blank
                }
                return tiles
            }

            // 8: Otherwise, repeat
        }
    }
    
    
    
    
    
    
    
    
    
    

    private func generateSolvedTiles() -> [Tile] {
        let tiles = (1...15).map {
            Tile(id: $0, row: ($0 - 1) / 4, col: ($0 - 1) % 4, value: $0)
        } + [Tile(id: 16, row: 3, col: 3, value: 0)]

        emptyTile = tiles.last
        return tiles
    }
}
