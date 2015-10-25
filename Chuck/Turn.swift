//
//  Turn.swift
//  Chuck
//
//  Created by Stephen Hardisty on 15/10/15.
//  Copyright © 2015 Mr. Stephen. All rights reserved.
//

import Foundation

class Turn {
    private var bounces: Int!
    private var startTime: Double!
    private var sidesHit: Int!
    
    init() {
        self.reset()
    }
    
    func reset() {
        self.startTime = CFAbsoluteTimeGetCurrent()
        self.sidesHit = 0
        self.bounces = 0
    }
    
    func registerBounce() {
        self.bounces = self.bounces + 1
    }
    
    func registerSideHit() {
        self.sidesHit = self.sidesHit + 1
    }
    
    func hasHitAllSides() -> Bool {
        return self.sidesHit == 4
    }
    
    func score() -> Int {
        let elapsed = CFAbsoluteTimeGetCurrent() - startTime
        return Int((Double(self.bounces) / elapsed) * 10)
    }
}