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
    let dragAction: (CGPoint) -> Void

    func body(content: Content) -> some View {
        if controlStyle == "Tap" {
            content
                .onTapGesture {
                    moveAction(tile)
                }
        } else {
            content
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            dragAction(value.location)
                        }
                )
        }
    }
}
