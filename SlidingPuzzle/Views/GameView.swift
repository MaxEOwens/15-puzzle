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
                
                if viewModel.inspectionActive {
                    Text("Inspection: \(viewModel.inspectionTimeRemaining)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                }

                
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
            
            
            // .background(settingsViewModel.settings.backgroundColor.color)
            .background(currentBackgroundColor)
            
            .onAppear {
                viewModel.leaderboardModel = leaderboardModel
                viewModel.showGame()
            }
        }
    }
    private var currentBackgroundColor: Color {
            if viewModel.inspectionActive {
                return viewModel.inspectionTimeRemaining <= settingsViewModel.settings.warningTime ? .yellow : .red
            } else {
                return settingsViewModel.settings.backgroundColor.color
            }
    }
}
