import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var leaderboardModel = LeaderboardViewModel()

    let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink(destination: SettingsView(viewModel: settingsViewModel)) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                    Spacer()
                    NavigationLink(destination: LeaderboardView()) {
                        Image(systemName: "list.number")
                            .imageScale(.large)
                    }
                }
                .padding()
                
                Spacer()
                
                let minutes = Int(viewModel.timeElapsed ?? 0) / 60 % 60
                let seconds = Int(viewModel.timeElapsed ?? 0) % 60
                let milliseconds = Int(viewModel.timeElapsed.truncatingRemainder(dividingBy: 1))
                
                Text("Time: " + String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds))
                
                
                
                
                    .font(.headline)
                
                Spacer()
                
                // Tile grid with conditional gesture
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(viewModel.tiles) { tile in
                        TileView(tile: tile)
                            .modifier(TileGestureModifier(tile: tile,
                                                          controlStyle: settingsViewModel.settings.controlStyle,
                                                          moveAction: viewModel.move))
                    }
                }
                .padding()
                
                Button("Play") {
                    viewModel.startGame(settings: settingsViewModel.settings)
                }
                .padding()
            }
            .onAppear {
                viewModel.leaderboardModel = leaderboardModel
                viewModel.showGame()
            }
        }
    }
}
