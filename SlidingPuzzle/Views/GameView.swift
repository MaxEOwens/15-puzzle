import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()

    let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: SettingsView(viewModel: SettingsViewModel())) {
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
            
            Text("Time: \(Int(viewModel.timeElapsed))s")
                .font(.headline)
            
            Spacer()

            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(viewModel.tiles) { tile in
                    TileView(tile: tile)
                        .onTapGesture {
                            viewModel.move(tile: tile)
                        }
                }
            }
            .padding()

            Button("Play") {
                viewModel.startGame(settings: Settings.default)
            }
            .padding()
        }
        .onAppear {
            viewModel.showGame()
        }
    }
}
