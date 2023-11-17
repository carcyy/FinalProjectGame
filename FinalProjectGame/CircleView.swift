//
//  CircleView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/9/23.
//

import SwiftUI
import SpriteKit

class MovingCirclesScene: SKScene, ObservableObject { //SKScene for SpriteKit scene
    let allColors: [UIColor] = [.red, .green, .blue, .yellow] // i wanted an array of colors for another mechanic i will introduce in the coming weeks
    var square: SKSpriteNode! // make a sprite kit model of my "shot" ! has to do with unwrapping/wrapping, making sure it isn't nil (which it shouldn't ever be so I used the !)
    var isSquareMoving = false // originally it needs to be stationary at the top
    
    @Published var score: Int = 0 // initialize score
    
    func respawnSquare() { // function to respawn the square once it has finished being "shot"
        isSquareMoving = false
        let respawnAction = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height - 30), duration: 0) // use an action to remove the square back to the top instead of constantly spawning new squares (lag, which it already lags a bit)
        square.run(respawnAction) // apply this to the square
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // override function kicks in when there is a touch
        if !isSquareMoving { // if the square isn't moving and there was a tap...
            let moveAction = SKAction.moveBy(x: 0, y: -size.height, duration: 2.0) // make an SKAction for movement of the square
            square.run(moveAction) {
                self.respawnSquare() //apply
            }
            isSquareMoving = true //the square is now moving after the tap, so we update the variable
        }
    }
    
    override func didMove(to view: SKView) { // override function is constantly going because the scene is in view
        backgroundColor = .white
        
        let topMargin: CGFloat = 125 // some space between the shot and the circles
        
        square = SKSpriteNode(color: .black, size: CGSize(width: 15, height: 15)) // create a square
        square.position = CGPoint(x: size.width / 2, y: size.height - 15) // give it a position at the top
        addChild(square) // add child to the scene
        
        for row in 0..<5 { // for loop for instantiating the rows of circles
            let rowY = size.height - topMargin - CGFloat(row * 100)
            let moveLeft = row % 2 == 0 // this piece determines whether the row will be moving left or right
            let shuffledColors = allColors.shuffled() // makes sure the colors are random
            for i in 0..<10 { //for loop for the circles now
                let color = shuffledColors[i % 4] //assigns the colors
                createAndMoveCircle(rowY: rowY, column: i, moveLeft: moveLeft, color: color) // creates the row
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) { // override is also always going based off time, checks for collision between square and circle
        checkForCollisions()
    }
    
    func checkForCollisions() {
        for circle in circles { //for each circle
            if circle.intersects(square) { // if it interacts with the square, remove it
                circle.removeFromParent() // spritekit remove from the scene
                
                if let index = circles.firstIndex(of: circle) {
                    circles.remove(at: index) // remove it at the position of the circle in the row
                }
                
                updateScore(for: circle.fillColor) //update the score based on the color of the circle
            }
        }
    }
    
    func createAndMoveCircle(rowY: CGFloat, column: Int, moveLeft: Bool, color: UIColor) { // create the circles and let them move
        let circle = SKShapeNode(circleOfRadius: 20)
        
        let initialXPosition: CGFloat
        if moveLeft {
            initialXPosition = size.width + CGFloat(column * 150)
        } else {
            initialXPosition = -CGFloat(column * 150)
        }
        
        circle.position = CGPoint(x: initialXPosition, y: rowY)
        circle.fillColor = color
        
        addChild(circle)
        //setup ^^
        
        let moveDistance: CGFloat
        
        if moveLeft {
            moveDistance = -size.width - CGFloat(10 * 150) //if moveleft is true then actually move it left
        } else {
            moveDistance = size.width + CGFloat(10 * 150) // or move right
        }
        
        let moveDuration = 4.0 // how fast they go
        
        let moveAction = SKAction.sequence([ //makes them actually move
            SKAction.moveBy(x: moveDistance, y: 0, duration: moveDuration),
            SKAction.run { [weak self] in // i decided to do weak self here because i feel like otherwise there may be memory issues with how many
                if let scene = self {
                    let defaultXPosition: CGFloat
                    if moveLeft {
                        defaultXPosition = scene.size.width + CGFloat(column * 150)
                    } else {
                        defaultXPosition = -CGFloat(column * 150)
                    }
                    circle.position.x = defaultXPosition
                }
            }
                                           ])
        
        let repeatAction = SKAction.repeatForever(moveAction)
        circle.run(repeatAction)
        
        circles.append(circle) // we have to keep track of the circles or else we cannot remove them so push them to an array
    }
    
    func updateScore(for color: UIColor) { //new
        switch color {
        case UIColor.red:
            score += 100
        case UIColor.green:
            score += 150
        case UIColor.blue:
            score += 200
        case UIColor.yellow:
            score += 250
            break
        default:
            break
        }
        print("Score: \(score)")
    }
    
    var circles: [SKShapeNode] = [] //define the array
}
