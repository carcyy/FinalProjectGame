//
//  ContentView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 10/26/23.
import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel(rows: 8, columns: 8) // observing the models so we can call functions
    @StateObject private var viewModelCircles = GameViewModelCircles()

    @State private var isMenuVisible = false // this variable helps us make sure either the game or menu is visible
    @State private var selectedLevel: Int?
    
    @State private var isStoreVisible = false

    var body: some View {
        VStack {
            if !isMenuVisible && selectedLevel == nil { //if nil, meaning nothing has been pressed again (im pretty sure this is also messing up my timer function after it completes once, i think one of these variables is still full and creates and infinite loop of spawning stuff... not sure though)
                
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
                    NavBar(viewModel: viewModel, isMenuVisible: $isMenuVisible)
                case 2:
                    NavBar2(viewModel: viewModelCircles, isMenuVisible: $isMenuVisible)
                default:
                    EmptyView() // otherwise show nothing new
                }
            }
        }
        .sheet(isPresented: $isMenuVisible) { // shows the level selector sheet that allows you to pick level 1 or level 2
            MenuView { level in
                selectedLevel = level
                isMenuVisible = false
            }
        }
    }
}
    

#Preview {
    ContentView()
}
