//
//  Piece.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 10/26/23.
//

import SwiftUI

struct Piece: Identifiable, Equatable {
    let id: UUID
    let color: Color
    let image: Image
    let type: PieceType
    let score: Int
    var hasPowerUp: Bool
    
    init(id: UUID = UUID(), type: PieceType) {
        self.id = id
        self.type = type
        self.color = type.color
        self.image = type.image
        self.score = type.score
        self.hasPowerUp = type.hasPowerUp
    }
}

enum PieceType {
    case type1
    case type2
    case type3
    case none
    
    var color: Color {
        switch self {
        case .type1: return Color.red
        case .type2: return Color.green
        case .type3: return Color.blue
        case .none: return Color.clear
        }
    }
    
    var image: Image {
        switch self {
        case .type1: return Image("yarnball1")
        case .type2: return Image("yarnball2")
        case .type3: return Image("yarnball3")
        case .none: return Image("empty")
        }
    }
    
    var score: Int {
        switch self {
        case .type1: return 100
        case .type2: return 150
        case .type3: return 200
        case .none: return 0
        }
    }
    
    var hasPowerUp: Bool {
        switch self {
        case .type1, .type2, .type3:
            return false // Set to true if you want all types to have power-up, modify as needed
        case .none:
            return false
        }
    }
}
