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
                
//                let totalMilliseconds = Int(viewModel.timeElapsed * 1000)
//                let minutes = (totalMilliseconds / 1000) / 60
//                let seconds = (totalMilliseconds / 1000) % 60
//                let milliseconds = (totalMilliseconds % 1000) / 10 // two-digit ms
//
//                Text(String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds))
//                    .font(.largeTitle).monospacedDigit()
                Text(viewModel.formattedTime(viewModel.timeElapsed))
                    .font(.largeTitle)
                    .monospacedDigit()
                
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
