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
                Text("Purrfect Pair")
                    .font(.system(size: 65, weight: .bold))
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .foregroundColor(Color.teal)
                    .background(Color.white)
                    .cornerRadius(10)
                
                
                NavigationStack {
                    VStack(spacing: 100) {
                        ForEach(1..<3) { x in
                            NavigationLink(destination: {
                                NavBar3(isNavBarVisible: x)
                            }, label: {
                                if (x == 1)
                                {
                                    Text("Meow Match")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                        .background(Color("ColorPink"))
                                        .cornerRadius(10)
                                }
                                else {
                                    Text("Yarn Catch")
                                        .font(.system(size: 40, weight: .bold))
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                        .foregroundColor(.white)
                                        .background(Color("ColorPurple"))
                                        .cornerRadius(10)
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
                .background(Color.teal)
                
                Button("Highscores") {
                    isStoreVisible.toggle()
                }
                .foregroundColor(.teal)
                .font(.system(size: 25, weight: .bold))
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(Color.white)
                .cornerRadius(10)
                .sheet(isPresented: $isStoreVisible) {
                    StoreView()
                }
            }
        }
        .background(Color.teal)
    }
}

struct StoreView: View {
    @ObservedObject var viewModel = GameViewModel(rows: 8, columns: 8) //references
    @ObservedObject var viewModel2 = GameViewModelCircles()
    
    @State private var game1Visibility = false // variable that shows which game
    @State private var game2Visibility = false
    
    var body: some View {
        
        ZStack{
            Color("ColorBack").ignoresSafeArea()
            
            VStack (spacing: 25){
                Text("Highscores")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(Color.teal)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                HStack (spacing: 10){
                    Button(action: {
                        game1Visibility = true
                        game2Visibility = false
                    }) {
                        Text("Meow Match")
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .bold))
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .background(Color("ColorPink"))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        game2Visibility = true
                        game1Visibility = false
                    }) {
                        Text("Yarn Catch")
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .bold))
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .background(Color("ColorPurple"))
                            .cornerRadius(10)
                    }
                }
                
                ScrollView {
                    VStack(spacing: 2.5) { // Adjust spacing between items
                        if game1Visibility == true && game2Visibility == false {
                            ForEach(viewModel.scores, id: \.self) { scoreData in
                                Text("User: \(scoreData.playerName), Score: \(scoreData.score), Date: \(scoreData.scoreDate)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(Color.teal)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                            }
                            .padding(5)
                        }
                        else if game2Visibility == true && game1Visibility == false {
                            ForEach(viewModel2.scene.scores2, id: \.self) { scoreData2 in
                                Text("User: \(scoreData2.playerName), Score: \(scoreData2.score), Date: \(scoreData2.scoreDate)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(Color.teal)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                            }
                            .padding(5)
                        }
                    }
                    //.padding(10) // Add padding around the VStack
                    .background(Color("ColorBack"))
                    .cornerRadius(10)
                }
            }
            .background(Color("ColorBack"))
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

