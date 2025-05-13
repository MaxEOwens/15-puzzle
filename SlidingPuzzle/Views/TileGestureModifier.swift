//
//  TileGestureModifier.swift
//  SlidingPuzzle
//
//  Created by Max Owens on 5/12/25.
//


import SwiftUI

struct TileGestureModifier: ViewModifier {
    let tile: Tile
    let controlStyle: String
    let moveAction: (Tile) -> Void

    func body(content: Content) -> some View {
        if controlStyle == "Tap" {
            content
                .onTapGesture {
                    moveAction(tile)
                }
        } else { // Swipe
            content
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            moveAction(tile)
                        }
                )
        }
    }
}
