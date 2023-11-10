//
//  NavBar.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/10/23.
//

import SwiftUI
import SpriteKit

struct NavBar: View {
    @StateObject var viewModel = GameViewModel(rows: 8, columns: 8) // observing a gameboard from the gameviewmodel
    @Binding var isMenuVisible: Bool
    @State private var timerSeconds = 30
    @State private var navigateBack = false
    

    var body: some View {
        NavigationView {
            VStack {
                if !navigateBack{ // this is to help hide the game when the timer is up, if navback is false, then the game view is up, else, hide it
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: viewModel.gameBoard.isEmpty ? 0 : viewModel.gameBoard[0].count), spacing: 5) { //making a grid
                        ForEach(viewModel.gameBoard.indices, id: \.self) { rowIndex in // instatiation of rows
                            ForEach(viewModel.gameBoard[rowIndex].indices, id: \.self) { columnIndex in // instantiation of column
                                CellView(piece: $viewModel.gameBoard[rowIndex][columnIndex], viewModel: viewModel)
                                    .id(UUID()) // give them each an id
                            }
                        }
                    }
                    .padding(10)
                    
                    Text("Time Remaining: \(timerSeconds) seconds") // a timer is created to show you how much time is left
                        .foregroundColor(.white)
                        .padding()
                        .background(timerSeconds > 0 ? Color.blue : Color.red) // when it hits zero it turns red
                        .cornerRadius(10)
                        .onAppear {
                            startTimer() // when the level starts, the timer appears
                        }
                }
                
                NavigationStack{ //this is the most confusing part due to the deprecation of Nav.Link and me not knowing how exactly to execute this......
                            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) { // we have a nav.link to content view, without the back button being shown to mimic the "menu"
                                Text("Return to Menu") // another button is included to always have the option to return to menu
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .navigationDestination(
                                isPresented: $navigateBack) { // this is the awful part, if navigateback is true then we go back to the content view
                                    ContentView().navigationBarBackButtonHidden(true)
                                    Text("")
                                        .hidden() //this section is always hidden, creating a huge gap space
                                }
                } //this part i definitely need help on, or am going to have to keep working at.
            }
        }
    }
    
    private func startTimer() { // this is a timer function
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in // always repeating,
                if timerSeconds > 0 { // if greater than 0
                    navigateBack = false
                    timerSeconds -= 1 // take away 1 every second
                } else {
                    timer.invalidate() // otherwise, it doesn't work anymore and will reset when opening again
                    navigateBack = true // changing this to true will trigger code above to hide the game view and go back to the contentView ("menu")
                }
            }
        } // same thing for the other nav
}

struct NavBar2: View {
    @StateObject var viewModel = GameViewModelCircles() // observing a different file this time because i split them
    @Binding var isMenuVisible: Bool
    @State private var timerSeconds = 30
    @State private var navigateBack = false

    var body: some View {
        NavigationView {
            VStack {
                if !navigateBack{ // same idea, if false then show otherwise if true then go away
                    SpriteView(scene: { // i had to declare it as a variable in order to apply visual effects onit like .size and .scalemode -> i could probably move this somewhere else potentially
                        viewModel.scene.size = CGSize(width: 300, height: 500) // scene = other view model, instead we are now showcasing our other game type, it was much easier to put them in diff tabs
                        viewModel.scene.scaleMode = .fill // this one i fit to the screen for now so i could see where the circles were moving
                        return viewModel.scene
                    }())
                    .frame(width: 300, height: 500)
                    .ignoresSafeArea()
                    
                    Text("Time Remaining: \(timerSeconds) seconds") //same timer function
                        .foregroundColor(.white)
                        .padding()
                        .background(timerSeconds > 0 ? Color.blue : Color.red)
                        .cornerRadius(10)
                        .onAppear {
                            startTimer()
                        }
                }
                
                NavigationStack{
                            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                                Text("Return to Menu")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .navigationDestination(
                                isPresented: $navigateBack) {
                                    ContentView().navigationBarBackButtonHidden(true)
                                    Text("")
                                        .hidden()
                                }
                }
            }
        }
    }
    
    private func startTimer() {
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timerSeconds > 0 {
                    navigateBack = false
                    timerSeconds -= 1
                } else {
                    timer.invalidate()
                    navigateBack = true
                }
            }
        }
}
