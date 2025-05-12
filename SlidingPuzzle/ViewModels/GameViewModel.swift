import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var tiles: [Tile] = []
    @Published var emptyTile: Tile?
    @Published var timer: Timer?
    @Published var timeElapsed: TimeInterval = 0
    @Published var moveCount: Int = 0
    @Published var isGameRunning: Bool = false

    // MARK: - Show solved board (used before Play is pressed)
    func showGame() {
        tiles = generateSolvedTiles()
        moveCount = 0
        timeElapsed = 0
        isGameRunning = false
        timer?.invalidate()
    }

    // MARK: - Start new shuffled game
    func startGame(settings: Settings) {
        tiles = generateShuffledTiles()
        moveCount = 0
        timeElapsed = 0
        isGameRunning = true
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeElapsed += 1
        }
    }

    func move(tile: Tile) {
        guard isGameRunning else { return }
        guard let emptyIndex = tiles.firstIndex(where: { $0.value == 0 }),
              let tileIndex = tiles.firstIndex(of: tile) else { return }

        let empty = tiles[emptyIndex]
        let dx = abs(empty.col - tile.col)
        let dy = abs(empty.row - tile.row)

        if (dx == 1 && dy == 0) || (dx == 0 && dy == 1) {
            // Swap rows and columns
            tiles[emptyIndex].row = tile.row
            tiles[emptyIndex].col = tile.col
            tiles[tileIndex].row = empty.row
            tiles[tileIndex].col = empty.col

            // Swap tiles in the array so the view updates
            tiles.swapAt(emptyIndex, tileIndex)

            // Update the reference to the new empty tile
            emptyTile = tiles[tileIndex]

            moveCount += 1
        }
    }

    // MARK: - Helpers
    private func generateShuffledTiles() -> [Tile] {
        var tiles = (1...15).map {
            Tile(id: $0, row: ($0 - 1) / 4, col: ($0 - 1) % 4, value: $0)
        } + [Tile(id: 16, row: 3, col: 3, value: 0)]

        tiles.shuffle()

        // Make sure row/col values match the new shuffled positions
        for (i, _) in tiles.enumerated() {
            tiles[i].row = i / 4
            tiles[i].col = i % 4
        }

        if let blank = tiles.first(where: { $0.value == 0 }) {
            emptyTile = blank
        }

        return tiles
    }

    private func generateSolvedTiles() -> [Tile] {
        let tiles = (1...15).map {
            Tile(id: $0, row: ($0 - 1) / 4, col: ($0 - 1) % 4, value: $0)
        } + [Tile(id: 16, row: 3, col: 3, value: 0)]

        emptyTile = tiles.last
        return tiles
    }
}
