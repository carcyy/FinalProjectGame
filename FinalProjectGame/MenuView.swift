//
//  MenuView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/9/23.
//
import SwiftUI
import SpriteKit

struct MenuView: View {
    @State private var isMenuVisible = false
    @State private var selectedLevel: Int?
    @State private var isStoreVisible = false
    
    @State private var isNavBarVisible = false
    
    var body: some View {
        VStack {
            if !isMenuVisible && selectedLevel == nil{
                Text("Carson's Game WIP")
                    .font(.system(size: 30))
                
                NavigationStack {
                    VStack {
                        ForEach(1..<3) { x in
                            NavigationLink(destination: {
                                NavBar3(isNavBarVisible: x)
                            }, label: {
                                if (x == 1)
                                {
                                    Text("Match 3+")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                else {
                                    Text("Ball Drop")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                            })
                        }
                    }
                }
                .navigationDestination(for: Int.self) { isNavBarVisible in
                    NavBar3(isNavBarVisible: isNavBarVisible)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationViewStyle(StackNavigationViewStyle())
                .padding()
                
                
                Button("Highscores") {
                    isStoreVisible.toggle()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .sheet(isPresented: $isStoreVisible) {
                    StoreView()
                }
            }
        }
    }
}

struct StoreView: View {
    @ObservedObject var viewModel = GameViewModel(rows: 8, columns: 8) //references
    @ObservedObject var viewModel2 = GameViewModelCircles()
    
    @State private var game1Visibility = false // variable that shows which game
    @State private var game2Visibility = false
    
    var body: some View {
        VStack {
            Text("Highscores")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Button("Match 3+ Highscore List") {
                game1Visibility = true
                game2Visibility = false
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.purple)
            .cornerRadius(10)
            Button("Ball Drop Highscore List") {
                game2Visibility = true
                game1Visibility = false
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.teal)
            .cornerRadius(10)
            
            if(game1Visibility == true && game2Visibility == false) // if in reference to game 1, display game 1 scores
            {
                List(viewModel.scores, id: \.self) { scoreData in
                    Text("User: \(scoreData.playerName), Score: \(scoreData.score), Date: \(scoreData.scoreDate)")
                }
            }
            else if(game2Visibility == true && game1Visibility == false) // if in reference to game 2, display game 2 scores
            {
                List(viewModel2.scene.scores2, id: \.self) { scoreData2 in
                    Text("User: \(scoreData2.playerName), Score: \(scoreData2.score), Date: \(scoreData2.scoreDate)")
                }
            }
        }
    }
}

extension GameViewModel.ScoreData: Hashable { //make them hashable so i can reference them in a list
    static func == (lhs: GameViewModel.ScoreData, rhs: GameViewModel.ScoreData) -> Bool {
        return lhs.playerName == rhs.playerName &&
               lhs.score == rhs.score &&
               lhs.scoreDate == rhs.scoreDate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(playerName)
        hasher.combine(score)
        hasher.combine(scoreDate)
    }
}

extension MovingCirclesScene.ScoreData2: Hashable { //make them hashable so i can reference them in a list
    static func == (lhs: MovingCirclesScene.ScoreData2, rhs: MovingCirclesScene.ScoreData2) -> Bool {
        return lhs.playerName == rhs.playerName &&
               lhs.score == rhs.score &&
               lhs.scoreDate == rhs.scoreDate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(playerName)
        hasher.combine(score)
        hasher.combine(scoreDate)
    }
}

