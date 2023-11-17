//
//  NavBar.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/10/23.
//

import SwiftUI
import SpriteKit

struct NavBar: View {
    @StateObject var viewModel = GameViewModel(rows: 8, columns: 8)
    //@Binding var shouldDismiss: Bool
    
    @State private var timer0 = false
    @State private var timerSeconds = 30
    @State private var timer: Timer?
    //var dismissCallback: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDestination: Int?
    
    var body: some View {
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
            
            Button("Return to Menu") {
                //shouldDismiss = true
                //dismissCallback()
                print("button press")
                presentationMode.wrappedValue.dismiss()
            }
            .fullScreenCover(isPresented: $timer0) {
                NavigationView {
                    MenuView()
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
    }
    
    private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timerSeconds > 0 {
                    timerSeconds -= 1
                } else {
                    timer.invalidate()
                    //dismissCallback()
                    presentationMode.wrappedValue.dismiss()
                    timer0 = true
                    //isMenuVisible = false
                }
            }
        }
    }

struct NavBar2: View {
    @StateObject var viewModel = GameViewModelCircles()
    //@StateObject var viewModelPoints = MovingCirclesScene()
    //@Binding var isMenuVisible: Bool
    //@Binding var shouldDismiss: Bool
    
    @State private var timer0 = false
    @State private var timerSeconds = 30
    @State private var timer: Timer?
    //var dismissCallback: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            Text("Score: \(viewModel.scene.score)")
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
            
            SpriteView(scene: {
                viewModel.scene.size = CGSize(width: 300, height: 500)
                viewModel.scene.scaleMode = .fill
                return viewModel.scene
            }())
            .frame(width: 300, height: 500)
            .ignoresSafeArea()
            
            Text("Time Remaining: \(timerSeconds) seconds")
                .foregroundColor(.white)
                .padding()
                .background(timerSeconds > 0 ? Color.blue : Color.red)
                .cornerRadius(10)
            
            Button("Return to Menu") {
                //dismissCallback()
                presentationMode.wrappedValue.dismiss()
                //isMenuVisible = false
            }
            .fullScreenCover(isPresented: $timer0) {
                NavigationView {
                    MenuView()
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
    }
    
    private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timerSeconds > 0 {
                    timerSeconds -= 1
                } else {
                    timer.invalidate()
                    //dismissCallback()
                    presentationMode.wrappedValue.dismiss()
                    //isMenuVisible = false
                    timer0 = true
        
                }
            }
        }
    }
