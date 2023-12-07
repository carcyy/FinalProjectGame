//
//  CircleView.swift
//  FinalProjectGame
//
//  Created by CUBS Customer on 11/9/23.
//


//updated to include the Circle.swift / GameCircle struct :)
import SwiftUI
import SpriteKit


class MovingCirclesScene: SKScene, ObservableObject { //SKScene for SpriteKit scene
    var square: SKSpriteNode! // make a sprite kit model of my "shot" ! has to do with unwrapping/wrapping, making sure it isn't nil (which it shouldn't ever be so I used the !)
    var isSquareMoving = false // originally it needs to be stationary at the top
    
    @Published var score: Int = 0 // initialize score
    
    @Published var scores2: [ScoreData2] = []
        
    @Published var playerName: String = ""
    @Published var scoreDate: String = ""
    
    struct ScoreData2: Codable, Identifiable {
        var id = UUID()
        var playerName: String
        var score: Int
        var scoreDate: String
    }
    
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
            
            for i in 0..<10 { // for loop for the circles now
                let circleType: [CircleType] = [.type1, .type2, .type3, .type4] // assign types of GameCircle
                let randomType = circleType.randomElement() ?? .type1 // default to type1 as our none
                createAndMoveCircle(rowY: rowY, column: i, moveLeft: moveLeft, circleType: randomType) // create the row
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) { // override is also always going based off time, checks for collision between square and circle
        checkForCollisions()
    }
    
    func checkForCollisions() {
        for (index, circle) in circles.enumerated() { // for each circle
            let circleNode = children[index] as? SKShapeNode // let the circle = this one
            
            if circleNode?.intersects(square) ?? false { // check to see if it collides with square
                circleNode?.removeFromParent() // remove it if so
                circles.remove(at: index) // remove the circle at specific index from the array
                updateScore(for: circle) // update score :)
            }
        }
    }
    
    func createAndMoveCircle(rowY: CGFloat, column: Int, moveLeft: Bool, circleType: CircleType) { // create the circles and let them move
        
        let circle = SKShapeNode(circleOfRadius: 20)
        
        let initialXPosition: CGFloat
        
        if moveLeft {
            initialXPosition = size.width + CGFloat(column * 150)
        } else {
            initialXPosition = -CGFloat(column * 150)
        }
        
        circle.position = CGPoint(x: initialXPosition, y: rowY)
        circle.fillColor = UIColor(circleType.color)
        
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
        
        let gameCircle = GameCircle(type: circleType)
        circles.append(gameCircle) // we have to keep track of the circles or else we cannot remove them so push them to an array
    }
    
    func updateScore(for circleType: GameCircle) {
        let circleScore = circleType.score
        score += circleScore
        print(score)
    }
    
    func saveScores(newScore: Int, playerName: String, scoreDate: String) { // same function
        print("saving scores ball edition")

        let newScoreData = ScoreData2(playerName: playerName, score: newScore, scoreDate: scoreDate)

        scores2.append(newScoreData)

        let encodedScores = try? JSONEncoder().encode(scores2)
        UserDefaults.standard.set(encodedScores, forKey: "gameScores2")
    }

    //func loadScores() {
        //if let savedScores = UserDefaults.standard.array(forKey: "gameScores") as? [Int] {
            //scores = savedScores
        //} else {
            //scores = [] // Initialize scores as an empty array if there are no saved scores yet
            //print("No scores")
        //}
    //}
    func loadScores() { // same function just copy pasted
        if let savedScoresData = UserDefaults.standard.data(forKey: "gameScores2") {
            do {
                scores2 = try JSONDecoder().decode([ScoreData2].self, from: savedScoresData)
                print("Loaded scores:", scores2)
            } catch {
                print("Error decoding scores:", error)
                scores2 = []
            }
        } else {
            scores2 = []
            print("No scores")
        }
    }
    
    //var circles: [SKShapeNode] = [] //define the array
    var circles: [GameCircle] = [] //new
}

