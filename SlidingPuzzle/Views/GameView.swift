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
                
                //viewModel.timeElapsed = viewModel.timeElapsed - settingsViewModel.settings.inspectionTime
                
                Text(viewModel.formattedTime(viewModel.timeElapsed))
                    .font(.largeTitle)
                    .monospacedDigit()
                
                Spacer()
                
                // Tile grid with conditional gesture
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.tiles) { tile in
                        TileView(tile: tile)
                            .modifier(TileGestureModifier(tile: tile,
                                                          controlStyle: settingsViewModel.settings.controlStyle,
                                                          moveAction: viewModel.move))
                    }
                }
                .padding()
                
                
                Button(action: {
                    viewModel.startGame(settings: settingsViewModel.settings)
                }) {
                    Text("Scramble")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                
                
                .padding()
            }
            
            
            .background(settingsViewModel.settings.backgroundColor.color)
            
            
            .onAppear {
                viewModel.leaderboardModel = leaderboardModel
                viewModel.showGame()
            }
        }
    }
}
