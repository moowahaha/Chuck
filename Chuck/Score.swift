//
//  Score.swift
//  Chuck
//
//  Created by Stephen Hardisty on 15/10/15.
//  Copyright © 2015 Mr. Stephen. All rights reserved.
//

import SpriteKit

class Score {
    var lastScore = 0
    var totalScore = 0
    let scoreContainer: UIView!
    let totalScoreLabel: UILabel!
    let lastScoreLabel: UILabel!
    
    init(scoreContainer: UIView, totalScoreLabel: UILabel, lastScoreLabel: UILabel) {
        self.scoreContainer = scoreContainer
        self.totalScoreLabel = totalScoreLabel
        self.lastScoreLabel = lastScoreLabel
    }
    
    func display(location: CGPoint) {
        if (self.totalScore == 0 && self.lastScore == 0) {
            return
        }
        self.totalScoreLabel.text = "\(self.totalScore)"
        self.lastScoreLabel.text = "+\(self.lastScore)"

        self.scoreContainer.center = location
        
        UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.lastScoreLabel.alpha = 1.0
                self.scoreContainer.alpha = 1.0
            },
            completion: nil
        )

        UIView.animateWithDuration(
            0.2,
            delay: 0.2,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.totalScoreLabel.alpha = 1.0
            },
            completion: nil
        )
    }
    
    func hide() {
        self.totalScoreLabel.alpha = 0.0
        self.lastScoreLabel.alpha = 0.0
        self.scoreContainer.alpha = 0.0
    }
    
    func add(score: Int) {
        self.lastScore = score
        self.totalScore = self.totalScore + score
    }
}