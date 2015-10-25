//
//  GameScene.swift
//  Chuck
//
//  Created by Stephen Hardisty on 14/10/15.
//  Copyright (c) 2015 Mr. Stephen. All rights reserved.
//

import SpriteKit
import AudioToolbox
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var ball: Ball!
    private var wasLastMovingBall = false
    private var turn: Turn!
    private var isGameOver = false
    private var walls: Walls!
    private var isFirstThrow = true
    var score: Score!
    var missLabel: UILabel!
    var controller: GameViewController!
    var motionManager: CMMotionManager!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = UIColor.blackColor()
        
        ball = Ball.generate(CGPoint(x: size.width / 2, y: size.height / 2))
        ball.physicsBody?.contactTestBitMask = 1
        self.addChild(ball)

        self.walls = Walls(scene: self)
        
        self.physicsWorld.contactDelegate = self
        
        self.turn = Turn()
    }

    override func didMoveToView(view: SKView) {
        self.motionManager = CMMotionManager()
        self.motionManager.startAccelerometerUpdates()

        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(panRecognizer)
    }

    // finger touches the ball
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.isGameOver {
            self.controller.startGame()
            return
        }
        
        let location = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(location)

        if self.isFirstThrow && touchedNode.isEqualToNode(ball) {
            self.isFirstThrow = false
            return
        }

        self.walls.hide()
        
        if touchedNode.isEqualToNode(ball) {
            self.initiateCatch(location)
        } else {
            self.gameOver("Missed catch")
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        // detect tilting to impact roll of ball
        #if !(arch(i386) || arch(x86_64))
            if let accelerometerData = motionManager.accelerometerData {
                physicsWorld.gravity = CGVector(
                    dx: accelerometerData.acceleration.x * 2,
                    dy: accelerometerData.acceleration.y * 2
                )
            }
        #endif
    }
    
    // callback for contact (e.g. ball hitting side of screen)
    func didEndContact(contact: SKPhysicsContact) {
        if self.isGameOver {
            return
        }
        
        if !self.wasLastMovingBall {
            self.turn.registerBounce()
            
            if (self.walls.highlightWall(contact.bodyA.collisionBitMask)) {
                self.turn.registerSideHit()
            }
        }
    }

    // callback for finger sliding around the screen
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        let viewLocation = recognizer.locationInView(self.view)
        let location = self.convertPointFromView(viewLocation)
        
        // check if the finger is moving on the ball
        if self.nodeAtPoint(location).isEqualToNode(ball) && ball.isStopped {
            if !self.isFirstThrow {
                self.score.display(viewLocation)
            }
            
            if recognizer.state == .Changed || recognizer.state == .Began {
                ball.moveTo(location)
                // hack: without this my finger can move faster than the ball and it 
                self.wasLastMovingBall = true
            } else if recognizer.state == .Ended {
                self.initiateRoll(recognizer)
            }
        }
        
        if !self.nodeAtPoint(location).isEqualToNode(ball) {
            if recognizer.state == .Changed && self.wasLastMovingBall {
                self.initiateRoll(recognizer)
            }
        }
    }
    
    // make the ball move based on pan velocity
    private func initiateRoll(recognizer: UIPanGestureRecognizer) {
        self.wasLastMovingBall = false
        self.score.hide()
        ball.roll(recognizer.velocityInView(recognizer.view))
    }
    
    // stop the ball
    private func initiateCatch(location: CGPoint) {
        if self.turn.hasHitAllSides() {
            ball.stop(location)
            
            self.score.add(self.turn.score())
            self.score.display(self.convertPointFromView(location))
            self.turn.reset()
        } else if !ball.isStopped {
            self.gameOver("Did not hit all sides")
        }
    }
    
    // game over. boo.
    private func gameOver(reason: String) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        ball.die()
        self.controller.promptForRestart(self.score, reason: reason)
        
        self.isGameOver = true
    }
}
