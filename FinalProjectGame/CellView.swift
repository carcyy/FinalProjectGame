//
//  CellView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 10/27/23.
//

import SwiftUI

struct CellView: View {
    @Binding var piece: Piece
    @ObservedObject var viewModel: GameViewModel
//where all the logic 
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.clear) //piece.color
                .overlay(
                    piece.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .aspectRatio(1.0, contentMode: .fit)
                .padding(5)
                .onTapGesture { // when you tap you need apply the logic of selection, moving, swapping, etc.
                    if let selectedPiece = viewModel.selectedPiece, selectedPiece.type != piece.type { // if you select a piece and it is not th
                        if let selectedRowIndex = viewModel.gameBoard.firstIndex(where: { $0.contains { $0.id == selectedPiece.id } }),
                           let selectedColumnIndex = viewModel.gameBoard[selectedRowIndex].firstIndex(where: { $0.id == selectedPiece.id }),
                           let currentRowIndex = viewModel.gameBoard.firstIndex(where: { $0.contains { $0.id == piece.id } }),
                           let currentColumnIndex = viewModel.gameBoard[currentRowIndex].firstIndex(where: { $0.id == piece.id }) {
                            //basically the above just makes sure the variables are full of the correct indicies
                            viewModel.gameBoard[selectedRowIndex][selectedColumnIndex] = piece // the intersection of row and column in the selected area is a piece, so save it
                            viewModel.gameBoard[currentRowIndex][currentColumnIndex] = selectedPiece // make sure its the selected piece
                            
                            viewModel.lastSwappedPiece = piece // make sure you know the last swapped is noted as well so you can see whats around
                            viewModel.checkMatchesAroundLastSwappedPiece()
                            viewModel.checkForExtraMatches() // check for extras around there
                            
                            //viewModel.checkMatchesAndProcess()
                        }
                        viewModel.selectedPiece = nil // otherwise there is not selected piece
                    } else {
                        viewModel.selectedPiece = piece // otherwise there is a piece
                    }
                }
                .border(viewModel.selectedPiece?.id == piece.id ? Color.teal : Color.clear, width: 2) // give it a border to see which one you've selected
        }
    }
}
