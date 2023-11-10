//
//  MenuView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/9/23.
//

import SwiftUI

struct StoreView: View {
    var body: some View {
        Text("Welcome to the Store!")
            .padding()
        Text("Week 4: includes addition to the buying of the power-ups.")
    }
}

struct MenuView: View {
    let onSelectLevel: (Int) -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                onSelectLevel(1)
            }) {
                Text("Level Type 1")
            }
            
            Button(action: {
                onSelectLevel(2)
            }) {
                Text("Level Type 2")
            }
            Spacer()
        }
        .padding()
    }
}
