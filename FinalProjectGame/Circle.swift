//
//  Circle.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/30/23.
//

import SwiftUI

struct GameCircle: Equatable {
    let color: Color
    let type: CircleType
    let score: Int
    let image: Image
    
    
    init(type: CircleType) {
        self.type = type
        self.color = type.color
        self.score = type.score
        self.image = type.image
    }
}

enum CircleType {
    case type1
    case type2
    case type3
    case type4
    //case none
    
    var color: Color {
        switch self {
        case .type1: return Color.red
        case .type2: return Color.green
        case .type3: return Color.blue
        case .type4: return Color.yellow
        //case .none: return Color.clear
        }
    }
    
    var image: Image {
        switch self {
        case .type1: return Image("yarnball1")
        case .type2: return Image("yarnball2")
        case .type3: return Image("yarnball3")
        case .type4: return Image("yarnball4")
        }
    }
    
    var score: Int {
        switch self {
        case .type1: return 100
        case .type2: return 150
        case .type3: return 200
        case .type4: return 250
        //case .none: return 0
        }
    }
}
