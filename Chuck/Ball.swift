//
//  Ball.swift
//  Chuck
//
//  Created by Stephen Hardisty on 14/10/15.
//  Copyright © 2015 Mr. Stephen. All rights reserved.
//

import UIKit
import SpriteKit

let Radius = CGFloat(70)
let InitialSpeedMultiplier = CGFloat(0.3)

class Ball: SKShapeNode {
    private var speedMultiplier: CGFloat?
    var isStopped: Bool = true
    
    class func generate(location: CGPoint) -> Ball {
        let ball = Ball(circleOfRadius: Radius)
        ball.fillColor = SKColor.whiteColor()
        ball.position = location
        ball.speedMultiplier = InitialSpeedMultiplier
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: Radius)
        if let physics = ball.physicsBody {
            physics.affectedByGravity = false
            physics.friction = 0.005
            physics.restitution = 0.99
            physics.mass = 0.6
            physics.allowsRotation = false
            physics.linearDamping = 0.1
            physics.angularDamping = 0.0
            physics.dynamic = true
        }
        return ball
    }
    
    func die() {
        self.physicsBody!.restitution = 0.5
        self.physicsBody!.linearDamping = 0.5
        self.physicsBody!.friction = 0.5

        UIView.animateWithDuration(
            0.4,
            delay: 0.2,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.alpha = 0.4
            },
            completion: nil
        )
    }
    
    func stop(location: CGPoint) {
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.velocity = CGVectorMake(0.0, 0.0)
        self.moveTo(location)
        self.isStopped = true
    }
    
    func moveTo(location: CGPoint) {
        self.position = location
    }
    
    func roll(velocity: CGPoint) {
        self.physicsBody!.affectedByGravity = true
        self.isStopped = false
        self.speedMultiplier = self.speedMultiplier! + (CGFloat(arc4random())/CGFloat(UInt32.max) / 50)
        self.physicsBody!.applyImpulse(
            CGVectorMake(
                velocity.x * self.speedMultiplier!,
                velocity.y * self.speedMultiplier! * -1.0
            )
        )
    }
}
