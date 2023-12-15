//
//  NavBar.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/10/23.
//

import SwiftUI
import SpriteKit

struct NavBar3: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = GameViewModel(rows: 8, columns: 8)
    @StateObject var viewModel2 = GameViewModelCircles()
    
    @State private var timer0 = false
    @State private var timerSeconds = 30
    @State private var timer: Timer?
    
    @State private var showingAlert = false
    @State private var isMenuViewPresented = false
    @State private var name = ""
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
                        .foregroundColor(Color("ColorPink"))
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("ColorPink"), lineWidth: 5)
                        )
                    
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
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(timerSeconds > 0 ? Color.teal : Color("ColorPink"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 5)
                        )
                }
            } else if isNavBarVisible == 2 { // ------------
                VStack {
                    Text("Score: \(viewModel2.scene.score)")
                        .foregroundColor(Color("ColorPink"))
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("ColorPink"), lineWidth: 5)
                        )
                    
                    GeometryReader { geometry in
                        SpriteView(scene: {
                            viewModel2.scene.size = CGSize(width: geometry.size.width + 350, height: geometry.size.height + 450)
                            viewModel2.scene.scaleMode = .fill
                            return viewModel2.scene
                        }())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                        //.padding(50)
                    }
                    
                    
                    Text("Time Remaining: \(timerSeconds) seconds")
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(timerSeconds > 0 ? Color.teal : Color("ColorPink"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 5)
                        )
                }
                .background(Color("ColorBack"))
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        //.fullScreenCover(isPresented: $isMenuViewPresented) {
            //NavigationView {
            //MenuView()
            //}
        //}
        .alert("Enter Highscore Details:", isPresented: $showingAlert) {
            VStack {
                TextField("Enter your name:", text: $name)
            }

            Button("OK", action: {
                submit()
                self.presentationMode.wrappedValue.dismiss()
            })
            .disabled(name.isEmpty)
        }
    }
        
    public func dateCheck() -> String {
        let currentDate = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YY"
        let dateString = dateFormatter.string(from: currentDate)

        return dateString
    }
    
    public func submit() {
        print("You entered \(name) + \(dateCheck())")
        //showingAlert.toggle()
        if(whichGame == 1)
        {
            viewModel.saveScores(newScore: viewModel.score, playerName: name, scoreDate: dateCheck())
        }
        else if(whichGame == 2)
        {
            viewModel2.scene.saveScores(newScore: viewModel2.scene.score, playerName: name, scoreDate: dateCheck())
        }
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
