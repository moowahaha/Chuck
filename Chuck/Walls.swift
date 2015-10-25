//
//  Walls.swift
//  Chuck
//
//  Created by Stephen Hardisty on 25/10/15.
//  Copyright © 2015 Mr. Stephen. All rights reserved.
//

import SpriteKit

class Walls {
    let BottomWallBitMask = UInt32(2)
    let LeftWallBitMask = UInt32(3)
    let TopWallBitMask = UInt32(4)
    let RightWallBitMask = UInt32(5)
    
    let SideGlowRadius = CGFloat(160)
    let EndGlowRadius = CGFloat(90)


    private var scene: GameScene!
    private var walls: [UInt32: SKShapeNode]!
    
    init(scene: GameScene) {
        self.walls = [UInt32: SKShapeNode]()
        self.scene = scene
        self.generate()
    }
    
    func highlightWall(bitMask: UInt32) -> (Bool) {
        let wallHit = self.walls[bitMask]
        
        if (wallHit == nil || wallHit!.alpha > 0.0) {
            return (false)
        } else {
            wallHit?.alpha = 1.0
            return (true)
        }
    }
    
    func hide() {
        for wall in self.walls.values {
            UIView.animateWithDuration(
                0.6,
                delay: 0.5,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    wall.alpha = 0.0
                },
                completion: nil
            )
        }
    }
    
    private func generate() {
        let frame = self.scene.frame
        
        // bottom
        self.generateWall(
            self.BottomWallBitMask,
            fromX: 0.0,
            fromY: 0.0,
            toX: frame.width,
            toY: 0.0
        )
        self.walls[self.BottomWallBitMask] = self.generateContactGlow(
            self.EndGlowRadius,
            x: frame.width / 2,
            y: self.EndGlowRadius * -1
        )
        
        // left
        self.generateWall(
            self.LeftWallBitMask,
            fromX: 0.0,
            fromY: 0.0,
            toX: 0.0,
            toY: frame.height
        )
        self.walls[self.LeftWallBitMask] = self.generateContactGlow(
            self.SideGlowRadius,
            x: self.SideGlowRadius * -1,
            y: frame.height / 2
        )
        
        // top
        self.generateWall(
            self.TopWallBitMask,
            fromX: 0.0,
            fromY: frame.height,
            toX: frame.width,
            toY: frame.height
        )
        self.walls[self.TopWallBitMask] = self.generateContactGlow(
            self.EndGlowRadius,
            x: frame.width / 2,
            y: frame.height + self.EndGlowRadius
        )
        
        // right
        self.generateWall(
            self.RightWallBitMask,
            fromX: frame.width,
            fromY: frame.height,
            toX: frame.width,
            toY: 0.0
        )
        self.walls[self.RightWallBitMask] = self.generateContactGlow(
            self.SideGlowRadius,
            x: frame.width + self.SideGlowRadius,
            y: frame.height / 2
        )
    }
    
    private func generateWall(collisionBitMask: UInt32, fromX: CGFloat, fromY: CGFloat, toX: CGFloat, toY: CGFloat) {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, fromX, fromY)
        CGPathAddLineToPoint(path, nil, toX, toY)
        
        let barrier = SKShapeNode(path: path)
        barrier.strokeColor = SKColor.blackColor()
        barrier.physicsBody = SKPhysicsBody(edgeLoopFromPath: path)
        barrier.physicsBody!.pinned = true
        barrier.physicsBody!.collisionBitMask = collisionBitMask
        self.scene.addChild(barrier)
    }
    
    private func generateContactGlow(radius: CGFloat, x: CGFloat, y: CGFloat) -> SKShapeNode {
        let glow = SKShapeNode(circleOfRadius: radius)
        glow.position = CGPoint(x: x, y: y)
        glow.fillColor = SKColor.whiteColor()
        glow.strokeColor = SKColor.whiteColor()
        glow.glowWidth = 10
        glow.alpha = 0.0
        
        self.scene.addChild(glow)
        
        return (glow)
    }

}