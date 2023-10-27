//
//  ContentView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 10/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GameViewModel(rows: 8, columns: 8) // observing a gameboard from the gameviewmodel

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: viewModel.gameBoard.isEmpty ? 0 : // making a grid
            viewModel.gameBoard[0].count), spacing: 5) {
            ForEach(viewModel.gameBoard.indices, id: \.self) { rowIndex in // instatiation of rows
                ForEach(viewModel.gameBoard[rowIndex].indices, id: \.self) { columnIndex in // instantiation of column
                    CellView(piece: $viewModel.gameBoard[rowIndex][columnIndex], viewModel: viewModel)
                        .id(UUID()) // give them each an id
                }
            }
        }
        .padding(10)
    }
}

#Preview {
    ContentView()
}
