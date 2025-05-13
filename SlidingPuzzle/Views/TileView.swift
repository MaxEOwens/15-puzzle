import SwiftUI

struct TileView: View {
    let tile: Tile
    
    
    
    var tileColor: Color {
        switch tile.value {
        case 0: return .clear
        case 1, 2, 3, 4: return .red
        case 5, 9, 13: return .orange
        case 6, 7, 8: return .green
        case 11, 12: return .blue
        case 10, 14: return .cyan
        case 15: return .purple
        default: return .gray // fallback color
        }
    }
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(tileColor)
                .frame(height: 80)
                .cornerRadius(5)

            if tile.value != 0 {
                Text("\(tile.value)")
                    .foregroundColor(.white)
                    .bold()
            }
        }
    }
}
