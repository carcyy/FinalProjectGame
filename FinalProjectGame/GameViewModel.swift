//
//  GameViewModel.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 10/26/23.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var gameBoard: [[Piece]] = [] // an array of array of pieces, what i use to access the pieces at row/column
    @Published var selectedPiece: Piece?
    @Published var lastSwappedPiece: Piece?
    
    @Published var score: Int = 0
    @Published var canScore: Bool = false
    
    @Published var powerUpCount: Int = 0
    let maxPowerUps: Int = 3
    
    init(rows: Int, columns: Int) {
        initializeGameBoard(rows: rows, columns: columns) // initiatize with pieces in the rows and columns
        
        while hasMatches() {
            initializeGameBoard(rows: rows, columns: columns) // keep instantiating until the board has no matches at the beginning
        }
        canScore = true
    }
    
    func initializeGameBoard(rows: Int, columns: Int) { // function to instantiate random pieces on the board
        gameBoard.removeAll() // makes sure that the game board is empty
        for _ in 0..<rows { // for loop starting from 0 up to the amount of rows : which is 8
            var row = [Piece]()
            for _ in 0..<columns { // for loop starting from 0 up to the amount of columns : which is 8
                let pieceTypes: [PieceType] = [.type1, .type2, .type3] // make sure that you can have all variety of pieces
                let randomType = pieceTypes.randomElement() ?? .none // let the random piece be a random piece type
                row.append(Piece(id: UUID(), type: randomType)) // append that to the row
            }
            gameBoard.append(row) // append that as well, one for each row and column
        }
        
        score = 0
    }
    
    func checkMatchesAroundLastSwappedPiece() { // looks around the piece that swap
        if let lastSwappedPiece = self.lastSwappedPiece { // let the last swapped piece be replaced
            if let row = gameBoard.firstIndex(where: { $0.contains { $0.id == lastSwappedPiece.id } }), // finding the index based off the last swapped
               let column = gameBoard[row].firstIndex(where: { $0.id == lastSwappedPiece.id }) // same thing looking in the column direction
            {
                _ = checkAndRemoveMatches(at: row, column: column) // learned that the underscore is used in place of a potential variable, checking to remove it at the row and column index.
            }
        }
    }
    
//    func collapsePieces() { //supposed to help make the pieces fall down
//            for column in gameBoard[0].indices {
//                var nonEmptyCells = [Piece]()
//                for row in gameBoard.indices {
//                    if gameBoard[row][column].type != .none {
//                        nonEmptyCells.append(gameBoard[row][column])
//                    }
//                }
//
//                nonEmptyCells.reverse()
//
//                for row in gameBoard.indices {
//                    if nonEmptyCells.isEmpty {
//                        gameBoard[row][column] = Piece(id: UUID(), type: .none)
//                    } else if let newPiece = nonEmptyCells.popLast() {
//                        gameBoard[row][column] = newPiece
//                    }
//                }
//            }
//        }

        //working on trying to generate new pieces in the spots of the old ones... kinda works but eventually want to implement gravity
//        func generateNewPieces() {
//            for column in gameBoard[0].indices {
//                for row in gameBoard.indices {
//                    if gameBoard[row][column].type == .none {
//                        let pieceTypes: [PieceType] = [.type1, .type2, .type3]
//                        let randomType = pieceTypes.randomElement() ?? .none
//                        gameBoard[row][column] = Piece(id: UUID(), type: randomType)
//                    }
//                }
//            }
//        }


//        func checkMatchesAndProcess() {
//            while hasMatches() {
//                checkForExtraMatches()
//                collapsePieces()
//                generateNewPieces()
//            }
//        }
    
    func hasMatches() -> Bool { // constantly checking to see if theres matches
        var matchesFound = false
        for row in gameBoard.indices { // for loop to parse row
            for column in gameBoard[row].indices { //for loop to parse column
                if checkAndRemoveMatches(at: row, column: column) { // if you have a match in this place
                    matchesFound = true // then its true
                }
            }
        }
        return matchesFound // return results
    }
    
    func checkAndRemoveMatches(at row: Int, column: Int) -> Bool { // check to remove matches like everywhere...
        let typeToMatch = gameBoard[row][column].type // find the type that you swapped from
        
        if typeToMatch == .none { // this should never happen but if the type is none then obviously theres no match
            return false // return false cause this shouldnt happen
        }
        
        var matchingVertical: [Int] = [row]
        var matchingHorizontal: [Int] = [column]
        
        //vertical check
        for offset in 1..<3 { // checking for at least 3
            if row + offset < gameBoard.count, gameBoard[row + offset][column].type == typeToMatch { //  checking the bounds of the board
                matchingVertical.append(row + offset) // append the none
            } else {
                break
            }
        }
        for offset in 1..<3 {
            if row - offset >= 0, gameBoard[row - offset][column].type == typeToMatch {
                matchingVertical.append(row - offset)
            } else {
                break
            }
        }
        
        //horizontal check
        for offset in 1..<3 {
            if column + offset < gameBoard[row].count, gameBoard[row][column + offset].type == typeToMatch {
                matchingHorizontal.append(column + offset)
            } else {
                break
            }
        }
        for offset in 1..<3 {
            if column - offset >= 0, gameBoard[row][column - offset].type == typeToMatch {
                matchingHorizontal.append(column - offset)
            } else {
                break
            }
        }
        
        if matchingVertical.count >= 3 { // if it is true, and there is a match present, then we need to remove the matches in the column
            removeMatches(at: matchingVertical, in: column, isColumnMatch: true)
            if canScore {
                print(matchingVertical.count)
                updateScore(for: typeToMatch, count: matchingVertical.count)
            }
        }
        
        if matchingHorizontal.count >= 3 { // if it is true, and there is a match present, then we need to remove the matches in the row
            removeMatches(at: matchingHorizontal, in: row, isColumnMatch: false)
            if canScore {
                print(matchingHorizontal.count)
                updateScore(for: typeToMatch, count: matchingHorizontal.count)
            }
        }
        
        return matchingVertical.count >= 3 || matchingHorizontal.count >= 3 // return whether that is true or false
    }
    
    func updateScore(for pieceType: PieceType, count: Int) {
            let pieceScore = pieceType.score * count
            score += pieceScore
            print(score)
        }
    
    func removeMatches(at positions: [Int], in row: Int, isColumnMatch: Bool) { // remove
        if positions.isEmpty { // if youre removing empty stuff then obviously that cant happen
            return
        }
        
        if isColumnMatch { // if there is a match in the column
            for r in positions { // r = row
                gameBoard[r][row] = Piece(id: UUID(), type: .none) // remove the piece by replacing it with the clear version
            }
        } else { // else its in a column
            for c in positions { // c = column
                gameBoard[row][c] = Piece(id: UUID(), type: .none) // same thing
            }
        }
    }
    
    func checkForExtraMatches() { // check after you match constantly to see if you can catch a "double" where if you mix and make two matches on the board
        for row in gameBoard.indices { // for loop to check rows
            for column in gameBoard[row].indices { // for loop to check the column
                if checkAndRemoveMatches(at: row, column: column) { // if you checked to remove matches, meaning you had a match...
                    checkForExtraMatches() // then check for extras
                    return // end
                }
            }
        }
    }
}

