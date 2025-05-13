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
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Text(viewModel.formattedTime(viewModel.timeElapsed))
                    .font(.largeTitle)
                    .monospacedDigit()
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                // Tile grid with conditional gesture
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.tiles) { tile in
                        TileView(tile: tile)
                            .modifier(TileGestureModifier(
                                tile: tile,
                                controlStyle: settingsViewModel.settings.controlStyle,
                                moveAction: viewModel.move,
                                dragAction: { point in
                                    viewModel.handleTouch(at: point)
                                }
                            ))
                    }
                }
                .padding()
                
                
                Button(action: {
                    if viewModel.isGameRunning || viewModel.inspectionActive {
                        viewModel.showGame() // Reset to solved board
                    } else {
                        viewModel.startGame(settings: settingsViewModel.settings)
                    }
                }) {
                    Text(viewModel.isGameRunning || viewModel.inspectionActive ? "Reset" : "Scramble")
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
            
            
            // .background(settingsViewModel.settings.backgroundColor.color)
            .background(currentBackgroundColor)
            
            .onAppear {
                viewModel.leaderboardModel = leaderboardModel
                viewModel.showGame()
            }
        }
    }
    private var currentBackgroundColor: Color {
        let pastelRed = Color(red: 1, green: 0.3686, blue: 0.3686)
        let pastelYellow = Color(red: 0.9882, green: 0.8314, blue: 0.3647)

        if viewModel.inspectionActive {
                return viewModel.inspectionTimeRemaining <= settingsViewModel.settings.warningTime ?  pastelYellow : pastelRed
            } else {
                return settingsViewModel.settings.backgroundColor.color
            }
    }
}
