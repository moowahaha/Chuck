//
//  GameViewController.swift
//  Chuck
//
//  Created by Stephen Hardisty on 14/10/15.
//  Copyright (c) 2015 Mr. Stephen. All rights reserved.
//

import UIKit
import SpriteKit

let HighScoreKey = "HIGH_SCORE"

class GameViewController: UIViewController {
    @IBOutlet weak var lastScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var restartLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var scoreContainer: UIView!
    @IBOutlet weak var missLabel: UILabel!
    @IBOutlet weak var gameOverReason: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var tapToRestart: UILabel!
    
    var defaults: NSUserDefaults!

    override func viewDidLoad() {
        // Configure the view.
        let skView = self.view as! SKView
        skView.allowsTransparency = false
        skView.frameInterval = 1
        skView.ignoresSiblingOrder = true
        
        self.showTitleLabels()
        
        self.startGame()
        
        self.defaults = NSUserDefaults.standardUserDefaults()
        
        UIView.animateWithDuration(
            0.2, delay: 2.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.titleLabel.alpha = 0.0
            },
            completion: nil
        )

        UIView.animateWithDuration(
            0.2,
            delay: 2.5,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.titleLabel2.alpha = 0.0
                self.titleLabel3.alpha = 0.0
            },
            completion: nil
        )
    }
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func startGame() {
        self.hideStatusLabels()
        
        let skView = self.view as! SKView
        
        let scene = GameScene(size: skView.frame.size)
        scene.controller = self
        scene.score = Score(
            scoreContainer: self.scoreContainer,
            totalScoreLabel: self.totalScoreLabel,
            lastScoreLabel: self.lastScoreLabel
        )
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        scene.missLabel = self.missLabel
        
        skView.presentScene(scene)
    }
    
    func promptForRestart(score: Score, reason: String!) {
        self.scoreContainer.alpha = 0.0
        
        self.hideTitleLabels()
        self.hideStatusLabels()
        
        self.restartLabel.text = "Scored \(score.totalScore)."
        self.gameOverReason.text = reason
        
        let currentHighScore = defaults.integerForKey(HighScoreKey)
        
        if score.totalScore > currentHighScore {
            defaults.setInteger(score.totalScore, forKey: HighScoreKey)
            self.restartLabel.text? += " New high score."
            self.highScore.text = "Last high score was \(currentHighScore)."
        } else if currentHighScore > 0 {
            self.highScore.text = "High score is \(currentHighScore)."
        } else {
            self.highScore.text = "No high score yet."
        }
        
        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.showStatusLabels()
            },
            completion: nil
        )
    }
    
    private func showTitleLabels() {
        self.labelContainer.center = CGPoint(
            x: self.view.frame.width / 2,
            y: (self.view.frame.height / 4) - Radius/2
        )
        
        self.titleLabel.alpha = 1.0
        self.titleLabel2.alpha = 1.0
        self.titleLabel3.alpha = 1.0
    }
    
    private func showStatusLabels() {
        self.gameOverReason.alpha = 1.0
        self.restartLabel.alpha = 1.0
        self.highScore.alpha = 1.0
        self.tapToRestart.alpha = 1.0
    }
    
    private func hideTitleLabels() {
        self.titleLabel.alpha = 0.0
        self.titleLabel2.alpha = 0.0
        self.titleLabel3.alpha = 0.0
    }
    
    private func hideStatusLabels() {
        self.restartLabel.alpha = 0.0
        self.gameOverReason.alpha = 0.0
        self.highScore.alpha = 0.0
        self.tapToRestart.alpha = 0.0
    }
}
