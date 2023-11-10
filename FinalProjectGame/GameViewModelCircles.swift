//
//  GameViewModelCircles.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/9/23.
//

import SwiftUI
import SpriteKit

class GameViewModelCircles: ObservableObject { // this just literally instantiates the code in the circleview lol
    @Published var scene: MovingCirclesScene
    
    init() {
        self.scene = MovingCirclesScene()
    }
}
// i dont think it needed to be split like this but helps for clarity sake
