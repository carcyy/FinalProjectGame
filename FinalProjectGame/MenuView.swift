//
//  MenuView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/9/23.
//
import SwiftUI

struct MenuView: View {
    @State private var isMenuVisible = false
    @State private var selectedLevel: Int?
    @State private var isStoreVisible = false
    
    var body: some View {
        VStack {
            if !isMenuVisible && selectedLevel == nil {
                Text("Carson's Game")
                    .font(.system(size: 50))
                Text("WIP")
                    .font(.system(size: 50))
                
                Button("Open Level Selector") { // level selection button
                    isMenuVisible.toggle() //toggle menu
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                
                Button("Open Store") { // store selection button
                    isStoreVisible.toggle() //toggle store
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                .sheet(isPresented: $isStoreVisible) {
                    StoreView()
                }
            }
            
            if let selectedLevel = selectedLevel { // if the menu selected level is either 1 or 2, then show the respective level.
                switch selectedLevel {
                case 1:
                    NavBar()
                case 2:
                    NavBar2()
                default:
                    EmptyView() // otherwise show nothing new
                }
            }
        }
        .sheet(isPresented: $isMenuVisible) { // shows the level selector sheet that allows you to pick level 1 or level 2
            MenuViewContent { level in
                selectedLevel = level
                isMenuVisible = false
            }
        }
    }
}

struct MenuViewContent: View {
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
        }
    }
}

struct StoreView: View {
    var body: some View {
        Text("Welcome to the Store!")
            .padding()
        Text("Week 4: includes addition to the buying of the power-ups.")
    }
}
