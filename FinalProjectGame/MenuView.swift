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
                                Text("Level Type \(x)")
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
                
                
                Button("Open Store") {
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
    var body: some View {
        Text("Welcome to the Store!")
            .padding()
        Text("Hoping to eventually figure out power-ups otherwise this will turn into a scoreboard.")
    }
}


