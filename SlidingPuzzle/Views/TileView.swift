import SwiftUI

struct TileView: View {
    let tile: Tile

    var body: some View {
        ZStack {
            Rectangle()
                .fill(tile.value == 0 ? Color.clear : Color.blue)
                .frame(height: 80)
                .cornerRadius(8)

            if tile.value != 0 {
                Text("\(tile.value)")
                    .foregroundColor(.white)
                    .bold()
            }
        }
    }
}
