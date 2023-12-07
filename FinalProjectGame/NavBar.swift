//
//  NavBar.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/10/23.
//

import SwiftUI
import SpriteKit

struct NavBar3: View {
    @StateObject var viewModel = GameViewModel(rows: 8, columns: 8)
    @StateObject var viewModel2 = GameViewModelCircles()
    
    @State private var timer0 = false
    @State private var timerSeconds = 30
    @State private var timer: Timer?
    
    @State private var showingAlert = false
    @State private var isMenuViewPresented = false
    @State private var name = ""
    @State private var date = ""
    @State private var whichGame = 0
    
    let isNavBarVisible: Int
    
    init(isNavBarVisible: Int) {
        self.isNavBarVisible = isNavBarVisible
    }
    
    var body: some View {
        VStack {
            if isNavBarVisible == 1 { // ---------------
                VStack {
                    Text("Score: \(viewModel.score)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: viewModel.gameBoard.isEmpty ? 0 : viewModel.gameBoard[0].count), spacing: 5) {
                        ForEach(viewModel.gameBoard.indices, id: \.self) { rowIndex in
                            ForEach(viewModel.gameBoard[rowIndex].indices, id: \.self) { columnIndex in
                                CellView(piece: $viewModel.gameBoard[rowIndex][columnIndex], viewModel: viewModel)
                                    .id(UUID())
                            }
                        }
                    }
                    .padding(10)
                    
                    Text("Time Remaining: \(timerSeconds) seconds")
                        .foregroundColor(.white)
                        .padding()
                        .background(timerSeconds > 0 ? Color.blue : Color.red)
                        .cornerRadius(10)
                }
            } else if isNavBarVisible == 2 { // ------------
                VStack {
                    Text("Score: \(viewModel2.scene.score)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                    
                    GeometryReader { geometry in
                        SpriteView(scene: {
                            viewModel2.scene.size = CGSize(width: geometry.size.width, height: geometry.size.height)
                            viewModel2.scene.scaleMode = .fill
                            return viewModel2.scene
                        }())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                    }
                    
                    
                    Text("Time Remaining: \(timerSeconds) seconds")
                        .foregroundColor(.white)
                        .padding()
                        .background(timerSeconds > 0 ? Color.blue : Color.red)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .fullScreenCover(isPresented: $isMenuViewPresented) {
            NavigationView {
                MenuView()
            }
        }
        .alert("Enter Highscore Details:", isPresented: $showingAlert) 
        {
            TextField("Enter your name:", text: $name)
            TextField("Enter the date:", text: $date)
                    Button("OK", action: submit)
                } message: {
                    Text("")
                }
    }
    
    public func submit() {
        print("You entered \(name) + \(date)")
        //showingAlert.toggle()
        if(whichGame == 1)
        {
            viewModel.saveScores(newScore: viewModel.score, playerName: name, scoreDate: date)
        }
        else if(whichGame == 2)
        {
            viewModel2.scene.saveScores(newScore: viewModel2.scene.score, playerName: name, scoreDate: date)
        }
        
        isMenuViewPresented.toggle()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timerSeconds > 0 {
                timerSeconds -= 1
            } else {
                timer.invalidate()
                timer0 = true
                
                if isNavBarVisible == 1 {
                    whichGame = 1
                    showingAlert.toggle()
                } else if isNavBarVisible == 2 {
                    whichGame = 2
                    showingAlert.toggle()
                }
            }
        }
    }
}
