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
    let type: PieceType

    init(id: UUID = UUID(), type: PieceType) {
        self.id = id
        self.type = type
        self.color = type.color
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
}
